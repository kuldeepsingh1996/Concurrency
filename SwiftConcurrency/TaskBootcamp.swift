//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 15/10/24.
//

import SwiftUI

class TaskBootcampViewModel : ObservableObject {
    
    @Published var image : UIImage? = nil
    
    @Published var image2 : UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        guard let url = URL(string: "https://picsum.photos/200") else  {
            return
        }
        do {
            let (data,repsonse) = try await URLSession.shared.data(from: url)
            await MainActor.run{
                self.image = UIImage(data: data)
                print("Image fetch")

            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        
        guard let url = URL(string: "https://picsum.photos/200") else  {
            return
        }
        do {
            let (data,repsonse) = try await URLSession.shared.data(from: url)
            await MainActor.run{
                self.image2 = UIImage(data: data)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskHomeView : View {
    var body: some View {
        NavigationStack {
            
            ZStack {
                NavigationLink("Click Me") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject var viewModel = TaskBootcampViewModel()
    
    @State private var fetchImageTask : Task<Void, Never>? = nil
    var body: some View {
        VStack(spacing:40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
            }
        }
        //Using this task if view is disapper thne it will automatically cancel the task
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
            
            
            
            /*
             Task Order Priority high to low userInitiated and high have equal priority
            
            Task(priority: .high) {
                print("high : \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task(priority: .userInitiated) {
                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task(priority: .medium) {
                print("medium : \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task(priority: .low) {
                print("low : \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task(priority: .utility) {
                print("utility : \(Thread.current) : \(Task.currentPriority)")
            }
            
            Task(priority: .background) {
                print("background : \(Thread.current) : \(Task.currentPriority)")
            }
             */
       // }
    }
}

#Preview {
    TaskHomeView()
}
