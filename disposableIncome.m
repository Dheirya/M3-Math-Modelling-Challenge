function DI = disposableIncome(salary, age, married, dependents, state, houseprice, rent, debt, debtTime)
    T_federal = federalTax(salary, married, dependents)
    T_property = propertyTax(state, houseprice, rent)
    Utilities = utilsCost(married, dependents)
    CostPerChild = dependentsCost(dependents, salary)
    HealthCare = healthCost(age, dependents, married)
    Debt = debtPayBack(debt, debtTime)
    Food = foodCost(dependents, married)
    Transportation = transCost(age)
    % dun dun dun
    Expenses = T_federal + T_property + Utilities + CostPerChild + HealthCare + Debt + Food + Transportation + rent;
    DI = salary - Expenses;
end

function tax = federalTax(salary, married, dependents)
    if married
        taxableIncome = max(salary - 32200, 0);
    else
        taxableIncome = max(salary - 16100, 0);
    end
    % federal income tax brackets
    percents = [.1, .12, .22, .24, .32, .35, .37];
    if married
        rates = [23850, 96950, 206700, 394600, 501050, 751600, Inf];
    else
        rates = [11925, 48475, 103350, 197300, 250525, 626350, Inf];
    end
    % federal income tax
    cumTax = 0;
    prevNum = 0;
    for i = 1 : length(percents)
        if taxableIncome >= rates(i)
            % tax full bracket
            cumTax = cumTax + (rates(i) - prevNum) * percents(i);
            prevNum = rates(i);
        else
            % tax only taxable income - lower bracket
            cumTax = cumTax + (taxableIncome - prevNum) * percents(i);
            break
        end
    end
    tax = cumTax;
    % social security
    if salary > 176100
        tax = tax + .062 * 176100;
    else
        tax = tax + .062 * salary;
    end
    % child deductions
    if taxableIncome > 2500
        if married
            if taxableIncome > 400000
                tax = tax - 1700 * dependents;
            else
                tax = tax - 2200 * dependents;
            end
        else
            if taxableIncome > 200000
                tax = tax - 1700 * dependents;
            else
                tax = tax - 2200 * dependents;
            end
        end
    end
    % medicare tax
    tax = tax + 0.0145 * salary;
    tax = max(tax, 0);
end

function tax = propertyTax(state, houseprice, rent)
    % avg state property tax
    % if they rent, they don't pay any taxes
    if rent > 0
        tax = 0;
    else
        states = ["Hawaii", "Alabama", "Nevada", "Arizona", "Colorado", "South Carolina", "Idaho", "Delaware", "Tennessee", "Utah", "West Virginia", "Louisiana", "Arkansas", "Wyoming", "District of Columbia", "North Carolina", "New Mexico", "California", "Montana", "Mississippi", "Virginia", "Indiana", "Kentucky", "Florida", "Georgia", "Oklahoma", "Oregon", "Washington", "Missouri", "Maryland", "North Dakota", "Minnesota", "Maine", "South Dakota", "Massachusetts", "Alaska", "Rhode Island", "Michigan", "Kansas", "Pennsylvania", "Ohio", "Iowa", "Wisconsin", "Texas", "Nebraska", "New York", "Vermont", "New Hampshire", "Connecticut", "Illinois", "New Jersey"];
        taxes = [.0027, .0038, .0047, .0048, .0048, .0048, .0049, .0050, .0050, .0052, .0053, .0055, .0055, .0057, .0058, .0066, .0070, .0070, .0072, .0072, .0073, .0074, .0075, .0076, .0077, .0080, .0081, .0081, .0085, .0097, .0099, .0102, .0102, .0106, .0107, .0111, .0121, .0125, .0129, .0130, .0131, .0139, .0142, .0149, .0149, .0155, .0159, .0166, .0181, .0201, .0211];
        tax = taxes(find(strcmp(states, state))) * houseprice;
    end
end

function util = utilsCost(married, dependents)
    % average utilities per number in household
    numOfPeople = dependents + married + 1;
    avgUtilitesCost = [2865, 4679, 5872, 5872, 6471];
    if numOfPeople >= 5
        util = avgUtilitesCost(5);
    else
        util = avgUtilitesCost(numOfPeople);
    end
end

function cost = dependentsCost(dependents, salary)
    % average cost of dependents based on salary
    if salary < 59200
        costPerC = 9791.67;
    elseif salary >= 59200 && salary <= 107400
        costPerC = 12583.33;
    else
        costPerC = 20166.67;
    end
    cost = dependents * costPerC;
end

function cost = healthCost(age, dependents, married)
    % average cost of healthcare based on age
    aBrackets = [20, 25, 30, 35, 40, 45, 50, 55, 60, inf];
    hCosts = [471, 488, 552, 594, 621, 702, 868, 1084, 1319, 1458] * 12;
    for i = 1 : length(aBrackets)
        if age <= aBrackets(i)
            cost = hCosts(i);
            break
        end
    end
    cost = (married + 1) * cost;
    cost = cost + dependents * 4200;
end

function debtOwed = debtPayBack(debt, debtTime)
    % average debt paid back per year based on
    if debt == 0 || debtTime == 0
        debtOwed = 0;
    else
        housingDebt = debt * (13.6 / 18.77);
        nonHousingDebt = debt * (5.17 / 18.77);
        debtOwed = (debt / debtTime) + housingDebt * .0615 + nonHousingDebt * ((.0514 + .0639) / 2);
    end
end

function cost = foodCost(dependents, married)
    % average food cost based on number of people
    numOfPeople = dependents + married + 1;
    avgFoodCost = [5235, 9363, 11158, 13055, 14790];
    if numOfPeople >= 5
        cost = avgFoodCost(5);
    else
        cost = avgFoodCost(numOfPeople);
    end
end

function cost = transCost(age)
    % average cost based on age
    aBrackets = [25, 34, 44, 54, 64, 74, inf];
    tCosts = [9243, 12802, 15581, 17184, 15085, 11414, 6855];
    for i = 1 : length(aBrackets)
        if age <= aBrackets(i)
            cost = tCosts(i);
            break
        end
    end
end
