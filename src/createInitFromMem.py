import numpy as np

def transposeMem(filenameIn, filenameOut, varName, format):
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
            f2.write(varName)
            f2.write('[')
            f2.write(str(j))
            f2.write('][')
            f2.write(str(i))
            f2.write('] = ')
            f2.write(format)
            f2.write(val)
            f2.write(";\n")
        f2.write('\n')
    f.close()
    f2.close()
    
transposeMem('cache_lru.mem', 'cache_lru.memInit', 'cache_lru', '2\'h')
transposeMem('cache_addr.mem', 'cache_addr.memInit', 'cache_addr', '9\'h')
