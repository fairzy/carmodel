//package com.alvin.api.utils;
//
///**
// * 通用异步下载类
// */
//import cn.com.pcgroup.common.android.utils.CacheUtils;
//import cn.com.pcgroup.common.android.utils.HttpUtils;
//import cn.com.pcgroup.common.android.utils.HttpUtils.HttpDownloadItem;
//
//import com.alvin.api.utils.LogOutputUtils;
//
//import android.graphics.drawable.Drawable;
//import android.os.Handler;
//import android.os.Message;
//
//import java.io.FileInputStream;
//import java.io.InputStream;
//import java.util.HashMap;
//import java.util.Map;
//
//public class AsyncImageLoader {
//    public static Map<String, String> imageFileCache = new HashMap<String, String>();
//    private final static String TAG = AsyncImageLoader.class.getSimpleName();
//    private final static int ImageCacheTime = 1209600;
//
//    public static Drawable loadDrawable(final String imageUrl,
//            final ImageCallback callback) {
//        // 异步读取图片更新
//        final Handler handler = new Handler() {
//            @Override
//            public void handleMessage(Message msg) {
//                callback.imageLoaded((Drawable) msg.obj, imageUrl);
//            }
//        };
//        new Thread() {
//            public void run() {
//                Drawable drawable = loadImageByUrl(imageUrl);
//                handler.sendMessage(handler.obtainMessage(0, drawable));
//            };
//        }.start();
//        return null;
//    }
//
//    public static Drawable loadImageByUrl(String imageUrl) {
//        synchronized (imageUrl) {
//            // return Drawable.createFromStream(new URL(imageUrl).openStream(),
//            // "src");
//            HttpDownloadItem httpDownloadItem = null;
//            boolean isError = false;
//            try {
//                httpDownloadItem = HttpUtils.invokeWithCache(imageUrl,
//                        CacheUtils.CACHE_EXTERNAL, ImageCacheTime, false);
//            } catch (Exception e) {
//                LogOutputUtils.i(TAG, "load image error");
//                e.printStackTrace();
//                isError = true;
//            }
//            if (isError) {
//                httpDownloadItem = null;
//                return null;
//            } else {
//                Drawable drawable = getDrawableByFile(httpDownloadItem
//                        .getInputStream());
//                if (null != imageFileCache && drawable != null) {
//                    imageFileCache.put(imageUrl, imageUrl);
//                    return drawable;
//                }
//            }
//            return null;
//        }
//    }
//
//    public static Drawable loadBitmap(String imageUrl) {
//        Drawable drawable = null;
//        InputStream inputStream;
//        try {
//            // long time=System.currentTimeMillis();
//            inputStream = new FileInputStream(
//                    HttpUtils.getCacheIgnoreExpire(imageUrl));
//            // LogOutput.e("花费时间",
//            // "time:"+(System.currentTimeMillis()-time)+"url:"+imageUrl);
//            if (inputStream != null) {
//                drawable = Drawable.createFromStream(inputStream, "src");
//            }
//        } catch (Exception e) {
//            LogOutputUtils.i(TAG, "load image error " + imageUrl);
//            // e.printStackTrace();
//        }
//        return drawable;
//    }
//
//    public static Drawable getDrawableByFile(InputStream inputStream) {
//        if (null != inputStream) {
//            try {
//                return Drawable.createFromStream(inputStream, "src");
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//        return null;
//    }
//
//    public interface ImageCallback {
//        public void imageLoaded(Drawable imageDrawable, String imageUrl);
//    }
//}
