function [si] = surpriseindex(t, num_spike,avg_rate)

%t = time interval to consider
%num_spike = total number of spikes
%avg_rate = average dischargerate

 MAXPROB = 1; 
 rt = 0.; %mean discharge rate times the time interval
 sum = 0.; %sumatory
 p = 0.; %probability
 new_prob = 0.;
 old_prob = 0.;
         

 
        rt = avg_rate * t;

        sum = exp(-rt);
        old_prob = exp(-rt);

        % does prob summation for 0 to n spikes */

        for (j = 1: num_spike) 

                new_prob = (rt * old_prob) / j;

                sum = sum + new_prob;

			%If sum gets sufficiently close to 1.000..., break out of the loop               

                if (sum >= 1)
                        sum = MAXPROB;
                        break;
                end       

                old_prob = new_prob;

        end


        % Subtract obtained probability from 1.0 to determine tail of distribution


        p = 1.0 - sum;
        if (p == 0) 
            p = 0.0000000000000000001;
        end    



        % the next line is for when p = 1 (log(1) = 0); the algorithm will sometimes stop searching for bob and eob 

        if (p >= 0.9999999999999)

                p = 0.9999999999999;
        end        

        if(p > 0)
          si = -log(p);
        else
          si = 0;  
        end  

        
