package me.huluwa.util;

import android.R;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ProgressBar;

public class URLImageView extends FrameLayout { 
	private Handler handler;
	private final int IMAGE_LOAD_TAG = 0;
	private String imageUrl;
	private ImageView urlImage = null;
	private ProgressBar progressBar;
	
	public URLImageView(Context context, String url) {
		super(context);	
		this.imageUrl = url;
		//
		urlImage = new ImageView( context );
		//
		progressBar = new ProgressBar( context );
		FrameLayout.LayoutParams p = new FrameLayout.LayoutParams(
				FrameLayout.LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		p.gravity = Gravity.CENTER;
		this.addView(progressBar, p);
		//
		handler = new Handler(){
			public void handleMessage(Message msg) {  
                switch (msg.what) {   
                	case IMAGE_LOAD_TAG:                       
                		byte[] bytes = (byte [])msg.obj;
                		     
                		Bitmap bitmap  = BitmapFactory.decodeByteArray(bytes, 0,
                				bytes.length);
                		urlImage.setImageBitmap(bitmap);
                		// 更新视图
                		updateView();
                		break;
                }   
                super.handleMessage(msg);   
           }
		};
		
	}
	
	public void updateView(){
		// remove progress bar
		this.removeView(progressBar);
		// add imageview
		FrameLayout.LayoutParams p = new FrameLayout.LayoutParams(
				FrameLayout.LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
		this.addView(urlImage, p);
		
	}
	
	public void startLoadImage( ){
		new DownThread(this.imageUrl).start();
	}
	
	private class DownThread extends Thread{
		private String url;
		public DownThread( String u ){
			this.url = u;
		}
		
		public void run(){
			byte[] rdata = HttpRequest.getDataWithUrl(this.url);
			
			Message message= handler.obtainMessage();
			message.what = IMAGE_LOAD_TAG;
			message.obj = rdata;
			handler.sendMessage(message);
		}
		
	}
	
}
