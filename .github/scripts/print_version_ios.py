#!/usr/bin/env python3

import sys
import xml.etree.ElementTree as ET
tree = ET.parse('ios/Runner/Info.plist')
root = tree.getroot()
params = root[0]

i = 0

for item in params:
    if item.text == 'CFBundleShortVersionString':
        print(params[i+1].text)
    i += 1

sys.exit(1)
