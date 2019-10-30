package com.flutter_webview_plugin;

import android.annotation.TargetApi;
import android.graphics.Bitmap;
import android.os.Build;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebView.HitTestResult;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.webkit.SslErrorHandler;
import android.net.http.SslError;

import android.util.Log;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Request.Builder;
import okhttp3.Response;
import okhttp3.Headers;
import okhttp3.RequestBody;

import java.io.*;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by lejard_h on 20/12/2017.
 */

public class BrowserClient extends WebViewClient {

    private String LOG_TAG = BrowserClient.class.getSimpleName();

    private Pattern invalidUrlPattern = null;
    private Pattern blockerUrlPattern = null;
    private Pattern validUrlHeaderPattern = null;

    private Map<Integer, String> statusCodeMapping = new HashMap<Integer, String>();
    private Map<String, Object> capturedHeaders = new HashMap<String, Object>();
    private Map<String, byte[]> postData = new HashMap<String, byte[]>();

    private void prepareStatusCodeMapping () {
        statusCodeMapping.put(100, "Continue");
        statusCodeMapping.put(101, "Switching Protocols");
        statusCodeMapping.put(200, "OK");
        statusCodeMapping.put(201, "Created");
        statusCodeMapping.put(202, "Accepted");
        statusCodeMapping.put(203, "Non-Authoritative Information");
        statusCodeMapping.put(204, "No Content");
        statusCodeMapping.put(205, "Reset Content");
        statusCodeMapping.put(206, "Partial Content");
        statusCodeMapping.put(300, "Multiple Choices");
        statusCodeMapping.put(301, "Moved Permanently");
        statusCodeMapping.put(302, "Found");
        statusCodeMapping.put(303, "See Other");
        statusCodeMapping.put(304, "Not Modified");
        statusCodeMapping.put(307, "Temporary Redirect");
        statusCodeMapping.put(308, "Permanent Redirect");
        statusCodeMapping.put(400, "Bad Request");
        statusCodeMapping.put(401, "Unauthorized");
        statusCodeMapping.put(403, "Forbidden");
        statusCodeMapping.put(404, "Not Found");
        statusCodeMapping.put(405, "Method Not Allowed");
        statusCodeMapping.put(406, "Not Acceptable");
        statusCodeMapping.put(407, "Proxy Authentication Required");
        statusCodeMapping.put(408, "Request Timeout");
        statusCodeMapping.put(409, "Conflict");
        statusCodeMapping.put(410, "Gone");
        statusCodeMapping.put(411, "Length Required");
        statusCodeMapping.put(412, "Precondition Failed");
        statusCodeMapping.put(413, "Payload Too Large");
        statusCodeMapping.put(414, "URI Too Long");
        statusCodeMapping.put(415, "Unsupported Media Type");
        statusCodeMapping.put(416, "Range Not Satisfiable");
        statusCodeMapping.put(417, "Expectation Failed");
        statusCodeMapping.put(418, "I'm a teapot");
        statusCodeMapping.put(422, "Unprocessable Entity");
        statusCodeMapping.put(425, "Too Early");
        statusCodeMapping.put(426, "Upgrade Required");
        statusCodeMapping.put(428, "Precondition Required");
        statusCodeMapping.put(429, "Too Many Requests");
        statusCodeMapping.put(431, "Request Header Fields Too Large");
        statusCodeMapping.put(451, "Unavailable For Legal Reasons");
        statusCodeMapping.put(500, "Internal Server Error");
        statusCodeMapping.put(501, "Not Implemented");
        statusCodeMapping.put(502, "Bad Gateway");
        statusCodeMapping.put(503, "Service Unavailable");
        statusCodeMapping.put(504, "Gateway Timeout");
        statusCodeMapping.put(505, "HTTP Version Not Supported");
        statusCodeMapping.put(511, "Network Authentication Required");
    }

    public BrowserClient() {
        this(null, null);
    }

    public BrowserClient(String invalidUrlRegex) {
        this( invalidUrlRegex, null, null);
    }

    public BrowserClient(String invalidUrlRegex, String blockerUrlRegex) {
        this( invalidUrlRegex, blockerUrlRegex, null);
    }

    public BrowserClient(String invalidUrlRegex, String blockerUrlRegex, String validUrlHeaderRegex) {
        super();

        this.prepareStatusCodeMapping();

        this.updateInvalidUrlRegex(invalidUrlRegex);
        this.updateUrlBlockerRegex(blockerUrlRegex);
        this.updateValidUrlHeaderRegex(validUrlHeaderRegex);
    }

