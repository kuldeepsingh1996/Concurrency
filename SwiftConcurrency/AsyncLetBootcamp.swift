//
//  AsyncLetBootcamp.swift
//  SwiftConcurrency
//
//  Created by Philophobic on 16/10/24.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    
    @State private var images : [UIImage] = []
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images,id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                    
                }

            }
            .navigationTitle("Async Let Bootcamp")

        }
        
        .onAppear {
            Task {
                do {
//                    let image = try await fetchImage()
//                    self.images.append(image)
//                    let image1 = try await fetchImage()
//                    self.images.append(image1)
//                    let image2 = try await fetchImage()
//                    self.images.append(image2)
//                    let image3 = try await fetchImage()
//                    self.images.append(image3)
//                    let image4 = try await fetchImage()
//                    self.images.append(image4)

                    //Using this we can fetch all image in same time
                    async let fetchimage1 = fetchImage()
                    async let fetchimage2 = fetchImage()
                    async let fetchimage3 = fetchImage()
                    async let fetchimage4 = fetchImage()

                    let (image1,image2,image3,image4) = await (try fetchimage1,try fetchimage2 , try fetchimage3,try fetchimage4)
                    self.images.append(contentsOf: [image1,image2,image3,image4])

                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            }else  {
                throw URLError(.badURL)
            }
        }
        catch {
            throw URLError(.badURL)
        }
    }
}

#Preview {
    AsyncLetBootcamp()
}
