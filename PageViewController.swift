//
//  PageViewController.swift
//  Twicether
//
//  Created by Lam Ngo on 12/26/17.
//  Copyright © 2017 Lam Ngo. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController{
    
    var arrayOfVCs : [UIViewController] = [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GreenViewController"),
                                           UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RedViewController"),
                                           UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlueViewController")]
    
    weak var dotDelegate : PageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setViewControllers([arrayOfVCs[0]], direction: .forward, animated: true, completion: nil)
        
        dotDelegate?.dotPageViewController(pageViewController: self, didUpdatePageCount: arrayOfVCs.count)
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = arrayOfVCs.index(of: firstViewController) {
            dotDelegate?.dotPageViewController(pageViewController: self, didUpdatePageIndex: index)
        }
    }
}
// MARK: UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = arrayOfVCs.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard arrayOfVCs.count > previousIndex else {
            return nil
        }
        
        return arrayOfVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = arrayOfVCs.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = arrayOfVCs.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return arrayOfVCs[nextIndex]
    }
    
}

protocol PageViewControllerDelegate: class{
    func dotPageViewController(pageViewController : PageViewController, didUpdatePageCount count: Int)
    
    func dotPageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int)
}
