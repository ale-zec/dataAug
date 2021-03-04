
function warped_images = stretch_contract(images)
    
    warped_images = uint8(zeros(size(images)));
    
    for(pattern=1:size(images,4))
        
        clear warped_cols_ch1 warped_cols_ch2 warped_cols_ch3 
        clear warped_rows_ch1 warped_rows_ch2 warped_rows_ch3
        clear change_points_col change_points_row
        
        %% define the variables for the equations
        x_col = 1:227;
        x_row = 1:227;
        equation = rand; % variable used to decide direction of stretching
        col = (rand * 15)+2; % U(2,17)
        row = (rand * 15)+2;
        expansion_col=5; % 5 in (8)
        expansion_row=5;


        %% choose direction of stretching/contracting (up+left / up+right / down+left / down+right)
        if equation >= 0 && equation<.25                   % (5) cols & rows => right-down
            y_col = ((1/col-col)/226)*(x_col-1)+col;
            y_row = ((1/row-row)/226)*(x_row-1)+row;
        elseif equation >= .25 && equation <.5             % (6) cols & rows => left-up
            y_col= ((col-1/col)/226)*(x_col-1)+(1/col);
            y_row= ((row-1/row)/226)*(x_row-1)+(1/row);
        elseif equation >= .5 && equation <.75             % (5) cols (6) rows => right-up
            y_col = ((1/col-col)/226)*(x_col-1)+col;
            y_row= ((row-1/row)/226)*(x_row-1)+(1/row);
        else                                               % (6) cols (5) rows => left-down
            y_col= ((col-1/col)/226)*(x_col-1)+(1/col); 
            y_row = ((1/row-row)/226)*(x_row-1)+row;
        end


        %% stretch the columns of the image
        ch1 = images(:,:,1,pattern);
        ch2 = images(:,:,2,pattern);
        ch3 = images(:,:,3,pattern);
        warped_cols_ch1(:,1) = ch1(:,1); % 1 is mapped in itself
        warped_cols_ch2(:,1) = ch2(:,1);
        warped_cols_ch3(:,1) = ch3(:,1);

        whereWeAre_col = 1;
        for column = 2:227 
            whereWeAre_col = whereWeAre_col + y_col(column); % (7) 
            warped_cols_ch1(:,floor(whereWeAre_col * expansion_col)) = ch1(:,column); % (8)
            warped_cols_ch2(:,floor(whereWeAre_col * expansion_col)) = ch2(:,column);
            warped_cols_ch3(:,floor(whereWeAre_col * expansion_col)) = ch3(:,column);
        end

        empty_columns = (sum(warped_cols_ch1)==0); % same for all channels, since we use the same mapping functions for all 3 channels

        % find the position of the empty columns of the image
        col=size(empty_columns);
        length_empty_col=col(2);
        j=1;
        interp_col_ch1=warped_cols_ch1;
        interp_col_ch2=warped_cols_ch2;
        interp_col_ch3=warped_cols_ch3;
        for i=1:length_empty_col-1
          if empty_columns(i)== 1 && empty_columns(i+1)==0
              change_points_col(j) = i+1;
              j=j+1;
          end
        end

        % interpolate the empty columns of the image
        b_col=size(change_points_col);
        length_change_col=b_col(2);
        start_point=1 ;
        for k=1:length_change_col 
            end_point=change_points_col(k);
            for i=start_point+1:end_point-1
                valueL_ch1= warped_cols_ch1(:,start_point)*(1/(i-start_point));
                valueL_ch2= warped_cols_ch2(:,start_point)*(1/(i-start_point));
                valueL_ch3= warped_cols_ch3(:,start_point)*(1/(i-start_point));

                valueR_ch1= warped_cols_ch1(:,end_point) * (1/(end_point-i));
                valueR_ch2= warped_cols_ch2(:,end_point) * (1/(end_point-i));
                valueR_ch3= warped_cols_ch3(:,end_point) * (1/(end_point-i));

                valueD= (1/(i-start_point)) + (1/(end_point-i)); % same for every channel

                interp_col_ch1(:,i) = (valueL_ch1 + valueR_ch1)/ valueD;
                interp_col_ch2(:,i) = (valueL_ch2 + valueR_ch2)/ valueD;
                interp_col_ch3(:,i) = (valueL_ch3 + valueR_ch3)/ valueD;
            end
           start_point=end_point;
        end

        % resize image after stretch/contract of the columns
        ch1_warped_col=imresize(interp_col_ch1,[227,227]);
        ch2_warped_col=imresize(interp_col_ch2,[227,227]);
        ch3_warped_col=imresize(interp_col_ch3,[227,227]);


        %% stretch rows of the image
        warped_rows_ch1(1,:) = ch1_warped_col(1,:);
        warped_rows_ch2(1,:) = ch2_warped_col(1,:);
        warped_rows_ch3(1,:) = ch3_warped_col(1,:);

        whereWeAre_row = 1;
        for row =  2:227
            whereWeAre_row = whereWeAre_row + y_row(row);
            warped_rows_ch1(floor(whereWeAre_row * expansion_row),:) = ch1_warped_col(row,:);
            warped_rows_ch2(floor(whereWeAre_row * expansion_row),:) = ch2_warped_col(row,:);
            warped_rows_ch3(floor(whereWeAre_row * expansion_row),:) = ch3_warped_col(row,:);
        end

        empty_rows = (sum(warped_rows_ch1,2)==0);

        % find empty rows of the image
        row=size(empty_rows);
        length_empty_row=row(1);
        j=1;
        interp_row_ch1=warped_rows_ch1;
        interp_row_ch2=warped_rows_ch2;
        interp_row_ch3=warped_rows_ch3;
        for i=1:length_empty_row
          if empty_rows(i)== 1 && empty_rows(i+1)==0
              change_points_row(j) = i+1;
              j=j+1;
          end
        end

        % interpolate the empty rows of the image
        b_row=size(change_points_row);
        length_change_row=b_row(2);
        start_point=1;
        for k=1:length_change_row 
            end_point=change_points_row(k);
            for i=start_point+1:end_point-1
                valueL_ch1= warped_rows_ch1(start_point,:)*(1/(i-start_point));
                valueL_ch2= warped_rows_ch2(start_point,:)*(1/(i-start_point));
                valueL_ch3= warped_rows_ch3(start_point,:)*(1/(i-start_point));

                valueR_ch1= warped_rows_ch1(end_point,:) * (1/(end_point-i));
                valueR_ch2= warped_rows_ch2(end_point,:) * (1/(end_point-i));
                valueR_ch3= warped_rows_ch3(end_point,:) * (1/(end_point-i));

                valueD= (1/(i-start_point)) + (1/(end_point-i));

                interp_row_ch1(i,:)= (valueL_ch1 + valueR_ch1)/ valueD;
                interp_row_ch2(i,:)= (valueL_ch2 + valueR_ch2)/ valueD;
                interp_row_ch3(i,:)= (valueL_ch3 + valueR_ch3)/ valueD;
            end
           start_point=end_point;
        end

        % resize image after stretch/contract of the columns and rows
        interp_row_ch1=uint8(interp_row_ch1);
        interp_row_ch2=uint8(interp_row_ch2);
        interp_row_ch3=uint8(interp_row_ch3);
        ch1_warped_rows=imresize(interp_row_ch1,[227,227]);
        ch2_warped_rows=imresize(interp_row_ch2,[227,227]);
        ch3_warped_rows=imresize(interp_row_ch3,[227,227]);


        %% final spatial stretched/contracted image
        warped_images(:,:,1,pattern) = ch1_warped_rows;
        warped_images(:,:,2,pattern) = ch2_warped_rows;
        warped_images(:,:,3,pattern) = ch3_warped_rows;
    end
end
