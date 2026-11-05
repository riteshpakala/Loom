import SwiftUI
import Granite
import FederationKit

/*
 Either this modal needs to be renamed aptly
 or merged with Write component.
 
 It handles both replies/edits to replies
 */
struct Reply: GraniteComponent {
    @Command var center: Center
    @Relay var content: ContentService
    
    @Environment(\.graniteBubble) var bubble
    
    var listeners: Void {
        content
            .center
            .interact
            .listen(.broadcast("reply")) { value in
                if let response = value as? ContentService.Interact.ResponseMeta {
                    
                    switch response.kind {
                    case .replyPostSubmit(let comment, let model):
                        guard let user = FederationKit.user()?.resource.user.person else {
                            return
                        }
                        bubble(.updatePost, (comment, comment.asView(creator: user, postView: model)) as (FederatedComment, FederatedCommentResource))
                    case .replyCommentSubmit(let comment, let reply):
                        bubble(.updateComment, (comment, reply) as (FederatedCommentResource, FederatedCommentResource?))
                    default:
                        break
                    }
                } else if let response = value as? ContentService.Interact.Meta {
                    switch response.kind {
                    case .editCommentSubmit(let model, _):
                        bubble(.updateComment, (model, nil) as (FederatedCommentResource, FederatedCommentResource?))
                    default:
                        break
                    }
                }
                _state.isReplying.wrappedValue = false
        }
    }
    
    
    let kind: Write.Kind
    let isPushed: Bool
    init(kind: Write.Kind, isPushed: Bool = false) {
        self.kind = kind
        switch kind {
        case .editReplyPost(let model, _), .editReplyComment(let model):
            _center = .init(.init(content: model.comment.content))
        default:
            break
        }
        self.isPushed = isPushed
    }
}
