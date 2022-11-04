//
//  DetailController.swift
//  MovieAppMVVM
//
//  Created by Samed Dağlı on 31.10.2022.
//

import UIKit
import SDWebImage
import PanModal
import CoreData

class DetailController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    
    var movie: Result?
    var favoriteMovies = [FavoriteMovie]()

    var favMovie: FavoriteMovie?
    var cast = [Cast]()
    var genres = [String]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        genreCollectionView.dataSource = self
        castCollectionView.dataSource = self
        genreCollectionView.register(UINib(nibName: K.genreCellXib, bundle: nil), forCellWithReuseIdentifier: K.genreCellIdentifier)
        castCollectionView.register(UINib(nibName: K.castCellXib, bundle: nil), forCellWithReuseIdentifier: K.castCellIdentifier)
        genreCollectionView.collectionViewLayout = createLayout(for: 0)
        castCollectionView.collectionViewLayout = createLayout(for: 1)
        loadFavoriteMovies()
        if let movie = movie{
            title = movie.title
            movieImageView.sd_setImage(with: URL(string: "\(NetworkHelper.shared.imagePath)/\(movie.backdropPath)"))
            titleLabel.text = movie.title
            ratingLabel.text = "\(movie.voteAverage)/10 IMDb"
            releaseDateLabel.text = movie.releaseDate
            languageLabel.text = Locale(identifier: "en-US").localizedString(forLanguageCode: movie.originalLanguage)
            descriptionLabel.text = movie.overview
            self.genres = movie.genres
            saveButton.isSelected = checkIfItIsAlreadyFavorited(id: movie.id)
            NetworkManager.shared.requestCast(movieID: movie.id) { result in
                switch result{
                case .success(let credits):
                    self.cast = credits.cast
                    self.castCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
        else if let movie = favMovie{
            title = movie.title
            movieImageView.sd_setImage(with: URL(string: "\(NetworkHelper.shared.imagePath)/\(movie.backDropPath!)"))
            titleLabel.text = movie.title
            ratingLabel.text = "\(movie.rate)/10 IMDb"
            languageLabel.text = Locale(identifier: "en-US").localizedString(forLanguageCode: movie.language ?? "")
            descriptionLabel.text = movie.overview
            self.genres = movie.genres!
            saveButton.isSelected = checkIfItIsAlreadyFavorited(id: Int(movie.id))
            NetworkManager.shared.requestCast(movieID: Int(movie.id)) { result in
                switch result{
                case .success(let credits):
                    self.cast = credits.cast
                    self.castCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                    return
                }
            }

        }
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let movie = self.movie{
            if !sender.isSelected{
                //Save
                let data = FavoriteMovie(context: self.context)
                data.id = Int64(movie.id)
                data.title = movie.title
                data.overview = movie.overview
                data.rate = movie.voteAverage
                data.releaseDate = movie.releaseDate
                data.posterPath = movie.posterPath
                data.language = movie.originalLanguage
                data.timestamp = Date().timeIntervalSince1970
                data.backDropPath = movie.backdropPath
                data.genres = movie.genres
                favoriteMovies.append(data)
                save()
            }
            else{
                //Delete
                print(favoriteMovies.count)
                for item in favoriteMovies{
                    if item.id == Int64(movie.id){
                        favoriteMovies.remove(at: favoriteMovies.firstIndex(of: item)!)
                        print(favoriteMovies.count)
                        context.delete(item)
                        print(context.deletedObjects)
                        save()
                    }
                }
            }
        }
        else if let movie = self.favMovie{
            if !sender.isSelected{
                //Save
                let data = FavoriteMovie(context: self.context)
                data.id = Int64(movie.id)
                data.title = movie.title
                data.overview = movie.overview
                data.rate = movie.rate
                data.releaseDate = movie.releaseDate
                data.posterPath = movie.posterPath
                data.language = movie.language
                data.timestamp = Date().timeIntervalSince1970
                data.backDropPath = movie.backDropPath
                data.genres = movie.genres
                favoriteMovies.append(data)
                save()
            }
            else{
                //Delete
                print(favoriteMovies.count)
                for item in favoriteMovies{
                    if item.id == Int64(movie.id){
                        favoriteMovies.remove(at: favoriteMovies.firstIndex(of: item)!)
                        print(favoriteMovies.count)
                        context.delete(item)
                        print(context.deletedObjects)
                        save()
                    }
                }
            }
        }
        sender.isSelected.toggle()
    }

    func save() {
        do{
            try context.save()
            print("Saved")
        }
        catch{
            print(error)
        }
    }
    func loadFavoriteMovies(){
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        do{
            favoriteMovies = try context.fetch(request)
        }
        catch{
            print(error)
        }
    }
    func checkIfItIsAlreadyFavorited(id: Int) -> Bool{
        for item in favoriteMovies{
            if item.id == id{
                return true
            }
        }
        return false
    }
    func createLayout(for num: Int) -> UICollectionViewLayout{
        if num == 0{
            let layout = UICollectionViewCompositionalLayout { sectionNum, env in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(20)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(20)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                return section
            }
            return layout
        }
        else{
            let layout = UICollectionViewCompositionalLayout { sectionNum, env in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .absolute(self.castCollectionView.frame.height)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                return section
            }
            return layout
        }
        
    }
    
}
extension DetailController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == genreCollectionView{
            return 1
        }
        else{
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollectionView{
            return genres.count
        }
        else{
            return cast.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollectionView{
            let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: K.genreCellIdentifier, for: indexPath) as! GenreCell
            cell.setup(title: genres[indexPath.row])
            return cell
        }
        else{
            let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: K.castCellIdentifier, for: indexPath) as! CastCell
            cell.setup(data: cast[indexPath.row])
            return cell
        }
    }
}

/*        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
 
 // Configure Fetch Request
 fetchRequest.includesPropertyValues = false

 do {
     let items = try context.fetch(fetchRequest) as [NSManagedObject]

     for item in items {
         context.delete(item)
     }

     // Save Changes
     try context.save()

 } catch {
     // Error Handling
     // ...
 }*/
