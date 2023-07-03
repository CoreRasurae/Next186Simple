import numpy as np

def transposeMem(filenameIn, filenameOut):
    f=open(str(filenameIn), 'r', buffering=1048576)
    lines = f.readlines()
    outputLines = []
    ignored = 0
    for line in lines:
        splittedLine = line.split(' ')
        cleanedUpLine = []
        for splittedElement in splittedLine:
            splittedElement = splittedElement.rstrip().lstrip()
            if len(splittedElement) == 0:
                continue
            cleanedUpLine.append(splittedElement)
        cleanedUpLine.reverse()    
        outputLines.append(cleanedUpLine)
    f2=open(str(filenameOut), 'w', buffering=1048576)
    for i in np.arange(len(outputLines[0])):
        for j in np.arange(len(outputLines)):
            line=outputLines[j]
            val=line.pop()
            f2.write(val)
            if j < len(outputLines)-1:
                f2.write(' ')
        f2.write('\n')
    f.close()
    f2.close()
    
transposeMem('cache_lru.mem', 'cache_lru.memT')
transposeMem('cache_addr.mem', 'cache_addr.memT')
