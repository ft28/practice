import sys

path = sys.argv[1]
with open(path, 'r') as fp:
    counter = 1 
    for line in fp:
         print('{"index": {"_id":"' + str(counter) + '"}}')
         print('{"word":"' + line.strip() + '"}')
         counter += 1
