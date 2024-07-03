% Trains the 'E - DETECTOR' using PERCEPTRON learning and 1 PROCESSING ELEMENT (PE) and returns its trained weights (W) and bias (b) when called using [W,b] = train_perceptE_1PE(PP,TA,MAX_EPOCHS)

% FUNCTION DEFINITION
function [W,b] = train_perceptE_1PE(PP, TE, MAX_EPOCHS) % output the W (weights) and b (bias) variable so it remains in the MATLAB workspace and we can then pass it effortlessly to the training function
    
    % INITIALIZE PERCEPTRON
    [num_features, num_samples] = size(PP); % obtain the dimensions (x,y) or [i,j] of the matrix containing the input samples (cols = 25) and their features (rows = 20)
    W = zeros(num_features,1); % we initialize the weight matrix as a zero matrix whose dimensions will be (num_features,1); that is, a (20 x 1) ZERO COLUMN VECTOR [00000 00000 00000 00000]^T
    b = 0; % initialize the bias scalar value to 0
    
    % WEIGHT AND BIAS HISTORY
    all_W = zeros(num_features, MAX_EPOCHS);
    all_b = zeros(1, MAX_EPOCHS);
    
    % EPOCH LOOP
    epoch_errors = zeros(1,MAX_EPOCHS); % global counter to keep track of number of errors (updates) for each epoch as a ROW VECTOR (1xMAX_EPOCHS)
    for epoch = 1:MAX_EPOCHS % epoch loop will start from epoch = 1 until reaching MAX_EPOCHS (defined when calling the function)
        fprintf("\nStarting Epoch: %d\n",epoch); % message indicating the start of epoch
        err_counter = 0; % initialize error counter variable at the beginning of the epoch loop
        
        % STORE WEIGHT AND BIAS FOR EACH EPOCH
        all_W(:, epoch) = W; % records the values of all the weights pertaining to each input feature in the current epoch
        all_b(epoch) = b; % records the value of the weight pertaining to the bias scalar at the current epoch
        
        % PERCEPTRON TRAINING LOOP
        for p = 1:num_samples % perceptron training loop will start from p = 1 until it finishes iterating over our number of samples (p = 25)
            input_sample = PP(:, p); % a complete input_sample per sample is stored in each column of the PP variable (PPTATE.mat file), so in the pth iteration we take ALL ROWS (: or 20) of the corresponding P COLUMN (p)
            t = TE(p); % the corresponding target per sample is stored in each column of the TE variable (PPTATE.mat file), so in the pth iteration we take its SINGLE ROW (1) of the corresponding P COLUMN (p)
            
            % LINEAR COMBINATION/NET-INPUT COMPUTATION (n)
            n = W' * input_sample - b; % W = (20x1) and input_sample = (20x1), so use W'(TRANSPOSE) = (1x20)*(20x1) for dimension compatibility
           
            % HARDLIMS() ACTIVATION COMPUTATION (a)
            a = hardlims(n); % because our encoding is bipolar (-1 or 1), use hardlims() which allows for symmetry
            
            % ERROR CALCULATION
            error = t - a; % error is the difference between our expected output versus what we computed
            
            % IF ERROR DETECTED
            if error ~= 0 % if error NOT EQUAL TO 0
                old_W = W; % store the current weight before updating
                old_b = b; % store the current bias before updating

                W = W + (error * input_sample); % update the value of the weight according to the computed error
                b = b - error; % update the bias

                new_W = W; % store the updated value for the weight
                new_b = b; % store the updated value for the bias

                fprintf('p%d caused a Weight and Bias update:\n',p); % report which sample number (p) triggered the error
                fprintf('Old W: '); disp(old_W'); % print row vector containing the values for the old set of weights
                fprintf('New W: '); disp(new_W'); % print row vector containing the values for the new set of weights
                fprintf('Old b: %d, New b: %d\n', old_b, new_b); % print the scalar value for the old bias and the new bias

                err_counter = err_counter + 1; % increment the error counter for the current sample
            end
        end
        
        % RECORD ERRORS
        epoch_errors(epoch) = err_counter; % at the end of training loop (or forward pass), update the number of errors in the epoch with the number of errors encountered in training
        
        % DISPLAY THE CURRENT EPOCH AND NUMBER OF ERRORS
        fprintf('Epoch: %d, Number of Errors: %d\n',epoch,err_counter)
        
        % CHECK FOR CONVERGENCE (NO ERROR IN A FULL EPOCH)
        if err_counter == 0
            fprintf('Converged at Epoch: %d\n', epoch);
            
            % TRUNCATE all_W AND all_b for unused epochs
            all_W = all_W(:, 1:epoch);
            all_b = all_b(1:epoch);
            epoch_errors = epoch_errors(1:epoch); % truncate error array as well
            break;
        end
    end
    
    % PLOT ERRORS
    figure;
    plot(1:length(epoch_errors), epoch_errors, '-o');
    xlabel('Epoch');
    ylabel('Number of Updates');
    title('Number of Weight & Bias Updates Per Epoch');
    grid on;
    
    % DISPLAY FINAL WEIGHTS AND BIAS IN A TABLE
    Trained_Parameters = [W; b]; % Concatenate W and b to display them in a single table
    ParameterNames = [strcat("W",string(1:num_features)), "Bias"]';
    T = table(Trained_Parameters, 'RowNames', ParameterNames);
    disp(T);
end
