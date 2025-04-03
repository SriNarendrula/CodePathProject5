//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController {

    // Array to store fetched posts
        private var posts: [Post] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view
        setupTableView()
                
        // Fetch posts
        fetchPosts()
    }

    private func setupTableView() {
            // Set data source and delegate
            tableView.dataSource = self
            
            // Register custom cell if you're not using storyboard to design the cell
            // tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
            
            // Configure table view appearance
            tableView.rowHeight = 150
            tableView.estimatedRowHeight = 1600 // Set an estimated height
            tableView.separatorStyle = .singleLine
        // In your setupTableView() method
        tableView.separatorInset = UIEdgeInsets.zero  // Remove separator insets
        }
    

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    guard let self = self else { return }
                            
                            // Store the fetched posts
                            self.posts = blog.response.posts

                            print("✅ We got \(self.posts.count) posts!")
                            
                            // Make sure the table view is reloaded AFTER posts array is updated
                            self.tableView.reloadData()
                            for post in posts {
                                            print("🍏 Summary: \(post.summary)")
                                        }
                            // Add this debug print
                            print("Table reloaded with \(self.posts.count) posts")
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection called: returning \(posts.count)")

        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell
        print("Configuring cell at row \(indexPath.row)")

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        // Get the post for this row
        let post = posts[indexPath.row]
        
        // Configure the cell with post data
        cell.configure(with: post)
        
        return cell
    }
}
