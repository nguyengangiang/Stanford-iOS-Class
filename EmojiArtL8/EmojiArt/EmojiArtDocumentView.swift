//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }

                    }
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    .gesture(self.doubleTapToZoom(in: geometry.size))
                    .onTapGesture {
                        self.document.deselectAll()
                    }

                    ForEach(self.document.emojis) { emoji in
                        ZStack {
                            Circle()
                                .fill(Color.yellow)
                                .opacity(emoji.isSelected ? 0.7 : 0)
                                .frame(width: emoji.fontSize * 1.2 * self.zoomScale, height: emoji.fontSize * 1.2 * self.zoomScale)
                            Text(emoji.text)
                               .gesture(TapGesture(count: 1)
                               .onEnded {
                                   self.document.toggleMatching(for: emoji)
                               }
                                .exclusively(before: self.doubleTapToZoom(in: geometry.size)))
                                .gesture(self.dragGesture())
                                .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                                .onLongPressGesture() {
                                    self.document.removeEmoji(emoji)
                                }
                        }
                        .position(self.position(for: emoji, in: geometry.size))
                    }
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
                    // SwiftUI bug (as of 13.4)? the location is supposed to be in our coordinate system
                    // however, the y coordinate appears to be in the global coordinate system
                    var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                if (self.document.selectedEmojis.isEmpty) {
                    gestureZoomScale = latestGestureScale
                }
            }
            .onEnded { finalGestureScale in
                if (!self.document.selectedEmojis.isEmpty) {
                    for emoji in self.document.selectedEmojis {
                        self.document.scaleEmoji(emoji, by: finalGestureScale)
                    }
                } else {
                    self.steadyStateZoomScale *= finalGestureScale
                }
            }
    }

    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                if (self.document.selectedEmojis.isEmpty) {
                    gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
                }
        }
        .onEnded { finalDragGestureValue in
            if (self.document.selectedEmojis.isEmpty) {
                self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
        }
    }

    @State private var steadyStateDragOffset: CGSize = .zero
    @GestureState private var gestureDragOffset: CGSize = .zero
    
    private var DragOffset: CGSize {
        (steadyStateDragOffset + gestureDragOffset) * zoomScale
    }
    
    private func dragGesture() -> some Gesture {
        DragGesture()
            .updating($gestureDragOffset) { latestDragGestureValue, gestureDragOffset, transaction in
                if (!self.document.selectedEmojis.isEmpty) {
                    gestureDragOffset = latestDragGestureValue.translation / self.zoomScale
                }
            }
        .onEnded{ finalDragGestureValue in
            withAnimation(.linear(duration: 0.1)) {
                self.steadyStateDragOffset = (finalDragGestureValue.translation / self.zoomScale)
                for emoji in self.document.selectedEmojis {
                    self.document.moveEmoji(emoji, by: self.steadyStateDragOffset)
                }
            }
        }
    }
    
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.steadyStatePanOffset = .zero
            self.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
        
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}
