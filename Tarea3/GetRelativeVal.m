function [RelValue] = GetRelativeVal(interval,distance,task)


%Getting values of the corresponding block
switch task
    case 2
        vec = [200 250 319 331 369 381 450 500];
    case 3
        vec = [450 500 619 669 706 756 870 920];
    case 4
        vec = [870 920 981 1169 1231 1419 1470 1520];
    case 5
        vec = [110 122 144 148 156 160 182 194];
    case 6
        vec = [182 194 217 222 232 237 260 272];
    case 7
        vec = [260 272 296 303 317 324 348 360];
end

%Getting relevant value
if task < 5
    val = interval;
else
    val = distance;
end

[a, RelValue] = ismember(val, vec);


