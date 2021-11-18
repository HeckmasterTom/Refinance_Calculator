# FINANCIAL MODELLING / DATA CALCULATIONS

library(tvm)

# calculate total debt to household income ratio
debtToIncomeRatioCalc <- function(debt, income){
  return(debt/income)
}

# calculate loan to house value ratio
loanToValueRatioCalc <- function(balance, houseValue){
  return(balance/houseValue)
}

# calculate predicted refinance interest rate
predictedRefiRateCalc <- function(creditScore, loanToValueRatio){
  # "Model" rationale
  # best rate: 2.374% - 10yr, well qualified buyer  - source: https://www.nerdwallet.com/mortgages/mortgage-rates
  # max rate: 4.142% - 30yr, poorly qualified buyer - source ^
  # 300-850 credit score 
  # 0.05-0.9 loan to value ratio
  # assume credit and l:v each contribute 50% with linear variation to calculate rate
  
  maxRate <- .04142 # should be dynamic
  minRate <- .02374 # should be dynamic
  
  cs_percentile <- (creditScore-300)/550 # higher is better
  ltv_percentile <- 1 - (loanToValueRatio-0.05)/0.9 # higher is better (after inversing)
  multiplier <- (0.5*cs_percentile + 0.5*ltv_percentile) # higher is better
  rate <- maxRate - (maxRate-minRate) * multiplier # higher is worse
  
  return(rate)
}

# calculate predicted refinance closing costs
predictedRefiClosingCostsCalc <- function(currentBalance){
  # estimate fixed costs of $3500 - source: https://www.bankofamerica.com/mortgage/closing-costs-calculator/
  fixed <- 3500
  # estimate variable costs at 1% of loan value - source ^
  variable <- .01 * currentBalance
  total <- fixed + variable
  return(total)
}

# calculate monthly refinance payment based on predicted refi rate
refiMonthlyPaymentCalc <- function(refiRate, currentBalance, monthsRemaining){
  monthlyRate <- refiRate / 12
  monthlyPayment <- pmt(currentBalance, monthsRemaining, monthlyRate)
  return(monthlyPayment)
}

# calculate gross total cost of loan remaining
grossTotalCostCalc <- function(monthlyPayment, monthsRemaining, closingCosts=0){
  # undiscounted cost to pay for duration of mortgage
  return(monthlyPayment*monthsRemaining+closingCosts)
}

# calculate net present value of loan remaining
npvCalc <- function(monthlyPayment, monthsRemaining, discountRate, closingCosts = 0){
  # discounted cost to pay for duration of mortgage
  pmts <- rep(monthlyPayment, monthsRemaining)
  npv <- npv(discountRate/12, pmts) + closingCosts
  return(npv)
}

# calculate breakeven point for a refinance
breakevenCalc <- function(refiClosingCosts, refiMonthlyPayment, currentMonthlyPayment, grossTotalCostCurrent, grossTotalCostRefi){
  # if current mortgage costs less than refi, breakeven doesn't exist
  if(grossTotalCostCurrent < grossTotalCostRefi){
    return(Inf)
  }else{
    # breakeven is num months (round down to integer) for diff in month pmts to offset closing costs
    breakeven <- refiClosingCosts / (currentMonthlyPayment - refiMonthlyPayment)
    return(floor(breakeven))
  }
}

# function to determine final recommendation
decisionFunction <- function(npvRefi, npvCurrent, totalCostRefi, totalCostCurrent){
  if(npvRefi > npvCurrent & totalCostRefi > totalCostCurrent){
    return("-- Do nothing --")
  }else if(npvRefi < npvCurrent & totalCostRefi < totalCostCurrent){
    return("++ Refi!")
  }else if(npvRefi < npvCurrent & totalCostRefi > totalCostCurrent){
    return("~~ Refi to Pay less now, more later")
  }else{
    return("~~ Refi to Pay more now, less later") 
  }
}