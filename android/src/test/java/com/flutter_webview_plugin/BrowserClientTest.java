package android.src.test.java.com.flutter_webview_plugin;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;

import android.net.Uri;
import android.webkit.WebResourceResponse;
import android.webkit.WebViewClient;
import android.webkit.WebView;
import android.webkit.WebResourceRequest;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

//@RunWith(PowerMockRunner.class)
public class BrowserClientTest {

    String testDomain;
    BrowserClient browserClient;

    public Map<String, String> getDefaultHeaders() {
        Map<String, String> returnHeaders = new HashMap<>();

        returnHeaders.put("Accept", "*/*");
        returnHeaders.put("Accept-Encoding", "gzip, deflate, br");
        returnHeaders.put("Accept-Language", "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7,la;q=0.6");
        returnHeaders.put("Connection", "keep-alive");
        returnHeaders.put("Cookie", "_ga=GA1.3.1758422152.1564075640; PHPSESSID=ccbfc4fa99c1961f8d263dbc1a6f1c43; CAKEPHP=d15d0578ee78d9c9f3ec2b9c04a63488");
        returnHeaders.put("Host", "buildblocks.prodemge.gov.br");
        returnHeaders.put("Layout", "");
        returnHeaders.put("Referer", "https://buildblocks.prodemge.gov.br/");
        returnHeaders.put("sec-ch-ua", "Google Chrome 77");
        returnHeaders.put("Sec-Fetch-Dest", "empty");
        returnHeaders.put("Sec-Fetch-Mode", "cors");
        returnHeaders.put("Sec-Fetch-Site", "same-origin");
        returnHeaders.put("User-Agent", "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 520)");
        returnHeaders.put("X-Requested-With", "XMLHttpRequest");

        return returnHeaders;
    }

    WebResourceRequest getMockWebresponse(String method, String url){
        WebResourceRequest mockRequest = Mockito.mock(WebResourceRequest.class);

        when(mockRequest.getUrl()).thenReturn(Uri.parse(url));
        when(mockRequest.getMethod()).thenReturn(method);
        when(mockRequest.getRequestHeaders()).thenReturn(getDefaultHeaders());

        return mockRequest;
    }

    @Before
    public void setUp() throws Exception {
        testDomain = "test.com";
        browserClient = new BrowserClient(
            "^(?!(https?:\\/\\/(?:\\w+\\.)*\\Q" + testDomain + "\\E(\\/\\S*)*)$)",
            "^(https?:\\/\\/(?:\\w+\\.)*\\Q" + testDomain + "\\E\\/pages(\\/\\S*)*)$"
        );
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

        WebResourceRequest mockRequest = getMockWebresponse("GET", "https://www."+testDomain );
        assertNull(browserClient.shouldInterceptRequest(null, mockRequest));
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