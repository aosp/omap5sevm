/*
 * Copyright (C) 2008 The Android Open Source Project
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

#ifndef ANDROID_ACCELEROMETER_SENSOR_H
#define ANDROID_ACCELEROMETER_SENSOR_H

#include <stdint.h>
#include <errno.h>
#include <sys/cdefs.h>
#include <sys/types.h>

#include "sensors.h"
#include "SensorBase.h"
#include "InputEventReader.h"

#define ACCEL_INPUT_NAME    "mpu6050-accelerometer"
#define GYRO_INPUT_NAME    "mpu6050-gyroscope"

/*****************************************************************************/

struct input_event;

class MPU6050Sensor : public SensorBase {
public:
            MPU6050Sensor(const char *name);
    virtual ~MPU6050Sensor();

    enum {
        accelerometer   = 0,
        gyroscope = 1,
        numSensors
    };

private:
    int mEnabled;
    InputEventCircularReader mInputReader;
    uint32_t mPendingMask;
    sensors_event_t mPendingEvents[numSensors];
    bool mHasPendingEvent;
    char input_sysfs_path[PATH_MAX];
    int input_sysfs_path_len;

    int setInitialState();

    virtual int readEvents(sensors_event_t* data, int count);
    virtual bool hasPendingEvents() const;
    virtual int setDelay(int32_t handle, int64_t ns);
    virtual int enable(int32_t handle, int enabled);
};

/*****************************************************************************/

#endif  // ANDROID_ACCELEROMETER_SENSOR_H
