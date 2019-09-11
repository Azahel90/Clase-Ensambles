function [cond, line_timesS, fr_control, fr_epoch] = ExtractRasterSpikesHM_MovementTimes(sua, loc, ttcount, TOTALRUNS, TOTALCHANNELS)
%function [cond,line_times,mean_fr_all] = ExtractRasterSpikes2(sua,loc,ttcount)

%Reads sua array of structures and extracts the information to construct
%cond for a specific unit found with and localization (loc array)

% First dimension cond(n) contains data describing the trial conditions
% included in each of the n rasters in the plot. Fields are:
% cond(n).id -- integer serving as a task condition descriptor
% cond(n).side -- 'L' or 'R', specific to construction task
% cond(n).monk -- string for monkey name
% cond(n).file -- file RUN corresponding to binary file from exp.
% cond(n).channel -- DAP channel (int) in which neuron was recorded
% cond(n).cell -- number (int) of cell in that RUN
% cond(n).matx -- number of matrix

% monk, file, channel, cell are stored at cond level even though they don't
% vary across cond.  A plotting peculiarity, no easy way to add text to a
% figure, text addition is to current axes (raster).  These data replace
% x-axis label of last raster on page.
%
% Second dimension trial(n) contains data describing each trial in parent
% raster, can index cond level variables with cond(n).field, and trial level
% variables as cond(i).trial(j).field.  Trial level fields are:
% cond(i).trial(j).trig = trial time of behavioral event serving as trigger
% cond(i).trial(j).spk_times = variable length array of all spike times on
% that trial. This should be common to all experiments

% constants

% TOTALCHANNELS = 7;
TOTALSPSK = 5;
TOTALTASKS = 7;
task(1,:) = 'CTR';
task(2,:) = 'TM1';
task(3,:) = 'TM2';
task(4,:) = 'TM3';
task(5,:) = 'SP1';
task(6,:) = 'SP2';
task(7,:) = 'SP3';
EpochNum = 8;

%finding the run the channel and the cell
[run,chan,cell] = ind2sub([TOTALRUNS,TOTALCHANNELS,TOTALSPSK],loc(ttcount)); %[42,16,5] =size fof the sua matrix, loc(ttcount) = index

for t = 2: TOTALTASKS

    eval_str = ['Ree =  sua(loc(ttcount)).sp' task(t,:) ';'];
    eval(eval_str);
    eval_str = ['Re =  sua(run,chan,cell).sp' task(t,:) ';'];
    eval(eval_str);
    REPE = numel(Re);

    [session] =  (sua(loc(ttcount)).session);
    [realrun] =  (sua(loc(ttcount)).runday);

    tr(1:REPE) = struct('spk_times', {[]},'interv', {[]},'repe',{[]});
    cond(t) = struct('ID', {task(t,:)}, 'monk',{'m1'}, 'session', {session}, 'run', {run}, 'realrun', {realrun},'channel', {chan}, 'cell', {cell}, 'numtrials', {REPE}, 'trial', {tr});

    for(r = 1:REPE)

        eval_str = ['[cond(t).trial(r).spk_times] =  deal(sua(loc(ttcount)).sp' task(t,:) '(r).k);'];
        eval(eval_str);
        
%         cond(t).trial(r).spk_times = cond(t).trial(r).spk_times * 1000;
%         & GMM original Black Rock data in seconds, convert to milliseconds

        eval_str = ['[b_times] =  deal(sua(loc(ttcount)).beh' task(t,:) '(r).k);'];
        eval(eval_str);

        eval_str = ['[cond(t).trial(r).interv] =  deal(sua(loc(ttcount)).int' task(t,:) '(r));'];
        eval(eval_str);
        
        eval_str = ['[cond(t).trial(r).distan] =  deal(sua(loc(ttcount)).spa' task(t,:) '(r));'];
        eval(eval_str);
        
        eval_str = ['[cond(t).trial(r).error] =  deal(sua(loc(ttcount)).err' task(t,:) '(r));'];
        eval(eval_str);

        eval_str = ['[cond(t).trial(r).repe] =  deal(sua(loc(ttcount)).rep' task(t,:) '(r));'];
        eval(eval_str);
        
        eval_str = ['[cond(t).trial(r).cate] =  deal(sua(loc(ttcount)).cat' task(t,:) '(r));'];
        eval(eval_str);
        
        eval_str = ['[cond(t).trial(r).traintest] =  deal(sua(loc(ttcount)).trt' task(t,:) '(r));'];
        eval(eval_str);

        nt = numel(b_times(:,1));
        endholdtime = 500; %%500 + 100
        endtrial = b_times(EpochNum,2);
        starttrial = b_times(1,1); %stim times, 1st valid stimulus + 90 for delay in activity

        time_epoch = endtrial - starttrial;%endSyncroMT;
        epoch = sum(cond(t).trial(r).spk_times >= starttrial & cond(t).trial(r).spk_times < endtrial); %number of spike during epoch
        fr_epoch(t).s(r) = (epoch/time_epoch)*1000;

        time_control =  endholdtime;
        control = sum(cond(t).trial(r).spk_times <= endholdtime); %number of spike during hold time (<500ms) * 2 = Hz of baseline firing rate
        fr_control(t).s(r) = (control/time_control)*1000;
        line_timesS(t,r).t = b_times(:,2); %%times of angl

    end%repe

end


