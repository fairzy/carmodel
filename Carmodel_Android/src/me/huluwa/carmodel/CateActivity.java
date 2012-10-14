package me.huluwa.carmodel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import me.huluwa.util.HttpRequest;

import org.json.JSONArray;
import org.json.JSONException;

import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ListView;
import android.widget.SimpleAdapter;

public class CateActivity extends ListActivity{
	public static final int CATE_LIST_TAG = 0;
	private Handler myHandler ;
	private JSONArray jsonArray;
	private ProgressDialog loadingDialog;
	
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
           
        myHandler = new Handler(){
        	public void handleMessage(Message msg) {  
        		loadingDialog.dismiss();
                switch (msg.what) {   
                	case CATE_LIST_TAG:                       
                		String jsonStr = (String)msg.obj;
                		try {
                			CateActivity.this.jsonArray = new JSONArray( jsonStr );
                		} catch (JSONException e) {
                			// TODO Auto-generated catch block
                			e.printStackTrace();
                		}
                		CateActivity.this.updateView();
                		break;
                }   
                super.handleMessage(msg);   
           } 
        };
        
        this.requestData();
    }
	
	public void updateView(){
		SimpleAdapter adapter = new SimpleAdapter(this, getListData(), R.layout.cate_list,
				new String[]{"icon", "title"}, new int[]{R.id.cate_icon, R.id.cate_title} );
		this.setListAdapter(adapter);
	}
	
	public void requestData(){
		loadingDialog = ProgressDialog.show(this, null, "Loading...");
		new Thread(){
			public void run(){
				String hoturl = "http://carmodel.sinaapp.com/api/category_list.php";
				String json = HttpRequest.getJsonWithUrl(hoturl);
				
				Message message=myHandler.obtainMessage();
				message.what = CATE_LIST_TAG;
				message.obj= json;
				myHandler.sendMessage(message);
			}
		}.start();
		
	}
	
	public List<Map<String, Object>> getListData(){
		int aicon[] = {R.drawable.image_category_icon_0, R.drawable.image_category_icon_1, 
				R.drawable.image_category_icon_2, R.drawable.image_category_icon_3, 
				R.drawable.image_category_icon_4, R.drawable.image_category_icon_5, 
				R.drawable.image_category_icon_6, R.drawable.image_category_icon_7,
				R.drawable.image_category_icon_8, R.drawable.image_category_icon_9};
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for( int i =0 ; i < this.jsonArray.length(); i++ ){
			try {
				Map<String, Object> item = new HashMap<String, Object>();
				item.put("title", this.jsonArray.getJSONObject(i).getString("name"));
				item.put("icon", aicon[i%10]);
				list.add(item);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return list;
	}
	
	@Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        Intent intent = new Intent(this, AlbumListActivity.class);
        int cate_id = -1;
		try {
			cate_id = jsonArray.getJSONObject(position).getInt("id");
		} catch (JSONException e) {
			e.printStackTrace();
		}
        intent.putExtra("cate_id", cate_id);
        startActivity(intent);
    }
}
