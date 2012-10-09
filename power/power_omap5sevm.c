/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOG_TAG "OMAP5 PowerHAL"
#include <utils/Log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#define BOOSTPULSE_PATH 	"/sys/devices/system/cpu/cpufreq/interactive/boostpulse"
#define MAX_SCALING_FREQ_PATH	"/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
#define TIMER_RATE_PATH		"/sys/devices/system/cpu/cpufreq/interactive/timer_rate"
#define MIN_SAMPLE_TIME_PATH	"/sys/devices/system/cpu/cpufreq/interactive/min_sample_time"
#define HISPEED_FREQ_PATH	"/sys/devices/system/cpu/cpufreq/interactive/hispeed_freq"
#define HISPEED_LOAD_VAL_PATH	"/sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load"
#define HISPEED_DELAY_PATH	"/sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay"

#define TIMER_RATE_VAL		"20000"
#define MIN_SAMPLE_TIME_VAL	"60000"
#define HISPEED_LOAD_VAL	"50"
#define HISPEED_DELAY_VAL	"100000"

#define NOMSPEED_FREQ_VAL	"700000"
#define HISPEED_FREQ_VAL	"1200000"

struct omap5sevm_power_module {
    struct power_module base;
    pthread_mutex_t lock;
    int boostpulse_fd;
    int boostpulse_warned;
};

static int str_to_tokens(char *str, char **token,
                         int max_token_idx, char *delim)
{
    char *pos, *start_pos = str;
    char *token_pos;
    int token_idx = 0;

    if (!str || !token || !max_token_idx) {
        return -EINVAL;
    }

    do {
        token_pos = strtok_r(start_pos, delim, &pos);
        if (token_pos)
            token[token_idx++] = strdup(token_pos);

        start_pos = NULL;
    } while (token_pos && token_idx < max_token_idx);

    return token_idx;
}

static int sysfs_read(char *path, void *dest, int nbytes)
{
    char buf[80];
    int len, ret = 0;
    int fd = open(path, O_RDONLY);

    if (fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", path, buf);
        return -EBADF;
    }

    len = read(fd, dest, nbytes);
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error writing to %s: %s\n", path, buf);
        ret = -EIO;
    }

    close(fd);
    return ret;
}

static void sysfs_write(char *path, char *s)
{
    char buf[80];
    int len;
    int fd = open(path, O_WRONLY);

    if (fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", path, buf);
        return;
    }

    len = write(fd, s, strlen(s));
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error writing to %s: %s\n", path, buf);
    }

    close(fd);
}

static void omap5sevm_power_init(struct power_module *module)
{

    sysfs_write(TIMER_RATE_PATH, TIMER_RATE_VAL);
    sysfs_write(MIN_SAMPLE_TIME_PATH, MIN_SAMPLE_TIME_VAL);
    sysfs_write(HISPEED_FREQ_PATH, NOMSPEED_FREQ_VAL);
    sysfs_write(HISPEED_LOAD_VAL_PATH, HISPEED_LOAD_VAL);
    sysfs_write(HISPEED_DELAY_PATH, HISPEED_DELAY_VAL);
}

static int boostpulse_open(struct omap5sevm_power_module *omap5sevm)
{
    char buf[80];

    pthread_mutex_lock(&omap5sevm->lock);

    if (omap5sevm->boostpulse_fd < 0) {
        omap5sevm->boostpulse_fd = open(BOOSTPULSE_PATH, O_WRONLY);

        if (omap5sevm->boostpulse_fd < 0) {
            if (!omap5sevm->boostpulse_warned) {
                strerror_r(errno, buf, sizeof(buf));
                ALOGE("Error opening %s: %s\n", BOOSTPULSE_PATH, buf);
                omap5sevm->boostpulse_warned = 1;
            }
        }
    }

    pthread_mutex_unlock(&omap5sevm->lock);
    return omap5sevm->boostpulse_fd;
}

static void omap5sevm_power_set_interactive(struct power_module *module, int on)
{
    /*
     * Lower maximum frequency when screen is off.  CPU 0 and 1 share a
     * cpufreq policy.
     */

    sysfs_write(MAX_SCALING_FREQ_PATH, on ? HISPEED_FREQ_VAL : NOMSPEED_FREQ_VAL);
}

static void omap5sevm_power_hint(struct power_module *module, power_hint_t hint,
                            void *data)
{
    struct omap5sevm_power_module *omap5sevm = (struct omap5sevm_power_module *) module;
    char buf[80];
    int len;

    switch (hint) {
    case POWER_HINT_INTERACTION:
        if (boostpulse_open(omap5sevm) >= 0) {
	    len = write(omap5sevm->boostpulse_fd, "1", 1);

	    if (len < 0) {
	        strerror_r(errno, buf, sizeof(buf));
		ALOGE("Error writing to %s: %s\n", BOOSTPULSE_PATH, buf);
	    }
	}
        break;

    case POWER_HINT_VSYNC:
        break;

    default:
        break;
    }
}

static struct hw_module_methods_t power_module_methods = {
    .open = NULL,
};

struct omap5sevm_power_module HAL_MODULE_INFO_SYM = {
    base: {
        common: {
            tag: HARDWARE_MODULE_TAG,
            module_api_version: POWER_MODULE_API_VERSION_0_2,
            hal_api_version: HARDWARE_HAL_API_VERSION,
            id: POWER_HARDWARE_MODULE_ID,
            name: "OMAP5sevm Power HAL",
            author: "The Android Open Source Project",
            methods: &power_module_methods,
        },

       init: omap5sevm_power_init,
       setInteractive: omap5sevm_power_set_interactive,
       powerHint: omap5sevm_power_hint,
    },

    lock: PTHREAD_MUTEX_INITIALIZER,
    boostpulse_fd: -1,
    boostpulse_warned: 0,
};
