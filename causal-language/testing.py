from clingo.control import Control 
from clingo.symbol import parse_term

"""
Test file format: put each ground atom in each line
- if by itself: assert in AS
- if prefixed by not & followed by spaces: assert not in AS
"""

EVENT_MOTOR_FILE = "event_motor.lp" 

def parseTestFile(testFile):
    f = open(testFile, "r")
    lines = f.readlines()
    f.close()
    inAS = []
    notInAS = []
    for line in lines: 
        l = line.strip()
        if l.startswith("not "): 
            notInAS.append((l[4:]).strip())
        else: 
            inAS.append(l)
    return [parse_term(z) for z in inAS], [parse_term(z) for z in notInAS]

"""
Model number: fail / pass
"""
def compareOnModel(model, inAS, notInAS): 
    print("Model#:", model.number)
    failedIn = []
    failedNotIn = []
    ok = True 
    for a in inAS: 
        if not model.contains(a):
            ok = False
            failedIn.append(str(a))
    for a in notInAS: 
        if model.contains(a): 
            ok = False 
            failedNotIn.append(str(a))
    if ok: 
        print("PASSED")
    else: 
        print("FAILED")
        print("Failed in: ", failedIn)
        print("Failed not in: ", failedNotIn)

""" 
TODO: write docs
"""
def unitTest(testname, problemEncodingFile, expectedFile): 
    print("------")
    print("Test:", testname)
    expectedInAS, expectedNotInAS = parseTestFile(expectedFile)

    ctl = Control()
    files = [EVENT_MOTOR_FILE, problemEncodingFile]
    for f in files: 
        ctl.load(f)
    ctl.ground()
    ctl.solve(on_model=lambda m: compareOnModel(m, expectedInAS, expectedNotInAS))
    print("------")

unitTest("yaleshooting", "examples/yaleshooting/yaleshooting.lp", "examples/yaleshooting/yaleshooting.test")
unitTest("pollution", "examples/pollution/pollution.lp", "examples/pollution/pollution.test")