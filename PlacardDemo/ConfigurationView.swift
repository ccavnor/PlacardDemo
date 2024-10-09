//
//  ConfigurationView.swift
//  PlacardDemo
//
//  Created by Christopher Charles Cavnor on 10/2/24.
//

import SwiftUI
import Placard

@Observable class ConfigurationModel {
    var duration: String = ""

    var placement: PlacardPlacement = .top
    var fade: Bool = false
    var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var showAnimation: TransitionAnimation = .none
    var hideAnimation: TransitionAnimation = .none
    var tapAnimation: TapAnimation = .none

    var edgeTop: String = ""
    var edgeLeft: String = ""
    var edgeRight: String = ""
    var edgeBottom: String = ""

    var backgroundColor: Color?
    var accentColor: UIColor?
    var primaryFont: UIFont?
    var secondaryFont: UIFont?
    var textColor: UIColor?

    func generateConfig() -> PlacardConfig {
        var _custom_config = PlacardConfig(
            placement: placement,
            insets: insets,
            showAnimation: showAnimation,
            hideAnimation: hideAnimation,
            tapAnimation: tapAnimation,
            fadeAnimation: fade)

        let insets = configureInsets()
        _custom_config.insets = insets

        return _custom_config
    }

    func resetConfig() {
        duration = ""
        placement = .top
        fade = false
        insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        showAnimation = .none
        hideAnimation = .none
        tapAnimation = .none
        edgeTop = ""
        edgeLeft = ""
        edgeRight = ""
        edgeBottom = ""
        backgroundColor = nil
        accentColor = nil
        primaryFont = nil
        secondaryFont = nil
        textColor = nil
    }

    func configureInsets() -> UIEdgeInsets {
        var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        insets.top = edgeTop.isEmpty ? 0 : CGFloat(Int(edgeTop) ?? 0)
        insets.left = edgeLeft.isEmpty ? 0 : CGFloat(Int(edgeLeft) ?? 0)
        insets.right = edgeRight.isEmpty ? 0 : CGFloat(Int(edgeRight) ?? 0)
        insets.bottom = edgeBottom.isEmpty ? 0 : CGFloat(Int(edgeBottom) ?? 0)

        return insets
    }

    func configureDuration() -> CGFloat {
        if let duration = Int(duration) {
            return CGFloat(duration)
        }
        return .infinity
    }

    public func priorityMessageView(_ priority: PlacardPriority) -> PlacardPriorityView {
        switch priority {
        case .success:
            return PlacardPriorityView(title: "Success!",
                                       statusMessage: "Some status message",
                                       config: generateConfig(),
                                       duration: configureDuration(),
                                       priority: priority)
        case .info:
            return PlacardPriorityView(title: "Some Info For Ya",
                                       statusMessage: "Peas sounds like peace, but tastes different.",
                                       config: generateConfig(),
                                       duration: configureDuration(),
                                       priority: priority)
        case .warning:
            return PlacardPriorityView(title: "Warning!",
                                       statusMessage: "Don't take anything seriously.",
                                       config: generateConfig(),
                                       duration: configureDuration(),
                                       priority: priority)
        case .error:
            return PlacardPriorityView(title: "An Error Done Happened",
                                       statusMessage: "But I'm not telling you which one.",
                                       config: generateConfig(),
                                       duration: configureDuration(),
                                       priority: priority)
        default:
            return PlacardPriorityView(title: "WTFudge 💩!",
                                       statusMessage: "some unknown thing happened",
                                       config: generateConfig(),
                                       duration: configureDuration(),
                                       priority: .default)
        }
    }

    public func customizeParametersForPlacardView(action: (() -> Void)? = nil) -> PlacardView {
        if let action = action {
            // add an action (fired on tap only)
            return PlacardView(title: "Don't forget to smile!",
                               statusMessage: "Teeth are like bats that hang from your gums.",
                               systemImageName: "face.smiling",
                               config: generateConfig(),
                               duration: configureDuration(),
                               action: action)
        }

        return PlacardView(title: "Don't forget to smile!",
                           statusMessage: "Teeth are like bats that hang from your gums.",
                           systemImageName: "mouth.fill",
                           config: generateConfig(),
                           duration: configureDuration())
    }

    public func configDefaultMessageView(config: PlacardConfig) -> PlacardView {
        return PlacardView(title: "You are fire!",
                           statusMessage: "(don't go swimming)",
                           systemImageName: "flame",
                           config: config,
                           duration: configureDuration())
    }

    public func customConfigMessageView(config: Custom) -> PlacardView {
        return PlacardView(title: "You Dawg!",
                           statusMessage: "Git that squeaky!",
                           systemImageName: "pawprint",
                           config: config,
                           duration: configureDuration())
    }

