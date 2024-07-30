package com.technosofts.vpnmax;


import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Collections;

import android.content.Intent;

import id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK);
        super.onActivityResult(requestCode, resultCode, data);
    }
    private MethodChannel disallowedAppsChannel;
    private static final String METHOD_CHANNEL_DISALLOWED_APPS = "disallowList";
    @Override
    public void finish() {
        disallowedAppsChannel.setMethodCallHandler(null);
        super.finish();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        disallowedAppsChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL_DISALLOWED_APPS);
        disallowedAppsChannel.setMethodCallHandler((call, result) -> {
            if ("applyChanges".equals(call.method)) {
                String str = call.argument("packageName");

                ArrayList<String> list = new ArrayList<String>(Collections.singletonList(str));
                boolean wow = false;
                try {

                    addInDisallowedList(list);
                    result.success(str + " : " + list);
                } catch (Exception e) {
                    e.printStackTrace();
                    result.success(str + " : dffd " + e.getMessage());
                }
                // result.success(str + " : " + wow);
            }
        });
    }
    private void addInDisallowedList(ArrayList<String> list) {
        // bypassPackages = list;
//        Set<String> set = new HashSet(list);
//        vpnProfile.mAllowedAppsVpn.addAll(set);
    }
}

