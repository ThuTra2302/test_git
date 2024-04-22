import 'dart:ui';

import '../res/image/app_image.dart';

class AppConstant {
  static final availableLocales = [
    const Locale('vi', 'VN'),
    const Locale('en', 'US')
  ];

  // static const keyGoogleMap = 'AIzaSyDUXrcW6YBqQGIYnX4VZEzApYcd-75-SdM';
  static const keyGoogleMap = 'AIzaSyC8CEwmuFyCgRbZEJjNNaLJ0CyTPhZN9wk';
  static const keyWeather = '9EQx3iNxQF8IRnKoxmv3398bLcbxQLQL3QwrEw19';
  static const averageV = 64; // kmh

  static const List<String> listNotificationContent = [
    "Wondering what to wear before going out? We got you cover with our precise Weather Forcast. Available now!!!",
    "You might need an umbrella today. Weather Forecast is available now!!!",
    "Avoid extreme weather conditions with our weekly weather forecast. Tap here to view.",
    "Planning to go out this weekend? Open the app  to check out the Weather Forecast!",
    "Are we having a beautiful weather today? Check out weather forecast now.",
    "Careful with sudden weather change. Be prepared with our weather forecast.",
    "The weather can be extreme. Tap here to see current weather.",
    "The wind started to blow. Check out weather before leaving.",
    "The sky is clear. Or is it? Tap here to see weather conditions now.",
    "Tap here to see the weather outside before leaving."
  ];

  static const List listWMOCode = [
    {
      'code': 0,
      'desEN': 'Clear sky',
      'desVN': 'Bầu trời quang đãng',
      'image': AppImage.weather_00,
      'image2': AppImage.weather_00_n
    },
    {
      'code': 1,
      'desEN': 'Mainly clear',
      'desVN': 'Trời quang',
      'image': AppImage.weather_01,
      'image2': AppImage.weather_01_n
    },
    {
      'code': 2,
      'desEN': 'Partly cloudy',
      'desVN': 'Mây mù',
      'image': AppImage.weather_02,
      'image2': AppImage.weather_02_n
    },
    {
      'code': 3,
      'desEN': 'Overcast',
      'desVN': 'U ám',
      'image': AppImage.weather_03
    },
    {
      'code': 45,
      'desEN': 'Fog',
      'desVN': 'Sương mù',
      'image': AppImage.weather_45
    },
    {
      'code': 48,
      'desEN': 'Depositing rime fog',
      'desVN': 'Đọng sương',
      'image': AppImage.weather_48
    },
    {
      'code': 51,
      'desEN': 'Drizzle light',
      'desVN': 'Mưa phùn nhẹ',
      'image': AppImage.weather_51
    },
    {
      'code': 53,
      'desEN': 'Drizzle moderate',
      'desVN': 'Mưa phùn vừa',
      'image': AppImage.weather_53
    },
    {
      'code': 55,
      'desEN': 'Drizzle dense intensity',
      'desVN': 'Mưa phùn sai hạt',
      'image': AppImage.weather_55
    },
    {
      'code': 56,
      'desEN': 'Freezing Drizzle light',
      'desVN': 'Mưa phùn lạnh nhẹ',
      'image': AppImage.weather_56
    },
    {
      'code': 57,
      'desEN': 'Freezing Drizzle dense intensity',
      'desVN': 'Mưa phùn lạnh sai hạt',
      'image': AppImage.weather_57
    },
    {
      'code': 61,
      'desEN': 'Rain slight',
      'desVN': 'Mưa nhẹ',
      'image': AppImage.weather_61
    },
    {
      'code': 63,
      'desEN': 'Rain moderate',
      'desVN': 'Mưa vừa',
      'image': AppImage.weather_63
    },
    {
      'code': 65,
      'desEN': 'Rain heavy intensity',
      'desVN': 'Mưa to',
      'image': AppImage.weather_65
    },
    {
      'code': 66,
      'desEN': 'Freezing Rain light',
      'desVN': 'Mưa lạnh nhẹ',
      'image': AppImage.weather_66
    },
    {
      'code': 67,
      'desEN': 'Freezing Rain: heavy intensity',
      'desVN': 'Mưa lạnh: nặng hạt',
      'image': AppImage.weather_67
    },
    {
      'code': 71,
      'desEN': 'Snow fall slight',
      'desVN': 'Tuyết rơi nhẹ',
      'image': AppImage.weather_71
    },
    {
      'code': 73,
      'desEN': 'Snow fall moderate',
      'desVN': 'Tuyết rơi trung bình',
      'image': AppImage.weather_73
    },
    {
      'code': 75,
      'desEN': 'Snow fall heavy intensity',
      'desVN': 'Tuyết rơi nặng hạt',
      'image': AppImage.weather_75
    },
    {
      'code': 77,
      'desEN': 'Snow grains',
      'desVN': 'Tuyết rơi lớn',
      'image': AppImage.weather_77
    },
    {
      'code': 80,
      'desEN': 'Rain showers slight',
      'desVN': 'Mưa rào nhẹ',
      'image': AppImage.weather_80
    },
    {
      'code': 81,
      'desEN': 'Rain showers moderate',
      'desVN': 'Mưa rào trung bình',
      'image': AppImage.weather_81
    },
    {
      'code': 82,
      'desEN': 'Rain showers violent',
      'desVN': 'Mưa rào nặng hạt',
      'image': AppImage.weather_82
    },
    {
      'code': 85,
      'desEN': 'Snow showers slight',
      'desVN': 'Mưa tuyết nhẹ',
      'image': AppImage.weather_85
    },
    {
      'code': 86,
      'desEN': 'Snow showers heavy',
      'desVN': 'Mưa tuyết nặng hạt',
      'image': AppImage.weather_86
    },
    {
      'code': 95,
      'desEN': 'Thunderstorm',
      'desVN': 'Dông bão',
      'image': AppImage.weather_95
    },
    {
      'code': 96,
      'desEN': 'Thunderstorm with slight',
      'desVN': 'Giông bão nhẹ',
      'image': AppImage.weather_96
    },
    {
      'code': 99,
      'desEN': 'Thunderstorm with heavy hail',
      'desVN': 'Giông bão kèm mưa đá',
      'image': AppImage.weather_99
    },
  ];

