function calculate_transcriptional_control_array(t::Float64,x::Array{Float64,1}, problem::Dict{String,Any})::Float64

    # initialize -
    u_variable = 0.0
    
    # alias elements of the species vector -
    mRNA = x[1]
    G = x[2]
    σ70 = x[3]  # nM I think

    # get stuff from the problem dictionary -
    E1 = problem["E1"]  # kJ/mol
    E2 = problem["E2"]  # kJ/mol
    R = problem["ideal_gas_constant_R"]  # kJ/molK Boltzmann constant is the gas constant per molecule
    T_K = problem["temperature_K"]  # K
    KD = problem["inducer_dissociation_constant"]  # nM
    n = problem["inducer_cooperativity_parameter"]  # dimensionless
    # k = 1.380649*10^-26 #kJ/K units don't work out if I use this, have to use R for boltzmann to make it per mol so dimensionless
    # kman = k/R #mol


    # TODO: write u-varible function here 
    fI = (σ70^n)/((KD^n) + (σ70^n))  # nM/(nM+nM) #so dimensionless
    w1 = exp(-E1/(R*T_K))
    w2 = exp(-E2/(R*T_K))

    u_variable = (w1 + fI*w2)/(1 +w1 + fI*w2)
    #top = exp(-E1/R*T_K) + fI*exp(-E2/R*T_K)  # kJ/mol/kJ*K/mol*K + dimensionless*(kJ/mol/kJ*K/mol*K)
    #bottom = 1 + exp(-E1/R*T_K) + fI*exp(-E2/R*T_K)
    #u_variable = (exp(-E1/R*T_K) + fI*exp(-E2/R*T_K))/(1 + exp(-E1/R*T_K) + fI*exp(-E2/R*T_K))

    # return -
    return u_variable
end
