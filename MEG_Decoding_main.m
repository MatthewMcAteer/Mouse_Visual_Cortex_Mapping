%% This script classifies data from Sensors 200 and 233 (corresponding to visual cortex) of MEG.
% The script first classifies data using K-means clustering, then a Support
% Vector machine for comparison. This experiment involved an MEG being used
% to record brain electrical activity in a test subject being shown a
% series of predefined images.

load('kmeans_results.mat');
load('MEG_decoding_data_final.mat');
load('SVM_prediction.mat');

X = MEG_data(:,[200,233]);

% The clustering of the data will change each time kmeans is run. This is
% because K-means uses a random start point and random iterations.

IDX = kmeans(X,5);
        
f1 = figure('Name','Kmeans clustering of MEG data');
plot(X(IDX==1,1),X(IDX==1,2),'b.','MarkerSize',16)
hold on
plot(X(IDX==2,1),X(IDX==2,2),'r.','MarkerSize',16)
plot(X(IDX==3,1),X(IDX==3,2),'g.','MarkerSize',16)
plot(X(IDX==4,1),X(IDX==4,2),'k.','MarkerSize',16)
plot(X(IDX==5,1),X(IDX==5,2),'m.','MarkerSize',16)

xlabel('Sensor 200 (T x 10^{-12} or picotesla)');
ylabel('Sensor 233 (T x 10^{-12} or picotesla)');
set(gca,'Xticklabel', {'-8','-6','-4','-2','0','2','4'});
set(gca,'Yticklabel', {'-6','-4','-2','-0','2','4','6'});

disp('K-means clusters have been plotted.');

%% Classification of the data using a Support Vector Machine (SVM)
% The svmtrain method performs the training phase of the SVM algorithm that
% generates the hyperplane to separate our data. SVMStruct contains the 
% parameters that describe the hyperplane.

%% Train your SVMStruct classifier, then use it with fitcsvm here.
SVMStruct = fitcsvm(train_data,train_cat_labels,'Standardize','on'); 
pred = predict(SVMStruct,test_data);

%% Adds an apostrophe to properly orient the data.
pred = pred';
        
%% Display the pred and test_cat_labels here one you can visually compare them. 
disp('The predicted image categories are as follows:');        
disp(pred);
disp('The correct image categories are as follows:');
disp(test_cat_labels);
        
%% Calculates the accuracy of the SVM Prediction by replacing the question marks.
A = sum(pred==test_cat_labels);
accuracy = A/length(pred);
accuracy = accuracy*100;
Message = ['The accuracy of this SVM Classifier is ',num2str(accuracy),' percent.'];
disp(Message);

