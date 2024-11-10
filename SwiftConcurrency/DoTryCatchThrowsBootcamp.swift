//
//  DoTryCatchThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 14/10/24.
//

//https://www.youtube.com/watch?v=ss50RX7F7nE&list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM&index=2



import SwiftUI

class DoTryCatchThrowsDataManager {
    
    let isActive : Bool = false
    func getTitle() -> (title:String?,error:Error?) {
        
        if isActive {
            return ("New Title",nil)
        }else  {
            return (nil,URLError(.badURL))

        }
    }
    
    func getTitle2() -> Result<String,Error> {
        if isActive {
            return .success("New Title")
        }else  {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Title"
        }else {
            throw URLError(.appTransportSecurityRequiresSecureConnection)
        }
    }
}

class DoTryCatchThrowsViewModel : ObservableObject {
    
    @Published var title = "Starting text"
    
    
    let manager = DoTryCatchThrowsDataManager()
    
    func fetchTitle() {
       // let returnTitle = manager.getTitle()
//        if let newTitle = returnTitle.title {
//            self.title = newTitle
//        } else if let error = returnTitle.error  {
//            self.title = error.localizedDescription
//        }
        /*
         let result = manager.getTitle2()
         
         switch result {
             
         case .success(let newTitle):
             self.title = newTitle
         case .failure(let error):
             self.title = error.localizedDescription
         }
         */
        
        do {
            let newTitle = try manager.getTitle3()
            self.title = newTitle
        }
        catch let error {
            self.title = error.localizedDescription
        }
        
        
       
    }
    
}

struct DoTryCatchThrowsBootcamp: View {
    @StateObject var viewModel = DoTryCatchThrowsViewModel()
    var body: some View {
        
        VStack {
            Text(viewModel.title)
                .frame(width:200, height:300)
                .background(.blue)
                .onTapGesture {
                    viewModel.fetchTitle()
                }
            
        }
    }
}

#Preview {
    DoTryCatchThrowsBootcamp()
}
