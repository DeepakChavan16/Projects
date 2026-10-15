#ifndef CONFIG_H
#define CONFIG_H
#include "secrets.h"

/************************************************
 *               WiFi
 ************************************************/
#define WIFI_SSID "YOUR_WIFI_NAME"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"

/************************************************
 *             Firebase
 ************************************************/
#define API_KEY         ""

#define DATABASE_URL    ""

#define KART_ID         "Kart01"

#define FIREBASE_BASE_PATH "/FormulaKart/Live/" KART_ID

#define FIRMWARE_NAME   "Telemetry_V3"

/************************************************
 *             GPS Pins
 ************************************************/
#define GPS_RX_PIN      16
#define GPS_TX_PIN      17
#define GPS_BAUD        9600

/************************************************
 *            RPM Sensor
 ************************************************/
#define RPM_PIN         4

/************************************************
 *          MAX6675 Pins
 ************************************************/
#define MAX6675_SO      19
#define MAX6675_CS      5
#define MAX6675_SCK     18

/************************************************
 *           MPU6050 Pins
 ************************************************/
#define MPU_SDA         21
#define MPU_SCL         22

/************************************************
 *      Analog Sensor Pins
 ************************************************/
#define BATTERY_PIN     34
#define FUEL_PIN        35

/************************************************
 *         Brake Switch
 ************************************************/
#define BRAKE_PIN       27

/************************************************
 *       Kill Switches
 ************************************************/
#define FRONT_KILL_PIN      25
#define EMERGENCY_KILL_PIN  26
#define REAR_KILL_PIN       33

/************************************************
 *            Buzzer
 ************************************************/
#define BUZZER_PIN      32

#endif