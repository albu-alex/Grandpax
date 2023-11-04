//
//  SessionsView.swift
//  Grandpax
//
//  Created by Alex Albu on 26.01.2023.
//

import SwiftUI
import RealmSwift

struct SessionsView: View {
    
    // MARK: - Environment
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - States
    
    @State private var deleteActionState: DeleteActionState = .untouched
    @StateObject var viewModel = SessionsViewModel()
    
    // MARK: - Lifecycle
    
    var body: some View {
        ZStack(alignment: .top) {
            HeaderView {
                presentationMode.wrappedValue.dismiss()
                viewModel.hardRemoveSessions()
            }
            .gesture(
                dragGestureHandler()
            )
            Color(Theme.background)
            MainContentView(viewModel: viewModel) {
                deleteActionState = .triggered
            }
        }
    }
    
    // MARK: - Methods
    
    private func dragGestureHandler() -> some Gesture {
        return DragGesture()
            .onEnded { value in
                if value.translation.height > 100 {
                    switch deleteActionState {
                    case .triggered:
                        ToastService.shared.showToast(
                            message: "Sessions will only be deleted if you press on the 'X' button from the view's header",
                            type: .info
                        )
                        deleteActionState = .acknowledged
                        break
                    case .acknowledged:
                        presentationMode.wrappedValue.dismiss()
                        break
                    default:
                        break
                    }
                }
            }
    }
}

fileprivate struct HeaderView: View {
    
    // MARK: - Closure
    
    var dissmissViewAction: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Text("Sessions")
                .bold()
                .font(.system(size: 22))
            Spacer()
            ActionButton(image: Image(systemName: "xmark")) {
                dissmissViewAction()
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: 60)
        .background(Color(Colors.white).opacity(0.5))
        .shadow(color: Color(Colors.shadow), radius: 40, y: 25)
        .zIndex(2)
    }
}

fileprivate struct EmptySessionView: View {
    var body: some View {
        ZStack {
            Color(Theme.background)
            VStack(spacing: 48) {
                Image(systemName: "exclamationmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Add a session before you can view them")
                    .font(.title)
                    .foregroundColor(Color(Theme.textColor))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.top, 80)
        }
        .background(Color(Theme.background))
        .scrollContentBackground(.hidden)
    }
}

fileprivate struct MainContentView: View {
    
    // MARK: - State
    
    @State private var isActivityControllerPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var mapSnapshot = ""
    @State private var sessionToBeDeleted = Session()
    @StateObject var viewModel: SessionsViewModel
    
    // MARK: - Closure
    
    var onDeleteActionStateChanged: () -> Void
    
    var body: some View {
        Color(Theme.background)
        
        VStack(alignment: .leading) {
            NavigationView {
                NavigationView {
                    if viewModel.sessions.count == 0 {
                        EmptySessionView()
                    } else {
                        List(viewModel.sessions) { session in
                            NavigationLink {
                                SessionDetailsView(otherSessions: viewModel.sessions, session: session)
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Text(session.name)
                                    .foregroundColor(Color(Theme.textColor))
                                    .padding(.vertical, 16)
                            }
                            .listRowBackground(Color(Theme.accentBackground))
                            .listRowSeparatorTint(Color(Theme.textColor))
                            .swipeActions {
                                Button(action: {
                                    sessionToBeDeleted = session
                                    isDeleteAlertPresented = true
                                }, label: {
                                    Image(systemName: "trash")
                                })
                                .tint(.red)
                                Button(action: {
                                    mapSnapshot = session.mapSnapshot
                                }, label: {
                                    Image(systemName: "square.and.arrow.up")
                                })
                                .tint(.blue)
                            }
                        }
                        .background(Color(Theme.background))
                        .scrollContentBackground(.hidden)
                        .alert(isPresented: $isDeleteAlertPresented) {
                            deletionConfirmationAlert(for: sessionToBeDeleted)
                        }
                    }
                }
            }
            .toolbar(.hidden)
            .onChange(of: mapSnapshot) { _ in
                isActivityControllerPresented = true
            }
            .sheet(isPresented: $isActivityControllerPresented) {
                viewModel.presentActivityViewControllerWithSnapshot(mapSnapshot)
            }
        }
        .padding(.top, 80)
    }
    
    // MARK: - Methods
    
    private func deletionConfirmationAlert(for session: Session) -> Alert {
        Alert(
            title: Text("Confirm Deletion"),
            message: Text("Are you sure you want to delete this session?"),
            primaryButton: .destructive(Text("Delete")) {
                viewModel.softRemoveSession(session)
                onDeleteActionStateChanged()
            },
            secondaryButton: .cancel()
        )
    }
}

// MARK: - Previews

struct PreviousView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsView()
    }
}
