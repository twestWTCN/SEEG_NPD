function R = makeHeader_SEEG_NPD()
if strcmp(getenv('COMPUTERNAME'),'SFLAP-2')
    R.origpath = 'C:\data\Rosch_data\';
    R.datapathr = 'C:\Users\Tim\Documents\Work\GIT\SEEG_NPD\Data\';
elseif strcmp(getenv('COMPUTERNAME'),'FREE')
    R.origpath = 'C:\home\data\Rosch_data\';
    R.datapathr = 'C:\Users\twest\Documents\Work\GitHub\SEEG_NPD\Data\';
end
R.subname = {'Subject 1'};
R.condname = {'PreTC Wake','PreTC Sleep','PostTC Wake'};
R.condfile = {'Pre_wake','Pre_sleep','Post'};
R.condnamelc = {'pre','post'};
% Preprocessing
R.pp.bp = [4 128]; %[4 500];
R.pp.fs = 300;

% Spectral Analysis
R.specanaly.frqbnd = [4 98]; %[4 498];
R.specanaly.epochL = 1;
R.specanaly.multitaper = 1;
R.specanaly.tapsmofrq = 1.5; % Spectral smoothing if taper
R.cohanaly.multitaper = 1;
R.cohanaly.method ={'coh','wpli_debiased'};
R.cohanaly.tapsmofrq = 2;
% NPD
% % % R.NPD.multitaper = 'M0.5'; % NO MULTITAPER"!!
R.NPD.windowlength = 9;
