class MockDelegateButtonTap: ButtonTap {
    var invokedButtonTapped = false
    var invokedButtonTappedCount: Int = 0
    var invokedButtonTappedParameter: Int = 0
    
    func buttonTapped(index: Int) {
        invokedButtonTapped = true
        invokedButtonTappedCount += 1
        invokedButtonTappedParameter = index
    }
}
