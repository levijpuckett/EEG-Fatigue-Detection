function acc = evaluate_features(Data_Post_t, Data_Pre_t, features, len_epoch)
% evaluate_features is a function which tests a feature vector by training
% the model, and calculating the classification accuracy.
[XrestN,XfatN] = feature_extraction(Data_Pre_t, Data_Post_t, len_epoch);

% Control RNG.
rand('state',21);

len_rest = size(XrestN,1);
len_fat = size(XfatN,1);
rest_samples = randperm(len_rest);
fat_samples = randperm(len_fat);
train_res = cast(0.2 * len_rest,'int16');

% Divide data into training and testing data.
Xtr = [XrestN(rest_samples(1 : end-train_res),features) ; XfatN(fat_samples(1 : end-train_res),features)];
ytr = [ones(len_rest-train_res,1) ; -ones(len_fat-train_res,1)];

Xtest = [XrestN(rest_samples(end-train_res:end),features) ; XfatN(fat_samples(end-train_res:end),features)];
ytest = [ones(train_res+1,1) ; -ones(train_res+1,1)];

% Train SVM model.
SVMModel = fitcsvm(Xtr, ytr);

% Evaluate model.
labels = predict(SVMModel, Xtest);
guess = labels == ytest;
disp('Original Result: ')
acc = mean(guess);
disp(mean(guess))

last_fat = 1;
last_rest = 1;

for i = 1 : 15
    this_sub_fat = cast((size(Data_Post_t{i},1) - 256 * 15) / (len_epoch+2*256),'int16');
    this_sub_rest = cast((size(Data_Pre_t{i},1) - 256 * 15) / (len_epoch+2*256),'int16');
    
    fat_r = 1 : len_fat;
    fat_tr = last_fat > fat_r | fat_r > (this_sub_fat + last_fat - 1);
    
    rest_r = 1 : len_rest;
    rest_tr = last_rest > rest_r | rest_r > (this_sub_rest + last_rest - 1);
    
    Xtr = [XrestN(:,features) ; XfatN(:,features)];
    ytr = [ones(len_rest,1) ; -ones(len_fat,1)];

    Xtest = [XrestN(last_rest : 1 : (last_rest + this_sub_rest-1),features) ; XfatN(last_fat : 1 : (last_fat + this_sub_fat-1),features)];
    ytest = [ones(this_sub_rest,1) ; -ones(this_sub_fat,1)];
    
    SVMModel = fitcsvm(Xtr, ytr);

    % Evaluate model.
    labels = predict(SVMModel, Xtest);
    guess = labels == ytest;
    disp('This subject: ')
    accc(i) = mean(guess);
    disp(mean(guess))
    
    last_fat = last_fat + this_sub_fat;
    last_rest = last_rest + this_sub_rest;
end
mean(accc)
end