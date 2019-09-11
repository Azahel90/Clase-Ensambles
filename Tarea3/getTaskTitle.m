function [taskTitle] = getTaskTitle(task)
switch task
    case 1
        taskTitle = 'Control';
    case 2
        taskTitle = 'TM1';
    case 3
        taskTitle = 'TM2';
    case 4
        taskTitle = 'TM3';
    case 5
        taskTitle = 'SP1';
    case 6
        taskTitle = 'SP2';
    case 7
        taskTitle = 'SP3';
end