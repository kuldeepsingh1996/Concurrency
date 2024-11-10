//
//  DownloadAsyncImage.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 15/10/24.
//

import SwiftUI

class DownloadAsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    
    func handleResponse(data:Data?,response:URLResponse?) -> UIImage? {
        guard let data = data , let image = UIImage(data: data) , let response = response as? HTTPURLResponse ,
              response.statusCode >= 200 , response.statusCode < 300 else {
            return  nil
        }
        return image
    }
    func downloadEscapingImage(completion:@escaping(_ image:UIImage?,_ error:Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data , let image = UIImage(data: data) , let response = response as? HTTPURLResponse ,
                  response.statusCode >= 200 , response.statusCode < 300 else {
                completion(nil,error)
                return
            }
            
            completion(image,nil)
        }
        .resume()
    }
    
    func downloadWithAsync() async throws -> UIImage?{
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        }
        catch {
            throw error
        }
    }
}

class DownloadAsyncImageViewModel : ObservableObject {
    
    @Published var image : UIImage? = nil
    let loader = DownloadAsyncImageLoader()
    func fetchImage() async {
        
      let image =  try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}


struct DownloadAsyncImage: View {
    
    @StateObject var viewModel = DownloadAsyncImageViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
            }
        }
        .onAppear {
//            .task {
//                viewModel.fetchImage()
//
//            }
            Task {
               await viewModel.fetchImage()
            }
        
        }
    }
}

#Preview {
    DownloadAsyncImage()
}
