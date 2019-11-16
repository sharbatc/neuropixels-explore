

%%%%%%%%%
%   GOAL: Find different nodal properties of some
%   brain matrix.
%
%   INPUT: Should be connectivity matrices in the
%   following dimensions.
%   n x n x measurement x subs
%       - where "n" = nodes

%  Dependencies: - find_nodal_versatility.m


% Import directories and datasets
clear
addpath '/Users/sorellana/Documents/MATLAB/BCT/BCT_2019'
addpath '/Users/sorellana/github/neuropixels-explore'

%Initialize things to import
filename = '/Users/sorellana/github/neuropixels-explore/import.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%s'

fileID = fopen(filename,'r');
filesIn = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
filesIn = filesin{1}
fclose(fileID);

for i = 1:size(filesIn,1)
  load(strcat('/Users/sorellana/github/neuropixels-explore/raw_data/', filesIn{2}))
end

%% BREAK try not running the section above twice


%Rename raw data
raw = zeros(size(X743475441_spiketimes), 3);
raw(:,:,1) = X743475441_spiketimes;
raw(:,:,2) = X744228101_spiketimes;
%raw(:,:,3) = ;
%clear X*

nsub = 2;
nnodes = size(X743475441_spiketimes,1)-1;

%for now
raw1 =  X743475441_spiketimes

%%%% Make connectivity matrices for imported data
%Clear out columns that do not  have anything on them - find the 1st variable with a 1
time = struct;

for i = 1:size(raw1(:,:),2)
  if any(raw1(:,i)>0);
    time.start(1) = i
    break
end
end

data1= raw1(:,time.start(1):end);

%Sample 25 ms seconds from the 1st matrix and 25 ms from the second matrix
% dimensions: nodes x samples times x stimulus types x subjects
sampletime = 25000
stimuli = 2
timeseries = nan(nnodes, sampletime, stimuli,3);

for i = 1:nsub
  timeseries(:,:,1,i) = raw1(:,25000:49999);
  timeseries(:,:,2,i) = raw1(:,100000:124999); %Third segement of the measurement
end

%Make connectivity matrix
    %Because it is spike data (ones and zeroes) we compute dice coefficient between
    %variables instead of correlation


matrix = nan(nnodes,nnodes,2,nsub);
for sub = 1:nsub
  for p = 1:stimuli
    for i = 1:nnodes
        for x = 1:nnodes
          if isempty(dice(timeseries(i,:,sub), timeseries(x,:,sub)));
          matrix(i,x,p,sub) = 0;
        else
          matrix(i,x,p,sub) =  dice(timeseries(i,:,sub), timeseries(x,:,sub));
        end
      end
    end
  end
end
save('sofia_ongoing_out.mat')

%For this data obtain nodal_versatility
% dimnensions: node x stimuli x subjects
versatility_m = zeros(nnodes,stimuli, nsubs)
for i  = 1:nsub
  for stim  = 1:stimuli
    find_nodal_versatility(:,stimuli,nsub) = find_nodal_versatility(matrix(:,:,stimuli,sub))
  end
end
versatility_m = find_nodal_versatility(matrix)' %add normalization parameter

save('sofia_ongoing_out.mat')

%% CONTINUATION
load('sofia_ongoing_out.mat')

%%%%%%%%%%% Visualize propoerties of these matrices

figure(1)
subplot(3,2,1)
hist(versatility_m(:,1,1))
subplot(3,2,2)
hist(versatility_m(:,2,1))

subplot(3,2,3)
hist(versatility_m(:,1,2))
subplot(3,2,4)
hist(versatility_m(:,2,2))
