import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decoded
                
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var isShowAddExpenseView = false
    
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter{ item in
            return item.type == "Personal"
        }
    }
    
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter{ item in
            return item.type == "Business"
        }
    }
    
    func removeExpenseByIds(ids: [UUID]) {
        expenses.items.removeAll { item in
            ids.contains(item.id)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(personalExpenses) { item in
                        HStack {
                            VStack {
                                Text(item.type)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: "HKD"))
                        }
                    }
                    .onDelete { index in
                        let ids = index.map {
                            personalExpenses[$0].id
                        }
                        
                        removeExpenseByIds(ids: ids)
                    }
                }
                .navigationTitle("Personal expense")
                
                List {
                    ForEach(expenses.items.filter{ item in
                        return item.type == "Business"
                    }) { item in
                        HStack {
                            VStack {
                                Text(item.type)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: "HKD"))
                        }
                    }
                    .onDelete { index in
                        let ids = index.map {
                            businessExpenses[$0].id
                        }
                        
                        removeExpenseByIds(ids: ids)
                    }
                }
                .navigationTitle("Business expense")
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    isShowAddExpenseView = true
                }
            }
            .sheet(isPresented: $isShowAddExpenseView, content: {
                AddView(expenses: expenses)
            })
        }
    }
}

#Preview {
    ContentView()
}
