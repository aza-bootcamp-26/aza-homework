
// ============================================================
// EXERCISE: Structs — Value Types
// Estimated time: 20 minutes
//
// Structs in Swift are MUCH more powerful than in C.
// They can have methods, computed properties, and protocol conformance.
// The key rule: assignment COPIES a struct. Two variables never
// share the same struct instance.
// ============================================================

import Foundation

// TODO 3a: Define a struct named Transaction with these stored properties:
//   id: String
//   date: Date
//   amount: Double
//   description: String
//   isDebit: Bool
//
// Add these computed properties:
//   formattedAmount: String
//     → returns "-$250.00" if isDebit, "+$250.00" if credit
//     → use String(format: "%.2f", abs(amount))
//
//   formattedDate: String
//     → use DateFormatter with dateStyle: .medium, timeStyle: .none
//
// Add a memberwise initializer (Swift gives you this FREE for structs —
// you do not need to write init() unless you want custom behavior).

struct Transaction {
    let id: String
    let date: Date
    let amount: Double
    var description: String
    let isDebit: Bool
    var isPending: Bool = false
    
    var formattedAmount: String {
        let sign = isDebit ? "-" : "+"
        return "\(sign)$\(String(format: "%.2f", abs(amount)))"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    mutating func markAsPending() {
        isPending = true
    }

    init(id: String, date: Date, amount: Double, description: String, isDebit: Bool) {
        self.id = id
        self.date = date
        self.amount = amount
        self.description = description
        self.isDebit = isDebit
    }
}

// TODO 3b: Create two Transaction instances:
//   t1: a credit of $2,500.00 described as "Direct Deposit"
//   t2: a debit of $45.67 described as "Starbucks"
// Print their formattedAmount and description.

var t1 = Transaction(id: "1", date: Date(), amount: 2_500.00, description: "Direct Deposit", isDebit: false)
var t2 = Transaction(id: "2", date: Date(), amount: 45.67, description: "Starbucks", isDebit: true)

print (t1.formattedAmount, t1.description)
print (t2.formattedAmount, t2.description)

// TODO 3c: Prove value semantics
// Assign t1 to a new variable t3.
// Try to change t3.description to "Modified".
// What happens? Why?
// Fix it by declaring t3 with var instead of let.
// Then change t3.description and print both t1.description and t3.description.
// Observe that t1 is unchanged. This is the key difference from classes.

// let t3 = t1
// t3.description = "Modified"
// print (t1.description) 

var t3 = t1
t3.description = "Modified"
print(t1.description)
print(t3.description) 

// TODO 3d: Add a mutating method to Transaction named markAsPending
// that sets a new stored property isPending: Bool = false to true.
// Call it on t2 and verify.

t2.markAsPending()
print(t2.isPending) 

// ============================================================
// EXERCISE: Classes — Reference Types
// Estimated time: 20 minutes
//
// Classes add: inheritance, reference semantics (assignment shares
// the same object), and deinitializers.
// Use classes for: managers, services, view controllers — things
// that have IDENTITY and LIFECYCLE, not just data.
// ============================================================

// TODO 4a: Define a class named BankAccount with:
//   Stored properties:
//     id: String
//     accountNumber: String
//     balance: Double
//     owner: String
//
//   A designated initializer: init(id:accountNumber:owner:initialBalance:)
//   where initialBalance has a default of 0.0
//
//   Methods:
//     deposit(amount: Double) — adds to balance if amount > 0
//     withdraw(amount: Double) -> Bool — subtracts if amount > 0 and <= balance; returns success
//     printSummary() — prints "Account [accountNumber] | Owner: [owner] | Balance: $X.XX"

class BankAccount {
    let id: String
    let accountNumber: String
    var balance: Double
    let owner: String
    
    init(id: String, accountNumber: String, owner: String, initialBalance: Double = 0.0) {
        self.id = id
        self.accountNumber = accountNumber
        self.owner = owner
        self.balance = initialBalance
    }
    
    func deposit(amount: Double) {
        if amount > 0 {
            balance += amount
        }
    }
    
    func withdraw(amount: Double) -> Bool {
        if amount > 0 && amount <= balance {
            balance -= amount
            return true
        }
        return false
    }
    
