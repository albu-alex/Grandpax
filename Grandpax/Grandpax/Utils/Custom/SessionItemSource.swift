//
//  SessionItemSource.swift
//  Grandpax
//
//  Created by Alex Albu on 07.10.2023.
//

import LinkPresentation

class SessionItemSource: NSObject, UIActivityItemSource {
    var title: String
    var item: Any
    
    init(item: Any) {
        self.title = "\(CommonStrings.appName): Share this session with your friends"
        self.item = item
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return item
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return item
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "person.2.fill")!)
        return metadata
    }

}
