//
//  ContentView.swift
//  proyectoFinalSwiftUI
//
//  Created by Juan on 09/04/20.
//  Copyright © 2020 usuario. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var edit = false
    @State var show = false
    @EnvironmentObject var obs : observer
    @State var selected : type = .init(id: "", title: "", msg: "", time: "", day: "")
   
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.bottom)
            VStack{
            VStack(spacing:5){
                HStack{
                    Text("Notas").font(.largeTitle).fontWeight(.heavy)
                    Spacer()
                    Button(action: {
                        
                    }){
                        Text(self.edit ? "Done" : "Edit")
                    }
                }.padding([.leading,.trailing], 15)
                    .padding(.top, 10)
                
                Button(action: {
                    self.edit.toggle()
                }){
                    
                    Image(systemName: "plus").resizable().frame(width: 25, height: 25).padding()
                    
                }//Diseño del boton agregar
                    .foregroundColor(.white)
                    .background(Color.red)
                    .clipShape(Circle())
                    .padding(.bottom, -15)
                    .offset( y: 15)
                    
                
            }.background(Rouded().fill(Color.white))
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 10){
                        ForEach(self.obs.datas){i in
                            cellview(edit: edit, data: selected).onTapGesture{
                                self.selected = i
                            }
                        }
                    }
                }
            }.sheet(isPresented: $show){
                SaveView(show: $show)
            }

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Rouded: Shape {
     func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 25, height: 25))
        return Path(path.cgPath)
    }
}
struct cellview : View {
     var edit: Bool
    var body :some View{
       
        VStack{
            if edit{
                Button(action: {
                    
                }){
                    Image(systemName: "minus.circle").font(.title)
                }.foregroundColor(.red)
            }
            Text(data.title).lineLimit(1)
            Spacer()
            VStack(spacing: 5){
                Text(data.day)
                Text(data.time)
            }
        }
    }
}

struct SaveView: View  {
    @State var msg = ""
     @State var title = ""
    @Binding var show : Bool
    var body :some View{
        VStack(spacing:12){
            HStack{
                Spacer()
                Button(action: {
                    self.show.toggle()
                }){
                    Text("Save")
                }
                    
            }
            TextField("Title", text: $title )
            multiline(txt: $msg)
        }
    }
}

struct multiline : UIViewRepresentable {
    
    @Binding var txt: String
    func makeCoordinator() -> multiline.Coordinator {
        
        return multiline.Coordinator(parent1: self)
    }
    
   func makeUIView(context: UIViewRepresentableContext<multiline>) -> UITextView{
           
           let textview = UITextView()
           textview.font = .systemFont(ofSize: 18)
           textview.delegate = context.coordinator
           return textview
       }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<multiline>) {
    
    }
    class coordinador : NSObject, UITextViewDelegate {
        var parent : multiline
        
        init(parent1: multiline){
            parent = parent1
        }
        func textViewDidChange(_ textView: UITextView) {
            self.parent.txt = textView.text
        }
    }
}
//Se crean las variables para usar en el mensaje
struct type: Identifiable {
    var id: String
    var title :String
    var msg : String
    var time : String
    var day : String
    
}

class observer: ObservedObject {
    @Published var datas = [type] ()
}

