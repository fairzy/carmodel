package me.huluwa.carmodel;

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.widget.TabHost;
import android.widget.TabWidget;

public class CarmodelActivity extends TabActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i( "log", "oncreate" );
        final TabHost tabHost = getTabHost();
        Resources res = this.getResources();
        TabWidget tabwidget = tabHost.getTabWidget();
        Log.i( "log", tabwidget.getLeft() + "-" + tabwidget.getRight() + "-" + tabwidget.getTop() + "-" + tabwidget.getBottom() );
        
        
        tabHost.addTab(tabHost.newTabSpec("hottab")
                .setIndicator("Hot", res.getDrawable(R.drawable.ic_tab_hot))
                .setContent(new Intent(this, HotActivity.class)));

        tabHost.addTab(tabHost.newTabSpec("catetab")
                .setIndicator("Category", res.getDrawable(R.drawable.ic_tab_cate))
                .setContent(new Intent(this, CateActivity.class)));
        
        // This tab sets the intent flag so that it is recreated each time
        // the tab is clicked.
        tabHost.addTab(tabHost.newTabSpec("favtab")
                .setIndicator("Favourite", res.getDrawable(R.drawable.ic_tab_fav))
                .setContent(new Intent(this, FavActivity.class)
                        .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)));
        
        tabHost.addTab(tabHost.newTabSpec("settingtab")
                .setIndicator("More", res.getDrawable(R.drawable.ic_tab_setting))
                .setContent(new Intent(this, SettingActivity.class)));
    }
}