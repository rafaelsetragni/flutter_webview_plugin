package com.flutter_webview_plugin;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

import android.net.Uri;
import android.webkit.WebViewClient;
import android.webkit.WebView;
import android.webkit.WebResourceRequest;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

public class BrowserClientTest {

    String testDomain;
    BrowserClient browserClient;
    Map<String, String> defaultHeaders;

    @Before
    public void setUp() throws Exception {
        testDomain = "buildblocks.prodmege.gov.br";
        browserClient = new BrowserClient(
            "^(?!(https?:\\/\\/(?:\\w+\\.)*\\Q" + testDomain + "\\E(\\/\\S*)*)\$)",
            "^(https?:\\/\\/(?:\\w+\\.)*\\Q" + testDomain + "\\E\\/pages(\\/\\S*)*)\$"
        );

        defaultHeaders = new HashMap<>(){{
            "Accept": "*/*",
                    "Accept-Encoding": "gzip, deflate, br",
                    "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7,la;q=0.6",
                    "Connection": "keep-alive",
                    "Cookie": "_ga=GA1.3.1758422152.1564075640; PHPSESSID=ccbfc4fa99c1961f8d263dbc1a6f1c43; CAKEPHP=d15d0578ee78d9c9f3ec2b9c04a63488",
                    "Host": "buildblocks.prodemge.gov.br",
                    "Layout": "",
                    "Referer": "https://buildblocks.prodemge.gov.br/",
                    "sec-ch-ua": "Google Chrome 77",
                    "Sec-Fetch-Dest": "empty",
                    "Sec-Fetch-Mode": "cors",
                    "Sec-Fetch-Site": "same-origin",
                    "User-Agent": "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 520)",
                    "X-Requested-With": "XMLHttpRequest"
        }};
    }

    @After
    public void tearDown() throws Exception {
        browserClient = null;
    }

    @Test
    public void updateInvalidUrlRegex() {
    }

    @Test
    public void updateUrlBlockerRegex() {
    }

    @Test
    public void updateValidUrlHeaderRegex() {
    }

    @Test
    public void onPageStarted() {
    }

    @Test
    public void onPageFinished() {
    }

    @Test
    public void shouldOverrideUrlLoading() {
    }

    @Test
    public void shouldOverrideUrlLoading1() {
    }

    @Test
    public void shouldInterceptRequest() {

        WebResourceRequest origRequest = new WebResourceRequest() {
            @Override
            public Uri getUrl() {
                return android.net.URI.create("https://www."+testDomain);
            }

            @Override
            public boolean isForMainFrame() {
                return false;
            }

            @Override
            public boolean isRedirect() {
                return false;
            }

            @Override
            public boolean hasGesture() {
                return false;
            }

            @Override
            public String getMethod() {
                return "GET";
            }

            @Override
            public Map<String, String> getRequestHeaders() {
                return defaultHeaders;
            }
        };

        assertNull(browserClient.shouldInterceptRequest(null, origRequest));
    }

    @Test
    public void onReceivedHttpError() {
    }

    @Test
    public void checkInvalidUrl() {
    }

    @Test
    public void checkBlockedUrl() {
    }

    @Test
    public void checkvalidUrlHeader() {
    }
}