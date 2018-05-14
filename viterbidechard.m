function [predecessor_states,error_Table,optimum_path,data] = viterbidechard(K,coded)
%Function implements the hard decision viterbi decoding
% K denotes the constraint length and coded is the demodulated binary
% sequence
%%
%Intializing arrays essential for the state decoding process
%The State Transition table: the next state given the current state and
%input
transition_Table=[0 0 2;1 0 2;2 1 3;3 1 3];
%The output table:determins the output given the current state and the
%input
output_Table=[0 0 3;1 3 0;2 2 1;3 1 2];
%Error Metric Array-Track of accumulated error
error_Table=zeros(2^(K-1),1);
%Initialize the current state to be always 0 
current_state=[0];
%State predecessor history-local optimum at each time instant
predecessor_states=zeros(2^(K-1),length(coded)/2);


%%
%Main section where magic happens
for i=0:length(predecessor_states)-1
    %possible states the algorithm might end up in given it's current state
    possible_states=transition_Table(current_state+1,2:3);
    %possible outputs the algorithm might end up in given it's current state
    possible_outputs=output_Table(current_state+1,2:3);
    possible_states=reshape(possible_states',1,[]);
    possible_outputs=reshape(possible_outputs',1,[]);
    possible_outputs=de2bi(possible_outputs,2,'left-msb');
    possible_outputs(possible_outputs~=0)=-1;
    possible_outputs(possible_outputs==0)=1;
    %Distance between received sequence and possible outputs
    %ham_distance= sum(abs(dec2bin(coded(i),2)-dec2bin(possible_outputs,2)),2);
    euc_distance= sum([coded(2*i+1) coded(2*i+2)].*possible_outputs,2);
    %A variable to keep track if a state has aleady been updated during the loop
    flag=zeros(2^(K-1),1);
    %A duplicate error metric variable to keep track of error in the for loop 
    error_Table2=nan(2^(K-1),1);
    %loop through current states
    for count=1:length(current_state)
        count2=transition_Table(current_state(count)+1,2:3);
        %update error metric for the possible states
        if(sum(flag(count2+1))==0)
            error_Table2(count2+1,1)= error_Table(current_state(count)+1,1)+euc_distance(2*count-1:2*count,1);
            flag(count2+1)=1;
            predecessor_states(count2+1,i+1)= current_state(count);
        else
            error_temp=error_Table(current_state(count)+1,1)+euc_distance(2*count-1:2*count,1);
            [error_Table2(count2+1,1),ind]=min([error_Table2(count2+1,1)';error_temp']);
            change_index= ind==2;
            if(~isempty(ind==2))
                predecessor_states(count2(change_index)+1,i+1)=current_state(count);
            end
            
            
        end
        
    end
    error_Table2(isnan(error_Table2))=0;
    error_Table=error_Table2;
    error_table(:,i+1)=error_Table;
    %update current state to possible state for next iteration
    current_state=unique(sort(possible_states));
end

%%
%Traceback
%End of block is zero since it's just flush bits
optimum_path=predecessor_states(1,length(predecessor_states));
for count3=length(predecessor_states)-1:-1:2
    path= predecessor_states(optimum_path(1)+1,count3);
    optimum_path=[path optimum_path];
end
%%
%Decode the optimum path
current_state=0;
data=[];
for count4=1:length(optimum_path)
    if(transition_Table(current_state+1,2)==optimum_path(count4))
        data=[data 0];
    else
        data=[data 1];
    end
    current_state=optimum_path(count4);
end
%last bit is 0.(The impact of flush bits)
data=[data 0];
end