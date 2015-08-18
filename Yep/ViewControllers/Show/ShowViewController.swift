//
//  ShowViewController.swift
//  Yep
//
//  Created by nixzhu on 15/8/12.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var finishButton: UIButton!

    var steps = [ShowStepViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    func makeUI() {

        let stepA = step("Yep Intro")
        let stepB = step("Yep Intro")
        let stepC = step("Yep Intro")

        steps = [stepA, stepB, stepC]

        pageControl.numberOfPages = steps.count
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.yepTintColor()

        finishButton.alpha = 0
        finishButton.setTitle(NSLocalizedString("Start Yep", comment: ""), forState: .Normal)

        let viewsDictionary = [
            "view": view,
            "stepA": stepA.view,
            "stepB": stepB.view,
            "stepC": stepC.view,
        ]

        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[stepA(==view)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)

        view.addConstraints(vConstraints)

        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[stepA(==view)][stepB(==view)][stepC(==view)]|", options: .AlignAllBottom | .AlignAllTop, metrics: nil, views: viewsDictionary)

        view.addConstraints(hConstraints)
    }

    private func step(name: String) -> ShowStepViewController {

        let step = storyboard!.instantiateViewControllerWithIdentifier("ShowStepViewController") as! ShowStepViewController

        step.showName = name

        step.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.addSubview(step.view)

        addChildViewController(step)
        step.didMoveToParentViewController(self)

        return step
    }

    // MARK: Actions

    @IBAction func finish(sender: UIButton) {

        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if YepUserDefaults.isLogined {
                appDelegate.startMainStory()
            } else {
                appDelegate.startIntroStory()
            }
        }
    }
    
}

// MARK: - UIScrollViewDelegate

extension ShowViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {

        let pageWidth = CGRectGetWidth(scrollView.bounds)
        let pageFraction = scrollView.contentOffset.x / pageWidth

        let page = Int(round(pageFraction))

        let isLastStep = (page == (steps.count - 1))

        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseInOut, animations: { _ in
            self.finishButton.alpha = isLastStep ? 1 : 0
            self.pageControl.alpha = isLastStep ? 0 : 1

        }, completion: { _ in
        })

        pageControl.currentPage = page
    }
}


