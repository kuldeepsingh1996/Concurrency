//
//  GlobalActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 28/10/24.
//

import SwiftUI

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One","Two","Three"]
    }
}

class GlobalActorBootcampViewModel : ObservableObject {
    
    @Published var dataArray : [String] = []
    let manager = MyNewDataManager()
    func getData() async {
        let data = await manager.getDataFromDatabase()
        self.dataArray.append(contentsOf: data)
    }
}

struct GlobalActorBootcamp: View {
    
    @StateObject var viewModel = GlobalActorBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray,id: \.self) {
                    Text($0)
                        .font(.headline)
                    
                }
            }
        }
        
        .task {
           await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
