//
//  HomeView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import SwiftUI
import SwipeActions

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    @State private var wrappedVal = 0

    let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
    let cellHeight: CGFloat = 100

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
//                    if let image = viewModel.avatarImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                            .clipShape(Circle())
//                            .padding(.leading, 20)
//                    } else {
//                        Image(systemName: "person.fill")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                            .clipShape(Circle())
//                            .padding(.leading, 20)
//                            .shimmering()
//                    }
                    
                    if let uiImage = ImageStorageService.shared.retrieveImage(for: viewModel.userAvatar) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.leading, 20)
                    } else {
                        Image(systemName: "person.fill") // Here "placeholder" should be the name of your placeholder image.
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.leading, 20)
                    }

                    VStack {
                        Text(viewModel.user.name)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .frame(width: 250, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        Text(viewModel.greetingMessage)
                            .font(.caption)
                            .frame(width: 250, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    NavigationLink(destination: NotificationView()) {
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .padding(.trailing, 20)
                            .padding()
                    }
                }
                .padding(.top, 20)
                ScrollView {
                    // Quote cell View
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(Color("Gray"))
                                .frame(width: cellWidth, height: cellHeight)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                            Text(viewModel.quote)
                                .font(.headline)
                                .frame(width: cellWidth, height: cellHeight)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.vertical, 10)

                    // Nearest Alarm cell view
                    if viewModel.isHaveAlarm {
                        AlarmCellView(alarm: viewModel.nearestActiveAlarm, mod: AlarmCellViewMode.edit)
                            .padding(.horizontal)
                            .frame(width: cellWidth, height: cellHeight)
                            .padding(.vertical, 10)
                    }

                    NavigationLink(destination: WorkShopView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color("Gray"))
                                .frame(width: cellWidth, height: 50)
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .padding(.leading, 40)

                                Text("Community Alarm")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                    .padding(.trailing, 40)
                            }
                        }
                    }
                    .padding(.vertical, 20)

                    // Articles category start
                    HStack {
                        Text("Articles")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    // Article Foreack
                    ForEach(viewModel.articles) { article in
                        AritclesCellView(article: article)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
