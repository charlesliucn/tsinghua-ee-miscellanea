function [trainMSE,testMSE] = calcMSE(traindata,testdata,Rals)

    ntrain = 80000;
    ntest = 10000;
    SSE_train = 0;
    for i = 1:ntrain
        j = traindata(i,1);
        k = traindata(i,2);
        true = traindata(i,3);
        e = true - Rals(j,k);
        SSE_train = SSE_train + e^2;
    end
    trainMSE = SSE_train/ntrain;

    SSE_test = 0;
    for i = 1:ntest
        j = testdata(i,1);
        k = testdata(i,2);
        true = testdata(i,3);
        e = true - Rals(j,k);
        SSE_test = SSE_test + e^2;
    end
    testMSE = SSE_test/ntest;
end