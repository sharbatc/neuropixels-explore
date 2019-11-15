

%%%%%%%%%
%   GOAL: Find different nodal properties of some
%   brain matrix.
%
%   INPUT: Should be connectivity matrices in the
%   following dimensions.
%   n x n x measurement x subs
%       - where "n" = nodes

%  Dependencies: - find_nodal_versatility.m
%

% Import directories and datasets
clear
addpath '/Users/sorellana/Documents/MATLAB/BCT/BCT_2019'
currentFolder = pwd;
addpath currentFolder
load ??

%%%% Rename input data to match the script



% Here name your input data as input_data
  data = input_data
  nsub = size(input_data,4)
  nnodes = size(input_data,1)
  ndim = size(input_data,3)

% 1) Obtain versality and organize it as follows:
%n x measurements x subs
%Also  store descriptive statistics of each vector
out = struct;
out.versality = nan(nnodes,ndim,nsub);
out.versat_T = table;

  for sub = 1:nsub
    temp = data(:,:,:,sub);
    for mat = 1:ndim
      temp2 = find_nodal_versatility(temp(:,:,mat))';
      out.versat(:,ndim,sub) = temp2;
      %Make table with versatility descriptives
      out.versat_T.subn = nsub;
      out.versat_T.std = std(out.versat(temp2));
      out.versat_T.mean = mean(out.versat(temp2));
    end
  end
clear temp
%
cd(currentFolder)
save('sofia_ongoing_out.mat')

%2) Compute the correlation between columns of the out.versat
    %Stored as correlation matrices (triu)
    %WHY: Determine how similar one presentation is as opposed to another

out.versat_corr_results = table
for i = 1:nsub
  %Store upper triangular of the correlation matrix.
  temp =  triu(corr(out.versat(:,:,i))); %stored as separate matrices
  out.versat_corr(i) = temp;
  % Store correlations in a Table from highest to lowest
  % also store their index - to find which to vars (matrices from input data)
  % are most similar.

    %Obtain number of upper triangular elements in your matrices
    nn = sum(sum(0<triu(abs(temp))))-1; %Check the -1 -- seemed to have worked for indexing.
     %index, and value of highest correlations
      temp_above_diag = triu(temp,1);
      [temp_corrs, temp_idx]= sort(temp2);
      %Table: value, row, column to store
      [temp_row,temp_col]= ind2sub(size(temp),temp_idx(end-nn,end));
      %Make one table per subject in the struct
      out.versat_corr_results(i).value = temp_corrs(end-nn,end);
      out.versat_corr_results(i).row = temp_row;
      out.versat_corr_results(i).col = temp_col;

end


% 2) For repeated measures: Give me a distribution of versatility per node

% across different presentations
    %Store it per subject in a structure

load('sofia_ongoing_out.mat')

    %Each row is a node - make the mini-distributions of each node
