function    [positionInplot] = getPositionInPlot(stimulus)

            switch(stimulus)
                case 182
                    positionInplot = 1;
                case 194
                    positionInplot = 2;
                case 217
                    positionInplot = 3;
                case 222
                    positionInplot = 4;
                case 232
                    positionInplot = 5;
                case 237
                    positionInplot = 6;
                case 260
                    positionInplot = 7;
                case 272
                    positionInplot = 8;
                otherwise
                    disp('stimulus');
            end

