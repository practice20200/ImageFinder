

import UIKit
import Elements

class ViewController : UIViewController,UICollectionViewDelegateFlowLayout{
    //======Elements========
    var results = [Result]()
    let searchBar = UISearchBar()
    
    lazy var titleLabel : BaseUILabel = {
        let label = BaseUILabel()
        label.text = "Enter a keyword"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width/2, height: view.frame.height/4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemRed
        return collectionView

    }()
    
    lazy var noResultLabel : BaseUILabel = {
        let label = BaseUILabel()
        label.text = "Oops! No Result"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentStack : VStack = {
        let stack = VStack()
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(collectionView)
        stack.addArrangedSubview(searchBar)
        stack.spacing = 20
        return stack
    }()
    
    //======Views========
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        
        view.addSubview(contentStack)
        view.addSubview(noResultLabel)
        
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            //No Results
            noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    //======Functions========
    func fetchPhotos(_ query: String){
        //Please enter "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id= + (your clientID)"
        let urlString = ""

        guard let url = URL(string: urlString) else{ return }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else{ return }
            
            do{
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data )
                DispatchQueue.main.async{
                    self?.results = jsonResult.results
                    self?.collectionView.reloadData()
                    if self?.results.count == 0 {
                        self?.noResultLabel.isHidden = false
                    }else {
                        self?.noResultLabel.isHidden = true
                    }
                    print(jsonResult.results.count)
                }
                print(jsonResult.results.count)
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

extension ViewController: UICollectionViewDelegate{
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(results)
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        let imageURLString = results[indexPath.row].urls.regular
        print(results)
        
        cell.configure(with: imageURLString)
        return cell
    }
}



extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
            titleLabel.text = text
            results = []
            collectionView.reloadData()
            fetchPhotos(text)
        }
    }
}
