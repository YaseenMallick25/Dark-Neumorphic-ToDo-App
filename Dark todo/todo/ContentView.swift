
import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var edit = false
    @State var show = false
    @EnvironmentObject var obs : observer
    @State var selected : type = .init(id: "", title: "", msg: "", time: "", day: "")
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(Color.darkStart, Color.darkEnd)
            
            VStack{
                
                
                VStack(spacing : 5){
                    
                    HStack{
                        
                        Text("ToDo").font(.largeTitle).fontWeight(.heavy).foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            
                            self.edit.toggle()
                            
                        }) {
                            
                            Text(self.edit ? "Done" : "Edit")
                            
                        }
                        
                    }.padding([.leading,.trailing], 15)
                        .padding(.top, 50)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 10){
                            
                            ForEach(self.obs.datas){i in
                                
                                cellview(edit: self.edit, data: i).onTapGesture {
                                    
                                    self.selected = i
                                    self.show.toggle()
                                    
                                }.environmentObject(self.obs)
                            }
                            
                        }.padding()
                        
                    }.padding(.top, 10)
                    
                    Button(action: {
                        
                        self.selected = type(id: "", title: "", msg: "", time: "", day: "")
                        self.show.toggle()
                        
                    }) {
                        
                        Image(systemName: "plus").resizable()
                            .frame(width: 25, height: 25).padding()
                        
                    }
                    .buttonStyle(DarkButtonStyle())
                   // .buttonStyle(DarkButtonStyle())
                        .foregroundColor(.blue)
                        .padding(.bottom, 50)
                    
                }
                
                
            }.sheet(isPresented: $show) {
                
                SaveView(show: self.$show, data: self.selected).environmentObject(self.obs)
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 25, height: 25))
        
        return Path(path.cgPath)
        
    }
}

struct cellview : View {
    
    var edit : Bool
    var data : type
    @EnvironmentObject var obs : observer
    
    var body : some View{
        
        HStack{
            
            if edit{
                
                Button(action: {
                    
                    if self.data.id != ""{
                        
                        self.obs.delete(id: self.data.id)
                        
                    }
                    
                }) {
                    
                    Image(systemName: "minus.circle").font(.title)
                    
                }.foregroundColor(.red)
            }
            
            Text(data.title).lineLimit(1)
            
            Spacer()
            
            VStack(alignment: .leading,spacing : 5){
                
                Text(data.day)
                Text(data.time)
                
            }
            
        }.padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color(#colorLiteral(red: 0.1971755463, green: 0.2123964241, blue: 0.2352711912, alpha: 0.9091109155))))
            .animation(Animation.easeInOut(duration: 0.6))
            .shadow(color: Color.black.opacity(0.9), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.1), radius: 10, x: -5, y: -5)
    }
}

struct SaveView : View {
    
    @State var msg = ""
    @State var title = ""
    @State var pri = ["Low", "Medium", "High"]
    @Binding var show : Bool
    @EnvironmentObject var obs : observer
    var data : type
    
    var body : some View{
        
        ZStack {
            
            Color.offWhite
            
           // LinearGradient(Color.darkStart, Color.darkEnd)
            
            VStack(spacing : 5){
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        
                        if self.data.id != ""{
                            
                            self.obs.update(id: self.data.id, msg: self.msg, title: self.title)
                            
                        }
                        else{
                            
                            self.obs.add(title: self.title, msg: self.msg, date: Date())
                        }
                        
                        self.show.toggle()
                        
                    }) {
                        
                        Text("Save")
                        
                    }
                }
                
                
                TextField("Title", text: $title)
                    .foregroundColor(.red)
                
                
                Divider()
                    .background(Color.black)
                
                
                multiline(txt: $msg)
                
                
            //    Section {
            //        Picker(selection: $pri, label: Text ("")) {
            //            ForEach (0 ..< pri.count ) {
            //                Text(self.pri[$0]).tag($0)
            //            }
            //        }
            //
            //    }
                
                
            }
            .padding()
            .onAppear {
                
                self.msg = self.data.msg
                self.title = self.data.title
                
            }
            
        }.edgesIgnoringSafeArea(.all)
        
    }
}

struct multiline : UIViewRepresentable {
    
    @Binding var txt : String
    
    func makeCoordinator() -> multiline.Coordinator {
        
        return multiline.Coordinator(parent1: self)
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<multiline>) -> UITextView{
        
        let textview = UITextView()
        textview.backgroundColor = UIColor.clear
        textview.font = .systemFont(ofSize: 18)
        textview.delegate = context.coordinator
        return textview
        
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<multiline>) {
        
        uiView.text = txt
        
    }
    
    class Coordinator : NSObject,UITextViewDelegate {
        
        var parent : multiline
        
        init(parent1 : multiline) {
            
            parent = parent1
            
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            self.parent.txt = textView.text
            
        }
    }
}

struct type : Identifiable {
    
    var id : String
    var title : String
    var msg : String
    var time : String
    var day : String
    
}

class observer : ObservableObject {
    
    @Published var datas = [type]()
    
    init() {
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            
            let res = try context.fetch(req)
            
            for i in  res as! [NSManagedObject]{
                
                let msg = i.value(forKey: "msg") as! String
                let title = i.value(forKey: "title") as! String
                let time = i.value(forKey: "time") as! String
                let day = i.value(forKey: "day") as! String
                let id = i.value(forKey: "id") as! String
                
                self.datas.append(type(id: id, title: title, msg: msg, time: time, day: day))
                
            }
        }
        catch {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func add(title : String,msg: String,date: Date){
        
        let format = DateFormatter()
        format.dateFormat = "dd/MM/YY"
        let day = format.string(from: date)
        format.dateFormat = "hh:mm a"
        let time = format.string(from: date)
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        entity.setValue(msg, forKey: "msg")
        entity.setValue(title, forKey: "title")
        entity.setValue("\(date.timeIntervalSince1970)", forKey: "id")
        entity.setValue(time, forKey: "time")
        entity.setValue(day, forKey: "day")
        
        do{
            
            try context.save()
            self.datas.append(type(id: "\(date.timeIntervalSince1970)", title: title, msg: msg, time: time, day: day))
            
        }
        catch {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func delete(id : String){
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
            
            let res = try context.fetch(req)
            
            for i in  res as! [NSManagedObject]{
                
                if i.value(forKey: "id") as! String == id{
                    
                    context.delete(i)
                    try context.save()
                    
                    for i in 0..<datas.count{
                        
                        if datas[i].id == id{
                            
                            datas.remove(at: i)
                            return
                            
                        }
                    }
                }
            }
        }
        catch{
            
            print(error.localizedDescription)
            
        }
    }
    
    func update(id : String,msg: String,title : String){
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            
            let res = try context.fetch(req)
            
            for i in  res as! [NSManagedObject] {
                
                if i.value(forKey: "id") as! String == id {
                    
                    i.setValue(msg, forKey: "msg")
                    i.setValue(title, forKey: "title")
                    
                    try context.save()
                    
                    for i in 0..<datas.count {
                        
                        if datas[i].id == id {
                            
                            datas[i].msg = msg
                            datas[i].title = title
                            
                        }
                    }
                }
            }
        }
        catch {
            
            print(error.localizedDescription)
        }
    }
}
