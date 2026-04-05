import SwiftUI

@Observable
final class AppState {
    var userProfile: UserProfile = UserProfile()
    var hasCompletedOnboarding: Bool = false
}
