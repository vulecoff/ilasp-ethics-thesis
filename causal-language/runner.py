from clingo.control import Control 

### Logic Program files ###
EVENT_MOTOR_FILE = "event_motor.lp"

# TODO: ORM MAPPING? 
def to_match(cSymbol, matchList): 
    temp = {}
    for s in matchList: 
        temp[s[0]] = s[1]
    if cSymbol.name in temp and cSymbol.match(cSymbol.name, temp[cSymbol.name]):
        return True
    return False

def on_model(m):
    print("Model:", m.number)
    atoms = m.symbols(atoms=True)
    EC_preds = [ ["holds", 2], ["happens", 3] ]
    error_preds = [["error", 2]]

    ec_atoms = []
    error_atoms = []
    for s in atoms: 
        if to_match(s, EC_preds): 
            ec_atoms.append(s)
        elif to_match(s, error_preds): 
            error_atoms.append(error_atoms)
    
    ec_atoms.sort(key=lambda symb: symb.arguments[-1])
    print("\n".join([str(_) for _ in ec_atoms]))

    print("----")
    print("Errors:")
    print("\n".join([str(_) for _ in error_atoms]))

    print("\n ---------- \n")

def main():
    clingo_args = ["-n 0"]
    ctl = Control(clingo_args)
    
    exampleFile = "examples/pollution.lp"
    files = [EVENT_MOTOR_FILE, exampleFile]
    for f in files: 
        ctl.load(f)
    ctl.ground()
    ctl.solve(on_model=on_model)

main()