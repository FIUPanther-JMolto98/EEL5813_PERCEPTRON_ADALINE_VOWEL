% Trains the 'E - DETECTOR' using ADALINE learning, STOCHASTIC update, and 1 PROCESSING ELEMENT (PE) and returns its trained weights (W) and bias (b) when called using [W,b] = train_adalineE_1PE_stochastic(PP,TE,MAX_EPOCHS)

% FUNCTION DEFINITION
function [W,b,MSE_hist] = train_adalineE_1PE_stochastic(PP, TE, MAX_EPOCHS, ALPHA) % output the W (weights) and b (bias) variable so it remains in the MATLAB workspace and we can then pass it effortlessly to the training function
    [num_features, num_samples] = size(PP); % obtain the dimensions (x,y) or [i,j] of the matrix containing the input samples (cols = 25) and their features (rows = 20) 
    W = zeros(num_features,1); % we initialize the weight matrix as a zero matrix whose dimensions will be (num_features,1); that is, a (20 x 1) ZERO COLUMN VECTOR [00000 00000 00000 00000]^T 
    b = 0; % initialize the bias scalar value to 0
% WEIGHT AND BIAS HISTORY
    all_W = zeros(num_features, MAX_EPOCHS); % this matrix with dimensions (20 x MAX_EPOCHS) will hold the values for ALL 20 weights ACROSS MAX_EPOCHS epochs
    all_b = zeros(1, MAX_EPOCHS); % this row vector with dimensions (1 x MAX_EPOCHS) will hold the values for EACH 1 bias ACROSS MAX_EPOCHS epochs
    MSE_hist = zeros(1,MAX_EPOCHS); % this row vector with dimensions (1 x MAX_EPOCHS) will record the MSE per epoch
% EPOCH LOOP
    for epoch = 1:MAX_EPOCHS % epoch loop will start from epoch = 1 until reaching MAX_EPOCHS (defined when calling the function)
        fprintf("\nSTARTING EPOCH: %d\n",epoch); % message indicating the start of epoch
        sum_error = 0; % instead of keeping track of the errors, we will initialize a variable that will hold the sum of the errors (MSE)
        dW_sum = zeros(num_features,1); % for batch learning, we will store the cumulative value of dW per epoch so we can apply gradient descent in an epoch per epoch manner 
        db_sum = 0; % for batch learning, we will store the cumulative value of db per epoch so we can apply gradient descent in an epoch per epoch manenr

        all_W(:, epoch) = W; % we populate ALL THE ROWS of our COLUMN at 'epoch' iteration with the weights W obtained
        all_b(epoch) = b; % we do the same thing with the bias obtained in the current epoch iteration

        % ADALINE TRAINING LOOP
        for p = 1:num_samples % adaline training loop will start from p = 1 until it finishes iterating over our number of samples (p = 25)
            input_sample = PP(:, p); % a complete input_sample per sample is stored in each column of the PP variable (PPTATE.mat file), so in the pth iteration we take ALL ROWS (: or 20) of the corresponding P COLUMN (p)
            t = TE(p); % the corresponding target per sample is stored in each column of the TA variable (PPTATE.mat file), so in the pth iteration we take its SINGLE ROW (1) of the corresponding P COLUMN (p)
            
            % LINEAR COMBINATION/NET-INPUT COMPUTATION (n)
            n = W' * input_sample + b; % W = (20x1) and input_sample = (20x1), so use W'(TRANSPOSE) = (1x20)*(20x1) for dimension compatibility
            
            % PURELIN() ACTIVATION COMPUTATION (a)
            a = n; % ADALINE learns using a linear activation function, where a = n
            
            % ERROR CALCULATION
            error = t - a; % error is the difference between our expected output versus what we computed 
            sum_error = sum_error + (error^2); % we increment the sum_error by adding the squared of the current calculated error by our accumulation of past errors
            
            % AT THE END OF LEARNING ITERATION FOR PATTERN P, UPDATE WEIGHTS AND BIAS SEQUENTIALLY (STOCHASTIC)
            W = W + (ALPHA * error * input_sample); % ΔW = α*(t-a)*x
            b = b + (ALPHA * error); % Δ = α*(t-a)

            % FOR STOCHASTIC LEARNING, OMIT THIS PART
            %dW_sum = dW_sum + (2 * error * (-input_sample)); % after pattern p has finished learning, we accumulate the gradient of the error with respect to the weight
            %db_sum = db_sum + (2 * error * (-1)); % after pattern p has finished learning, we accumulate the gradient of the error with respect to the bias

        end

        % FOR STOCHASTIC, OMIT THIS PART
        % UPDATE THE WEIGHTS AND BIAS USING ACCUMULATED GRADIENTS (BATCH LEARNING)
        %W = W - ALPHA * (dW_sum/num_samples); % update the weight using the accumulated dW_sum across the number_samples
        %b = b - ALPHA * (db_sum/num_samples); % update the bias using the accumulated db_sum across the number_samples

        % STORE MEAN-SQUARED ERROR
        MSE_hist(epoch) = sum_error/num_samples; % sum_error/num_samples will give us the mean, as the errors were squared in a pattern-by-pattern basis
        fprintf('Epoch: %d, MSE: %.4f\n',epoch,MSE_hist(epoch)) % print current epoch and corresponding MSE computation
    end
    
    % PLOT MSE
    figure;
    plot(1:epoch, MSE_hist(1:epoch), '-o');
    xlabel('Epoch');
    ylabel('Mean Squared Error');
    title('MSE vs Epoch');
    grid on;

    % PLOT PARAMETER (WEIGHTS AND BIAS) EVOLUTION
    figure;
    plot(1:epoch, all_W(1,1:epoch), '-o', 'DisplayName', 'w1');
    hold on;
    plot(1:epoch, all_W(2,1:epoch), '-s', 'DisplayName', 'w2');
    plot(1:epoch, all_W(3,1:epoch), '-d', 'DisplayName', 'w3');
    plot(1:epoch, all_W(4,1:epoch), '-^', 'DisplayName', 'w4');
    plot(1:epoch, all_b(1:epoch), '-p', 'DisplayName', 'Bias');
    hold off;
    xlabel('Epoch');
    ylabel('Parameter Value');
    title('Parameter Evolution');
    legend;
    grid on;

    % DISPLAY FINAL WEIGHTS AND BIAS
    Trained_Parameters = [W; b]; 
    ParameterNames = [strcat("W",string(1:num_features)), "Bias"]';
    T = table(Trained_Parameters, 'RowNames', ParameterNames);
    disp(T);
end
