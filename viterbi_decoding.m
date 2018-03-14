%%
%Parameters of the convolutional code
K=3;
n=1/2;
%Generating Funtions
%%
%Intializing arrays essential for the state decoding process
%The State Transition table: the next state given the current state and
%input
transition_Table=[0 0 2;1 0 2;2 1 3;3 1 3];
inverse_Transition_table=[0 1;2 3;0 1;2 3];
%The output table:determins the output given the current state and the
%input
output_Table=[0 0 3;1 3 0;2 2 1;3 1 2];
%State predecessor history-local optimum at each time instant
pred_Table= zeros(2^(K-1),K*5+1);
%Error Metric Array-Track of accumulated error
error_Table=zeros(2^(K-1),1);
error_Table2=zeros(2^(K-1),1);
%State Sequence Array
sequence_array=zeros(K*5+1,1);
%
current_state=[0];
rcvd=[0 3 3];
predecessor_states=zeros(2^(K-1),length(rcvd));


%%

for i=1:length(rcvd)
    possible_states=transition_Table(current_state+1,2:3);
    possible_outputs=output_Table(current_state+1,2:3);
    possible_states=reshape(possible_states',1,[]);
    possible_outputs=reshape(possible_outputs',1,[]);
    ham_distance= sum(abs(dec2bin(rcvd(i),2)-dec2bin(possible_outputs,2)),2);
    flag=zeros(2^(K-1),1);
    for count=1:length(current_state)
        count2=transition_Table(current_state(count)+1,2:3);
        if(sum(flag(count2+1))==0)
            error_Table2(count2+1,1)= error_Table(current_state(count)+1,1)+ham_distance(2*count-1:2*count,1)
            flag(count2+1)=1;
            predecessor_states(count2+1,i)= current_state(count);
        else
            error_temp=error_Table(current_state(count)+1,1)+ham_distance(2*count-1:2*count,1);
            [error_Table2(count2+1,1),ind]=min([error_Table2(count2+1,1)';error_temp']);
            change_index=find(ind==2);
            if(~isempty(ind==2))
                predecessor_states(count2(change_index)+1,i)=current_state(count);
            end
            
            
        end
        
    end
    error_Table=error_Table2;
    current_state=unique(sort(possible_states));
end
            
    
    %predecessor-successor metric


%Traceback

    
