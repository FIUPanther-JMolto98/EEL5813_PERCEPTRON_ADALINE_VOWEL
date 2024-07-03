% Uses the TRAINED parameters (W,b) obtained when running train_perceptE_1PE to predict the labels of the TRAINING SETS (TSET1,TSET2,TSET3)

% FUNCTION DEFINITION
function predict_adalineE_1PE(W, b, TEST_DATA)
    
    % TEST_DATA: a matrix where each column is a sample to predict 
    % in this directory, these would be: TSET1, TSET2, TSET3
    % W: the learned weights (W vector/matrix) from the trained perceptron
    % b: the learned bias (b scalar) from the trained perceptron
    
    % INITIALIZE TESTING/PREDICTION VECTOR
    num_samples = size(TEST_DATA, 2); % get the number of columns in TEST_DATA, as patterns are stored column-wise
    predictions = zeros(1, num_samples); % initialize a row vector of zeroes [0000 0000 0000 0000] that will contain the predictions
    true_labels = [-1,-1,-1,-1,-1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]; % contains GROUND TRUTH for what DOES CONSTITUTE an 'E' and what DOES NOT CONSTITUTE an 'E' (we know the labels, as we created TSET1, TSET2, TSET3)
    
    % INITIALIZE COUNTERS
    correct_predictions = 0;
    total_predictions = num_samples;

    % TESTING/PREDICTION LOOP
    for p = 1:num_samples
        
        input_sample = TEST_DATA(:, p); % extract sample 'p' at iteration 'p'
        
        % LINEAR COMBINATION/NET-INPUT (n) COMPUTATION
        n = W' * input_sample + b;
        
        % ACTIVATION COMPUTATION
        a = hardlims(n);
        
        % STORE PREDICTION
        predictions(p) = a;

        % CHECK IF PREDICTION MATCHES TRUE LABEL
        if predictions(p) == true_labels(p)
            correct_predictions = correct_predictions + 1;
        end
    end

    % CALCULATING ACCURACY/RATIO
    accuracy = (correct_predictions / total_predictions) * 100;
    
    % PRINT ARRAY CONTAINING THE PREDICTIONS AND RELEVANT DATA
    disp('Predictions: ');
    disp(predictions);
    fprintf('Total Correct: %d\n', correct_predictions);
    fprintf('Total Tested: %d\n', total_predictions);
    fprintf('Accuracy: %.2f%%\n', accuracy);
end