    func printSummary() {
        print("Account \(accountNumber) | Owner: \(owner) | Balance: $\(String(format: "%.2f", balance))")
    }
}

// TODO 4b: Create two BankAccount instances:
//   checking: id "acc_001", accountNumber "1234567890", owner "Jane Smith", balance 1_000.00
//   savings:  id "acc_002", accountNumber "0987654321", owner "Jane Smith", balance 5_000.00
// Call deposit and withdraw on checking. Print summaries for both.

let checking = BankAccount(id: "acc_001", accountNumber: "1234567890", owner: "Jane Smith", initialBalance: 1_000.00)
let savings = BankAccount(id: "acc_002", accountNumber: "0987654321", owner: "Jane Smith", initialBalance: 5_000.00)

checking.printSummary();
checking.deposit(amount: 500);
checking.printSummary();
checking.withdraw(amount: 200);
checking.printSummary();

// TODO 4c: Prove reference semantics
// Assign checking to a new variable checkingRef.
// Call checkingRef.deposit(amount: 500)
// Print checking.balance and checkingRef.balance.
// Observe they are THE SAME object — both show the updated balance.
// Write a comment explaining why this is different from the struct in 3c.

var checkingRef = checking
checkingRef.deposit(amount: 500)
print(checking.balance)
print(checkingRef.balance)

// Classes are reference type, meaning the variable stores a reference to its object in memory. 
// When setting one variable equal to another, it will cause them both to point to the same object in memory.
// Structs store values directly, so when they're copied those values are copied. 

// TODO 4d: Inheritance
// Define a class PremiumBankAccount that inherits from BankAccount.
// Add a stored property overdraftLimit: Double
// Override withdraw(amount:) so that withdrawal succeeds if
// amount <= balance + overdraftLimit (draws from overdraft if needed).
// Add a convenience initializer that takes the same params as BankAccount
// plus overdraftLimit.
//
// Test it: create a premium account with balance 100 and overdraftLimit 500.
// Withdraw 400 — should succeed (draws on overdraft).
// Withdraw 800 — should fail (exceeds balance + overdraftLimit).

class PremiumBankAccount: BankAccount {
    let overdraftLimit: Double
    
    init(id: String, accountNumber: String, owner: String, initialBalance: Double = 0.0, overdraftLimit: Double) {
        self.overdraftLimit = overdraftLimit
        super.init(id: id, accountNumber: accountNumber, owner: owner, initialBalance: initialBalance)
    }
    
    override func withdraw(amount: Double) -> Bool {
        if amount > 0 && amount <= balance + overdraftLimit {
            balance -= amount
            return true
        }
        return false
    }
}

var premiumAccount = PremiumBankAccount(id: "acc_003", accountNumber: "5", owner: "Aza", initialBalance: 100, overdraftLimit: 500)
premiumAccount.printSummary()
print(premiumAccount.withdraw(amount: 400))
premiumAccount.printSummary()
print(premiumAccount.withdraw(amount: 800))
premiumAccount.printSummary()

// ============================================================
// EXERCISE: Enumerations
// Estimated time: 15 minutes
//
// Swift enums are the richest in any mainstream language.
// They can carry associated values — meaning each case can
// store different data. This replaces many patterns where
// Python/JS developers would use a dict or tuple.
// ============================================================

// TODO 5a: Define an enum TransactionType with cases:
//   credit, debit, transfer, fee
// Make it conform to String and CaseIterable:
//   enum TransactionType: String, CaseIterable

enum TransactionType: String, CaseIterable {
    case credit
    case debit
    case transfer
    case fee

    var displayName: String {
        switch self {
        case .credit:
            return "Credit"
        case .debit:
            return "Debit"
        case .transfer:
            return "Transfer"
        case .fee:
            return "Fee"
        }
    }
}

// TODO 5b: Add a computed property displayName: String to TransactionType
// using a switch that returns:
//   credit   → "Credit"
//   debit    → "Debit"
//   transfer → "Transfer"
//   fee      → "Fee"


// TODO 5c: Enum with associated values
// Define an enum AccountError with these cases:
//   insufficientFunds(available: Double, requested: Double)
//   accountInactive
//   dailyLimitExceeded(limit: Double)
//   invalidAmount
//
// Write a function describeError(_ error: AccountError) -> String
// that uses a switch with associated value binding to return
// a user-friendly message for each case.
// Test it with all four cases.

enum AccountError {
    case insufficientFunds(available: Double, requested: Double)
    case accountInactive
    case dailyLimitExceeded(limit: Double)
    case invalidAmount
}

func describeError(_ error: AccountError) -> String {
    switch error {
    case .insufficientFunds(available: let available, requested: let requested):
        return "Insufficient funds. Available: $\(available), Requested: $\(requested)"
    case .accountInactive:
        return "Account is inactive."
    case .dailyLimitExceeded(limit: let limit):
        return "Daily limit exceeded. Limit: $\(limit)"
    case .invalidAmount:
        return "Invalid amount."
    }
}

print(describeError(.insufficientFunds(available: 100.0, requested: 1_000_000.0)))
print(describeError(.accountInactive))
print(describeError(.dailyLimitExceeded(limit: 10.0)))
print(describeError(.invalidAmount))

// TODO 5d: Iterate over all cases
// Using CaseIterable on TransactionType, print all transaction types
// and their raw values:
// for type in TransactionType.allCases { print(...) }
// Expected:
//   credit → "credit"
//   debit → "debit"
//   etc.

for type in TransactionType.allCases {
    print("\(type) → \"\(type.rawValue)\"")
}