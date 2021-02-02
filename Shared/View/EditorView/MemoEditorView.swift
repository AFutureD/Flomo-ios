//
//  MemoEditorView.swift
//  flomo (iOS)
//
//  Created by AFuture on 2021/2/2.
//

import UIKit
import SwiftUI
import Proton
import Foundation

struct MemoEditorView: View {
    var body: some View {
        MemoTextView()
    }
}


struct MemoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditorView()
    }
}

struct MemoTextView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> MemoEditorViewController {

        var editor = MemoEditorViewController()
        return editor
    }

    func updateUIViewController(_ TextViewController: MemoEditorViewController, context: Context) {
    }
}

//struct MemoTextView: UIViewRepresentable {
//    func makeUIView(context: Context) -> some UIView {
//        return EditorView()
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//    }
//
//
//}

class MemoEditorViewController: UIViewController {

    let editor = EditorView()
    
    let commandExecutor = EditorCommandExecutor()
    var buttons = [UIButton]()

//    var encodedContents: JSON = ["contents": []]
    let commands: [(title: String, command: EditorCommand, highlightOnTouch: Bool)] = [
//        (title: "Panel", command: PanelCommand(), highlightOnTouch: false),
        (title: "List", command: ListCommand(), highlightOnTouch: false),
        (title: "Bold", command: BoldCommand(), highlightOnTouch: true),
        (title: "Italics", command: ItalicsCommand(), highlightOnTouch: true),
        (title: "TextBlock", command: TextBlockCommand(), highlightOnTouch: false),
    ]

//    let editorButtons: [(title: String, selector: Selector)] = [
//        (title: "Encode", selector: #selector(encodeContents(sender:))),
//        (title: "Decode", selector: #selector(decodeContents(sender:))),
//        (title: "Sample", selector: #selector(loadSample(sender:))),
//    ]

    let listFormattingProvider = ListFormattingProvider()
        
    func setup() {
        editor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editor)
        editor.layer.borderColor = UIColor.systemBlue.cgColor
        editor.layer.borderWidth = 1.0
        
        editor.listFormattingProvider = listFormattingProvider
        
        editor.registerProcessor(ListTextProcessor())
        
        editor.delegate = self
        EditorViewContext.shared.delegate = self
        
        NSLayoutConstraint.activate([
//            editor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            editor.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            editor.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            editor.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
//            editor.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
        editor.setFocus()
    }
}

class ListFormattingProvider: EditorListFormattingProvider {
    let listLineFormatting: LineFormatting = LineFormatting(indentation: 25, spacingBefore: 0)
    let sequenceGenerators: [SequenceGenerator] =
        [NumericSequenceGenerator(),
         DiamondBulletSequenceGenerator(),
         SquareBulletSequenceGenerator()]

    func listLineMarkerFor(editor: EditorView, index: Int, level: Int, previousLevel: Int, attributeValue: Any?) -> ListLineMarker {
        let sequenceGenerator = self.sequenceGenerators[(level - 1) % self.sequenceGenerators.count]
        return sequenceGenerator.value(at: index)
    }
}

extension MemoEditorViewController: EditorViewDelegate {
    func editor(_ editor: EditorView, didChangeSelectionAt range: NSRange, attributes: [NSAttributedString.Key: Any], contentType: EditorContent.Name) {
        guard let font = attributes[.font] as? UIFont else { return }

        buttons.first(where: { $0.titleLabel?.text == "Bold" })?.isSelected = font.isBold
        buttons.first(where: { $0.titleLabel?.text == "Italics" })?.isSelected = font.isItalics
    }

    func editor(_ editor: EditorView, didReceiveFocusAt range: NSRange) {
        print("Focussed: `\(editor.contentName?.rawValue ?? "<root editor>")` at depth: \(editor.nestingLevel)")
    }

    func editor(_ editor: EditorView, didChangeSize currentSize: CGSize, previousSize: CGSize) {
        print("Height changed from \(previousSize.height) to \(currentSize.height)")
    }
}
