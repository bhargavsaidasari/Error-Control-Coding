%%Auxiliary function needed for main to run
function msg2= bin_to_states(msg)
msg2=[];
for i=0:(length(msg)/2)-1
    msb=2*i+1;
    lsb=msb+1;
    msg2=[msg2 2*msg(msb)+msg(lsb)];
end
end
