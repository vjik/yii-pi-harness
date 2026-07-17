#!/bin/sh
set -eu

cp /pi-yii/SYSTEM.md /pi/SYSTEM.md

PI_EXTENSIONS="/pi-yii/extensions"
PI_PROMPTS="/pi-yii/prompts"
PI_SETTINGS="/pi/settings.json"
node -e "
    const fs = require('fs');
    let settings;
    try {
        settings = JSON.parse(fs.readFileSync('$PI_SETTINGS', 'utf8'));
    } catch (e) {
        settings = {};
    }
    if (!Array.isArray(settings.extensions)) {
        settings.extensions = [];
    }
    if (!settings.extensions.includes('$PI_EXTENSIONS')) {
        settings.extensions.push('$PI_EXTENSIONS');
    }
    if (!Array.isArray(settings.prompts)) {
        settings.prompts = [];
    }
    if (!settings.prompts.includes('$PI_PROMPTS')) {
        settings.prompts.push('$PI_PROMPTS');
    }
    fs.writeFileSync('$PI_SETTINGS', JSON.stringify(settings, null, 2) + '\n');
"

exec "$@"
