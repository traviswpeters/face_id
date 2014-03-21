countCorrect = 0;
tic
for i = 1:length(descriptsTest)
    tic
    indMatch(i) = kNN_classifierCell(descriptsTest{i}, descriptsTrain);
    disp([num2str(i) ' matched to ' num2str(indMatch) ' in ' num2str(toc) ' seconds'])
    if (i == indMatch(i))
        countCorrect = countCorrect + 1;
    end
end
[num2str(countCorrect) ' people were correctly matched out of ' num2str(length(descriptsTest)) ' people.']
toc