    public func customViewMessageView(config: PlacardConfig) -> some View  {
        return PlacardCustomView(title: "some title", statusMessage: "some body", config: config, duration: configureDuration()) {
            ViewWithButton()
        }
    }
}

struct ConfigurationView: View {
    @State var model: ConfigurationModel

    var body: some View {
        Form {

            Section {
                LabeledContent {
                    TextField(".infinity", text: $model.duration)
                        .frame(width: 60, height: 30)
                        .padding(5)
                        .border(Color.black)
                } label: {
                    Text("Duration (seconds) \n(time before disappearing)")
                }
            } header: {
                Text("Placard Timing")
            } footer: {
                Text("This applies to all examples")
            }

            Section {
                Picker("Placard screen placement", selection: $model.placement) {
                    Text("Top").tag(PlacardPlacement.top)
                    Text("Middle").tag(PlacardPlacement.center)
                    Text("Bottom").tag(PlacardPlacement.bottom)
                }
            } header: {
                Text("Screen Placement")
            } footer: {
                Text("This applies to those examples that don't use their own config file")
            }

            Section {
                Picker("Choose an animation for Placard appearance (show)", selection: $model.showAnimation) {
                    Text("None (no animation)").tag(TransitionAnimation.none)
                    Text("Fade in").tag(TransitionAnimation.fade)
                    Text("Float downward").tag(TransitionAnimation.floatDown)
                    Text("Float upward").tag(TransitionAnimation.floatUp)
                    Text("Float from left").tag(TransitionAnimation.floatLeft)
                    Text("Float from right").tag(TransitionAnimation.floatRight)
                    Text("rollup").tag(TransitionAnimation.rollUp)
                    Text("rolldown").tag(TransitionAnimation.rollDown)
                    Text("spin").tag(TransitionAnimation.spin)
                    Text("spin on x-axis").tag(TransitionAnimation.spinOnX)
                    Text("spin on y-axis").tag(TransitionAnimation.spinOnY)
                    Text("Expand from the x-axis").tag(TransitionAnimation.toX)
                    Text("Expand from the y-axis").tag(TransitionAnimation.toY)
                    Text("Expand from a point").tag(TransitionAnimation.toPoint)
                }

                Picker("Choose an animation for Placard disappearance (hide)", selection: $model.hideAnimation) {
                    Text("None (no animation)").tag(TransitionAnimation.none)
                    Text("Fade out").tag(TransitionAnimation.fade)
                    Text("Float downward").tag(TransitionAnimation.floatDown)
                    Text("Float upward").tag(TransitionAnimation.floatUp)
                    Text("Float to left").tag(TransitionAnimation.floatLeft)
                    Text("Float to right").tag(TransitionAnimation.floatRight)
                    Text("rollup").tag(TransitionAnimation.rollUp)
                    Text("rolldown").tag(TransitionAnimation.rollDown)
                    Text("spin").tag(TransitionAnimation.spin)
                    Text("spin on x-axis").tag(TransitionAnimation.spinOnX)
                    Text("spin on y-axis").tag(TransitionAnimation.spinOnY)
                    Text("Collapse to the x-axis").tag(TransitionAnimation.toX)
                    Text("Collapse to the y-axis").tag(TransitionAnimation.toY)
                    Text("Collapse to a point").tag(TransitionAnimation.toPoint)
                }

                Picker("Choose an animation for Placard tap", selection: $model.tapAnimation) {
                    Text("None (no animation)").tag(TapAnimation.none)
                    Text("Pulse inward").tag(TapAnimation.pulseIn)
                    Text("Pulse outward").tag(TapAnimation.pulseOut)
                    Text("Zoom in and ease out").tag(TapAnimation.zoomInWithEasing)
                    Text("Zoom out ease in").tag(TapAnimation.zoomOutWithEasing)
                }

                Toggle("Message should fade in/out", isOn: $model.fade)
            } header: {
                Text("Animations")
            } footer: {
                Text("These apply to those examples that don't use their own config file")
            }

            Section {
                HStack {
                    TextField("top", text: $model.edgeTop)
                        .frame(width: 50, height: 30)
                        .padding(5)
                        .border(Color.black)
                    TextField("left", text: $model.edgeLeft)
                        .frame(width: 50, height: 30)
                        .padding(5)
                        .border(Color.black)
                    TextField("right", text: $model.edgeRight)
                        .frame(width: 50, height: 30)
                        .padding(5)
                        .border(Color.black)
                    TextField("bottom", text: $model.edgeBottom)
                        .frame(width: 55, height: 30)
                        .padding(5)
                        .border(Color.black)
                }
                .padding(20)
            } header: {
                Text("Use edge insets to offset Placard")
            } footer: {
                Text("This applies to those examples that don't use their own config file")
            }

        }
    }
}

