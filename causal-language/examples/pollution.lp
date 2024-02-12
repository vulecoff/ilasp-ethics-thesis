%-----CONTEXT----------

%prod_m = production of medicines
%prod_s = production of connected speakers
%dis_w = discharging wastewater
%fau_p = potable water plant fault
%m_k = availability ok k doses of medicine
%w_m = waste water due to medicine production
%e_n = employement of n individuals
%w_s = waste water due to speakers production
%t_os = treatement plant of medecine factory out of service
%s_sup = pollution indicator above threshold
%d = inhabitants deprived of drinking water

time(0..3).

initiallyP(t_os).			
initiallyN(m_k). 
initiallyN(w_m). 
initiallyN(e_n). 
initiallyN(w_s). 
initiallyN(s_sup). 
initiallyN(d). 

fluent(m_k).
fluent(w_m).
fluent(e_n).
fluent(w_s).
fluent(t_os).
fluent(s_sup).
fluent(d).

action(prod_m,true,prod_mEff).
conj(prod_mEff).
in(prod_mEff,m_k).
in(prod_mEff,w_m).

action(prod_s,true,prod_sEff).
conj(prod_sEff).
in(prod_sEff,e_n).
in(prod_sEff,w_s).

auto(dis_w,dis_wCond,dis_wEff).
disj(dis_wCond).
in(dis_wCond,w_s).
in(dis_wCond,dis_wCond1).
conj(dis_wCond1).
in(dis_wCond1,w_m).
in(dis_wCond1,t_os).
conj(dis_wEff).
in(dis_wEff,s_sup).

auto(fau_p,fau_pCond,fau_pEff).
conj(fau_pCond).
in(fau_pCond,s_sup).
conj(fau_pEff).
in(fau_pEff,d).


%-----SCENARIO----------

performs(prod_m,0).
performs(prod_s,1).