    public void updateInvalidUrlRegex(String invalidUrlRegex) {
        if (invalidUrlRegex != null) {
            this.invalidUrlPattern = Pattern.compile(invalidUrlRegex, Pattern.MULTILINE | Pattern.CASE_INSENSITIVE);
            Log.d(LOG_TAG, "Invalid regex applied: "+invalidUrlRegex);
        } else {
            this.invalidUrlPattern = null;
        }
    }

    public void updateUrlBlockerRegex(String blockerUrlRegex) {
        if (blockerUrlRegex != null) {
            this.blockerUrlPattern = Pattern.compile(blockerUrlRegex, Pattern.MULTILINE | Pattern.CASE_INSENSITIVE);
            Log.d(LOG_TAG, "URL block regex applied: "+blockerUrlRegex);
        } else {
            this.blockerUrlPattern = null;
        }
    }

    public void updateValidUrlHeaderRegex(String validUrlHeader) {
        if (validUrlHeader != null) {
            this.validUrlHeaderPattern = Pattern.compile(validUrlHeader, Pattern.MULTILINE | Pattern.CASE_INSENSITIVE);
            Log.d(LOG_TAG, "Valid header regex applied: "+validUrlHeader);
        } else {
            this.validUrlHeaderPattern = null;
        }
    }

