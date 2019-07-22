//
//  SlideViewController.swift
//  PollApp
//
//  Created by Ben Stewart on 6/28/19.
//  Copyright © 2019 Crawtech. All rights reserved.
//

import UIKit

class SlideViewController: UIPageViewController{
    

    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "NameController"),
            self.getViewController(withIdentifier: "ContactSelect"),
            self.getViewController(withIdentifier: "AllSetVC"),
            self.getViewController(withIdentifier: "AllSetVC2")

        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: Selector(("receivedChange")), name: Notification.Name("buttonClickedNotification"), object: nil)
        self.dataSource = self
        self.delegate   = self
    
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension SlideViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil }
        
        if(UserDefaults.standard.bool(forKey: "nextPage") == true)
        {return pages[nextIndex]}
        else {return nil}
    }
    func receivedChange (_ notification: Notification) {
        print("YEETUS")
    
    }
 
    
}
extension SlideViewController: UIPageViewControllerDelegate { }
