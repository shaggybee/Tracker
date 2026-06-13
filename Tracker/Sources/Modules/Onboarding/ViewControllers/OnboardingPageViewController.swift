//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Kislov Vadim on 03.06.2026.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Public properties
    var didCompleteOnboarding: Completion?
    
    // MARK: - Private properties
    private lazy var pages: [UIViewController] = {
        let pagesModels = [
            OnboardingScreenModel(
                text: NSLocalizedString(L10n.Onboarding.Titles.trackWhatYouWant, comment: ""),
                image: UIImage(resource: .onboardingScreenFirst)
            ),
            OnboardingScreenModel(
                text: NSLocalizedString(L10n.Onboarding.Titles.notOnlyWaterAndYoga, comment: ""),
                image: UIImage(resource: .onboardingScreenSecond)
            )
        ]
        
        return pagesModels.map { model in
            let vc = OnboardingScreenViewController()
            
            vc.config(with: model)
            
            return vc
        }
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        
        pageControl.addTarget(
            self,
            action: #selector(didPageControlValueChange(_:)),
            for: .valueChanged)
        
        return pageControl
    }().forAutoLayout
    
    lazy var completionButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = Radius.size16
        button.backgroundColor = .ypBlack
        button.setTitleColor(.white, for: .normal)
        button.setTitle(
            NSLocalizedString(L10n.Onboarding.Titles.completionButton, comment: ""),
            for: .normal
        )
        
        button.addTarget(
            self,
            action:  #selector(didTapCompleteButton(_:)),
            for: .touchUpInside)
        
        return button
    }().forAutoLayout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
    }
    
    private func setElements() {
        dataSource = self
        delegate = self
        
        if let page = pages.first {
            setViewControllers(
                [page],
                direction: .forward,
                animated: true
            )
        }
        
        pageControl.numberOfPages = pages.count
        
        view.addSubview(pageControl)
        view.addSubview(completionButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            completionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.space50),
            completionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            completionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            completionButton.heightAnchor.constraint(equalToConstant: Constants.completionButtonHeight),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: completionButton.topAnchor, constant: -Spacing.space24)
        ])
    }
    
    @objc private func didTapCompleteButton(_ sender: UIButton) {
        didCompleteOnboarding?()
    }
    
    @objc private func didPageControlValueChange(_ sender: UIPageControl) {
        let selectedPageIndex = sender.currentPage
        
        guard let currentVC = viewControllers?.first,
              let currentPageIndex = pages.firstIndex(of: currentVC),
              let newViewController = pages[safe: selectedPageIndex] else { return }
        
        let direction: UIPageViewController.NavigationDirection = selectedPageIndex > currentPageIndex
            ? .forward
            : .reverse
        
        setViewControllers(
            [newViewController],
            direction: direction,
            animated: true
        )
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let prevIndex = currentIndex - 1
        
        return prevIndex >= 0 ? pages[prevIndex] : pages.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = currentIndex + 1
        
        return nextIndex < pages.count ? pages[nextIndex] : pages.first
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - Constants
private extension OnboardingPageViewController {
    enum Constants {
        static let completionButtonHeight: CGFloat = 60
    }
}