    @Override
    public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
        Log.d(LOG_TAG, "SSL error founded: "+error.getUrl());
        handler.proceed(); // Ignore SSL certificate errors
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);

        Log.d(LOG_TAG, "onPageStarted: "+url);

        Map<String, Object> data = new HashMap<>();
        data.put("url", url);
        data.put("type", "startLoad");

        capturedHeaders.clear();
        postData.clear();

        FlutterWebviewPlugin.channel.invokeMethod("onState", data);
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        Map<String, Object> data = new HashMap<>();
        data.put("url", url);

        FlutterWebviewPlugin.channel.invokeMethod("onUrlChanged", data);

        data.put("type", "finishLoad");
        Log.d(LOG_TAG, "onState finishLoad invoked");
        FlutterWebviewPlugin.channel.invokeMethod("onState", data);

        data.put("headers", capturedHeaders);
        Log.d(LOG_TAG, "afterHttpRequests invoked");
        FlutterWebviewPlugin.channel.invokeMethod("afterHttpRequests", data);
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
        String url = request.getUrl().toString();
        return this.shouldOverrideUrlLoading(view, url);
    }

    private int HitTest2WKNavigationType(HitTestResult original){

        if (original.getType() > 0) {
            return HitTestResult.SRC_ANCHOR_TYPE; // int 0
        } else {
            return -1;
        }
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        // returning true causes the current WebView to abort loading the URL,
        // while returning false causes the WebView to continue loading the URL as usual.
        boolean isInvalidUrlAction = checkInvalidUrl(url);
        boolean isBlockedUrl = checkBlockedUrl(url);

        Map<String, Object> data = new HashMap<>();
        data.put("url", url);

        if(isInvalidUrlAction){

            Log.d(LOG_TAG, "Invalid url: "+url);
            data.put("navigationType", HitTest2WKNavigationType(view.getHitTestResult()));
            data.put("type", "abortLoad");

        } else if(isBlockedUrl){

            Log.d(LOG_TAG, "Blocked url: "+url);
            data.put("type", "blockedLoad");

        } else {
            data.put("type", "shouldStart");
        }

        FlutterWebviewPlugin.channel.invokeMethod("onState", data);

        return isInvalidUrlAction || isBlockedUrl;
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest origRequest){

        String url = origRequest.getUrl().toString();
        String httpMethod = origRequest.getMethod();

        Log.d(LOG_TAG, httpMethod+": "+url);

        if(!httpMethod.toLowerCase().equals("get") || !checkvalidUrlHeader(url)){
            return super.shouldInterceptRequest(view, origRequest);
        }

        try {
            OkHttpClient client = new OkHttpClient.Builder()
                    .retryOnConnectionFailure(true)
                    .build();

            Map<String, String> requestHeaders  = origRequest.getRequestHeaders();
            Map<String, String> responseHeaders = new HashMap<String, String>();

            Builder requestBuilder = new Request.Builder();

            for (Map.Entry<String, String> entry : requestHeaders.entrySet()) {
                requestBuilder.addHeader(entry.getKey(), entry.getValue());
            }

            okhttp3.Request request = requestBuilder.url(url).build();

            long startTime = System.currentTimeMillis();
            startTime = (startTime < 0) ? 0 : startTime;

            int retries = 0;
            int limitRetries = 5;
            okhttp3.Response response = null;

            do{
                try {
                        response = client.newCall(request).execute();
                } catch (Exception e) {
                    //e.printStackTrace();
                    retries++;
                    Log.d(LOG_TAG, "Exception founded: " + e.getMessage() + " (" + retries + ")");
                }
            } while (response == null && retries < limitRetries);

            if(response == null)
               return null;

            long duration = (response.cacheResponse() != null) ?
                    0 : System.currentTimeMillis() - startTime;

            String httpMessage = response.message();
            if (httpMessage.equals("")) {
                httpMessage = statusCodeMapping.get(response.code());
            }
            httpMessage = (httpMessage.equals("") || httpMessage == null) ? "OK" : httpMessage;

            int httpCode = response.code();

            for (Map.Entry<String, List<String>> entry : response.headers().toMultimap().entrySet()) {
                StringBuilder value = new StringBuilder();
                for (String val : entry.getValue()) {
                    value.append((value.toString().isEmpty()) ? val : "; " + val);
                }
                responseHeaders.put(entry.getKey(), value.toString());
            }

            byte[] dataBytes = response.body().bytes();
            InputStream dataStream = new ByteArrayInputStream(dataBytes);

            String[] arrOfContent;
            String completeContentType = responseHeaders.get("Content-Type");

            if(completeContentType != null){
                arrOfContent = completeContentType.split(";");
            } else {
                arrOfContent = new String[0];
            }

            String mimeType = "application/octet-stream"; // "application/binary"; //
            String encoding = null;

            if(arrOfContent.length > 0) mimeType = arrOfContent[0].trim();
            if(arrOfContent.length > 1) encoding = arrOfContent[1].split("=")[1].trim();

            final Map<String, Object> data = new HashMap<>();

            data.put("httpMethod",  httpMethod);
            data.put("httpCode",    httpCode);
            data.put("httpMessage", httpMessage);

            data.put("mimeType", mimeType);
            data.put("encoding", encoding);

            data.put("startTime",   startTime);
            data.put("duration",    duration);
            data.put("size",        dataBytes.length);

            data.put("requestHeaders",  requestHeaders);
            data.put("responseHeaders", responseHeaders);

            this.capturedHeaders.put(url, data);

            return new WebResourceResponse(
                mimeType,
                encoding,
                httpCode,
                httpMessage,
                responseHeaders,
                dataStream // response.body().byteStream() //
            );

        } catch (Exception e) {
            e.printStackTrace();
            Log.d(LOG_TAG, e.getMessage());
        }

        return null;
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
        super.onReceivedHttpError(view, request, errorResponse);
        Map<String, Object> data = new HashMap<>();
        data.put("url", request.getUrl().toString());
        data.put("code", Integer.toString(errorResponse.getStatusCode()));
        FlutterWebviewPlugin.channel.invokeMethod("onHttpError", data);
    }

    @Override
    public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
        super.onReceivedError(view, errorCode, description, failingUrl);
        Map<String, Object> data = new HashMap<>();
        data.put("url", failingUrl);
        data.put("code", Integer.toString(errorCode));
        FlutterWebviewPlugin.channel.invokeMethod("onHttpError", data);
    }

    private boolean checkInvalidUrl(String url) {
        if (invalidUrlPattern == null) {
            Log.d(LOG_TAG, "Empty invalid url regex: "+url);
            return false;
        } else {
            Matcher matcher = invalidUrlPattern.matcher(url);

            if(matcher.lookingAt()){
                Log.d(LOG_TAG, "Invalid url matched: "+url);
                return true;
            }
            Log.d(LOG_TAG, "valid url regex("+invalidUrlPattern.toString()+"): "+url);
            return false;
        }
    }

    private boolean checkBlockedUrl(String url) {
        if (blockerUrlPattern == null) {
            return false;
        } else {
            Matcher matcher = blockerUrlPattern.matcher(url);

            if(matcher.lookingAt()){
                Log.d(LOG_TAG, "Blocked url matched: "+url);
                return true;
            }
            return false;
        }
    }

    private boolean checkvalidUrlHeader(String url) {
        if (validUrlHeaderPattern == null) {
            return false;
        } else {
            Matcher matcher = validUrlHeaderPattern.matcher(url);

            if(matcher.lookingAt()){
                Log.d(LOG_TAG, "Valid url header matched: "+url);
                return true;
            }
            return false;
        }
    }
}