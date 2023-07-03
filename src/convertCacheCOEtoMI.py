import numpy as np

def readCOEAndConvertToMI(filenameIn, filenameOutNibH, filenameOutNibL, ignoreNumLines, header=None, asByteMems=False):
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
    files=[]
    if asByteMems:
        fNHH=open(str(filenameOutNibH.replace('.mi','H.mi')), 'w', buffering=1048576)
        fNHL=open(str(filenameOutNibH.replace('.mi','L.mi')), 'w', buffering=1048576)
        fNLH=open(str(filenameOutNibL.replace('.mi','H.mi')), 'w', buffering=1048576)
        fNLL=open(str(filenameOutNibL.replace('.mi','L.mi')), 'w', buffering=1048576)
        files = [fNHH, fNHL, fNLH, fNLL]
    else:
        fNH=open(str(filenameOutNibH), 'w', buffering=1048576)
        fNL=open(str(filenameOutNibL), 'w', buffering=1048576)
        files = [fNH, fNL]
    if header is not None:
        for f1 in files: 
            f1.write(header)

    for line in outputLines:
        value=int(line, 16)
        if asByteMems:
            tempValue = value;
            i=3
            for f1 in files:
                strHex=hex((value>>(i*8)) & 0x0ff)[2:]
                f1.write((2-len(strHex))*'0')
                f1.write(strHex)
                f1.write('\n')
                i=i-1
        else:
            strH=hex(value>>16)[2:]
            files[0].write((4-len(strH))*'0')
            files[0].write(strH)
            strL=hex(value & 0x0ff)[2:]
            files[1].write((4-len(strL))*'0')            
            files[1].write(strL)
            files[0].write('\n')
            files[1].write('\n')
    f.close()
    for f1 in files:
        f1.close()
    
header = '#File_format=Hex\n'+ \
         '#Address_depth=4096\n' + \
         '#Data_width=8 \n'

readCOEAndConvertToMI('Cache_bootload.coe', 'Cache_bootloadNibH.mi', 'Cache_bootloadNibL.mi', 2, header, asByteMems=True)
