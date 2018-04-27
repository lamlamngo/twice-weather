//
//  DotViewController.swift
//  Twicether
//
//  Created by Lam Ngo on 12/28/17.
//  Copyright © 2017 Lam Ngo. All rights reserved.
//

import UIKit

class DotViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func button(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageViewController = segue.destination as? PageViewController {
            pageViewController.dotDelegate = self
        }
    }

}

extension DotViewController : PageViewControllerDelegate {
    func dotPageViewController(pageViewController: PageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func dotPageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
