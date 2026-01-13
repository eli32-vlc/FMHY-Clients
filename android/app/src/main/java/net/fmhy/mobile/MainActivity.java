package net.fmhy.mobile;

import android.os.Bundle;
import android.webkit.WebSettings;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Enable mixed content mode to allow HTTPS content in HTTP scheme WebView
        getBridge().getWebView().getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        
        // Enable hardware acceleration for better performance
        getBridge().getWebView().setLayerType(android.view.View.LAYER_TYPE_HARDWARE, null);
        
        // Enable DOM storage
        getBridge().getWebView().getSettings().setDomStorageEnabled(true);
        
        // Enable database
        getBridge().getWebView().getSettings().setDatabaseEnabled(true);
    }
}
