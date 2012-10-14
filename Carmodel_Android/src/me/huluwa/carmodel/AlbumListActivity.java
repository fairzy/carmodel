package me.huluwa.carmodel;

import java.util.ArrayList;
import java.util.List;

import me.huluwa.util.HttpRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class AlbumListActivity extends ListActivity{
	public static final int ALBUM_LIST_TAG = 0;
	private JSONObject jsonObj;
	private Handler myHandler;
	private ProgressDialog loadingDialog;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		Intent intent = this.getIntent();
		int cate_id = intent.getIntExtra("cate_id", -1);
		
		myHandler = new Handler(){
        	public void handleMessage(Message msg) {  
        		loadingDialog.dismiss();
        		
                switch (msg.what) {   
                	case ALBUM_LIST_TAG:                       
                		String jsonStr = (String)msg.obj;
                		Log.i("log", jsonStr);
                		try {
                			AlbumListActivity.this.jsonObj = new JSONObject( jsonStr );
                		} catch (JSONException e) {
                			e.printStackTrace();
                		}
                		AlbumListActivity.this.updateView();
                		break;
                }   
                super.handleMessage(msg);   
           } 
        };
        
        this.requestData( cate_id );
	}
	
	public void requestData(final int cate_id){
		loadingDialog = ProgressDialog.show(this, null, "Loading...");
		new Thread(){
			public void run(){
				String hoturl = "http://carmodel.sinaapp.com/api/topic_list.php?category_id=" + cate_id;
				String json = HttpRequest.getJsonWithUrl(hoturl);
				
				Message message=myHandler.obtainMessage();
				message.what = ALBUM_LIST_TAG;
				message.obj= json;
				myHandler.sendMessage(message);
			}
		}.start();
		
	}
	
	public void updateView(){
		List<String> list = new ArrayList<String>();
		JSONArray jarray;
		try {
			jarray = jsonObj.getJSONArray("data");
		
			for( int i=0; i<jarray.length(); i++ ){
				list.add( jarray.getJSONObject(i).getString("name"));
			}
		} catch (JSONException e	) {
			e.printStackTrace();
		}
		this.setListAdapter( new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, list) );
	}
	
	@Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        Intent intent = new Intent(this, AlbumDetailActivity.class);
        int al_id = -1;
        JSONArray jarray;
		try {
			jarray = jsonObj.getJSONArray("data");
			al_id = jarray.getJSONObject(position).getInt("id");
		} catch (JSONException e) {
			e.printStackTrace();
		}
        intent.putExtra("album_id", al_id);
        startActivity(intent);
    }
}
