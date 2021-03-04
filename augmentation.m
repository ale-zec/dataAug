% PARAMETERS
%    - trainingImages: tensor containing images, has size (227, 227, 3, (number of images))      
%    - labels: contains the labels of trainingImages    
%    - trainingImages(:,:,:,i) belongs to class labels(i)

% RETURNS
%    - trainingImagesFinal: tensor containing original and augmented patterns, has size (227, 227, 3, (number of images)*36)
%    - labelsFinal: contains the labels of trainingImagesFinal 

function [trainingImagesFinal, labelsFinal] = augmentation(trainingImages, labels)

    [trainingImagesFinal, labelsFinal] = cumulative_shdw_h(trainingImages, labels);

end

% cumulative shadows (35 groups, both contrast functions, with harshness)
function [trainingImagesModified, labelsModified] = cumulative_shdw_h(trainingImages, labels)
    
    group1 = trainingImages;
    group2 = trainingImages;
    group3 = trainingImages;
    group4 = trainingImages;
    group5 = trainingImages;
    group6 = trainingImages;
    group7 = trainingImages;
    group8 = trainingImages;
    group9 = trainingImages;
    group10 = trainingImages;
    group11 = trainingImages;
    group12 = trainingImages;
    group13 = trainingImages;
    group14 = trainingImages;
    group15 = trainingImages;
    group16 = trainingImages;
    group17 = trainingImages;
    group18 = trainingImages;
    group19 = trainingImages;
    group20 = trainingImages;
    group21 = trainingImages;
    group22 = trainingImages;
    group23 = trainingImages;
    group24 = trainingImages;
    group25 = trainingImages;
    group26 = trainingImages;
    group27 = trainingImages;
    group28 = trainingImages;
    group29 = trainingImages;
    group30 = trainingImages;
    group31 = trainingImages;
    group32 = trainingImages;
    group33 = trainingImages;
    group34 = trainingImages;
    group35 = trainingImages;

    % soft contrasts
    
    %%% group 1 
    % stretched
    group1 = stretch_contract(group1);


    %%% group 2 
    % decrease contrast 1, blur
    group2 = contrast_blur_h(group2,1,0,0);
    
    
    %%% group 3 
    % increase contrast 1, blur
    group3 = contrast_blur_h(group3,1,1,0);

    
    %%% group 4 
    % stretch, decrease contrast 1, blur
    group4 = stretch_contract(group4);
    group4 = contrast_blur_h(group4,1,0,0);
    
    
    %%% group 5 
    % stretch, increase contrast 1, blur
    group5 = stretch_contract(group5);
    group5 = contrast_blur_h(group5,1,1,0);


    %%% group 6 
    % decrease contrast 2, blur
    group6 = contrast_blur_h(group6,2,0,0);
    
    
    %%% group 7 
    % increase contrast 2, blur
    group7 = contrast_blur_h(group7,2,1,0);

    
    %%% group 8 
    % stretch, decrease contrast 2, blur
    group8 = stretch_contract(group8);
    group8 = contrast_blur_h(group8,2,0,0);
    
    
    %%% group 9
    % stretch, increase contrast 2, blur
    group9 = stretch_contract(group9);
    group9 = contrast_blur_h(group9,2,1,0);
    
    
    %%% group 10
    % shadows
    group9 = shadows(group9);
    
    
    %%% group 11 
    % shadows, stretch
    group11 = stretch_contract(group11);
    group11 = shadows(group11);

    
    %%% group 12 
    % decrease contrast 1, blur, shadows
    group12 = contrast_blur_h(group12,1,0,0);
    group12 = shadows(group12);
    
    
    %%% group 13 
    % increase contrast 1, blur, shadows
    group13 = contrast_blur_h(group13,1,1,0);
    group13 = shadows(group13);
    
    
    %%% group 14 
    % stretch, decrease contrast 1, blur, shadows
    group14 = stretch_contract(group14);
    group14 = contrast_blur_h(group14,1,0,0);
    group14 = shadows(group14);
    
    
    %%% group 15 
    % stretch, increase contrast 1, blur, shadows
    group15 = stretch_contract(group15);
    group15 = contrast_blur_h(group15,1,1,0);
    group15 = shadows(group15);
    

    %%% group 16 
    % decrease contrast 2, blur, shadows
    group16 = contrast_blur_h(group16,2,0,0);
    group16 = shadows(group16);
    
    
    %%% group 17 
    % increase contrast 2, blur, shadows
    group17 = contrast_blur_h(group17,2,1,0);
    group17 = shadows(group17);
    
    
    %%% group 18 
    % stretch, decrease contrast 2, blur, shadows
    group18 = stretch_contract(group18);
    group18 = contrast_blur_h(group18,2,0,0);
    group18 = shadows(group18);
    
    
    %%% group 19
    % stretch, increase contrast 2, blur, shadows
    group19 = stretch_contract(group19);
    group19 = contrast_blur_h(group19,2,1,0);
    group19 = shadows(group19);
    
    % harsh contrasts

    %%% group 20
    % decrease contrast 1, blur
    group20 = contrast_blur_h(group20,1,0,1);
    
    
    %%% group 21 
    % increase contrast 1, blur
    group21 = contrast_blur_h(group21,1,1,1);

    
    %%% group 22 
    % stretch, decrease contrast 1, blur
    group22 = stretch_contract(group22);
    group22 = contrast_blur_h(group22,1,0,1);
    
    
    %%% group 23 
    % stretch, increase contrast 1, blur
    group23 = stretch_contract(group23);
    group23 = contrast_blur_h(group23,1,1,1);


    %%% group 24 
    % decrease contrast 2, blur
    group24 = contrast_blur_h(group24,2,0,1);
    
    
    %%% group 25 
    % increase contrast 2, blur
    group25 = contrast_blur_h(group25,2,1,1);

    
    %%% group 26 
    % stretch, decrease contrast 2, blur
    group26 = stretch_contract(group26);
    group26 = contrast_blur_h(group26,2,0,1);
    
    
    %%% group 27
    % stretch, increase contrast 2, blur
    group27 = stretch_contract(group27);
    group27 = contrast_blur_h(group27,2,1,1);

    
    %%% group 28 
    % decrease contrast 1, blur, shadows
    group28 = contrast_blur_h(group28,1,0,1);
    group28 = shadows(group28);
    
    
    %%% group 29 
    % increase contrast 1, blur, shadows
    group29 = contrast_blur_h(group29,1,1,1);
    group29 = shadows(group29);
    
    
    %%% group 30 
    % stretch, decrease contrast 1, blur, shadows
    group30 = stretch_contract(group30);
    group30 = contrast_blur_h(group30,1,0,1);
    group30 = shadows(group30);
    
    
    %%% group 31 
    % stretch, increase contrast 1, blur, shadows
    group31 = stretch_contract(group31);
    group31 = contrast_blur_h(group31,1,1,1);
    group31 = shadows(group31);
    

    %%% group 32 
    % decrease contrast 2, blur, shadows
    group32 = contrast_blur_h(group32,2,0,1);
    group32 = shadows(group32);
    
    
    %%% group 33 
    % increase contrast 2, blur, shadows
    group33 = contrast_blur_h(group33,2,1,1);
    group33 = shadows(group33);
    
    
    %%% group 34 
    % stretch, decrease contrast 2, blur, shadows
    group34 = stretch_contract(group34);
    group34 = contrast_blur_h(group34,2,0,1);
    group34 = shadows(group34);
    
    
    %%% group 35
    % stretch, increase contrast 2, blur, shadows
    group35 = stretch_contract(group35);
    group35 = contrast_blur_h(group35,2,1,1);
    group35 = shadows(group35);
    
    
    %%% output
    trainingImagesModified = cat(4,trainingImages, group1, group2, group3, group4, group5, group6, group7, group8, group9, group10, group11, group12, group13, group14, group15, group16, group17, group18, group19, group20, group21, group22, group23, group24, group25, group26, group27, group28, group29, group30, group31, group32, group33, group34, group35);
    labelsModified = [labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels, labels];
end