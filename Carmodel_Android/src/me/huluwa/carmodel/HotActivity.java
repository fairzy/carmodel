package me.huluwa.carmodel;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import me.huluwa.util.HttpRequest;
import me.huluwa.util.URLImageView;

import android.app.Activity;
import android.app.ProgressDialog;
import android.app.DownloadManager.Request;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.LinearLayout;
import android.widget.TextView;

public class HotActivity extends Activity {	
	public static final int IMAGE_LIST_TAG = 10;
	private JSONArray imageArray;
	private Handler myHandler ;
	private ProgressDialog loadingDialog;
	private int pageIndex = 0;
	
	
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.setContentView(R.layout.hot_list);
        
		myHandler = new Handler() {
			public void handleMessage(Message msg) {
				switch (msg.what) {
				case IMAGE_LIST_TAG:
					try {
						imageArray = new JSONArray((String) msg.obj);
					} catch (JSONException e) {
						e.printStackTrace();
					}
					HotActivity.this.updateView();
					break;
				}
				super.handleMessage(msg);
			}
		};
		 this.requestHotlist();
	}
	
	public void updateView(){
		loadingDialog.dismiss();
		LinearLayout leftlayoutLayout = (LinearLayout)this.findViewById(R.id.hot_leftLayout);
		LinearLayout rightlayoutLayout = (LinearLayout)this.findViewById(R.id.hot_rightLayout);
		
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
	
	public void requestHotlist(){
		loadingDialog = ProgressDialog.show(this, null, "Loading ... ");
		new RequestThread(pageIndex).start();
	}
	
	private class RequestThread extends Thread{
		private int index;
		public RequestThread(int ind){
			this.index = ind;
		}
		
		public void run(){
			String hoturl = "http://carmodel.sinaapp.com/api/hot_list.php?page="+index;
			String json = HttpRequest.getJsonWithUrl(hoturl);
			
			Message message=myHandler.obtainMessage();
			message.what = IMAGE_LIST_TAG;
			message.obj= json;
			myHandler.sendMessage(message);
		}
	}
}
