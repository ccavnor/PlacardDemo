//
//  Container.swift
//  PlacardDemo
//
//  Created by Christopher Charles Cavnor on 9/26/24.
//

import SwiftUI
import Placard

// modifier for buttons
struct CustomButtonStyle: ButtonStyle {
    var color: Color = .gray

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

// Custom SwiftUI view
struct ViewWithButton: View {
    @State var action: Bool = false

    var body: some View {
        var color: String {
            if action { return "red" }
            return "green"
        }

        VStack {
            Text("Make me see \(color)")
                .background(action ? .green : .red)
            Button(action: {
                action.toggle()
            }) {
                HStack {
                    Image(systemName: "face.dashed")
                        .font(.title)
                        .foregroundColor(action ? .green : .red)
                    Text("change me")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(40)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
        .background(Color(red: 155/255, green: 198/255, blue: 222/255))
    }
}

/// Example custom case
enum Custom: PlacardConfigP {
    case terminal
    var backgroundColor: UIColor? {
        switch self { case .terminal: return .lightGray }
    }

    var accentColor: UIColor? {
        switch self {
        case .terminal: return .purple
        }
    }

    var primaryFont: UIFont? {
        switch self {
        case .terminal: return UIFont(name: "HelveticaNeue-Light", size: 24.0)
        }
    }

    var secondaryFont: UIFont? {
        switch self {
        case .terminal: return UIFont(name: "HelveticaNeue-Light", size: 16.0)
        }
    }

    var titleTextColor: UIColor? {
        switch self { case .terminal: return .green }
    }

    var placement: PlacardPlacement? {
        switch self { default: return .center }
    }

    var insets: UIEdgeInsets? {
        switch self { default: return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) }
    }

    var showAnimation: TransitionAnimation? {
        switch self { default: return .spinOnX }
    }

    var hideAnimation: TransitionAnimation? {
        switch self { default: return .spinOnY }
    }

    var tapAnimation: TapAnimation? {
        switch self { default: return .zoomOutWithEasing }
    }

    var fadeAnimation: Bool? {
        switch self { default: return true }
    }
}

struct ContainerView: View {
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State var path: NavigationPath = .init()

    @State private var tapped = false
    func toggleTapped() { tapped.toggle() }

    let model = ConfigurationModel()

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility, preferredCompactColumn: $preferredColumn) {
            // sidebar
            Button("Show Placards >") {
                columnVisibility = .detailOnly
                preferredColumn = .detail
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 10)

            CommentBlockView(comment: "These configuration options can be used to alter the Placard view on the following page.", foregroundColor: .green)

            VStack {
                Button("Reset") {
                    model.resetConfig()
                }
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)

                ConfigurationView(model: model)
            }
            .navigationTitle("Configurations")
        } detail: {
            CommentBlockView(comment: "The configuration options from the sidebar are the same ones available for use in the Placard configuration type. Not all examples below will take these (some examples use a hard-coded configuration), But all examples that take them will say so in their button label.", foregroundColor: .black)
            ScrollView(.vertical) {
                NavigationStack(path: $path.animation(.easeOut)) {
                    CommentBlockView(comment: """
                    There are three Placard types that you may use:
                        - PlacardPriorityView: a simple, built-in way to display status messages based on priorities.
                        - PlacardView: Another built-in type, but more configurable than PlacardPriorityView and without priorities.
                        - PlacardCustomView: Placard will take your SwiftUI view and display it as a Placard!
                    
                    See the examples below.
                    """, foregroundColor: .gray)
                    VStack {
                        /*
                         Basic priority types
                         */
                        SectionHeaderBlockView(title: "PlacardPriorityView: Priority Status Types")
                        TitleBlockView(title: "These are the most basic Placard type. All you need to do is pass in a title, a message, and the priority.")
                        CommentBlockView(comment: "This is the format of a Placard with priority of .success.")
                        CodeBlockView(code: """
                        PlacardPriorityView(title: "Success!",
                                            statusMessage: "Some status message",
                                            priority: priority)
                        """)
                        CommentBlockView(comment: "Click the button below to display a success Placard.")
                        NavigationLink("Success message (uses sidebar options)",
                                       destination: model.priorityMessageView(.success)).buttonStyle(CustomButtonStyle(color: .green))

                        CommentBlockView(comment: "This is an .info priority Placard.")
                        CodeBlockView(code: """
                        PlacardPriorityView(title: "Some Info For Ya",
                                            statusMessage: "Peas sounds like peace, but tastes different.",
                                            priority: priority)
                        """)
                        NavigationLink("Info message (uses sidebar options)",
                                       destination: model.priorityMessageView(.info)).buttonStyle(CustomButtonStyle(color: .blue))
                        CommentBlockView(comment: "This is an .warning priority Placard.")
                        CodeBlockView(code: """
                        PlacardPriorityView(title: "Warning!",
                                            statusMessage: "Don't take anything seriously.",
                                            priority: priority)
                        """)
                        NavigationLink("Warning message (uses sidebar options)",
                                       destination: model.priorityMessageView(.warning)).buttonStyle(CustomButtonStyle(color: .yellow))
                        CommentBlockView(comment: "This is an .error priority Placard.")
                        CodeBlockView(code: """
                        PlacardPriorityView(title: "An Error Done Happened",
                                            statusMessage: "But I'm not telling you which one.",
                                            priority: priority)
                        """)
                        NavigationLink("Error message (uses sidebar options)",
                                       destination: model.priorityMessageView(.error)).buttonStyle(CustomButtonStyle(color: .red))
                        CommentBlockView(comment: "This is an .default priority Placard - in case you need a general type.")
                        CodeBlockView(code: """
                        PlacardPriorityView(title: "WTFudge 💩!",
                                            statusMessage: "some unknown thing happened",
                                            priority: .default)
                        """)
                        NavigationLink("Default message (uses sidebar options)",
                                       destination: model.priorityMessageView(.default)).buttonStyle(CustomButtonStyle(color: .black))


                        /*
                         PlacardView: Customize PlacardView types
                         */
                        SectionHeaderBlockView(title: "PlacardView: A non-priority built-in type.")
                        TitleBlockView(title: "PlacardView instances are just like PlacardPriorityView instances, but are meant to be an easy way to display a configurable built-in view.")

                        // Customize by overriding parameters (systemImage, action, duration)
                        TitleBlockView(title: "PlacardView types can be customized via a few parameters (systemImage, action, duration).")
                        CommentBlockView(comment: "Here, we pass in our own systemImage to display.")
                        CodeBlockView(code: """
                        PlacardView(title: "Don't forget to smile!",
                                    statusMessage: "Teeth are like bats that hang from your gums.",
                                    systemImageName: "mouth.fill")
                        """)
                        NavigationLink("Show Placard (uses sidebar options)",
                                       destination: model.customizeParametersForPlacardView())
                        .buttonStyle(CustomButtonStyle())

                        CommentBlockView(comment: "Placards take an action (of type () -> Void) to perform when tapped.")
                        CodeBlockView(code: """
                        PlacardView(title: "Don't forget to smile!",
                                    statusMessage: "Teeth are like bats that hang from your gums.",
                                    systemImageName: "face.smiling",
                                    action: self.toggleTapped)
                        """)
                        NavigationLink("Show Placard (uses sidebar options)",
                                       destination: model.customizeParametersForPlacardView(action: self.toggleTapped))
                        .buttonStyle(CustomButtonStyle())

                        // customize using config file
                        TitleBlockView(title: "But PlacardView types take a configuration where PlacardView formatting can be changed.")
                        CommentBlockView(comment: "A configuration of type PlacardConfig can be passed in to override some or all of the defaults. All available configuration options are being set below:")
                        CodeBlockView(code: """
                        let config = PlacardConfig(backgroundColor: .darkGray,
                                                    primaryFont: UIFont.systemFont(ofSize: 30.0, weight: .heavy),
                                                    secondaryFont: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                                    accentColor: .red,
                                                    titleTextColor: .yellow,
                                                    placement: .top,
                                                    insets: UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20),
                                                    showAnimation: .spin,
                                                    hideAnimation: .spin,
                                                    tapAnimation: .pulseIn,
                                                    fadeAnimation: true)
                        """)
                        CodeBlockView(code: """
                        PlacardView(title: "You are fire!", 
                            statusMessage: "(don't go swimming)",
                            systemImageName: "flame",
                            config: config)
                        """)
                        let _config = PlacardConfig(backgroundColor: .darkGray,
                                                    primaryFont: UIFont.systemFont(ofSize: 30.0, weight: .heavy),
                                                    secondaryFont: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                                    accentColor: .red,
                                                    titleTextColor: .yellow,
                                                    placement: .top,
                                                    insets: UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20),
                                                    showAnimation: .spin,
                                                    hideAnimation: .spin,
                                                    tapAnimation: .pulseIn,
                                                    fadeAnimation: true)
                        NavigationLink("Show Placard",
                                       destination: model.configDefaultMessageView(config: _config))
                        .buttonStyle(CustomButtonStyle())

                        /*
                         Customize priority types using your own config type
                         */
                        TitleBlockView(title: "Another way to use a configuration - use an enumeration.")
                        CommentBlockView(comment: "This is basically the same as using a PlacardConfig instance, but you can define a configuration type (conforming to PlacardConfigP) and use that instead.")
                        CodeBlockView(code: """
                        enum Custom: PlacardConfigP {
                            case terminal
                            var backgroundColor: UIColor? {
                                switch self { case .terminal: return .lightGray }
                            }
                        
                            var accentColor: UIColor? {
                                switch self {
                                case .terminal: return .purple
                                }
                            }
                        
                            var primaryFont: UIFont? {
                                switch self {
                                case .terminal: return UIFont(name: "HelveticaNeue-Light", size: 24.0)
                                }
                            }
                        
                            var secondaryFont: UIFont? {
                                switch self {
                                case .terminal: return UIFont(name: "HelveticaNeue-Light", size: 16.0)
                                }
                            }
                        
                            var titleTextColor: UIColor? {
                                switch self { case .terminal: return .green }
                            }
                        
                            var placement: PlacardPlacement? {
                                switch self { default: return .center }
                            }
                        
                            var insets: UIEdgeInsets? {
                                switch self { default: return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) }
                            }
                        
                            var showAnimation: TransitionAnimation? {
                                switch self { default: return .spinOnX }
                            }
                        
                            var hideAnimation: TransitionAnimation? {
                                switch self { default: return .spinOnY }
                            }
                        
                            var tapAnimation: TapAnimation? {
                                switch self { default: return .zoomOutWithEasing }
                            }
                        
                            var fadeAnimation: Bool? {
                                switch self { default: return true }
                            }
                        }
                        """)
                        CodeBlockView(code: """
                        PlacardView(title: "You Dawg!",
                        statusMessage: "Git that squeaky!",
                        systemImageName: "pawprint",
                        config: Custom.terminal)
                        """)

                        NavigationLink("Show Placard",
                                       destination: model.customConfigMessageView(config: Custom.terminal))
                        .buttonStyle(CustomButtonStyle())


                        /*
                         custom views - use your own view as a Placard
                         */
                        SectionHeaderBlockView(title: "PlacardCustomView")
                        TitleBlockView(title: "Define your own SwiftUI view to use as a Placard.")
                        CommentBlockView(comment: "Create a view like the one below.")
                        CodeBlockView(code: """
                        struct ViewWithButton: View {
                            @State var action: Bool
                        
                            var body: some View {
                                var color: String {
                                    if action { return "red" }
                                    return "green"
                                }
                        
                                VStack {
                                    Text("Make me see \\(color)")
                                        .background(action ? .green : .red)
                                    Button(action: {
                                        action.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: "face.dashed")
                                                .font(.title)
                                                .foregroundColor(action ? .green : .red)
                                            Text("change me")
                                                .fontWeight(.semibold)
                                                .font(.title)
                                        }
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.black)
                                        .cornerRadius(40)
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
                                .background(Color(red: 155/255, green: 198/255, blue: 222/255))
                            }
                        }
                        """)
                        CommentBlockView(comment: "Use a custom configuration if you want.")
                        CodeBlockView(code: """
                        let _custom_config = PlacardConfig(
                            placement: .bottom,
                            insets: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20),
                            showAnimation: .floatRight,
                            hideAnimation: .floatLeft,
                            tapAnimation: .zoomInWithEasing,
                            fadeAnimation: true)
                        """)
                        let _custom_config = PlacardConfig(
                            placement: .bottom,
                            insets: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20),
                            showAnimation: .floatRight,
                            hideAnimation: .floatLeft,
                            tapAnimation: .zoomInWithEasing,
                            fadeAnimation: true)

                        CommentBlockView(comment: "Pass that view into a PlacardCustomView instance.")
                        CodeBlockView(code: """
                        PlacardCustomView(title: "some title", statusMessage: "some body", config: _custom_config) {
                            ViewWithButton(action: toggle)
                        }
                        """)

                        NavigationLink("Show Placard",
                                       destination: model.customViewMessageView(config: _custom_config))
                        .buttonStyle(CustomButtonStyle())

                    }
                    .navigationTitle("Placards")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)

                    Spacer()
                }
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
        .sheet(isPresented: $tapped, content: {
            Text("Placard was tapped")
                .fontWeight(.semibold)
                .font(.title)
            Button("(Tap to close)") {
                tapped = false
            }
        })
    }

}



