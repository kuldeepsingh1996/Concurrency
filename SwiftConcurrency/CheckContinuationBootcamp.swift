//
//  CheckContinuationBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 22/10/24.
//

import SwiftUI

class CheckContinuationBootcampNetworkManager  {
    
    func getData(url:URL) async throws -> Data {
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            return data
        }
        catch {
            throw error
        }
    }
    
    func getData2(url:URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, repsonse, erro in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let erro = erro {
                    continuation.resume(throwing: erro)
                }else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }

}

class CheckContinuationBootcampViewModel : ObservableObject {
    @Published var image : UIImage? = nil
    
    let networkManager = CheckContinuationBootcampNetworkManager()
    
    func getImage() async {
        
            guard let url = URL(string: "https://picsum.photos/200") else {
                return
            }
        do {
            let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        }
        catch {
            print(error)
        }
    }
}

struct CheckContinuationBootcamp: View {
    
    @StateObject  private var  viewModel = CheckContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
            }
        }
        .task {
           await viewModel.getImage()
        }
    }
}

#Preview {
    CheckContinuationBootcamp()
}
