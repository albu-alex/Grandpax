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

fileprivate struct MainContentView: View {
    
    // MARK: - State
    
    @State private var isActivityControllerPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var mapSnapshot = ""
    @StateObject var viewModel: SessionsViewModel
    
    // MARK: - Closure
    
    var onDeleteActionStateChanged: () -> Void
    
    var body: some View {
        Color(Theme.background)
        
        VStack(alignment: .leading) {
            NavigationView {
                NavigationView {
                    List(viewModel.sessions) { session in
                        NavigationLink {
                            SessionDetailsView(previousSessions: viewModel.sessions, session: session)
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
                        .alert(isPresented: $isDeleteAlertPresented) {
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
                    .background(Color(Theme.background))
                    .scrollContentBackground(.hidden)
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
}

// MARK: - Previews

struct PreviousView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsView()
    }
}
