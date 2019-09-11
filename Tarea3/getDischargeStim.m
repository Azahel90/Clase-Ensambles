function StimDischarge = getDischargeStim(Spikes, Behtimes)


%Poner en ventanas de 250 ms
%Arreglar la funcion para que
%Permute 100 veces.

Stim1 = Behtimes(9);%1st stimulus time
Stim2 = Behtimes(10);%2st stimulus time

StimulusTime = Stim2-Stim1;

NumStimSpikes = sum(Spikes >= Stim1 & Spikes < Stim2);
StimDischarge = (NumStimSpikes/StimulusTime)*1000;


