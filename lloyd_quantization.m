function y = lloyd_quantization(input_sig,num_levels)
    %Compute the optimum Lloyd Quantization values given an input signal
    %Inputs
    %input_sig-Input Signal
    %num_levels-Numberr of Quantization levels
    %Outputs
    %y-Quantized final output
    y=zeros(size(input_sig));
    if(length(input_sig)<1000)
        [~,levels]=lloyds(input_sig,linspace(-1,1,num_levels));
    else
        [~,levels]=lloyds(input_sig(1:1000),linspace(-1,1,num_levels));
    end
    for i=1:length(input_sig)
        [~,ind]=min(abs(input_sig(i)-levels));
        y(i)=levels(ind);
    end
end