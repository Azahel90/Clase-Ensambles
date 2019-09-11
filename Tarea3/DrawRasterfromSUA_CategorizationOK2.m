function DrawRasterfromSUA_CategorizationOK(sua_id, cond, times, EpochNum, SDF_MAX,ActPer, monkey)
%%
%%% Constants for graph appearance and structure
TICK_HEIGHT = 7;
ROW_HEIGHT = TICK_HEIGHT + (TICK_HEIGHT / 15);
plot_cols = 1;      % Tasks SP2
plot_rows = 8;     % Subplot rows per figure
x_tick_span = 500;  % Draw x ticks every 500 ms
Mat = [200 250 319 331 369 381 450 500; 450 500 619 669 706 756 870 920; 870 920 981 1169 1231 1419 1470 1520; ...
    110 122 144 148 156 160 182 194; 182 194 217 222 232 237 260 272; 260 272 296 303 317 324 348 360]; % test stimuli per block

%%% SDF
KERNEL_WIDTH = 60;

%%% Variables
tasks = [2 3 4 5 6 7]; % 1 = control, 2 = TM1, 3 = TM2, 4 = TM3, 5 = SP1, 6 = SP2, 7 = SP3
do_sdf = 1;
fill_SDF = 0;
do_raster = 1;
distinction = 1; % 1 = plot all trials, 2 = plot only correct trials, 3 = plot only error trials
correctcounter = zeros(8,6);
incorrectcounter = zeros(8,6);


clear RTcounter RTs
RTs = zeros(8, 12); % holder for RT times per interval per repetition.
RTcounter = zeros(8, 1);
task = 5;
%%% Get time range for x axis:
[pre, post] = getPrePost (task, EpochNum, monkey);

%%% Figure
scrsz = get(0,'ScreenSize');
tit = [' cell ' num2str(sua_id) ', monkey ' num2str(monkey)];
thisTitle = [tit ', Y top = ' num2str(SDF_MAX)];
flag = 0;
figure('position', [-1230 10 scrsz(3)/1.6 scrsz(4)/1.6], 'Name', tit);
hold on;
trialcounter = zeros(30, 1); % Counter for the number of repetitions for every task, phase and stimulus.


%----ActivationPeriod------%
bspk = {ActPer.bspk};
espk = {ActPer.espk};
% Peak = [ActPer.PeakHz];
PeakIdx = [ActPer.Peakidx];


% idxPeak = cell2mat(PeakIdx(~cellfun(@(x) isempty(x),PeakIdx,'UniformOutput',1)));
% bspk = cell2mat(bspike(idxPeak));
% espk = cell2mat(espike(idxPeak));

TotalTrials = numel(cond);
samp_points = pre(task):10:post(task);           % Time points for the ksdensity function (1 ms intervals between temporal boundaries of raster)

this_cond_sdf = zeros(numel(samp_points), 30);  % Data holder for output of ksdensity
All_cond_sdf = [];

%%% Count corrects per stimulus
for ii = 1 : TotalTrials % Trial loop
    clear st r c er
    
    st = times(ii,2);
    [r, c] = find(Mat(task, :) == st);
    
    er = times(ii,3);
    
    line_times = single(times(ii, 8:14)); % Get behav times
    line_times(end) = [];
    shift = line_times(EpochNum);
    line_times = line_times - shift;
    RTcounter(c) = RTcounter(c) + 1;
    RTs(c, RTcounter(c)) = line_times(5); % Obtain RTs for every trial
    
    switch er
        case 0
            correctcounter(c, task - 1) = correctcounter(c, task) + 1;
        case 707
            incorrectcounter(c, task - 1) = incorrectcounter(c, task) + 1;
    end
end   % Trial loop

% calculate mean and SD RTs
mean_SD_RTs(:, 1) = mean(RTs,2);
mean_SD_RTs(:, 2) = std(RTs,0, 2); %/sqrt(12);

for this_cond = 1 : TotalTrials % Trial loop
    clear error test
    error = times(this_cond,3);
    test = 1;
    plotTasks
    
end   % Trial loop

clear maxSDFvalTime maxSDFvalSpace

