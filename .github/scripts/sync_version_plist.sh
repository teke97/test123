#!/usr/bin/env python3

import sys
import xml.etree.ElementTree as ET
tree = ET.parse('ios/Runner/Info.plist')
root = tree.getroot()
params = root[0]

i = 0

for item in params:
    if item.text == 'CFBundleShortVersionString':
        params[i+1].text = sys.argv[1]
    if item.text == 'CFBundleVersion':
        params[i+1].text = sys.argv[2]
    i += 1

root[0] = params
tree = ET.ElementTree(root)
tree.write("ios/Runner/Info.plist") # , encoding='utf-8', xml_declaration=True)
