package me.huluwa.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import android.util.Log;

public class HttpRequest {
	public static String getJsonWithUrl(String path){
		String datastr = null;
		// Get方式请求
		try{
			// 新建一个URL对象
			URL url = new URL(path);
			// 打开一个HttpURLConnection连接
			HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
			// 设置连接超时时间
			urlConn.setConnectTimeout(5 * 1000);
			// 开始连接
			urlConn.connect();
			// 判断请求是否成功
			if (urlConn.getResponseCode() == HttpURLConnection.HTTP_OK ) {
				// 获取返回的数据
				BufferedReader breader = new BufferedReader( new InputStreamReader(urlConn.getInputStream()) );
				StringBuffer textBuff = new StringBuffer();
				String line = null;
				while( (line = breader.readLine()) != null ){
					textBuff.append( line );
				}
				datastr = textBuff.toString();
			} else {
				Log.e("httpRequest", "Get方式请求失败");
			}
			// 关闭连接
			urlConn.disconnect();
		}catch( Exception e ){
			e.printStackTrace();
			Log.e("httpRequest", "网络请求异常"+e.toString()+e.getMessage());
		}
		return datastr;
	}
	
	public static byte[] getDataWithUrl(String path){
		byte[] rdata = null;
		// Get方式请求
		try{
			// 新建一个URL对象
			URL url = new URL(path);
			// 打开一个HttpURLConnection连接
			HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
			// 设置连接超时时间
			urlConn.setConnectTimeout(5 * 1000);
			// 开始连接
			urlConn.connect();
			// 判断请求是否成功
			if (urlConn.getResponseCode() == HttpURLConnection.HTTP_OK ) {
				int length = urlConn.getContentLength();
				rdata = new byte[length];
				Log.i("length", length+"");
				// 获取返回的数据
				InputStream inputStream = urlConn.getInputStream();
				int alllen = 0;
				int readlen = -1;
				byte[] buf = new byte[512];
				while ( (readlen = inputStream.read(buf)) != -1 ) {
					System.arraycopy(buf, 0, rdata, alllen, readlen);
					alllen += readlen;
				}
			} else {
				Log.e("httpRequest", "请求data失败");
			}
			// 关闭连接
			urlConn.disconnect();
		}catch( Exception e ){
			e.printStackTrace();
			Log.e("httpRequest", "网络请求异常"+e.toString()+e.getMessage());
		}

		return rdata;
	}
}
