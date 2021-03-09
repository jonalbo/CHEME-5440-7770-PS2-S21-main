function generate_problem_dictionary(path_to_parameters_file::String)::Dict{String,Any}

    # initialize -
    problem_dictionary = Dict{String,Any}()


    try

        # load the TOML parameters file -
        toml_dictionary = TOML.parsefile(path_to_parameters_file)["biophysical_constants"]

        # setup the initial condition array -
        initial_condition_array = [
            0.0 ;   # 1 mRNA
            5.0 ;   # nM and constant TODONE: gene concentration goes here -
            0.0 ;   # 3 I = we'll fill this in the execute script 
        ]
        # TODO: calculate the mRNA_degradation_constant 
       # s decided not to use this bc couldnt confirm a good reasoning from the papers for how to use the half life for the degradation constant
        mRNA_degradation_constant = log(2)/toml_dictionary["mRNA_half_life_in_min"] #converts mRNA to a constant
        #mRNA_degradation_constant = 3.75/3600
        # TODONE: VMAX for transcription -
        RNAPII_concentration= toml_dictionary["RNAPII_concentration"]                               # units: nM
        transcription_elongation_rate= toml_dictionary["transcription_elongation_rate"]                       # units: nt/s
        gene_length_in_nt= toml_dictionary["gene_length_in_nt"]                                   # units: nt

        VMAX_X = RNAPII_concentration*(transcription_elongation_rate/gene_length_in_nt)  # nM*(nt/s/nt) = nM/s

 

        # TODO: Stuff that I'm forgetting?
        # check to see whenever problem[""] is used, I think only this one wasn't defined
        problem_dictionary["inducer_cooperativity_parameter"] =toml_dictionary["inducer_cooperativity_parameter"]
        problem_dictionary["transcription_elongation_rate"] =toml_dictionary["transcription_elongation_rate"]
        # --- PUT STUFF INTO problem_dictionary ---- 
        problem_dictionary["transcription_time_constant"] = toml_dictionary["transcription_time_constant"]
        problem_dictionary["transcription_saturation_constant"] = toml_dictionary["transcription_saturation_constant"]
        problem_dictionary["E1"] = toml_dictionary["energy_promoter_state_1"]
        problem_dictionary["E2"] = toml_dictionary["energy_promoter_state_2"]
        problem_dictionary["inducer_dissociation_constant"] = toml_dictionary["inducer_dissociation_constant"]
        problem_dictionary["ideal_gas_constant_R"] = 0.008314  # kJ/mol-K
        problem_dictionary["temperature_K"] = (273.15+37)
        problem_dictionary["initial_condition_array"] = initial_condition_array
        problem_dictionary["mRNA_degradation_constant"] = mRNA_degradation_constant
        problem_dictionary["maximum_transcription_velocity"] = VMAX_X  # nM/s eq 7

        
        # return -
        return problem_dictionary


    catch error
        throw(error)
    end
end