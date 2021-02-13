import 'dart:ui';

import 'package:flutter/material.dart';

const String ONE_NETWORK_URL =
    "https://digital.vodafone.com.eg/OneNetwork/Login.aspx?ReturnUrl=OneNetwork/dashboard.aspx";
const String SPLUNK_KPIs_URL = "https://digital.vodafone.com.eg/en-US/account/";

const double default_font_size = 14.0;
const double chat_text_font_size = 16.0;
const double text_font_size = 17.0;
const double chat_mid_text_font_size = 18.0;
const double min_font_size = 11.0;
const double large_font_size = 22.0;
const double medium_font_size = 12.0;
const double button_BorderRadius = 4.0;
const double button_width_percentage = 0.75;
const double button_height = 40;
const Color vodaRed = Color(0xFFE60000);
const Color remWhite = Color(0xFFFFFFFF);
const Color backgroundColor = Color(0xFFd1e29e);
const Color backgroundColor2 = Color(0xFFa6cc3d);
const Color themeColor = Color(0xFF268549);
const Color themeColor2 = Color(0xFF4f976a);
const String vodafone_red_icon = 'assets/ic_vodafone.png';
const String vodafone_large_icon = 'assets/vodafone_larg.png';
const String vodafone_side_bg = 'assets/side_bg.png';
const String nwAndItIcon = 'assets/network.png';
const String roIcon = 'assets/internet.png';
const String allIcon = 'assets/grid.png';

final List<String> spinnerChooseDateItems1 = [
  'Today',
  'Last 24',
  'Last 48',
  'Last week',
  'Last month',
  'Custom'
];


String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return "Good Morning";
  }
  if (hour < 17) {
    return "Good Afternoon";
  }
  return "Good Evening";
}

String GREETING =
    "${greeting()}. I am Service Management  Chatbot. How can I help you ?"
    " Please select an action below ."
    " To make sure you receive the best quality, all chats/actions are recorded."; //0
const String SELECT_ACTION = "Please select an action below"; //1
const String SELECT_VENDOR = "Please Select The Vendor"; //2
const String ENTER_SITE_ID = "Please enter the physical site ID"; //3
const String ENTER_SITE_ID_HUB_ID = "Please enter physical site ID / HUb ID"; //3
const String CHOOSE_DEVICE_TYPE = "Please choose type of device"; //6
const String CALIBRATE_DEVICES =
    "You will be able to calibrate 1 to 3 devices / sectors per time"; //7
const String ENTER_OTP = "Please Enter the OTP"; //8
const String PROCESSING_REQUEST = "Your request is under processing"; //10
const String CALIBRATE_FAULTY_DEVICES =
    "You will be able to calibrate faulty devices / sectors"; //11
const String SELECT_TECHNOLOGY = "Choose the technology"; //12
