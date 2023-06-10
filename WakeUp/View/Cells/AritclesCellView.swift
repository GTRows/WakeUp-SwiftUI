//
//  AritclesCellView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 6.06.2023.
//

import SwiftUI

struct AritclesCellView: View {
    var article: ArticlesModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Gray"))
                .frame(width: UIScreen.main.bounds.width - 40, height: 350)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
            VStack(alignment: .leading) {
                Image(article.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 60, height: 150)
                    .clipped()
                    .cornerRadius(20)
                    .padding(.leading, 20)
                Text(article.title)
                    .font(.largeTitle)
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                Text(article.description)
                    .font(.subheadline)
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct AritclesCellView_Previews: PreviewProvider {
    static var previews: some View {
        AritclesCellView(article: Constants.tempArticles[0])
    }
}
