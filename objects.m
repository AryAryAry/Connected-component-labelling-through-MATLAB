function out = objects(a)
    %% Initialize image matrix and other variables
    a = rgb2gray(imread(a)); %convert to a BW image for cannny operator input
    out = uint8(30*edge(out,'canny')); %change 30 to any initial value you want
    anch = [1 1]; %anchor that moves whenever an object is completely labelled
    R = size(out,1);
    C = size(out,2);
    t = struct('arr',{[],[]});
    %to initialize the connected points cell array. One contains the sources to check surroundings of and the 
    %other stores the pixels that will become the source elements after the current source cell elements have been inspected
    i = 1;j = 60; s = 1; d = 2; last_emp = 0;
    %j is the value that is assigned to connected componenets, you change
    %it according to the number of objects in your image data.
    %lamp_emp is used to check if last source element has 0 surroundings of value 30. 
    %Suppose, the last source element gives 0 elements in destination, so
    %it will move on to the next source element, which
    %actually isn't present. The code checks if last_emp is 1 and then does
    %the exchange of source and destination matrices, otherwise moves on to the next source element.
    %% Start checking 
    while (anch(1)~= R || anch(2)~= C)
        if(out(anch(1),anch(2)) == 30)%check 30 labelled pixel
            t(1).arr = anch;  %put the anchor element as the first source array element
            out(anch(1),anch(2)) = j; %label the first pixel with new value
            while true
                [row,col] = find(out(t(s).arr(i,1)-1:t(s).arr(i,1)+1,t(s).arr(i,2)-1:t(s).arr(i,2)+1) == 30);
                %find the elements labelled 30 from 8 pixels around the
                %source element.The resultant matrix gives index values relative
                %to pixel : [source row-2 source column-2]
                if sum([row col])== 0 & i~=size(t(s).arr,1) 
                    %check if all surrounding pixels present are labelled and the source element is last or not.
                    %Ths helps us decide whether we have to go to the next
                    %existing source element or..<continued>
                    last_emp = 0;
                    i = i+1;
                    continue;
                elseif sum([row col])==0 & i==size(t(s).arr,1) 
                    %<continued>..whether we have to switch the source
                    %and destination arrays because the next source doesn't
                    %exist
                    last_emp = 1;
                end

                if sum([row col])~= 0 & last_emp == 0
                    %proceed only if source element has 30-labelled pixels around and is not an empty last element
                        temp = (t(s).arr(i,:)-2).*ones(size(row(1))) + [row col]; %get absolute positions
                        t(d).arr = [t(d).arr;temp];% store their absolute positions
                        for k=1:size(temp,1)
                            out(temp(k,1),temp(k,2))=j; %assign new labels to them
                        end
                end

                if i == size(t(s).arr,1)  %all elements of source array read
                    i = 1; %to continue again until break
                    if size(t(d).arr) == [0 0] 
                        %check if the destination array doesn't have any elements. The blob is all labelled
                        j = j+30; 
                        %new label value for next blob/object. Change the
                        %increment according to no of objects in your image
                        %make sure the value of j doesn't cross 255. You
                        %can change the image to uint16 above for higher
                        %ranges of j.
                        s=1;d=2; 
                        t(s).arr=[];%emptying source array
                        last_emp=0; %important 
                        break;  %move on to next blob/object
                    else
                        t(s).arr = []; %if elements present in destination, clear the souce
                        switch(s) %switch source and destination indices in cell array
                            case 1
                                s=2; d=1; 
                            case 2
                                s=1; d=2;
                            otherwise
                        end
                        last_emp=0;
                    end
                else
                    i = i+1; %if more elements remain in the source, keep labelling
                end
            end
        else
    %% moving anchor ahead
            if anch(2) == C
                anch(1) = anch(1)+1;
                anch(2) = 1;
            else
                anch = anch + [0 1];
            end
        end    
    end
    % show final labelled image
    % subscribe to pewdiepie :)
imshow(out);
end
