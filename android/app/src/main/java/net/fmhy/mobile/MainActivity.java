package net.fmhy.mobile;

import android.os.Bundle;
import android.webkit.WebSettings;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Enable mixed content mode to allow HTTPS content in HTTP scheme WebView
        // MIXED_CONTENT_ALWAYS_ALLOW is required (not COMPATIBILITY_MODE) because:
        // - The app uses http://localhost scheme (standard for Capacitor)
        // - The iframe loads https://fmhy.net (HTTPS content)
        // - COMPATIBILITY_MODE only allows passive content (images), not active content (iframes)
        // - We need full iframe functionality, which requires ALWAYS_ALLOW
        getBridge().getWebView().getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        
        // Enable hardware acceleration for better performance
        getBridge().getWebView().setLayerType(android.view.View.LAYER_TYPE_HARDWARE, null);
        
        // Enable DOM storage
        getBridge().getWebView().getSettings().setDomStorageEnabled(true);
        
        // Enable database
        getBridge().getWebView().getSettings().setDatabaseEnabled(true);
    }
}
