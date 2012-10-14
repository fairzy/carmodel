package me.huluwa.carmodel;

import me.huluwa.util.HttpRequest;
import me.huluwa.util.URLImageView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.LinearLayout;

public class AlbumDetailActivity extends Activity {
	public final int IMAGE_LIST_TAG = 0;
	private Handler myHandler;
	private JSONArray imageArray;
	private ProgressDialog loadingDialog;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.album_detail);
		
		Intent intent = this.getIntent();
		int album_id = intent.getIntExtra("album_id", -1);
		
		myHandler = new Handler(){
        	public void handleMessage(Message msg) {  
                switch (msg.what) {   
                	case IMAGE_LIST_TAG:                       
                		String jsonStr = (String)msg.obj;
                		Log.i("log_album", jsonStr);
                		try {
                			AlbumDetailActivity.this.imageArray = new JSONArray( jsonStr );
                		} catch (JSONException e) {
                			e.printStackTrace();
                		}
                		AlbumDetailActivity.this.updateView();
                		break;
                }   
                super.handleMessage(msg); 
           } 
        };
        this.requestData( album_id );
	}
	
	public void requestData(final int album_id ){
		loadingDialog = ProgressDialog.show(this, null, "Loading... ");
		new Thread(){
			public void run(){
				String hoturl = "http://carmodel.sinaapp.com/api/image_list.php?topic_id=" + album_id;
				String json = HttpRequest.getJsonWithUrl(hoturl);
				
				Message message=myHandler.obtainMessage();
				message.what = IMAGE_LIST_TAG;
				message.obj= json;
				myHandler.sendMessage(message);
			}
		}.start();
	}
	
	public void updateView(){
		loadingDialog.dismiss();
		LinearLayout leftlayoutLayout = (LinearLayout)this.findViewById(R.id.album_left_layout);
		LinearLayout rightlayoutLayout = (LinearLayout)this.findViewById(R.id.album_right_layout);
		
		for (int i = 0; i < imageArray.length(); i++) {
			JSONObject obj;
			try {
				obj = imageArray.getJSONObject(i);
				String url = obj.getString("link");
				String sizes = obj.getString("size");
				String[] sizea = sizes.split("x");
				int width = Integer.parseInt(sizea[0]);
				int height = Integer.parseInt(sizea[1]);
				
				int truewidth = 240;
				int trueheight = (int)(((float)height/width) * truewidth);
				Log.i("image", url + "," + width + "," + height + "," + trueheight);
				// add to layout
				URLImageView urlimageView = new URLImageView(this, url);
				urlimageView.setBackgroundColor(Color.WHITE);
				LinearLayout.LayoutParams fp = new LinearLayout.LayoutParams(truewidth, trueheight);
				fp.setMargins(0, 5, 0,0);
				if ( i%2 == 0 ) {
					leftlayoutLayout.addView(urlimageView, fp);
				}else{
					rightlayoutLayout.addView(urlimageView, fp);
				}				
				urlimageView.startLoadImage();
				
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	}
}
