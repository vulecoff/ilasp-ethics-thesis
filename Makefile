test-trolley: 
	clingo standard_ec.lp trolley.test.lp --out-ifs=\\n -n 0

test-yaleshooting: 
	clingo standard_ec.lp yaleshooting.test.lp

causal-trace: 
	clingo standard_ec.lp causal_trace.lp trolley.test.lp --out-ifs=\\n -n 0


trolley-dde: 
	clingo trolley_dde.lp possible_world_ec.lp --out-ifs=\\n -n 0

env: 
	conda activate py3.7