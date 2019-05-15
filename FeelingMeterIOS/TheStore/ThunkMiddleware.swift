import Foundation
import ReSwift
import ReSwiftThunk

func thunkFeeling(_ feeling: Feeling) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        
        dispatch(ChangeFeelingAction(feeling: feeling))
    }
}
