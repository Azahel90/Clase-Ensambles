function CosSimilarity(Rasterbin)
%Cosine similarity anonymous function
SimMat = zeros(size(Rasterbin,2),size(Rasterbin,2));
d = @(u,v)transpose(u)*v/(norm(u)*norm(v));

cont = 1;
while(cont <= size(Rasterbin,2))
    for i=1:size(Rasterbin,2)
        A{1} = Rasterbin(:,cont);
        B{1} = Rasterbin(:,i);
        SimMat(cont,i) = cellfun(d,A,B);
    end
    cont = cont+1;
end

%-----Plot Figure-----%
figure;
colorbar
colormap(parula)
imagesc(SimMat)
title('Similarity Matrix')
