function preprocess_SEEG(R)
if nargin<1
    R = makeHeader_SEEG_NPD;
end
for sub = 1:numel(R.subname)
    for cond = 1:numel(R.condname)
        load([R.origpath R.subname{sub} '\' R.subname{sub} '_red_nodes.mat'])
        load([R.origpath R.subname{sub} '\all_chans.mat'])
        cfg = [];
        cfg.dataset = [R.origpath R.subname{sub} '\' R.condfile{cond} '.edf'];
        cfg.channel = nodes;
        ftdata = ft_preprocessing(cfg);
        
        cfg = [];
        cfg.resamplefs = R.pp.fs;
        ftdata = ft_resampledata(cfg,ftdata);
        
        cfg = [];
        cfg.hpfilter = 'yes';
        cfg.lpfilter = 'yes';
        cfg.hpfreq = R.pp.bp(1);
        cfg.lpfreq = R.pp.bp(2);
        cfg.dftfilter= 'yes';
        cfg.dftfreq = [50 100 150];
        cfg.demean = 'yes';
        cfg.polyremoval   = 'yes';
        cfg.polyorder = 4;
        ftdata = ft_preprocessing(cfg,ftdata);
        ftdata.thermocoagch = intersect(ftdata.label,tc_chans);
        % %         cfg = [];
        % %         ft_databrowser(cfg,ftdata);
        mkdir([R.datapathr R.subname{sub}])
        save([R.datapathr R.subname{sub} '\' R.subname{sub} '_' R.condfile{cond} '_redData.mat'],'ftdata')
    end
end
