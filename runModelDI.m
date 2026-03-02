salary = 85000;    % joint salary
age = 32;
married = true;        % true or false
dependents = 1;          % number of kids
state = "Texas";     % full state name, capitalized
houseprice = 300000;     % 0 if renting
rent = 0;           % monthly rent, 0 if owning
debt = 50000;       % total debt balance
debtTime = 10;          % years to pay off debt

DI = disposableIncome(salary, age, married, dependents, state, houseprice, rent, debt, debtTime);

disp("=== FINAL DISPOSABLE INCOME ===")
fprintf('$%.2f\n',DI)