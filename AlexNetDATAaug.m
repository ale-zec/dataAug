clear all
warning off

disp("Start:");
disp(datestr(now,'HH:MM:SS'));

%load('DatasColor_38.mat');
load('Datas_2.mat');

NF=size(DATA{3},1); %number of folds
DIV=DATA{3}; %division between training and test set 
DIM1=DATA{4}; %number of training patterns
DIM2=DATA{5}; %number of patterns
yE=DATA{2}; %labels
NX=DATA{1}; %images

%load pre-trained network
net = alexnet; % alexnet
siz=[227 227];

% network parameters
miniBatchSize = 30;
learningRate = 1e-4;
metodoOptim='sgdm';
options = trainingOptions(metodoOptim,...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',20,...
    'InitialLearnRate',learningRate,...
    'Verbose',false,...
    'Plots','training-progress',...
    'ExecutionEnvironment','gpu');
numIterationsPerEpoch = floor(DIM1/miniBatchSize);


for fold=1:NF
    close all force
    
    disp("Progress:");
    disp(datestr(now,'HH:MM:SS'));
    disp(fold);
    
    trainPattern=(DIV(fold,1:DIM1)); % training set indexes
    testPattern=(DIV(fold,DIM1+1:DIM2)); % test set indexes
    y=yE(DIV(fold,1:DIM1)); % training labels
    yy=yE(DIV(fold,DIM1+1:DIM2)); % test labels
    numClasses = max(y); % number of classes
    
    % training set
    clear nome trainingImages
    for pattern=1:DIM1
        IM=NX{DIV(fold,pattern)};
        
        % eventual preprocessing
        
        % resize, create 3 channels if the image doesn't have them
        IM=imresize(IM,[siz(1) siz(2)]);
        if size(IM,3)==1
            IM(:,:,2)=IM;
            IM(:,:,3)=IM(:,:,1);
        end
        trainingImages(:,:,:,pattern)=IM;
    end
    imageSize=size(IM);
    
    % data augmentation
    [trainingImages, y] = augmentation(trainingImages, y);
    
    % default data augemtation with augmented image datastore    
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true);
    trainingImages = augmentedImageSource(imageSize,trainingImages,categorical(y'),'DataAugmentation',imageAugmenter);

    % network tuning
    layersTransfer = net.Layers(1:end-3);
    layers = [
        layersTransfer
        fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
        softmaxLayer
        classificationLayer];
    netTransfer = trainNetwork(trainingImages,layers,options); % with augmented image datastore
    %netTransfer = trainNetwork(trainingImages,categorical(y'),layers,options); % without augmented image datastore
    
    % test set
    clear nome test testImages
    for pattern=ceil(DIM1)+1:ceil(DIM2)
        IM=NX{DIV(fold,pattern)};
        
        % eventual preprocessing
        
        IM=imresize(IM,[siz(1) siz(2)]);
        if size(IM,3)==1
            IM(:,:,2)=IM;
            IM(:,:,3)=IM(:,:,1);
        end
        testImages(:,:,:,pattern-ceil(DIM1))=uint8(IM);
    end
    
    % classification
    [outclass, score{fold}] =  classify(netTransfer,testImages);
    
    % accuracy
    [a,b]=max(score{fold}'); 
    ACC(fold)=sum(b==yy)./length(yy);
    
end
meanACC = mean(ACC)

disp("Finish:");
disp(datestr(now,'HH:MM:SS'));

% save
save('data.mat','score','ACC','meanACC');

