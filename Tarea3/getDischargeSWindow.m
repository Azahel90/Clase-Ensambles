function StimDischarge = getDischargeSWindow(Spikes,Behav, Behtimes)


%Poner en ventanas de 250 ms
%Arreglar la funcion para que
%Permute 100 veces.

Stim1 = Behav(1);%1st stimulus time
Stim2 = Behav(2);%2st stimulus time

% StimulusTime = Behtimes(10)-Behtimes(9);
StimulusTime = Stim2-Stim1 ;

NumStimSpikes = sum(Spikes >= Stim1 & Spikes < Stim2);
StimDischarge = (NumStimSpikes/StimulusTime)*1000;


