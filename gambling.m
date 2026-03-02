function SGNP = sportsGamblingNetProfit(age, income, education, sex, behavioral)
    freq = gamblingFrequency();
    SGNP = freq * avgBet * avgReturn;
end

function f = gamblingFrequency()
    ageMultiplier = []
    ageIndexes = []
    sexMultiplier = []
    sexIndexes = []
    incomeMultiplier = []
end