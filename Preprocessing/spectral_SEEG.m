function spectral_SEEG(R)
if nargin<1
    R = makeHeader_SEEG_NPD;
end
close all
for sub = 1:numel(R.subname)
    for cond = 1:numel(R.condname)
        load([R.datapathr R.subname{sub} '\' R.subname{sub} '_' R.condfile{cond} '_redData.mat'])
        
        tc_ind = find(strncmp(ftdata.label,ftdata.thermocoagch{1},2));
        ftdata.label{tc_ind} = 'TC ch';
        cfg = [];
        cfg.length = R.specanaly.epochL;
        Xseg = ft_redefinetrial(cfg,ftdata);
        
        cfg           = [];
        cfg.method = 'mtmfft';
        cfg.output = 'fourier';
        cfg.foilim = R.specanaly.frqbnd;
        % cfg.pad = 128;
        cfg.pad = 'nextpow2';
        if R.specanaly.multitaper == 1
            cfg.tapsmofrq = R.specanaly.tapsmofrq;
        else
            cfg.taper = 'hanning';
        end
        freq = ft_freqanalysis(cfg, Xseg);
        
        tpx = squeeze(mean(abs(freq.fourierspctrm(:,:,:)).^2,1));
        % Normalisation
        for i = 1:numel(Xseg.label)
            tpx(i,:) = tpx(i,:)./sum(tpx(i,freq.freq>4 & freq.freq<45));
        end
        
        figure(1)
        subplot(1,numel(R.condname),cond)
        a = plot(repmat(freq.freq,size(tpx,1),1)',tpx'); hold on       
        a(tc_ind).LineWidth = 1.5;
        xlabel('Freq (Hz)'); ylabel('Normalised Power');        title(R.condname{cond})
        set(gca, 'XScale', 'log');set(gca, 'YScale', 'log'); xlim(R.specanaly.frqbnd)
        legend(ftdata.label,'Location','best'); grid on;
        set(gcf,'Position',[179 510 1437 384]);
        
        
        cfg           = [];
        cfg.method = 'mtmfft';
        cfg.output = 'fourier';
        cfg.foilim = R.specanaly.frqbnd;
        % cfg.pad = 128;
        cfg.pad = 'nextpow2';
        if R.cohanaly.multitaper == 1
            cfg.tapsmofrq = R.cohanaly.tapsmofrq;
        else
            cfg.taper = 'hanning';
        end
        freq = ft_freqanalysis(cfg, Xseg);
        
        for cohi = 1:numel(R.cohanaly.method)
            % Now Coherences
            cfg = [];
            cfg.method = R.cohanaly.method{cohi};
            coh = ft_connectivityanalysis(cfg, freq);
            
            %         figure(2)
            %         for i = 1:numel(coh.label)
            %             for j = 1:numel(coh.label)
            %                 subplot(numel(coh.label),numel(coh.label),sub2ind([numel(coh.label) numel(coh.label)],i,j))
            %                 plot(coh.freq,abs(squeeze(coh.([cfg.method 'spctrm'])(i,j,:)))); ylim([0 0.5])
            %             end
            %         end
            for thermo = 1:2
                cpx = coh.([cfg.method 'spctrm']);
                if thermo == 1
                    list = 1:numel(coh.label); tag = 'all';
                    cpx = cpx(list,list,:);
                                    A = nan(size(cpx,1));
                A = find(triu(A, 1)); % finds the indices of the above diagonal
                cpx2 = reshape(cpx,size(cpx,1).^2,[]); cpx2 = cpx2(A,:);
                else
                    list = tc_ind;
%                     list = setdiff(1:numel(coh.label),tc_ind);
                    tag = 'TC chan.';
                    cpx = cpx(list,:,:);
                    cpx2 = squeeze(cpx);
                end
                figure((3*10) + cohi)
                subplot(2,numel(R.condname),sub2ind([numel(R.condname) 2],cond,thermo))
                plot(repmat(freq.freq,size(cpx2,1),1)',cpx2')
                xlabel('Freq (Hz)'); ylabel(R.cohanaly.method{cohi}); title([R.condname{cond} ' ' tag])
                xlim(R.specanaly.frqbnd); ylim([0 1]); grid on;
%                 set(gca, 'XScale', 'log');
                set(gcf,'Position',[300 109 1360 896]);
            end
        end
    end
end
