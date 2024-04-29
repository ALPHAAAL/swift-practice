import SwiftUI
import Observation

struct User: Codable {
    var firstName: String
    var lastName: String
}

struct ContentView: View {
    @State private var user: User
    @State private var isShowSheet = false
    @State private var numbers = [Int]();
    @AppStorage("currentIndex") private var currentIndex = 0;
    
    init(user: User = User(firstName: "Justin", lastName: "Bieber"), isShowSheet: Bool = false, numbers: [Int] = [Int](), currentIndex: Int = 0) {
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "user") {
            if let decodedData = try? decoder.decode(User.self, from: data) {
                self.user = decodedData
                print(decodedData)
            } else {
                self.user = user
            }
        } else {
            self.user = user
        }
        self.isShowSheet = isShowSheet
        self.numbers = numbers
        self.currentIndex = currentIndex
    }
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                TextField("First name", text: $user.firstName)
                TextField("Last name", text: $user.lastName)
                
                Button("Add number") {
                    numbers.append(currentIndex)
                    currentIndex += 1
                    UserDefaults.standard.set(currentIndex, forKey: "currentIndex")
                }
                Button("Show") {
                    isShowSheet.toggle()
                }
                Button("Save user") {
                    let encoder = JSONEncoder()
                    
                    if let data = try? encoder.encode(user) {
                        UserDefaults.standard.set(data, forKey: "user")
                    }
                }
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                SecondView(title: "Foo")
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

struct SecondView: View {
    let title: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Second view \(title)")
            Button("Dismiss view") {
                dismiss()
            }
        }
    }
}

#Preview {
    ContentView()
}
