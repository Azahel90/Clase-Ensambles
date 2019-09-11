function block = GetBlock(this_task)

switch this_task
    case 2
        block = 1;
    case 3
        block = 2;
    case 4
        block = 3;        
    case 5
        block = 1;
    case 6
        block = 2;
    case 7
        block = 3;                
    otherwise
        disp('wrong task');
end
        