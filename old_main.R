# create person class with relevant vars
setClass("person", slots=list(name="character", 
                              creditScore="numeric", 
                              debtLoad="numeric", 
                              householdIncome="numeric", 
                              currentBalance="numeric", 
                              monthlyPayment="numeric", 
                              interestRate="numeric", 
                              maturityDate="character", 
                              loans="list"))

# Create method to predict refinance rate for person
setMethod("predictedRefiRateCalc",
          "person",
          function(object) {
            if(object@debtLoad > object@householdIncome){
              object@predictedRefiRate <- 0.09
            }else{
              object@predictedRefiRate <- 0.01
            }
          }
)

# create loan class with relevant vars
setClass("loan", slots=list(type="character",
                            startDate="character",
                            maturityDate="character",
                            duration="numeric",
                            interestRate="numeric",
                            beginningPrincipal="numeric",
                            currentBalance="numeric",
                            closingCosts="numeric",
                            discountRate="numeric",
                            netPresentValue="numeric",
                            grossTotalCost="numeric",
                            grossTotalCostRemaining="numeric",
                            monthlyPayment="numeric",
                            monthsToMaturity="numeric"))

# read in the input file
# need to correct for name being interpreted as categorical variable
input <- read.csv("inputFile.csv", stringsAsFactors = FALSE)

for (line in input) {
  person_i <- new("person", 
                  name=input[i,1], 
                  creditScore=input[i,2], 
                  debtLoad=input[i,3], 
                  householdIncome=input[i,4], 
                  currentBalance=input[i,5], 
                  monthlyPayment=input[i,6], 
                  interestRate=input[i,7], 
                  maturityDate=input[i,8])
  current_mortgage <- new("loan",
                          type="current",
                          currentBalance=person_i@currentBalance,
                          interestRate=person_i@interestRate,
                          monthlyPayment=person_i@monthlyPayment,
                          maturityDate=person_i@maturityDate)
  
  # Calculate refinance interest rate
  
}

