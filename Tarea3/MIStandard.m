% Mutual Information
% Estimates of mutual information
% Input
% Data -> Matrix of random variable X data. Every entry (i,j) correspond
% to the jth sample to X over the ist value of random variable Y.
% Output
% MI -> Mutual Information
function MI = MIStandard(Data)
% % % Define the number of bins and width
MaxData = max(max(Data));
if MaxData == 0
    MaxData = 1;
end
[nx ny] = size(Data);
NumberBins = round(sqrt(nx * ny));
Bins = 0: MaxData / NumberBins: MaxData;
% % % % % 
% % % Estimate of Joint and Marginal Probability
[PXY, T] = hist(Data', Bins);
[PX T] = hist(Data(:), Bins);
PX = PX / sum(PX);
PXY = PXY ./ repmat(sum(PXY), NumberBins + 1, 1);
PY = 1 / nx;
% % % % % 
MI = 0;
% % % Estimate the Mutual Information
for c1 = 1: NumberBins + 1
    for c2 = 1: nx
        if (PX(c1) ~= 0) && (PXY(c1, c2) ~= 0)
            MI = MI + PY * PXY(c1, c2) * log2(PXY(c1, c2) / PX(c1));
        end
    end
end