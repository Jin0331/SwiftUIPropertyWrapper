//
//  ContentView.swift
//  SwiftUIPropertyWrapper
//
//  Created by JinwooLee on 5/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                Forum()
                    .tabItem {
                        Image(systemName: "bubble.right")
                    }
                
                Text("두번째 탭")
                    .tabItem {
                        Image(systemName: "house")
                    }
            }
            .navigationTitle("Scrum 스터디 방")
        }
    }
}

struct Forum : View {
    
    @State private var lists : [Post] = Post.list
    @State private var showAddView : Bool = false
    @StateObject var postVM = PostViewModel()
    
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(postVM.list) { post in
                    NavigationLink {
                        PostDetail(postVM: postVM, post: post)
                    } label: {
                        PostRow(post: post)
                    }
                    .tint(.primary)
                }
            }
        }
        .refreshable { }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            Button {
                showAddView.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .padding()
                    .background(Circle().fill(.white).shadow(radius: 4))
            }
            .padding()
        }
        .sheet(isPresented: $showAddView) {
            PostAdd(postVM: postVM)
        }
        
        
    }
}

class PostViewModel : ObservableObject {
    @Published var list : [Post] = Post.list
    
    func addPost(text : String) {
        let newPost = Post(username: "유저 이름", content: text)
        list.insert(newPost, at: 0)
    }
}

struct PostAdd : View {
    @FocusState private var focused : Bool
    @Environment(\.dismiss) private var dismiss
    @State private var text : String = ""
    
    @ObservedObject var postVM : PostViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("포스트를 입력해주세요", text: $text)
                    .font(.title)
                    .padding()
                    .padding(.top)
                    .focused($focused)
                    .onAppear {
                        focused = true
                    }
                Spacer()
            }
            .navigationTitle("포스트 게시")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("게시") {
                        postVM.addPost(text: text)
                        dismiss()
                    }
                }

            }
        }
    }
}

struct PostDetail : View {
    
    @State private var showEditView : Bool = false
    @ObservedObject var postVM : PostViewModel
    
    let post : Post
    
    var body: some View {
        VStack(spacing:20) {
            Text(post.username)
            Text(post.content)
                .font(.largeTitle)
            
            Button {
                showEditView = true
            } label: {
                Image(systemName: "pencil")
                Text("수정")
            }
            
            .sheet(isPresented: $showEditView, content: {
                PostAdd(postVM: postVM)
            })
        }

    }
}

struct PostRow : View {
    
    let post : Post
    let colors : [Color] = [
        Color.orange, Color.green, Color.pink, Color.purple, Color.blue, Color.yellow, Color.brown, Color.cyan, Color.mint
    ]
    
    var body: some View {
        HStack {
            Circle()
                .fill(colors.randomElement() ?? .gray)
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(post.username)
                Text(post.content)
                    .font(.title)
            }
            
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder()
        }
        .padding()
    }
}

struct Post : Identifiable {
    let id = UUID()
    let username : String
    let content : String
}

extension Post {
    static var list : [Post] = [
        Post(username: "프렘", content: "스크럼 스터디 할 사람"),
        Post(username: "민디고", content: "저요저요"),
        Post(username: "천원", content: "저는 Swift 별로"),
        Post(username: "쵸비", content: "저도 할래요"),
        Post(username: "라쿤", content: "탈주각"),
        Post(username: "지누", content: "저도 하고 싶어요")
    ]
}

#Preview {
//    PostRow(post: Post(username: "지누", content: "안녕하세요"))
//    PostAdd { post in
//        
//    }
    
//    NavigationView {
//        Forum()
//    }
    
    ContentView()
}
