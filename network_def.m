function A=network_def(index)

if index==1
    A = [0 1 1 0; 0 0 0 1; 1 1 0 0; 0 1 1 0];
elseif index==2
    A = [0 1 0 0; 0 0 0 1; 1 0 0 0; 0 0 1 0];
elseif index==3
    A = [0 1 0 0; 0 0 0 1; 1 0 0 0; 1 0 1 0];
elseif index==4
    A = [0 1 1 1; 0 0 0 0; 0 0 0 0; 0 0 0 0];
elseif index==5
    A = [0 1 1 1; 0 0 0 1; 0 0 0 0; 0 0 0 0];
elseif index==6
    A = [0 0 1 0; 0 0 0 1; 0 1 0 0; 1 0 0 0];
elseif index==7
    A = [0 1 0 0; 0 0 0 1; 1 0 0 0; 0 0 1 0]';
end
end