package org.cnio.appform.util.captcha;

import com.octo.captcha.service.image.ImageCaptchaService;
import com.octo.captcha.service.image.DefaultManageableImageCaptchaService;

public class ImgCaptchaSingleton {

    private static ImageCaptchaService instance = 
    												new DefaultManageableImageCaptchaService();

    public static ImageCaptchaService getInstance(){
        return instance;
    }
}