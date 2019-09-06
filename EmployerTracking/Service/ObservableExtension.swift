import RxSwift
import RxCocoa

extension ObservableType {
  
  func filter(if trigger: Observable<Bool>) -> Observable<E> {
    return withLatestFrom(trigger) { (myValue, triggerValue) -> (E, Bool) in
      return (myValue, triggerValue)
      }
      .filter { (myValue, triggerValue) -> Bool in
        return triggerValue == true
      }
      .map { (myValue, triggerValue) -> E in
        return myValue
    }
  }
}
