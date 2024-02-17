#!/bin/bash

if curl -f https://ericwnelson.info/health-check; then
    echo "Service validation succeeded."
    exit 0
else
    echo "Service validation failed."
    exit 1
fi