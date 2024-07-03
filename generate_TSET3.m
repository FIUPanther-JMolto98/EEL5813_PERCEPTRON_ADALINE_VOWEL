% Generates TSET3 from the TSET2 variable in TSETS.mat by inputting the coordinates of the pixels (x,y) to be TOGGLED

load('TSETS.mat', 'TSET2'); % load the TSET2 variable from the TSETS.mat file

TSET3 = TSET2; % create a new variable TSET3 as a copy of TSET2

num_samples = size(TSET2, 2); % number of samples

samples_to_skip = [1, 6, 11, 16, 21]; % define the samples to skip

for k = 1:num_samples % begin loop through each sample
    
    if ismember(k, samples_to_skip) % skip specified samples
        fprintf('Skipping sample %d.\n', k);
        continue; % skip the rest of the loop body and proceed to the next iteration
    end
    
    fprintf('Modifying sample %d.\n', k); % display current sample number
    
    while true
        x = input('Enter x-coordinate to toggle (1-5): '); % ask user for x coordinate
        y = input('Enter y-coordinate to toggle (1-4): '); % ask user for y coordinate
        if x >= 1 && x <= 5 && y >= 1 && y <= 4 % validate the input
            break;
        else
            fprintf('Invalid input. Ensure x is between 1-5 and y is between 1-4.\n');
        end
    end
    
    TSET3(:, k) = togglp1(TSET3(:, k), x, y); % apply the togglp1 function to the k-th sample in TSET3
    
    continue_toggle = input('Continue to next sample? (yes=1, no=0): '); % ask the user if they want to proceed with the next sample
    if ~continue_toggle
        break;
    end
end
