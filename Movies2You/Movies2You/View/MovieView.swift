//
//  MovieView.swift
//  Movies2You
//
//  Created by Jhonatan Alves on 11/01/22.
//

import SwiftUI

// main view
struct MovieView: View {
    @ObservedObject var movieViewModel = MovieViewModel()
    
    var body: some View {
        ScrollView {
            if let movie = movieViewModel.movie {
                MovieHeaderView(movie: movie)
            }
            // checks if there's a related movies list
            if let relatedMoviesList = movieViewModel.movie?.relatedMovies {
                VStack {
                    // gets a RelatedMoviesItemView with each movie's info
                    ForEach (relatedMoviesList) { relatedMovie in
                        RelatedMoviesItemView(relatedMovie: relatedMovie)
                    }
                }
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }
}

// creates a view with the main movie backdrop image, title, likes and views numbers
struct MovieHeaderView: View {
    var movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            // gets the image from the movie backdrop URL
            AsyncImage(url: URL(string: movie.backdropImageURL)) { phase in
                Group {
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                    // if there's a error it shows a black view item
                    else if phase.error != nil {
                        Color.black
                    }
                    // shows loading element while the image is downloaded
                    else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(movie.title)
                    .bold()
                    .font(.title)
                Spacer()
                HStack(alignment: .center) {
                    Text(String(movie.likes))
                    Text("Likes")
                    Text(String(movie.views))
                    Text("Views")
                    Spacer()
                }
                .font(.caption)
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

// gets a movie and creates a view with poster image, title, release year and genres
struct RelatedMoviesItemView: View {
    var relatedMovie: Movie
    
    var body: some View {
        HStack {
            // gets the image from the movie poster URL
            AsyncImage(url: URL(string: relatedMovie.posterImageURL)) { phase in
                Group {
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Rectangle())
                    }
                    // if there's a error it shows a black view item
                    else if phase.error != nil {
                        Color.black
                    }
                    // shows loading element while the image is downloaded
                    else {
                        ProgressView()
                    }
                }
                .frame(width: 60, height: 100, alignment: .center)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(relatedMovie.title)
                HStack {
                    Text(String(relatedMovie.releaseYear))
                    Text(relatedMovie.genres[0].name)
                    Spacer()
                }
                .font(.caption)
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle")
                }
                .font(.caption)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
