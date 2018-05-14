function y=uniform_quantization(input_sig,num_levels)

    y=zeros(size(input_sig));
    levels=linspace(-1,1,num_levels);
    for i=1:length(input_sig)
        [~,ind]=min(abs(input_sig(i)-levels));
        y(i)=levels(ind);
    end
end