  static const List listSuggestTourGuide = [
    "Can you recommend some special local dishes or food spots that I shouldn't miss?",
    "Can you recommend a famous or scenic road trip route around this area?",
    "Could you suggest an excellent travel destination or spot nearby?",
    "Could you suggest a well-known or highly-rated restaurant in the vicinity?",
  ];

  static const List listSuggestTravelMusic = [
    "Suggest a song that matches my upbeat and energetic mood",
    "Recommend a track that complements my relaxed and chill atmosphere.",
    "I'm feeling a bit nostalgic today. What song would you suggest?",
    "In the mood for something motivational and empowering. Any song recommendations?",
  ];

  static const List listSuggestKaraoke = [
    "Any recommendation for a fun and energetic song?",
    "Suggest a karaoke song that suits my laid-back and easygoing mood.",
    "I'm feeling a bit nostalgic today. What song would you suggest?",
    "Looking for a classic karaoke anthem that everyone can sing along to. Any recommendations?",
  ];

  static const List listSuggestPodcast = [
    "Could you recommend a travel podcast that will keep me engaged on the journey?",
    "Any recommendations for a travel-themed podcast?",
    "Can you suggest a podcast that features exciting travel experiences and outdoor activities?",
    "Any suggestions for shows that delve into the local customs, traditions, and cuisine of different places?",
  ];

  static const List listSuggestMeditationMusic = [
    "Give me a meditation music for a 30-minute car ride.",
    "Suggest calming meditation tracks for a train journey.",
    "Can you recommend meditation music that's perfect for in-flight relaxation? ",
    "What meditation music do you suggest for a serene drive, helping me stay mindful and stress-free while on the road?",
  ];

  static const List listSuggestEbook = [
    "Can you recommend some top e-books tailored specifically for bikers?",
    "Could you suggest some e-books that provide guidance on trip planning, safety?",
    "Are there any e-books you would recommend for bikers looking to learn more about modifying their bikes?",
    "What are some highly-rated e-books that focus on motorcycle culture?",
  ];

  static const List<Map> listCategory = [
    {
      "title": "Tour guide",
      "ic_path": AppImage.categoryTourGuide,
      "messenger1":
          "Play as a tour guide to answer the questions. If the content of the conversation is not related to travel, location, vacation, road trip, or thing to do and eat during travel, refuse to answer. Note reply in user language.",
      "messenger2":
          "Certainly, I'll do my best to answer questions related to travel, location, vacation, road trip, or thing to do and eat during travel. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.",
      "list_suggest": listSuggestTourGuide,
    },
    {
      "title": "Travel Music",
      "ic_path": AppImage.categoryTravelMusic,
      "messenger1":
          "Play as a music expert answer the questions. If the content of the conversation is not related to picking song based on user mood, refuse to answer. Note reply in user language.",
      "messenger2":
          "Certainly, I'll do my best to answer questions related to picking songs based on your mood. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.",
      "list_suggest": listSuggestTravelMusic,
    },
    {
      "title": "Karaoke",
      "ic_path": AppImage.categoryKaraoke,
      "messenger1":
          "Play as a music expert answer the questions. If the content of the conversation is not related to picking karaoke song based on user mood, refuse to answer. Note reply in user language.",
      "messenger2":
          "Certainly, I'll do my best to answer questions related to picking karaoke songs based on your mood. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.",
      "list_suggest": listSuggestKaraoke,
    },
    {
      "title": "Meditation Music",
      "ic_path": AppImage.categoryMeditationMusic,
      "messenger1":
          "Play as a travel expert answer the questions. If the content of the conversation is not related to picking travel podcast based on user preferences, refuse to answer. Note reply in user language.",
      "messenger2":
          "Certainly, I'll do my best to answer questions related to picking travel podcast based on your mood. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.",
      "list_suggest": listSuggestMeditationMusic,
    },
    {
      "title": "Podcast",
      "ic_path": AppImage.categoryPodcast,
      "messenger1":
          "Play as a travel expert answer the questions. If the content of the conversation is not related to picking travel podcast based on user preferences, refuse to answer. Note reply in user language.",
      "messenger2":
          "Certainly, I'll do my best to answer questions related to picking travel podcast based on your mood. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.",
      "list_suggest": listSuggestPodcast,
    },
    {
      "title": "E-book for biker",
      "ic_path": AppImage.categoryEbook,
      "messenger1":
          "Play as an ebook biker to answer the questions. If the content of the conversation is not related to content in ebook for biker like essential tips on motorcycle maintenance safety and riding skills for motorcycle ethusiasts, riding, touring, bike customization from must read ebook for biker, refuse to answer. Note reply in user language.",
      "messenger2":
          "Certainly, I'll do my best to answer questions related to essential tips on motorcycle maintenance safety and riding skills for motorcycle ethusiasts, riding, touring, bike customization from must read ebook for biker. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.",
      "list_suggest": listSuggestEbook,
    },
  ];
}
