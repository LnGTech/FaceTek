//
//  RecognitionGLView.swift
//  LiveRecognition
//
//  Created by Anton on 11/03/2019.
//  Copyright © 2019 Luxand, Inc. All rights reserved.
//

import Foundation
import UIKit
import GLKit

class RecognitionGLView: UIView {
    var backingWidth: GLint = 0;
    var backingHeight: GLint = 0;
    var viewRenderbuffer: GLuint = 0;
    var viewFramebuffer: GLuint = 0;
    var context: EAGLContext = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)!;

    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentScaleFactor = 1.0
        
        let eaglLayer: CAEAGLLayer = self.layer as! CAEAGLLayer;
        eaglLayer.isOpaque = true;
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: 1, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8];
        
        context = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)!;
        
        EAGLContext.setCurrent(context);
        
        createFramebuffers();
    }
    
    func createFramebuffers() {
        glDisable(GLenum(GL_DEPTH_TEST));
        
        // Onscreen framebuffer object
        glGenFramebuffers(1, &viewFramebuffer);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), viewFramebuffer);
        
        glGenRenderbuffers(1, &viewRenderbuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), viewRenderbuffer);

        let eaglLayer: CAEAGLLayer = self.layer as! CAEAGLLayer;
        context.renderbufferStorage(Int(GL_RENDERBUFFER), from:eaglLayer);
        
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &backingWidth);
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &backingHeight);
        print("Backing width: \(backingWidth) height: \(backingHeight)");
        
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), viewRenderbuffer);
        
        if (glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GL_FRAMEBUFFER_COMPLETE) {
            print("Error generating framebuffer");
            exit(1);
        }
    }
    
    func destroyFramebuffer() {
        if (viewFramebuffer != 0) {
            glDeleteFramebuffers(1, &viewFramebuffer);
            viewFramebuffer = 0;
        }
        if (viewRenderbuffer != 0) {
            glDeleteRenderbuffers(1, &viewRenderbuffer);
            viewRenderbuffer = 0;
        }
    }
    
    func setDisplayFramebuffer() {
        if (context != nil) {
            //EAGLContext.setCurrent(context)
            if (viewFramebuffer == 0) {
                createFramebuffers();
            }
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), viewFramebuffer);
            glViewport(0, 0, backingWidth, backingHeight);
        }
    }
    
    func presentFramebuffer() -> Bool {
        var success: Bool = false;
        if (context != nil) {
            //EAGLContext.setCurrent(context)
            glBindRenderbuffer(GLenum(GL_RENDERBUFFER), viewRenderbuffer);
            success = (true == context.presentRenderbuffer(Int(GL_RENDERBUFFER)));
        
        
        
        }
        return success;
    }
    
    deinit {
        //context = nil;
    }
}
