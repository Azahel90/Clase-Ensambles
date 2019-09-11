function MI = MutualInformation(Data)
% Input:
% Data is k x m matrix that correspond to k trials per m stimuli
% Output:
% MI is mutual information
% Response Binning
MinData = min(Data(:));
MaxData = max(Data(:));
[k, m] = size(Data);
n = round(sqrt(k*m));
Bin = MinData: (MaxData-MinData)/(n-1): MaxData;
% Conditional probability
pr_s = hist(Data, Bin);
% Joint Probability
prs = pr_s / sum(pr_s(:));
% Rectification of Joint Probability
prs(prs < 1e-10) = 1e-10;
prs = prs / sum(prs(:));
% Prior probability
ps = ones(1, m) / m;
% Plot of joint probability
% plot(Bin, prs, 'linewidth', 2)
% xlabel('Stimuli')
% ylabel('p(r,s)')
% title('Joint Probability')
% Marginal probability p(x)
pr = sum(prs, 2); 
% Mutual Information matrix
MI_Mat = prs .* log2(prs./(pr*ps));
MI = sum(MI_Mat(:));