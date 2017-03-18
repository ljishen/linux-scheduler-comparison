#!/usr/bin/env python3

import shutil
import xml.etree.ElementTree as ET

COMPOSITE_FILE = '/var/lib/phoronix-test-suite/test-results/scheduler-comparison/composite.xml'

tree = ET.parse(COMPOSITE_FILE)
root = tree.getroot()

remove_descriptions = ['Phoronix Test Suite System Monitoring', 'Drive Read Speed', 'Drive Write Speed', 'System Iowait Monitor', 'Swap Usage Monitor']

for result in root.findall('Result'):
    description = result.find('Description').text
    if any(r_desc in description for r_desc in remove_descriptions):
        root.remove(result)

try:
    shutil.copyfile(COMPOSITE_FILE, COMPOSITE_FILE + '.bak')
    tree.write(COMPOSITE_FILE)
except shutil.Error as e:
    print('Error: %s' % e)
except IOError as e:
    print('Error: %s' % e.strerror)
