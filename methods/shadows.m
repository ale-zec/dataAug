
function trainingImagesFinal = shadows(trainingImages)
    
    trainingImagesFinal = uint8(zeros(size(trainingImages)));
    
    for pattern = 1:size(trainingImages , 4)               
        
        
        %% shadows 
        
        xval = linspace(0,1,227); % every column number normalized between 0 and 1
        
        direction = randi(2)-1; % 1: l->r, 0: r->l
        
        % function darkens half of the image
        if(direction)
           yval = 0.2+((xval./0.5).^(1/2)).*0.8;
        else
           yval = 0.2+(((-xval+1)./0.5).^(1/2)).*0.8;
        end
        
        % cap values of the function at 1, so that after the midpoint of
        % the image is reached, pixel intensities get multiplied by 1
        yval(yval>1)=1;
        
        % applying shadows 
        ch1 = trainingImages(:,:,1,pattern);
        ch2 = trainingImages(:,:,2,pattern);
        ch3 = trainingImages(:,:,3,pattern);

        for i = 1 : 227
            ch1(:,i) = ch1(:,i)*yval(i);
            ch2(:,i) = ch2(:,i)*yval(i);
            ch3(:,i) = ch3(:,i)*yval(i);
        end

        
        %% append modified image at the end of the dataset
        trainingImagesFinal(:,:,1,pattern) = ch1;
        trainingImagesFinal(:,:,2,pattern) = ch2;
        trainingImagesFinal(:,:,3,pattern) = ch3;
    end
end
