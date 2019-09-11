function Rafagas(nameplot,varargin)

tamano = 5;
aa=1;
if(length(varargin)==1)
    
    cond1 = varargin{1};
    for j=aa:5
        for i=j:5
            xcorr_Plot = xcorr(cond1(j,:),cond1(i,:),'coeff');
            subplot(5,5,i + (tamano * (j-1)))
            plot(xcorr_Plot)
            ylim([-.3 1])
            title(['Rafaga ',num2str(j),'vs','Rafaga',num2str(i)])
            
            if( i + (tamano * (j-1))~=  tamano*tamano)
                set(gca, 'box', 'off', 'xtick', []);
                set(gca, 'box', 'on', 'ytick', []);
            end
        end
        suptitle(nameplot)
    end
    Mat = Rafagas25;
    
else
    figure;
    cond1 = varargin{1,1};
    cond2 = varargin{1,2};
    for j=aa:5
        for i=j:5
            xcorr_Plot = xcorr(cond1(j,:),cond2(i,:),'coeff');
            subplot(5,5,i + (tamano * (j-1)))
            plot(xcorr_Plot)
            ylim([-.3 1])
            title(['Rafaga ',num2str(j),'vs','Rafaga',num2str(i)])
            
            if( i + (tamano * (j-1))~=  tamano*tamano)
                set(gca, 'box', 'off', 'xtick', []);
                set(gca, 'box', 'on', 'ytick', []);
            end
        end
        suptitle(nameplot)
    end
    Mat = Rafagas25;
end


    function Mat = Rafagas25
        if(length(varargin) == 1)
            Mat = reshape(cond1(:,1:end-1)',625,100);
            for j =1:size(Mat,2)
                for i=1:size(Mat,2)
                    [C,Lag]= xcorr(Mat(:,j),Mat(:,i));
                    MatSim(j,i)= C((Lag == 0));
                    %                MatSim(j,i)= max(xcorr(Mat(:,j),Mat(:,i)));
                    
                end
            end
            MatSim = MatSim./max(MatSim,[],2);
        else
            Mat = [reshape(cond1(:,1:end-1)',625,100),reshape(cond2(:,1:end-1)',625,100)];
            for j =1:size(Mat,2)-100
                for i=101:size(Mat,2)
%                     [C,Lag]= xcorr(Mat(:,j),Mat(:,i));
%                     MatSim(j,i)= C((Lag == 0));
                                   MatSim(j,i)= max(xcorr(Mat(:,j),Mat(:,i)));
                    
                end
            end
            MatSim = MatSim./max(MatSim,[],2);
            
        end
        
    end


%     function  Mat = Rafagas25
%         if(length(varargin) == 1)
%             Mat = reshape(cond1(:,1:end-1)',625,100);
%             [C,Lag]= xcorr(Mat(:,1),Mat(:,1),500);
%         else
%             Mat = [reshape(cond1(:,1:end-1)',625,100),reshape(cond2(:,1:end-1)',625,100)];
%         end

figure;
imagesc(MatSim(:,101:end))
colormap('jet')
colorbar
title([nameplot,' 25 ms'])
end


