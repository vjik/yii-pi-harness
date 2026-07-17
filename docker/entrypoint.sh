#!/bin/sh
set -eu

cp /pi-yii/SYSTEM.md /pi/SYSTEM.md

exec "$@"
