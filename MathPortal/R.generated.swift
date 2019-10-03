//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.image` struct is generated, and contains static references to 23 images.
  struct image {
    /// Image `BackIcon`.
    static let backIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "BackIcon")
    /// Image `NextArrow`.
    static let nextArrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "NextArrow")
    /// Image `birthday`.
    static let birthday = Rswift.ImageResource(bundle: R.hostingBundle, name: "birthday")
    /// Image `boyBlack`.
    static let boyBlack = Rswift.ImageResource(bundle: R.hostingBundle, name: "boyBlack")
    /// Image `boyColor`.
    static let boyColor = Rswift.ImageResource(bundle: R.hostingBundle, name: "boyColor")
    /// Image `boyWhite`.
    static let boyWhite = Rswift.ImageResource(bundle: R.hostingBundle, name: "boyWhite")
    /// Image `editProfile`.
    static let editProfile = Rswift.ImageResource(bundle: R.hostingBundle, name: "editProfile")
    /// Image `edit`.
    static let edit = Rswift.ImageResource(bundle: R.hostingBundle, name: "edit")
    /// Image `einsteinBlack`.
    static let einsteinBlack = Rswift.ImageResource(bundle: R.hostingBundle, name: "einsteinBlack")
    /// Image `einsteinColor`.
    static let einsteinColor = Rswift.ImageResource(bundle: R.hostingBundle, name: "einsteinColor")
    /// Image `einsteinWhite`.
    static let einsteinWhite = Rswift.ImageResource(bundle: R.hostingBundle, name: "einsteinWhite")
    /// Image `girlBlack`.
    static let girlBlack = Rswift.ImageResource(bundle: R.hostingBundle, name: "girlBlack")
    /// Image `girlColor`.
    static let girlColor = Rswift.ImageResource(bundle: R.hostingBundle, name: "girlColor")
    /// Image `girlWhite`.
    static let girlWhite = Rswift.ImageResource(bundle: R.hostingBundle, name: "girlWhite")
    /// Image `profile2`.
    static let profile2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile2")
    /// Image `profileIcon`.
    static let profileIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "profileIcon")
    /// Image `profile`.
    static let profile = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile")
    /// Image `search`.
    static let search = Rswift.ImageResource(bundle: R.hostingBundle, name: "search")
    /// Image `settingsFilledIcon`.
    static let settingsFilledIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "settingsFilledIcon")
    /// Image `settingsIcon`.
    static let settingsIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "settingsIcon")
    /// Image `solve`.
    static let solve = Rswift.ImageResource(bundle: R.hostingBundle, name: "solve")
    /// Image `student`.
    static let student = Rswift.ImageResource(bundle: R.hostingBundle, name: "student")
    /// Image `teacher`.
    static let teacher = Rswift.ImageResource(bundle: R.hostingBundle, name: "teacher")
    
    /// `UIImage(named: "BackIcon", bundle: ..., traitCollection: ...)`
    static func backIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.backIcon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "NextArrow", bundle: ..., traitCollection: ...)`
    static func nextArrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.nextArrow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "birthday", bundle: ..., traitCollection: ...)`
    static func birthday(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.birthday, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "boyBlack", bundle: ..., traitCollection: ...)`
    static func boyBlack(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.boyBlack, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "boyColor", bundle: ..., traitCollection: ...)`
    static func boyColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.boyColor, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "boyWhite", bundle: ..., traitCollection: ...)`
    static func boyWhite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.boyWhite, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "edit", bundle: ..., traitCollection: ...)`
    static func edit(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.edit, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "editProfile", bundle: ..., traitCollection: ...)`
    static func editProfile(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.editProfile, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "einsteinBlack", bundle: ..., traitCollection: ...)`
    static func einsteinBlack(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.einsteinBlack, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "einsteinColor", bundle: ..., traitCollection: ...)`
    static func einsteinColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.einsteinColor, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "einsteinWhite", bundle: ..., traitCollection: ...)`
    static func einsteinWhite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.einsteinWhite, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "girlBlack", bundle: ..., traitCollection: ...)`
    static func girlBlack(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.girlBlack, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "girlColor", bundle: ..., traitCollection: ...)`
    static func girlColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.girlColor, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "girlWhite", bundle: ..., traitCollection: ...)`
    static func girlWhite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.girlWhite, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profile", bundle: ..., traitCollection: ...)`
    static func profile(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profile2", bundle: ..., traitCollection: ...)`
    static func profile2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile2, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profileIcon", bundle: ..., traitCollection: ...)`
    static func profileIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profileIcon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "search", bundle: ..., traitCollection: ...)`
    static func search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.search, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "settingsFilledIcon", bundle: ..., traitCollection: ...)`
    static func settingsFilledIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settingsFilledIcon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "settingsIcon", bundle: ..., traitCollection: ...)`
    static func settingsIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settingsIcon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "solve", bundle: ..., traitCollection: ...)`
    static func solve(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.solve, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "student", bundle: ..., traitCollection: ...)`
    static func student(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.student, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "teacher", bundle: ..., traitCollection: ...)`
    static func teacher(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.teacher, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 3 nibs.
  struct nib {
    /// Nib `TabBarButtonView`.
    static let tabBarButtonView = _R.nib._TabBarButtonView()
    /// Nib `TaskDetailsViewControllerSolutionCell`.
    static let taskDetailsViewControllerSolutionCell = _R.nib._TaskDetailsViewControllerSolutionCell()
    /// Nib `TaskViewControllerTableViewCell`.
    static let taskViewControllerTableViewCell = _R.nib._TaskViewControllerTableViewCell()
    
    /// `UINib(name: "TabBarButtonView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.tabBarButtonView) instead")
    static func tabBarButtonView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.tabBarButtonView)
    }
    
    /// `UINib(name: "TaskDetailsViewControllerSolutionCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.taskDetailsViewControllerSolutionCell) instead")
    static func taskDetailsViewControllerSolutionCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.taskDetailsViewControllerSolutionCell)
    }
    
    /// `UINib(name: "TaskViewControllerTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.taskViewControllerTableViewCell) instead")
    static func taskViewControllerTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.taskViewControllerTableViewCell)
    }
    
    static func tabBarButtonView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.tabBarButtonView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func taskDetailsViewControllerSolutionCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> TaskDetailsViewControllerSolutionCell? {
      return R.nib.taskDetailsViewControllerSolutionCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TaskDetailsViewControllerSolutionCell
    }
    
    static func taskViewControllerTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> TaskViewControllerTableViewCell? {
      return R.nib.taskViewControllerTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TaskViewControllerTableViewCell
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 8 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `BrowseViewControllerTableViewCell`.
    static let browseViewControllerTableViewCell: Rswift.ReuseIdentifier<BrowseViewControllerTableViewCell> = Rswift.ReuseIdentifier(identifier: "BrowseViewControllerTableViewCell")
    /// Reuse identifier `ImageCell`.
    static let imageCell: Rswift.ReuseIdentifier<ProfileImagesCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "ImageCell")
    /// Reuse identifier `KeyboardCell`.
    static let keyboardCell: Rswift.ReuseIdentifier<CustomKeyboardCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "KeyboardCell")
    /// Reuse identifier `SolvedTasksViewControllerTableViewCell`.
    static let solvedTasksViewControllerTableViewCell: Rswift.ReuseIdentifier<SolvedTasksViewControllerTableViewCell> = Rswift.ReuseIdentifier(identifier: "SolvedTasksViewControllerTableViewCell")
    /// Reuse identifier `TaskDetailsViewControllerSolutionCell`.
    static let taskDetailsViewControllerSolutionCell: Rswift.ReuseIdentifier<TaskDetailsViewControllerSolutionCell> = Rswift.ReuseIdentifier(identifier: "TaskDetailsViewControllerSolutionCell")
    /// Reuse identifier `TaskDetailsViewControllerTableViewCell`.
    static let taskDetailsViewControllerTableViewCell: Rswift.ReuseIdentifier<TaskDetailsViewControllerTableViewCell> = Rswift.ReuseIdentifier(identifier: "TaskDetailsViewControllerTableViewCell")
    /// Reuse identifier `TaskViewControllerTableViewCell`.
    static let taskViewControllerTableViewCell: Rswift.ReuseIdentifier<TaskViewControllerTableViewCell> = Rswift.ReuseIdentifier(identifier: "TaskViewControllerTableViewCell")
    /// Reuse identifier `UserCell`.
    static let userCell: Rswift.ReuseIdentifier<CreatedTasksViewControllerTableViewCell> = Rswift.ReuseIdentifier(identifier: "UserCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 10 storyboards.
  struct storyboard {
    /// Storyboard `BrowseTasksViewController`.
    static let browseTasksViewController = _R.storyboard.browseTasksViewController()
    /// Storyboard `CreatedTasksViewController`.
    static let createdTasksViewController = _R.storyboard.createdTasksViewController()
    /// Storyboard `CustomKeyboard`.
    static let customKeyboard = _R.storyboard.customKeyboard()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Loading`.
    static let loading = _R.storyboard.loading()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Onboarding`.
    static let onboarding = _R.storyboard.onboarding()
    /// Storyboard `SolvedTasksViewController`.
    static let solvedTasksViewController = _R.storyboard.solvedTasksViewController()
    /// Storyboard `TaskDetailsViewController`.
    static let taskDetailsViewController = _R.storyboard.taskDetailsViewController()
    /// Storyboard `UserViewController`.
    static let userViewController = _R.storyboard.userViewController()
    
    /// `UIStoryboard(name: "BrowseTasksViewController", bundle: ...)`
    static func browseTasksViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.browseTasksViewController)
    }
    
    /// `UIStoryboard(name: "CreatedTasksViewController", bundle: ...)`
    static func createdTasksViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.createdTasksViewController)
    }
    
    /// `UIStoryboard(name: "CustomKeyboard", bundle: ...)`
    static func customKeyboard(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.customKeyboard)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Loading", bundle: ...)`
    static func loading(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.loading)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "Onboarding", bundle: ...)`
    static func onboarding(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.onboarding)
    }
    
    /// `UIStoryboard(name: "SolvedTasksViewController", bundle: ...)`
    static func solvedTasksViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.solvedTasksViewController)
    }
    
    /// `UIStoryboard(name: "TaskDetailsViewController", bundle: ...)`
    static func taskDetailsViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.taskDetailsViewController)
    }
    
    /// `UIStoryboard(name: "UserViewController", bundle: ...)`
    static func userViewController(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.userViewController)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _TabBarButtonView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "TabBarButtonView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _TaskDetailsViewControllerSolutionCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = TaskDetailsViewControllerSolutionCell
      
      let bundle = R.hostingBundle
      let identifier = "TaskDetailsViewControllerSolutionCell"
      let name = "TaskDetailsViewControllerSolutionCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> TaskDetailsViewControllerSolutionCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TaskDetailsViewControllerSolutionCell
      }
      
      fileprivate init() {}
    }
    
    struct _TaskViewControllerTableViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = TaskViewControllerTableViewCell
      
      let bundle = R.hostingBundle
      let identifier = "TaskViewControllerTableViewCell"
      let name = "TaskViewControllerTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> TaskViewControllerTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TaskViewControllerTableViewCell
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try browseTasksViewController.validate()
      try createdTasksViewController.validate()
      try customKeyboard.validate()
      try launchScreen.validate()
      try loading.validate()
      try main.validate()
      try onboarding.validate()
      try solvedTasksViewController.validate()
      try taskDetailsViewController.validate()
      try userViewController.validate()
    }
    
    struct browseTasksViewController: Rswift.StoryboardResourceType, Rswift.Validatable {
      let browseSelectedTaskViewController = StoryboardViewControllerResource<BrowseSelectedTaskViewController>(identifier: "BrowseSelectedTaskViewController")
      let browseTasksViewController = StoryboardViewControllerResource<BrowseTasksViewController>(identifier: "BrowseTasksViewController")
      let bundle = R.hostingBundle
      let name = "BrowseTasksViewController"
      
      func browseSelectedTaskViewController(_: Void = ()) -> BrowseSelectedTaskViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: browseSelectedTaskViewController)
      }
      
      func browseTasksViewController(_: Void = ()) -> BrowseTasksViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: browseTasksViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.browseTasksViewController().browseSelectedTaskViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'browseSelectedTaskViewController' could not be loaded from storyboard 'BrowseTasksViewController' as 'BrowseSelectedTaskViewController'.") }
        if _R.storyboard.browseTasksViewController().browseTasksViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'browseTasksViewController' could not be loaded from storyboard 'BrowseTasksViewController' as 'BrowseTasksViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct createdTasksViewController: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let createdTasksViewController = StoryboardViewControllerResource<CreatedTasksViewController>(identifier: "CreatedTasksViewController")
      let mathEquationViewController = StoryboardViewControllerResource<MathEquationViewController>(identifier: "MathEquationViewController")
      let name = "CreatedTasksViewController"
      let taskViewController = StoryboardViewControllerResource<MathPortal.TaskViewController>(identifier: "TaskViewController")
      
      func createdTasksViewController(_: Void = ()) -> CreatedTasksViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: createdTasksViewController)
      }
      
      func mathEquationViewController(_: Void = ()) -> MathEquationViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mathEquationViewController)
      }
      
      func taskViewController(_: Void = ()) -> MathPortal.TaskViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: taskViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.createdTasksViewController().createdTasksViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'createdTasksViewController' could not be loaded from storyboard 'CreatedTasksViewController' as 'CreatedTasksViewController'.") }
        if _R.storyboard.createdTasksViewController().mathEquationViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mathEquationViewController' could not be loaded from storyboard 'CreatedTasksViewController' as 'MathEquationViewController'.") }
        if _R.storyboard.createdTasksViewController().taskViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'taskViewController' could not be loaded from storyboard 'CreatedTasksViewController' as 'MathPortal.TaskViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct customKeyboard: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let customKeyboardViewController = StoryboardViewControllerResource<CustomKeyboardViewController>(identifier: "CustomKeyboardViewController")
      let name = "CustomKeyboard"
      
      func customKeyboardViewController(_: Void = ()) -> CustomKeyboardViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: customKeyboardViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.customKeyboard().customKeyboardViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'customKeyboardViewController' could not be loaded from storyboard 'CustomKeyboard' as 'CustomKeyboardViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct loading: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let loadingViewController = StoryboardViewControllerResource<LoadingViewController>(identifier: "LoadingViewController")
      let name = "Loading"
      
      func loadingViewController(_: Void = ()) -> LoadingViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loadingViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.loading().loadingViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'loadingViewController' could not be loaded from storyboard 'Loading' as 'LoadingViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = LaunchLogoViewController
      
      let bundle = R.hostingBundle
      let logInViewController = StoryboardViewControllerResource<LogInViewController>(identifier: "LogInViewController")
      let loginOrRegisterViewController = StoryboardViewControllerResource<LoginOrRegisterViewController>(identifier: "LoginOrRegisterViewController")
      let name = "Main"
      let registerViewController = StoryboardViewControllerResource<RegisterViewController>(identifier: "RegisterViewController")
      let tabBarViewController = StoryboardViewControllerResource<TabBarViewController>(identifier: "TabBarViewController")
      
      func logInViewController(_: Void = ()) -> LogInViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: logInViewController)
      }
      
      func loginOrRegisterViewController(_: Void = ()) -> LoginOrRegisterViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginOrRegisterViewController)
      }
      
      func registerViewController(_: Void = ()) -> RegisterViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: registerViewController)
      }
      
      func tabBarViewController(_: Void = ()) -> TabBarViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: tabBarViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "BackIcon", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'BackIcon' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "edit", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'edit' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "profileIcon", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'profileIcon' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "search", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'search' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "solve", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'solve' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.main().logInViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'logInViewController' could not be loaded from storyboard 'Main' as 'LogInViewController'.") }
        if _R.storyboard.main().loginOrRegisterViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'loginOrRegisterViewController' could not be loaded from storyboard 'Main' as 'LoginOrRegisterViewController'.") }
        if _R.storyboard.main().registerViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'registerViewController' could not be loaded from storyboard 'Main' as 'RegisterViewController'.") }
        if _R.storyboard.main().tabBarViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'tabBarViewController' could not be loaded from storyboard 'Main' as 'TabBarViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct onboarding: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "Onboarding"
      let onboardingBasicInfoViewController = StoryboardViewControllerResource<OnboardingBasicInfoViewController>(identifier: "OnboardingBasicInfoViewController")
      let onboardingRoleViewController = StoryboardViewControllerResource<OnboardingRoleViewController>(identifier: "OnboardingRoleViewController")
      
      func onboardingBasicInfoViewController(_: Void = ()) -> OnboardingBasicInfoViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: onboardingBasicInfoViewController)
      }
      
      func onboardingRoleViewController(_: Void = ()) -> OnboardingRoleViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: onboardingRoleViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "birthday", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'birthday' is used in storyboard 'Onboarding', but couldn't be loaded.") }
        if UIKit.UIImage(named: "einsteinColor", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'einsteinColor' is used in storyboard 'Onboarding', but couldn't be loaded.") }
        if UIKit.UIImage(named: "student", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'student' is used in storyboard 'Onboarding', but couldn't be loaded.") }
        if UIKit.UIImage(named: "teacher", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'teacher' is used in storyboard 'Onboarding', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.onboarding().onboardingBasicInfoViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'onboardingBasicInfoViewController' could not be loaded from storyboard 'Onboarding' as 'OnboardingBasicInfoViewController'.") }
        if _R.storyboard.onboarding().onboardingRoleViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'onboardingRoleViewController' could not be loaded from storyboard 'Onboarding' as 'OnboardingRoleViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct solvedTasksViewController: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "SolvedTasksViewController"
      let solveTaskViewController = StoryboardViewControllerResource<SolveTaskViewController>(identifier: "SolveTaskViewController")
      let solvedTasksViewController = StoryboardViewControllerResource<SolvedTasksViewController>(identifier: "SolvedTasksViewController")
      
      func solveTaskViewController(_: Void = ()) -> SolveTaskViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: solveTaskViewController)
      }
      
      func solvedTasksViewController(_: Void = ()) -> SolvedTasksViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: solvedTasksViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.solvedTasksViewController().solveTaskViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'solveTaskViewController' could not be loaded from storyboard 'SolvedTasksViewController' as 'SolveTaskViewController'.") }
        if _R.storyboard.solvedTasksViewController().solvedTasksViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'solvedTasksViewController' could not be loaded from storyboard 'SolvedTasksViewController' as 'SolvedTasksViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct taskDetailsViewController: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "TaskDetailsViewController"
      let taskDetailsViewController = StoryboardViewControllerResource<TaskDetailsViewController>(identifier: "TaskDetailsViewController")
      
      func taskDetailsViewController(_: Void = ()) -> TaskDetailsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: taskDetailsViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.taskDetailsViewController().taskDetailsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'taskDetailsViewController' could not be loaded from storyboard 'TaskDetailsViewController' as 'TaskDetailsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct userViewController: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let editUserViewController = StoryboardViewControllerResource<EditUserViewController>(identifier: "EditUserViewController")
      let name = "UserViewController"
      let profileImagesViewController = StoryboardViewControllerResource<ProfileImagesViewController>(identifier: "ProfileImagesViewController")
      let userViewController = StoryboardViewControllerResource<UserViewController>(identifier: "UserViewController")
      
      func editUserViewController(_: Void = ()) -> EditUserViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: editUserViewController)
      }
      
      func profileImagesViewController(_: Void = ()) -> ProfileImagesViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: profileImagesViewController)
      }
      
      func userViewController(_: Void = ()) -> UserViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: userViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "editProfile", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'editProfile' is used in storyboard 'UserViewController', but couldn't be loaded.") }
        if UIKit.UIImage(named: "einsteinBlack", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'einsteinBlack' is used in storyboard 'UserViewController', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.userViewController().editUserViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'editUserViewController' could not be loaded from storyboard 'UserViewController' as 'EditUserViewController'.") }
        if _R.storyboard.userViewController().profileImagesViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'profileImagesViewController' could not be loaded from storyboard 'UserViewController' as 'ProfileImagesViewController'.") }
        if _R.storyboard.userViewController().userViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'userViewController' could not be loaded from storyboard 'UserViewController' as 'UserViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
