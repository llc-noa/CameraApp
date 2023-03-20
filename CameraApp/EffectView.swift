//
//  EffectView.swift
//  CameraApp
//
//  Created by 菅谷亮太 on 2023/03/19.
//

import SwiftUI

struct EffectView: View {
    let filterArray = ["CIPhotoEffectMono",
                       "CIPhotoEffectChrome",
                       "CIPhotoEffectFade",
                       "CIPhotoEffectInstant",
                       "CIPhotoEffectNoir",
                       "CIPhotoEffectProcess",
                       "CIPhotoEffectTonal",
                       "CIPhotoEffectTransder",
                       "CISepiaTone",
    ]
    @State var filterSelectNumber = 0
    @Binding var isShowSheet:Bool
    let captureImge:UIImage
    @State var showImage:UIImage?
    var body: some View {
        VStack{
            Spacer()
            if let showImage {
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Button {
                let filterName = filterArray[filterSelectNumber]
                filterSelectNumber += 1
                if filterSelectNumber == filterArray.count{
                    filterSelectNumber = 0
                }
                let rotate = captureImge.imageOrientation
                let inputImage = CIImage(image: captureImge)
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                effectFilter.setDefaults()
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                let ciContext = CIContext(options: nil)
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                
                showImage = UIImage(cgImage: cgImage,
                                    scale: 1.0,
                                    orientation: rotate
                )
                
            }label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
            if let showImage,
               let shareImage = Image(uiImage: showImage){
                ShareLink(item:shareImage, subject:nil,message:nil,preview:SharePreview("Photo",image: shareImage)){
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                .padding()
            }
            Button {
                
            }label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
        }
        .onAppear(){
            showImage = captureImge
        }
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(
            isShowSheet: .constant(true),
            captureImge: UIImage(named: "preview_use")!)
    }
}
