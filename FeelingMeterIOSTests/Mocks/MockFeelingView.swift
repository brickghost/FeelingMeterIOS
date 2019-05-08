class MockFeelingView: FeelingView {
    var setButtonImagesCalled = false
    
    override func setButtonImages(rating: Int) {
        setButtonImagesCalled = true
    }
}
