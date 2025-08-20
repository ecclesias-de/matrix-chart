#!/bin/bash

if [[ -f /etc/ma1sd/ma1sd.yaml.tmpl ]]; then
    gomplate -f  /etc/ma1sd/ma1sd.yaml.tmpl -o /etc/ma1sd/ma1sd.yaml
fi

exec java -jar /app/ma1sd.jar -c /etc/ma1sd/ma1sd.yaml