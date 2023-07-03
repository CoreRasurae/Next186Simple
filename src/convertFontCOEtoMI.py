import numpy as np

def readCOEAndConvertToMI(filenameIn, filenameOut, ignoreNumLines, header=None):
    f=open(str(filenameIn), 'r', buffering=1048576)
    lines = f.readlines()
    outputLines = []
    ignored = 0
    for line in lines:
        if ignored < ignoreNumLines:
            ignored = ignored + 1
            continue
        splittedLine = line.split(',')
        for splittedElement in splittedLine:
            splittedElement = splittedElement.replace(',','').replace(';','').rstrip().lstrip()
            if len(splittedElement) == 0:
                continue
            print(splittedElement)  
            outputLines.append(splittedElement)
    f2=open(str(filenameOut), 'w', buffering=1048576)
    for line in outputLines:
        if header is not None:
            f2.write(header)
        f2.write(line)
        f2.write('\n')
    f.close()
    f2.close()
    
header = '#File_format=Hex\n'+ \
         '#Address_depth=4096\n' + \
         '#Data_width=8 \n'

readCOEAndConvertToMI('font.coe', 'font.mi', 3, header)
