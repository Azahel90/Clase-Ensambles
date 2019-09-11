function [pre, post] = getPrePost (task, EpochNum, monkey)
if task < 5
    switch EpochNum
        
        case 1
            pre(1) = -500;
            pre(2) = -500;
            pre(3) = -500;
            pre(4) = -500;
            pre(5) = -500;
            pre(6) = -500;
            pre(7) = -500;
            post(1) = 4500;
            post(2) = 4500;
            post(3) = 4500;
            post(4) = 4500;
            post(5) = 4500;
            post(6) = 4500;
            post(7) = 4500;
            
        case 2
            pre(1) = -500;
            pre(2) = -500;
            pre(3) = -500;
            pre(4) = -500;
            pre(5) = -500;
            pre(6) = -500;
            pre(7) = -500;
            post(1) = 2500;
            post(2) = 2500;
            post(3) = 2500;
            post(4) = 2500;
            post(5) = 2500;
            post(6) = 2500;
            post(7) = 2500;
%             post(1) = 3000;
%             post(2) = 3000;
%             post(3) = 3000;
%             post(4) = 3000;
%             post(5) = 3000;
%             post(6) = 3000;
%             post(7) = 3000;
            
        case 3            
            pre(1) = -1500;
            pre(2) = -1500;
            pre(3) = -1500;
            pre(4) = -1500;
            pre(5) = -1500;
            pre(6) = -1500;
            pre(7) = -1500;
            post(1) = 2000;
            post(2) = 2000;
            post(3) = 2000;
            post(4) = 2000;
            post(5) = 2000;
            post(6) = 2000;
            post(7) = 2000;
%             pre(1) = -2000;
%             pre(2) = -2000;
%             pre(3) = -2000;
%             pre(4) = -2000;
%             pre(5) = -2000;
%             pre(6) = -2000;
%             pre(7) = -2000;
%             post(1) = 2500;
%             post(2) = 2500;
%             post(3) = 2500;
%             post(4) = 2500;
%             post(5) = 2500;
%             post(6) = 2500;
%             post(7) = 2500;
            
        case 4
            pre(1) = -2000;
            pre(2) = -1990;
            pre(3) = -2400;
            pre(4) = -3000;
            pre(5) = -2000;
            pre(6) = -2000;
            pre(7) = -2000;
            
            if monkey == 1
                post(1) = 600;
                post(2) = 600;
                post(3) = 600;
                post(4) = 600;
                post(5) = 600;
                post(6) = 600;
                post(7) = 600;
            end
            
        case {5, 6, 7}
            pre(1) = -3500;
            pre(2) = -3000;
            pre(3) = -3500;
            pre(4) = -3500;
            pre(5) = -3500;
            pre(6) = -3500;
            pre(7) = -3500;
            post(1) = 1500;
            post(2) = 1500;
            post(3) = 1500;
            post(4) = 1500;
            post(5) = 1500;
            post(6) = 1500;
            post(7) = 1500;   
    end
    
elseif task > 4
    switch EpochNum
        case 1
            pre(1) = -500;
            pre(2) = -500;
            pre(3) = -500;
            pre(4) = -500;
            pre(5) = -500;
            pre(6) = -500;
            pre(7) = -500;
            post(1) = 4500;
            post(2) = 4500;
            post(3) = 4500;
            post(4) = 4500;
            post(5) = 4500;
            post(6) = 4500;
            post(7) = 4500;
            
        case 2
           pre(1) = -500;
            pre(2) = -500;
            pre(3) = -500;
            pre(4) = -500;
            pre(5) = -500;
            pre(6) = -500;
            pre(7) = -500;
            post(1) = 2500;
            post(2) = 2500;
            post(3) = 2500;
            post(4) = 2500;
            post(5) = 2500;
            post(6) = 2500;
            post(7) = 2500;            
        case 3
%             pre(1) = -1500;
%             pre(2) = -1500;
%             pre(3) = -1500;
%             pre(4) = -1500;
%             pre(5) = -1500;
%             pre(6) = -1500;
%             pre(7) = -1500;
%             post(1) = 3500;
%             post(2) = 3500;
%             post(3) = 3500;
%             post(4) = 3500;
%             post(5) = 3500;
%             post(6) = 3500;
%             post(7) = 3500;
   pre(1) = -1500;
            pre(2) = -1500;
            pre(3) = -1500;
            pre(4) = -1500;
            pre(5) = -1500;
            pre(6) = -1500;
            pre(7) = -1500;
            post(1) = 2000;
            post(2) = 2000;
            post(3) = 2000;
            post(4) = 2000;
            post(5) = 2000;
            post(6) = 2000;
            post(7) = 2000;
            
%             pre(1) = -2000;
%             pre(2) = -2000;
%             pre(3) = -2000;
%             pre(4) = -2000;
%             pre(5) = -2000;
%             pre(6) = -2000;
%             pre(7) = -2000;
%             post(1) = 2500;
%             post(2) = 2500;
%             post(3) = 2500;
%             post(4) = 2500;
%             post(5) = 2500;
%             post(6) = 2500;
%             post(7) = 2500;

            
            
        case 4
            pre(1) = -2000;
            pre(2) = -1990;
            pre(3) = -2400;
            pre(4) = -3000;
            pre(5) = -2000;
            pre(6) = -2000;
            pre(7) = -2000;
            
            if monkey == 1
                post(1) = 600;
                post(2) = 600;
                post(3) = 600;
                post(4) = 600;
                post(5) = 600;
                post(6) = 600;
                post(7) = 600;
            end
            
        case {5, 6, 7}
            pre(1) = -3000;
            pre(2) = -3000;
            pre(3) = -3000;
            pre(4) = -3000;
            pre(5) = -3000;
            pre(6) = -3000;
            pre(7) = -3000;
            post(1) = 2000;
            post(2) = 2000;
            post(3) = 2000;
            post(4) = 2000;
            post(5) = 2000;
            post(6) = 2000;
            post(7) = 2000;
    end
    
end

end


