//
//  MovieDao.swift
//  GrabilityTest
//
//  Created by Aplimovil on 8/29/17.
//  Copyright © 2017 Franklinsc. All rights reserved.
//

import Foundation
import SQLite

class MovieDao {
    
    var db:Connection!
    let table = Table("movie")
    let id = Expression<Int>("id")
    let title = Expression<String>("title")
    let date = Expression<String>("date")
    let overview = Expression<String>("overview")
    
    let voteCount = Expression<Int>("voteCount")
    let voteAverage = Expression<Double>("voteAverage")
    
    let posterPath = Expression<String>("posterPath")
    let backdropPath = Expression<String>("backdropPath")
    
    let category = Expression<Int>("category")
    let movieType = Expression<Int>("movieType")
    
    init() {
        do{
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection.init("\(path)/movie.sqlite3")
            try db!.run(table.create(temporary: false, ifNotExists: true, withoutRowid: true, block: { (table) in
                
                table.column(id, primaryKey: true)
                table.column(title)
                table.column(date)
                table.column(overview)
                table.column(voteCount)
                table.column(voteAverage)
                table.column(posterPath)
                table.column(backdropPath)
                table.column(category)
                table.column(movieType)
                
            }))
            
        }catch{
            db = nil
        }
    }
    
    
    
    func insert(movie : Movie)-> Int64{
        
        let insert = table.insert(
            id <- movie.id,
            title <- movie.title,
            date <- movie.date,
            overview <- movie.overview,
            voteCount <- movie.voteCount,
            voteAverage <- Double(movie.voteAverage),
            posterPath <- movie.posterPath,
            backdropPath <- movie.backdropPath,
            category <- movie.category.hashValue,
            movieType <- movie.movieType.hashValue)
        
        do{
            return try db.run(insert)
        }catch{
            return -1
        }
    }
    
    func update(movie : Movie)-> Int{
        let filter = table.filter(id == movie.id)
        let update = filter.update(
            title <- movie.title,
            date <- movie.date,
            overview <- movie.overview,
            voteCount <- movie.voteCount,
            voteAverage <- Double(movie.voteAverage),
            posterPath <- movie.posterPath,
            backdropPath <- movie.backdropPath,
            category <- movie.category.hashValue,
            movieType <- movie.movieType.hashValue)
        
        do{
            return try db.run(update)
        }catch{
            print("MovieDao - Update : Error, actualizando")
            return -1
        }
        
    }
    
    func delete(movie : Movie) -> Int{
        let filter = table.filter(id == movie.id)
        do{
            
            return try db.run(filter.delete())
            
        }catch{
            
            return -1
        }
        
        
    }
    
    func findById(idMovie:Int)->Movie?{
        let filter = table.filter(id == idMovie)
        
        
        do {
            let data = try db.prepare(filter)
            var row:Row?
            
            for r  in data {
                row = r
                break
            }
            
            return rowToMovie(row: row)
            
        }catch{
            
            return nil
        }
        
    }
    
    
    func findByCategoryAndMovieType(mvType: MovieType, mvCategory:Category)->[Movie]{
        
        let ctg = mvCategory.hashValue
        let typ = mvType.hashValue
        ///
        let filter = table.filter(category == ctg && movieType == typ)
        
        var movies: [Movie] = [Movie]()
        
        do {
            let data = try db.prepare(filter)
            
            for row  in data {
                movies.append(rowToMovie(row: row)!)
            }
            
            return movies
            
        }catch{
            
            return movies
        }
        
    }
    
    func findByTitle(title : String) ->[Movie]{

        
        var movies: [Movie] = [Movie]()
        
        do {
            let data = try db.prepare("SELECT * FROM movie WHERE title like '%\(title)%'")
            for item  in data {
                movies.append(itemToMovie(item: item)!)
            }
            return movies
            
        }catch{
            return movies
        }
    }
    
    func getAll()->[Movie]{
        
        do{
            let rows = try db.prepare(table)
            return rowsToList(rows: rows)
            
        }catch{
            
            return [Movie]()
        }
    }
    
    
    private func rowsToList(rows:AnySequence<Row>)->[Movie]{
        var data:[Movie] = [Movie]()
        
        for r in rows{
            data.append(rowToMovie(row: r)!)
        }
        
        return data
    }
    
    private func rowToMovie(row:Row? )->Movie?{
        if row == nil{
            return nil
        }else{
            
            var movie:Movie =  Movie()
            movie.id = (row?.get(id))!
            movie.title = row?.get(title)
            movie.date = row?.get(date)
            movie.overview = row?.get(overview)
            movie.voteCount = Int((row?.get(voteCount))!)
            movie.voteAverage = Float((row?.get(voteAverage))!)
            
            movie.posterPath = row?.get(posterPath)
            movie.backdropPath = row?.get(backdropPath)
            
            movie.category = Category.fromNumber(number: (row?.get(category))!)
            movie.movieType = MovieType.fromNumber(number: (row?.get(movieType))!)
            
            return movie

        }
    }
    
    private func itemToMovie(item:[Binding?] )->Movie?{

            
        var movie:Movie =  Movie()
        movie.id = Int(item[0] as! Int64)
        movie.title = item[1] as! String
        movie.date = item[2] as! String
        movie.overview = item[3] as! String
        movie.voteCount = Int(item[4] as! Int64)
        movie.voteAverage = Float(item[5] as! Double)
            
        movie.posterPath = item[6] as! String
        movie.backdropPath = item[7] as! String
            
        movie.category = Category.fromNumber(number: Int(item[8] as! Int64))
        movie.movieType = MovieType.fromNumber(number: Int(item[9] as! Int64))
            
        return movie
            
    }
}
