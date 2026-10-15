#include <WiFi.h>
#include "wifiManager.h"
#include "config.h"

void wifiBegin()
{
    WiFi.mode(WIFI_STA);

    // Force public DNS resolvers (Google DNS) in case the access point's
    // own DHCP hands out a DNS server that can't resolve public/internet
    // domains like identitytoolkit.googleapis.com. This was causing:
    //   "DNS Failed for identitytoolkit.googleapis.com"
    // which prevented Firebase auth from ever completing, which in turn
    // meant firebaseReady() never became true and uploadTelemetry()
    // never ran.
    IPAddress primaryDNS(8, 8, 8, 8);
    IPAddress secondaryDNS(8, 8, 4, 4);
    WiFi.config(INADDR_NONE, INADDR_NONE, INADDR_NONE, primaryDNS, secondaryDNS);

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    Serial.printf("Connecting to SSID: %s\n", WIFI_SSID);

    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        Serial.print(" Status=");
        Serial.println(WiFi.status());
        delay(1000);
    }

    Serial.println();
    Serial.println("=================================");
    Serial.println("WiFi Connected");
    Serial.print("IP : ");
    Serial.println(WiFi.localIP());
    Serial.println("=================================");
}

bool wifiConnected()
{
    return WiFi.status() == WL_CONNECTED;
}

void wifiLoop()
{
    static unsigned long lastReconnectAttempt = 0;

    // Already connected
    if (WiFi.status() == WL_CONNECTED)
        return;

    // Try reconnecting every 5 seconds
    if (millis() - lastReconnectAttempt >= 5000)
    {
        lastReconnectAttempt = millis();

        Serial.println("WiFi disconnected. Reconnecting...");

        WiFi.disconnect();
        WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    }
}