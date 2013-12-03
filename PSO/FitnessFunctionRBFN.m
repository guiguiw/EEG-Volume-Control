function [fitness] = FitnessFunctionRBFN(C,G, Data, Class1Label,Class2Label)
    clear accuracy;
    modelRBFN = rbfnTrain(Data.Learning.Labels,Data.Learning.Features,C,G,Class1Label,Class2Label);
    modelRBFNValidation = rbfnTrain(Data.Validation.Labels,Data.Validation.Features,C,G,Class1Label,Class2Label);
    [predictions, accuracy1] = rbfnPredict(Data.Validation.Labels,Data.Validation.Features,modelRBFN,Class1Label,Class2Label);
    [predictions, accuracy2] = rbfnPredict(Data.Learning.Labels,Data.Learning.Features,modelRBFNValidation,Class1Label,Class2Label);
    fitness = abs(accuracy1*100-accuracy2)/(accuracy1(1)*100+accuracy2(1));
    fprintf('Accuracy: %f Accuracy: %f\t L: %d B: %f \n',accuracy1,accuracy2,C,G);
end
