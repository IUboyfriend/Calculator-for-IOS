//
//  ContentView.swift
//  Calculator
//
//  Created by HAO Jiadong on 7/10/2022.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier{
    let action:(UIDeviceOrientation) -> Void
    func body(content: Content) -> some View{
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)){ _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping(UIDeviceOrientation) -> Void) -> some View{
        self.modifier(DeviceRotationViewModifier(action: action))
        
    }
}
struct ContentView: View {
    @StateObject private var calculatorVM = CalculatorViewModel()
    @State private var orientation = UIDeviceOrientation.unknown
    var body: some View{
        Group{
            if orientation.isPortrait{
                    ZStack{
                        Color.black.edgesIgnoringSafeArea(.all)
                        VStack{
                            HStack{
                                Text("Mode: \(calculatorVM.selectedMode)")
                                    .padding()
                                    .font(.system(size:30))
                                    .foregroundColor(Color.white)
                            }
                            
                            HStack{
                                Picker("Mode",selection: $calculatorVM.selectedMode){
                                    ForEach(calculatorVM.mode, id: \.self){
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .background(Color.blue)
                            }
                            
                            HStack{
                                Spacer()
                                Text(calculatorVM.value)
                                    .bold().font(.system(size:100)).foregroundColor(.white)
                            }
                            .padding()
                            
                            if(calculatorVM.selectedMode == "DEC"){
                                ForEach (calculatorVM.buttons, id: \.self){ row in
                                    HStack(spacing:12){
                                        ForEach(row,id: \.self){ item in
                                            Button(action: {
                                                print(item.rawValue)
                                                calculatorVM.didTap(button: item)
                                            },label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom,3)
                                }
                            }
                            else if (calculatorVM.selectedMode == "BIN"){
                                ForEach (calculatorVM.binButtons, id: \.self){ row in
                                    HStack(spacing:12){
                                        ForEach(row,id: \.self){ item in
                                            Button(action: {
                                                print(item.rawValue)
                                                calculatorVM.didTap(button: item)
                                            },label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom,3)
                                }
                                Spacer()
                                        .frame(height:412)
                                    
                            }
                            else{
                                ForEach (calculatorVM.hexButtons, id: \.self){ row in
                                    HStack(spacing:12){
                                        ForEach(row,id: \.self){ item in
                                            Button(action: {
                                                print(item.rawValue)
                                                calculatorVM.didTap(button: item)
                                            },label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom,3)
                                }
                            }
                        
                    }
                        
                }
            }
            else if orientation.isLandscape{
                ZStack{
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack{
                            Text("Mode: \(calculatorVM.selectedMode)")
                                .padding()
                                .font(.system(size:30))
                                .foregroundColor(Color.white)
                        }
                        
                        HStack{
                            Picker("Mode",selection: $calculatorVM.selectedMode){
                                ForEach(calculatorVM.mode, id: \.self){
                                    Text($0)
                                }
                            }
                            .pickerStyle(.segmented)
                            .background(Color.blue)
                        }
                        
                        HStack{
                            Spacer()
                            Text(calculatorVM.value)
                                .bold().font(.system(size:35)).foregroundColor(.white)
                        }
                        .padding()
                        
                        if(calculatorVM.selectedMode == "DEC"){
                            ForEach (calculatorVM.landscapeButtons, id: \.self){ row in
                                HStack(spacing:12){
                                    ForEach(row,id: \.self){ item in
                                        Button(action: {
                                            print(item.rawValue)
                                            calculatorVM.didTap(button: item)
                                        },label:{
                                            Text(item.rawValue)
                                                .font(.system(size:20))
                                                .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                .background(item.buttonColor)
                                                .foregroundColor(.white)
                                                .cornerRadius(self.buttonHeight()/2)
                                        })
                                        
                                    }
                                }
                                .padding(.bottom,3)
                            }
                        }
                        else if (calculatorVM.selectedMode == "BIN"){
                            ForEach (calculatorVM.binButtons, id: \.self){ row in
                                HStack(spacing:12){
                                    ForEach(row,id: \.self){ item in
                                        Button(action: {
                                            print(item.rawValue)
                                            calculatorVM.didTap(button: item)
                                        },label:{
                                            Text(item.rawValue)
                                                .font(.system(size:20))
                                                .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                .background(item.buttonColor)
                                                .foregroundColor(.white)
                                                .cornerRadius(self.buttonHeight()/2)
                                        })
                                        
                                    }
                                }
                                .padding(.bottom,3)
                            }
                            Spacer()
                                    .frame(height:116)
                                
                        }
                        else{
                            ForEach (calculatorVM.lanscapeHexButtons, id: \.self){ row in
                                HStack(spacing:12){
                                    ForEach(row,id: \.self){ item in
                                        Button(action: {
                                            print(item.rawValue)
                                            calculatorVM.didTap(button: item)
                                        },label:{
                                            Text(item.rawValue)
                                                .font(.system(size:20))
                                                .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                .background(item.buttonColor)
                                                .foregroundColor(.white)
                                                .cornerRadius(self.buttonHeight()/2)
                                        })
                                        
                                    }
                                }
                                .padding(.bottom,3)
                            }
                        }
                    
                }
                    
            }
            }
            else
            {
                    ZStack{
                        Color.black.edgesIgnoringSafeArea(.all)
                        VStack{
                            HStack{
                                Text("Mode: \(calculatorVM.selectedMode)")
                                    .padding()
                                    .font(.system(size:30))
                                    .foregroundColor(Color.white)
                            }
                            
                            HStack{
                                Picker("Mode",selection: $calculatorVM.selectedMode){
                                    ForEach(calculatorVM.mode, id: \.self){
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .background(Color.blue)
                            }
                            
                            HStack{
                                Spacer()
                                Text(calculatorVM.value)
                                    .bold().font(.system(size:100)).foregroundColor(.white)
                            }
                            .padding()
                            
                            if(calculatorVM.selectedMode == "DEC"){
                                ForEach (calculatorVM.buttons, id: \.self){ row in
                                    HStack(spacing:12){
                                        ForEach(row,id: \.self){ item in
                                            Button(action: {
                                                print(item.rawValue)
                                                calculatorVM.didTap(button: item)
                                            },label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom,3)
                                }
                            }
                            else if (calculatorVM.selectedMode == "BIN"){
                                ForEach (calculatorVM.binButtons, id: \.self){ row in
                                    HStack(spacing:12){
                                        ForEach(row,id: \.self){ item in
                                            Button(action: {
                                                print(item.rawValue)
                                                calculatorVM.didTap(button: item)
                                            },label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom,3)
                                }
                                Spacer()
                                        .frame(height:412)
                                    
                            }
                            else{
                                ForEach (calculatorVM.hexButtons, id: \.self){ row in
                                    HStack(spacing:12){
                                        ForEach(row,id: \.self){ item in
                                            Button(action: {
                                                print(item.rawValue)
                                                calculatorVM.didTap(button: item)
                                            },label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width: self.buttonWidth(item:item), height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom,3)
                                }
                            }
                        
                    }
                        
                }
            }
            
        }
        .onRotate{ newOrientation in
            orientation = newOrientation
        }
    
        
    }
    
    func buttonWidth(item:CalcuButton) -> CGFloat{
        var width = (UIScreen.main.bounds.width - (5*12)) / 4
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            width = (UIScreen.main.bounds.width - 360) / 4
        }
        if item == .zero && calculatorVM.selectedMode == "DEC" && !orientation.isLandscape{
            return width * 2
        }
        if(orientation.isLandscape){
            width = (UIScreen.main.bounds.width - (7*12) - 560 )/6
        }
        return width
    }
    
    func buttonHeight() -> CGFloat{
        var height = (UIScreen.main.bounds.width - (5*12)) / 4
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            height = (UIScreen.main.bounds.width - 360) / 4
        }
        if(orientation.isLandscape){
            height = (UIScreen.main.bounds.width - (7*12) - 560 )/6
        }
        return height
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
