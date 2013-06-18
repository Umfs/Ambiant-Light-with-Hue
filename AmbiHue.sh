#!/bin/bash

curl --request PUT --data "{\"on\": true,\"bri\":$3,\"sat\":$2,\"hue\":$1,\"effect\":\"none\"}" http://YourIP/api/YourToken/lights/1/state
curl --request PUT --data "{\"on\": true,\"bri\":$3,\"sat\":$2,\"hue\":$1,\"effect\":\"none\"}" http://YourIP/api/YourToken/lights/2/state
curl --request PUT --data "{\"on\": true,\"bri\":$3,\"sat\":$2,\"hue\":$1,\"effect\":\"none\"}" http://YourIP/api/YourToken/lights/3/state