%%% Nested funtion:
    function plotTasks
        clear stim positionInplot repetition spk_vect line_times x numspikes shift line_times row_y_loc top_y bot_y y num_lines line_x line_bot line_top line_y this_trial_sdf r c trial_max
        params.sigma = 12;%ms
        params.delta = 1000;%
        params.SDFWindowLength = 1;%
        
        %         ActivationPer = ActPer;
        %         bspk = {ActivationPer.bspk};
        
        stim = times(this_cond,2);
        categ = times(this_cond,4);
        [r, c] = find(Mat(task, :) == stim);
        positionInplot = getPositionInPlot(stim);
        
        trialcounter(positionInplot) = trialcounter(positionInplot) + 1;
        repetition = trialcounter(positionInplot); % Current repetition for this task, phase and stimulus.
        
        spk_vect = single(cond{this_cond}); % Get spike times
        spk_vect = spk_vect';
        line_times = single(times(ii, 8:14)); % Get behav times
        line_times(end) = []; % Eliminate last behav time
        
        %%% RASTER %%%
        %%% Define x values for raster dots:
        x = [spk_vect; spk_vect];
        numspikes = numel(spk_vect);
        shift = line_times(EpochNum);
        line_times = line_times - shift;  % Re-express all behav times relative to trigger event
        x = x - shift;                    % Re-express all spike times relative to trigger event
        
        %%% Define y values for raster dots
        row_y_loc = -((repetition - 1) * ROW_HEIGHT); % First trial is top row, build raster by adding trials below
        
        top_y = ones(1, numspikes) * (row_y_loc);
        bot_y = top_y - TICK_HEIGHT;
        y = [top_y; bot_y];
        
        subplot(plot_rows, plot_cols, positionInplot);
        hold on;
        
        if do_raster
            line(x,y,'color',[0.5 0.5 0.5], 'LineWidth', 1); % Plot raster row
        end
        %%%-----------Activation Periods-------------------------%
        if repetition == 6 && positionInplot <= length(PeakIdx)
            if  (PeakIdx(positionInplot)~=0)
                idx = PeakIdx(positionInplot);
                ymax = median(bot_y:top_y);
                ymin = ymax;
                line([bspk{positionInplot}(idx),espk{positionInplot}(idx)], [ymin ymax ],'Color',[1 0 0],'LineWidth',1);
            end
        end
        %------------------------------------------------------%
        
        
        %%% Draw dots at the times of behaviour events
        if(~isempty(find(line_times, 1)))   % If behav times
            num_lines = numel(line_times);
            line_x(:,1:num_lines) = [line_times;line_times];
            line_bot = -((repetition - 1) * ROW_HEIGHT) - 3;
            line_top = line_bot - (TICK_HEIGHT ) + 4;
            line_y = [line_top; line_bot];
            line(line_x, line_y, 'color', [0 0 0], 'LineWidth', 1);
        end
        
        %%% Calculate SDFs %%%
        if(do_sdf && numspikes > 0)
            %             [ this_trial_sdf, winTimes,winSpikes ] = spikes2density( params, x(1, :), samp_points(1), samp_points(end)+1);
            %             this_trial_sdf = this_trial_sdf *120; % Convert SDF to hz
            %             close
            %             hold on
            %             plot(this_trial_sdf)
            %             mden1 = max(this_trial_sdf);%
            this_trial_sdf = ksdensity(x(1, :), samp_points, 'kernel', 'normal', 'width', KERNEL_WIDTH); % Evaluate SDF at samp_points
            this_trial_sdf = this_trial_sdf * numspikes * 1000; % Convert SDF to hz
            %             mden2 = max(this_trial_sdf);
            %             mden2/mden1
            %             plot(this_trial_sdf,'-k')
            %             hold off
            
            this_cond_sdf(:, positionInplot) = (this_cond_sdf(:, positionInplot) + this_trial_sdf(:));  % Add current SDF to ongoing sum
            
            All_cond_sdf{positionInplot}(:,trialcounter(positionInplot)) = this_trial_sdf;  % Add current SDF to ongoing sum
        end
        
        trial_max = 12;
        
        if repetition == trial_max % If max number of repetitions for this condition has reached
            clear trigline_x trigline_y titstim
            [taskTitle] = getTaskTitle(task+1);
            %---------Activation Periods-------------%
            APcont = 1; %Activation Periods counter
            
            trigline_x = [0; 0];
            RTline_x1 = [mean_SD_RTs(c, 1) - mean_SD_RTs(c, 2); mean_SD_RTs(c, 1) - mean_SD_RTs(c, 2)];
            RTline_x2 = [mean_SD_RTs(c, 1) + mean_SD_RTs(c, 2); mean_SD_RTs(c, 1) + mean_SD_RTs(c, 2)];
            trigline_y = [0; -trial_max * ROW_HEIGHT];
            set(gca, 'LineWidth', 1);
            line(trigline_x, trigline_y, 'color', [1 0 0],'LineWidth', 1.5); % Draw line at reference (alignement) behavior event
            line(RTline_x1, trigline_y, 'color', [0 1 0],'LineWidth', 1); % Draw line at reference (alignement) behavior event
            %      line(RTline_x2, trigline_y, 'color', [0 0 1],'LineWidth', 1); % Draw line at reference (alignement) behavior event
            titstim = num2str(stim);
            
            text((pre(task) - 150), -89.6/2, titstim,  'FontSize', 12); % Draw condition titles
            
            
            %%% Draw task titles
            flag = DrawTaskTitles_8 (positionInplot, thisTitle, taskTitle, pre, post, flag);
            
            if(do_sdf)
                clear yrange conversion
                this_cond_sdf(:, positionInplot) = this_cond_sdf(:,positionInplot) / trialcounter(positionInplot); %  avg SDF
                Mean_SDF  = mean(All_cond_sdf{positionInplot}');
                SD_SDF  = std(All_cond_sdf{positionInplot}')/sqrt(12);
                %%% Scale and shift SDF to raster range.
                yrange = ROW_HEIGHT * trial_max;
                conversion = yrange / SDF_MAX;
                Mean_SDF  = (Mean_SDF .* conversion) - yrange;
                SD_SDF  = (SD_SDF .* conversion);
                
                [l,p] =  boundedline(samp_points, Mean_SDF  ,SD_SDF,'-b','alpha');
                
            end % If do SDF
            
            axis([pre(task), post(task), - trial_max * ROW_HEIGHT,0]);  %  reset ranges for x and y axes
            %             set(gca, 'XTick', pre(task):x_tick_span:post(task));        %  reset tick spacing
            set(gca, 'YTick', []);                                      %  turn off y ticks
            set(gca, 'TickDir', 'out');                                 %  switch side of axis for tick marks
            set(gca, 'TickLength', [.007 .007]);                          %  this in proportion of x axis
            set(gca, 'XTickLabel', []);
            clear num_lines line_x line_bot line_top line_y;
            
        end % If last repetition
    end
end
