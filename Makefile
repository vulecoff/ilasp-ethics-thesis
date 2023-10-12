test-trolley: 
	clingo standard-ec.lp trolley.test.lp --out-ifs=\\n -n 0

test-yaleshooting: 
	clingo standard-ec.lp yaleshooting.test.lp

causal-trace: 
	clingo standard-ec.lp causal-trace.lp trolley.test.lp --out-ifs=\\n -n 0

sim: 
	clingo simulation-ec.lp --out-ifs=\\n -n 0