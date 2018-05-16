%% MASTER FOR SEEG THERMOCOAGULATION EXPERIMENTS
clear; close all
add_SEEG_NPD_paths()
R = makeHeader_SEEG_NPD;
preprocess_SEEG(R)
spectral_SEEG(R)