% Visualizes ALL 25 TSET2 PATTERNS in (TSETS.mat, TSET2) by creating different subplots and using the dispapm() function in conjunction with col2mtx() found in the pwd

load('TSETS.mat', 'TSET2');  % Make sure TSET2 is loaded into the workspace

% Number of samples and figure size setting
[num_features, num_samples] = size(TSET2);
sqrt_samples = ceil(sqrt(num_samples)); % sqrt(25) = 5, for a 5x5 grid

figure;

% Loop through all samples
for i = 1:num_samples
    subplot(sqrt_samples, sqrt_samples, i); % Creating a subplot for each sample
    dispapm(col2mtx(TSET2(:,i))); % Displaying the sample
    title(sprintf('Sample %d', i)); % Adding a title for each subplot
end