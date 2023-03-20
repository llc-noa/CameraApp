//
//  ContentView.swift
//  CameraApp
//
//  Created by 菅谷亮太 on 2023/03/18.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var captureImage: UIImage? = nil
    @State var isShowSheet = false
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    var body: some View {
        VStack{
            Button{
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラ利用可能")
                    captureImage = nil
                    isShowSheet.toggle()
                }else{
                    print("カメラ利用不可")
                }
            }label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            .sheet(isPresented: $isShowSheet){
                if let captureImage {
                    EffectView(isShowSheet: $isShowSheet, captureImge: captureImage)
                }
                else{
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
            }
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images,preferredItemEncoding: .automatic,photoLibrary: .shared()){
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .onChange(of: photoPickerSelectedImage){
                PhotosPickerItem in
                if let PhotosPickerItem{
                    PhotosPickerItem.loadTransferable(type: Data.self){
                        result in
                        switch result{
                        case .success(let data):
                            if let data{
                                captureImage = nil
                                captureImage = UIImage(data: data)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            }
        }
        .onChange(of: captureImage){
            image in
            if let _ = image {
                isShowSheet.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
