from clingo.control import Control 

### Logic Program files ###
EVENT_MOTOR_FILE = "event_motor.lp"
CAUSAL_MOTOR_FILE = "causal_motor.lp"

# TODO: ORM MAPPING? 
def to_match(cSymbol, matchList): 
    temp = {}
    for s in matchList: 
        temp[s[0]] = s[1]
    if cSymbol.name in temp and cSymbol.match(cSymbol.name, temp[cSymbol.name]):
        return True
    return False

def on_model(m):
    print("Model#:", m.number)
    print()
    atoms = m.symbols(atoms=True)
    EC_preds = [ ["holds", 2], ["happens", 3]]
    causal_preds = [["direct_ness", 2], ["weight", 3]]
    error_preds = [["error", 2]]

    ec_atoms = []
    causal_atoms = []
    error_atoms = []
    for s in atoms: 
        if to_match(s, EC_preds): 
            ec_atoms.append(s)
        elif to_match(s, error_preds): 
            error_atoms.append(s)
        elif to_match(s, causal_preds):
            causal_atoms.append(s)
    
    ec_atoms.sort(key=lambda symb: symb.arguments[-1])
    print("Event traces:")
    print("\n".join([str(_) for _ in ec_atoms]))
    print("----")

    causal_atoms.sort(key=lambda symb: (symb.arguments[0].arguments[-1], symb.arguments[0].arguments[0]))
    print("Causal traces:")
    print("\n".join([str(_) for _ in causal_atoms]))
    print("----")

    print("Errors:")
    print("\n".join([str(_) for _ in error_atoms]))

    print("\n----------\n")

def main():
    clingo_args = ["-n 0"] # find all models
    ctl = Control(clingo_args)
    
    exampleFile = "examples/duplication/voting.lp"
    files = [EVENT_MOTOR_FILE, CAUSAL_MOTOR_FILE, exampleFile]
    for f in files: 
        ctl.load(f)
    ctl.ground()
    ctl.solve(on_model=on_model)

main()