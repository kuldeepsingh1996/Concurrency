//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 15/10/24.
//

import SwiftUI

class AsyncAwaitBootcampViewModel : ObservableObject {
    
    @Published var dataArray : [String] = []
    
    func addTitle() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.dataArray.append("New Title : \(Thread.current)")

        }
    }
    
    func addTitle1() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                let title2 = "Title3 : \(Thread.current)"
                self.dataArray.append(title2)
            }
        }
    }
    
    func addAuthor() async {
        let author1 = "Author 1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author 2 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)

            let author3 = "Author 3 : \(Thread.current)"
            self.dataArray.append(author3)

        }

    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let something1 = "something  : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)

            let author3 = "something 1 : \(Thread.current)"
            self.dataArray.append(author3)

        }
    }
}
struct AsyncAwaitBootcamp: View {
    
    @StateObject var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray,id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            Task {
               await viewModel.addAuthor()
                await viewModel.addSomething()
                let finalText = "Final Text : \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
