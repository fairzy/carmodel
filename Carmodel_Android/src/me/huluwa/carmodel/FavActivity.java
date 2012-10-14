package me.huluwa.carmodel;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class FavActivity extends Activity {

	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView textview = new TextView(this);
        textview.setText("This is the favourite tab");
        setContentView(textview);
    }
}
