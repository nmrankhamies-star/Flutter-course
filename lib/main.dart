import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// =============================================================================
// 1. إدارة الثيم وحالة التقدم (Global State)
// =============================================================================
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// كلاس بسيط لإدارة تقدم الأذكار في الذاكرة
class ProgressManager {
  // يخزن نسبة الإنجاز لكل قسم (من 0.0 إلى 1.0)
  static Map<String, double> categoryProgress = {
    "أذكار الصباح": 0.0,
    "أذكار المساء": 0.0,
    "أذكار بعد الصلاة": 0.0,
    "أذكار النوم": 0.0,
    "أذكار الاستيقاظ": 0.0,
  };

  static void updateProgress(String category, int finishedItems, int totalItems) {
    if (totalItems == 0) return;
    categoryProgress[category] = finishedItems / totalItems;
  }

  static double getTotalProgress() {
    double total = 0;
    categoryProgress.forEach((key, value) => total += value);
    return total / categoryProgress.length; // متوسط الإنجاز العام
  }
}

void main() {
  runApp(const TasbeehApp());
}

// =============================================================================
// 2. الألوان والثوابت
// =============================================================================
const Color kPrimaryBlue = Color(0xFF0D47A1);
const Color kAccentLight = Color(0xFFE3F2FD);
const Color kAccentDark = Color(0xFF2C3E50);
const Color kBgLight = Color(0xFFF8F9FA);
const Color kBgDark = Color(0xFF121212);
const Color kCardLight = Colors.white;
const Color kCardDark = Color(0xFF1E1E1E);

// =============================================================================
// 3. قاعدة بيانات الأذكار (حصن المسلم - كاملة)
// =============================================================================
class AthkarData {
  static List<Map<String, dynamic>> getAthkar(String category) {
    switch (category) {
      case "أذكار الصباح":
        return [
          {"text": "أَعُوذُ بِاللهِ مِنْ الشَّيْطَانِ الرَّجِيمِ\n{اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ}", "count": 1},
          {"text": "بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم\n{قُلْ هُوَ اللَّهُ أَحَدٌ * اللَّهُ الصَّمَدُ * لَمْ يَلِدْ وَلَمْ يُولَدْ * وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ}", "count": 3},
          {"text": "بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم\n{قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ * مِن شَرِّ مَا خَلَقَ * وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ * وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ * وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ}", "count": 3},
          {"text": "بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم\n{قُلْ أَعُوذُ بِرَبِّ النَّاسِ * مَلِكِ النَّاسِ * إِلَهِ النَّاسِ * مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ * الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ * مِنَ الْجِنَّةِ وَ النَّاسِ}", "count": 3},
          {"text": "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لا إِلَهَ إِلا اللَّهُ، وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ", "count": 1},
          {"text": "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ", "count": 1},
          {"text": "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ", "count": 1},
          {"text": "اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ", "count": 4},
          {"text": "اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ", "count": 1},
          {"text": "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ. اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ", "count": 3},
          {"text": "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ", "count": 7},
          {"text": "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ", "count": 3},
          {"text": "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا", "count": 3},
          {"text": "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ", "count": 1},
          {"text": "أَصْبَحْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ", "count": 1},
          {"text": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", "count": 100},
          {"text": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", "count": 100},
          {"text": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ", "count": 3},
          {"text": "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا", "count": 1},
          {"text": "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ", "count": 100},
        ];
      case "أذكار المساء":
        return [
          {"text": "أَعُوذُ بِاللهِ مِنْ الشَّيْطَانِ الرَّجِيمِ\n{اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ...} (آية الكرسي)", "count": 1},
          {"text": "سورة الإخلاص، وسورة الفلق، وسورة الناس", "count": 3},
          {"text": "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لا إِلَهَ إِلا اللَّهُ، وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ", "count": 1},
          {"text": "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ", "count": 1},
          {"text": "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ... (سيد الاستغفار)", "count": 1},
          {"text": "اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ", "count": 4},
          {"text": "اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ", "count": 1},
          {"text": "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي...", "count": 3},
          {"text": "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ", "count": 7},
          {"text": "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ", "count": 3},
          {"text": "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا", "count": 3},
          {"text": "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ", "count": 1},
          {"text": "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ", "count": 3},
          {"text": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", "count": 100},
          {"text": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", "count": 100},
          {"text": "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ", "count": 100},
        ];
      case "أذكار بعد الصلاة":
        return [
          {"text": "أَسْتَغْفِرُ اللَّهَ (3 مرات) اللَّهُمَّ أَنْتَ السَّلامُ وَمِنْكَ السَّلامُ، تَبَارَكْتَ يَا ذَا الْجَلالِ وَالإِكْرَامِ", "count": 1},
          {"text": "لا إلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لا مَانِعَ لِمَا أَعْطَيْتَ، وَلا مُعْطِيَ لِمَا مَنَعْتَ، وَلا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ", "count": 1},
          {"text": "لا إلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ. لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ، لا إلَهَ إِلا اللَّهُ، وَلا نَعْبُدُ إِلا إِيَّاهُ، لَهُ النِّعْمَةُ وَلَهُ الْفَضْلُ وَلَهُ الثَّنَاءُ الْحَسَنُ، لا إلَهَ إِلا اللَّهُ مُخْلِصِينَ لَهُ الدِّينَ وَلَوْ كَرِهَ الْكَافِرُونَ", "count": 1},
          {"text": "سُبْحَانَ اللَّهِ", "count": 33},
          {"text": "الْحَمْدُ لِلَّهِ", "count": 33},
          {"text": "اللَّهُ أَكْبَرُ", "count": 33},
          {"text": "لا إلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ (تمام المائة)", "count": 1},
          {"text": "أَعُوذُ بِاللهِ مِنْ الشَّيْطَانِ الرَّجِيمِ\n{اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ...} (آية الكرسي)", "count": 1},
          {"text": "سورة الإخلاص، وسورة الفلق، وسورة الناس (3 مرات بعد الفجر والمغرب، ومرة بعد باقي الصلوات)", "count": 1},
        ];
      case "أذكار النوم":
        return [
          {"text": "يَجْمَعُ كَفَّيْهِ ثُمَّ يَنْفُثُ فِيهِمَا وَيَقْرَأُ فِيهِمَا: سورة الإخلاص، والفلق، والناس، ثُمَّ يَمْسَحُ بِهِمَا مَا اسْتَطَاعَ مِنْ جَسَدِهِ (3 مرات)", "count": 3},
          {"text": "أَعُوذُ بِاللهِ مِنْ الشَّيْطَانِ الرَّجِيمِ\n{اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ...} (آية الكرسي)", "count": 1},
          {"text": "بِاسْمِكَ رَبِّـي وَضَعْـتُ جَنْـبي، وَبِكَ أَرْفَعُـه، فَإِن أَمْسَـكْتَ نَفْسِـي فارْحَـمْهَا، وَإِنْ أَرْسَلْتَـهَا فاحْفَظْـهَا بِمَا تَحْفَـظُ بِه عِبَـادَكَ الصَّـالِحِـينَ", "count": 1},
          {"text": "اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي وَأَنْتَ تَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا. اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ", "count": 1},
          {"text": "اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ", "count": 3},
          {"text": "بِاسْـمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا", "count": 1},
          {"text": "سُبْحَانَ اللَّهِ (33)، الْحَمْدُ لِلَّهِ (33)، اللَّهُ أَكْبَرُ (34)", "count": 1},
        ];
      case "أذكار الاستيقاظ":
        return [
          {"text": "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ", "count": 1},
          {"text": "لا إلَهَ إِلا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ. سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلا إلَهَ إِلا اللَّهُ، وَاللَّهُ أَكْبَرُ، وَلا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ، رَبِّ اغْفِرْ لِي", "count": 1},
          {"text": "الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِي جَسَدِي، وَرَدَّ عَلَيَّ رُوحِي، وَأَذِنَ لِي بِذِكْرِهِ", "count": 1},
        ];
      default: return [];
    }
  }
}

// =============================================================================
// 4. شاشة البداية (Splash Screen)
// =============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainLayout()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)]),
              child: const Icon(Icons.fingerprint, size: 80, color: kPrimaryBlue),
            ),
            const SizedBox(height: 20),
            const Text("المسبحة الرقمية", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 5. صفحة معلومات التطبيق
// =============================================================================
class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  void _openWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("جاري الانتقال إلى واتساب: 772002517"), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("معلومات التطبيق", style: TextStyle(color: Colors.white)), backgroundColor: kPrimaryBlue, centerTitle: true, iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: Column(
        children: [
          Container(height: 100, width: double.infinity, decoration: const BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)))),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)]), child: const Icon(Icons.fingerprint, size: 80, color: kPrimaryBlue)),
                  const SizedBox(height: 20),
                  Text("المسبحة الرقمية", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : kPrimaryBlue)),
                  const Text("الإصدار 1.0.0", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                    child: Column(
                      children: [
                        const Text("تطوير وبرمجة", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 10),
                        Text("خميس  نمران وسالم بايعشوت", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 5),
                        const Text("Flutter Developer", style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity, height: 55,
                          child: ElevatedButton(
                            onPressed: () => _openWhatsApp(context),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.phone, color: Colors.white), SizedBox(width: 10), Text("تواصل عبر واتساب", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text("775602742", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.grey[800])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 6. صفحة "الورد اليومي" (الإضافة الجديدة - Dashboard)
// =============================================================================
class DailyWirdPage extends StatelessWidget {
  const DailyWirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double totalProgress = ProgressManager.getTotalProgress();

    return Scaffold(
      appBar: AppBar(title: const Text("الورد اليومي", style: TextStyle(color: Colors.white)), backgroundColor: kPrimaryBlue, centerTitle: true, iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: Column(
        children: [
          Container(
            height: 200, width: double.infinity,
            decoration: const BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: 100, height: 100, child: CircularProgressIndicator(value: totalProgress, strokeWidth: 8, backgroundColor: Colors.white24, color: Colors.greenAccent)),
                    Text("${(totalProgress * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                const Text("إنجازك اليوم", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildProgressTile(context, "أذكار الصباح", Icons.wb_sunny_outlined),
                _buildProgressTile(context, "أذكار المساء", Icons.nights_stay_outlined),
                _buildProgressTile(context, "أذكار بعد الصلاة", Icons.mosque_outlined),
                _buildProgressTile(context, "أذكار النوم", Icons.bed_outlined),
                _buildProgressTile(context, "أذكار الاستيقاظ", Icons.alarm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTile(BuildContext context, String category, IconData icon) {
    double progress = ProgressManager.categoryProgress[category] ?? 0.0;
    bool isDone = progress >= 1.0;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isDone ? Colors.green.withOpacity(0.1) : Theme.of(context).canvasColor, shape: BoxShape.circle), child: Icon(icon, color: isDone ? Colors.green : kPrimaryBlue)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: isDone ? Colors.green : kPrimaryBlue, minHeight: 6),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Text(isDone ? "مكتمل" : "${(progress * 100).toInt()}%", style: TextStyle(color: isDone ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 7. التطبيق الرئيسي (Main App)
// =============================================================================
class TasbeehApp extends StatelessWidget {
  const TasbeehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'المسبحة الرقمية',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light, fontFamily: 'Cairo', scaffoldBackgroundColor: kBgLight, primaryColor: kPrimaryBlue, cardColor: kCardLight, canvasColor: kAccentLight, useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark, fontFamily: 'Cairo', scaffoldBackgroundColor: kBgDark, primaryColor: kPrimaryBlue, cardColor: kCardDark, canvasColor: kAccentDark, useMaterial3: true, iconTheme: const IconThemeData(color: Colors.white),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

// =============================================================================
// 8. الهيكل الرئيسي
// =============================================================================
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const HomeScreen(), const AzkarSelectionPage(), const TasbeehCounterPage(), const SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: IndexedStack(index: _selectedIndex, children: _pages)),
          Positioned(
            bottom: 20, left: 20, right: 20,
            child: Container(
              height: 65,
              decoration: BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.circular(35), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.settings, 3, Colors.white54, Colors.white),
                  _buildMainNavItem("السبحة", 2),
                  _buildNavItem(Icons.menu_book, 1, Colors.white54, Colors.white),
                  _buildNavItem(Icons.home_filled, 0, Colors.white54, Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color color, Color selectedColor) {
    bool isSelected = _selectedIndex == index;
    return IconButton(onPressed: () => setState(() => _selectedIndex = index), icon: Icon(icon, color: isSelected ? selectedColor : color, size: 26));
  }

  Widget _buildMainNavItem(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold)), const SizedBox(width: 5), Icon(Icons.fingerprint, color: isSelected ? Colors.white : Colors.white70)]),
      ),
    );
  }
}

// =============================================================================
// 9. الصفحة الرئيسية
// =============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // تحديث الصفحة عند العودة إليها لضمان تحديث عداد الورد اليومي
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // حساب الإنجاز الكلي للعرض في الهيدر
    double totalProgress = ProgressManager.getTotalProgress();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          _buildHeader(
            context,
            title: "حياك الله ... 👋",
            subtitle: "لا يزال لسانك رطباً بذكر الله",
            verse: "{ فَاذْكُرُونِي أَذْكُرْكُمْ }",
            bottomWidget: GestureDetector(
              // هنا ننتقل لصفحة الورد اليومي
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyWirdPage()));
                refresh(); // تحديث الصفحة عند العودة لرؤية التغييرات
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("وردك اليومي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("اضغط للتفاصيل", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
                      ],
                    ),
                    Row(children: [Text("${(totalProgress * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(width: 10), Icon(totalProgress >= 1.0 ? Icons.check_circle : Icons.pie_chart, color: Colors.greenAccent)]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("الأقسام الرئيسية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : kPrimaryBlue)), const SizedBox(width: 10), Icon(Icons.grid_view_rounded, color: kPrimaryBlue)]),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(children: [Expanded(child: _buildCard(context, "أذكار المساء", "حصنك الحصين", Icons.nights_stay_outlined)), const SizedBox(width: 15), Expanded(child: _buildCard(context, "أذكار الصباح", "بداية يومك", Icons.wb_sunny_outlined))]),
                const SizedBox(height: 15),
                Row(children: [Expanded(child: _buildCard(context, "أذكار النوم", "باسمك ربي", Icons.bed_outlined)), const SizedBox(width: 15), Expanded(child: _buildCard(context, "أذكار بعد الصلاة", "ختام الصلاة", Icons.mosque_outlined))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, IconData icon) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AzkarDetailPage(category: title)));
        refresh(); // تحديث الصفحة عند العودة
      },
      child: Container(
        height: 130, padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Theme.of(context).canvasColor, shape: BoxShape.circle), child: Icon(icon, color: isDark ? Colors.white : kPrimaryBlue, size: 24)),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)), Text(subtitle, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey, fontSize: 11))]),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 10. صفحة السبحة (Counter)
// =============================================================================
class TasbeehCounterPage extends StatefulWidget {
  const TasbeehCounterPage({super.key});
  @override
  State<TasbeehCounterPage> createState() => _TasbeehCounterPageState();
}

class _TasbeehCounterPageState extends State<TasbeehCounterPage> {
  int _count = 0;
  int _target = 33;
  String _selectedDhikr = "سبحان الله";
  final List<String> _dhikrOptions = ["سبحان الله", "الحمد لله", "الله أكبر", "أستغفر الله", "لا حول ولا قوة إلا بالله", "سبحان الله وبحمده", "اللهم صل على محمد"];

  void _increment() {
    setState(() => _count++);
    HapticFeedback.mediumImpact();
    if (_count == _target) HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        _buildHeader(context, title: "السبحة الإلكترونية", subtitle: "إختر الذكر وابدأ", verse: "", height: 160),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: isDark ? Colors.white24 : kPrimaryBlue.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDhikr, isExpanded: true, icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white : kPrimaryBlue), dropdownColor: Theme.of(context).cardColor,
                    style: TextStyle(color: isDark ? Colors.white : kPrimaryBlue, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    items: _dhikrOptions.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, textAlign: TextAlign.right))).toList(),
                    onChanged: (newValue) => setState(() { _selectedDhikr = newValue!; _count = 0; }),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _increment,
                child: Container(
                  width: 240, height: 240,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: (isDark ? Colors.white : kPrimaryBlue).withOpacity(0.1), blurRadius: 30, spreadRadius: 5)], border: Border.all(color: (isDark ? Colors.white : kPrimaryBlue).withOpacity(0.1), width: 8)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("$_count", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: isDark ? Colors.white : kPrimaryBlue)), Text("/ $_target", style: const TextStyle(color: Colors.grey, fontSize: 18))]),
                ),
              ),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [_controlButton(context, Icons.refresh, "تصفير", () => setState(() => _count = 0)), const SizedBox(width: 40), _controlButton(context, Icons.ads_click, "الهدف $_target", () => setState(() { if (_target == 33) _target = 100; else if (_target == 100) _target = 1000; else _target = 33; }))]),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _controlButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Theme.of(context).canvasColor, shape: BoxShape.circle), child: Icon(icon, color: isDark ? Colors.white : kPrimaryBlue)), const SizedBox(height: 5), Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black))]),
    );
  }
}

// =============================================================================
// 11. صفحة قائمة الأذكار
// =============================================================================
class AzkarSelectionPage extends StatelessWidget {
  const AzkarSelectionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, title: "حصن المسلم", subtitle: "جميع الأذكار اليومية", verse: "", height: 180),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _azkarListTile(context, "أذكار الصباح", Icons.wb_sunny),
              _azkarListTile(context, "أذكار المساء", Icons.nights_stay),
              _azkarListTile(context, "أذكار بعد الصلاة", Icons.mosque),
              _azkarListTile(context, "أذكار الاستيقاظ", Icons.alarm),
              _azkarListTile(context, "أذكار النوم", Icons.bed),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _azkarListTile(BuildContext context, String title, IconData icon) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AzkarDetailPage(category: title))),
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Theme.of(context).canvasColor, shape: BoxShape.circle), child: Icon(icon, color: isDark ? Colors.white : kPrimaryBlue)),
        title: Text(title, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}

// =============================================================================
// 12. صفحة تفاصيل الأذكار (تحديث التقدم)
// =============================================================================
class AzkarDetailPage extends StatefulWidget {
  final String category;
  const AzkarDetailPage({super.key, required this.category});
  @override
  State<AzkarDetailPage> createState() => _AzkarDetailPageState();
}

class _AzkarDetailPageState extends State<AzkarDetailPage> {
  late List<Map<String, dynamic>> azkarList;
  int finishedCount = 0;

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> rawData = AthkarData.getAthkar(widget.category);
    azkarList = rawData.map((e) => {"text": e['text'], "count": e['count'], "current": 0}).toList();
  }

  void updateGlobalProgress() {
    finishedCount = azkarList.where((item) => item['current'] >= item['count']).length;
    ProgressManager.updateProgress(widget.category, finishedCount, azkarList.length);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color headerColor = isDark ? kCardDark : kPrimaryBlue;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category, style: const TextStyle(color: Colors.white)), backgroundColor: kPrimaryBlue, centerTitle: true, iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: Stack(
        children: [
          Container(height: 50, decoration: const BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)))),
          azkarList.isEmpty ? Center(child: Text("لا توجد أذكار مضافة حالياً", style: TextStyle(color: isDark ? Colors.white : Colors.black))) : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: azkarList.length,
            itemBuilder: (ctx, index) {
              final item = azkarList[index];
              final bool isDone = item['current'] >= item['count'];
              return GestureDetector(
                onTap: () {
                  if (!isDone) {
                    setState(() {
                      item['current']++;
                      updateGlobalProgress(); // تحديث التقدم عند كل ضغطة
                    });
                    HapticFeedback.lightImpact();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: isDone ? (isDark ? Colors.green.shade900 : Colors.green.shade50) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), border: isDone ? Border.all(color: Colors.green) : null, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                  child: Column(children: [
                    Text(item['text'], textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.bold, color: isDone ? Colors.grey : (isDark ? Colors.white : kPrimaryBlue))),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), decoration: BoxDecoration(color: isDone ? Colors.green : kPrimaryBlue, borderRadius: BorderRadius.circular(20)), child: Text(isDone ? "تم" : "${item['current']} / ${item['count']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 13. صفحة الإعدادات
// =============================================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _vibration = true;
  bool _sound = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;
    return Column(
      children: [
        _buildHeader(context, title: "الإعدادات", subtitle: "تخصيص التطبيق", verse: "", height: 160),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSettingsTile(context, "الإهتزاز عند التسبيح", Icons.vibration, _vibration, (val) => setState(() => _vibration = val)),
              _buildSettingsTile(context, "أصوات الأزرار", Icons.volume_up, _sound, (val) => setState(() => _sound = val)),
              _buildSettingsTile(context, "الوضع الليلي", Icons.dark_mode, isDarkMode, (val) => themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light),
              _buildSettingsTile(context, "تنبيهات الأذكار", Icons.notifications_active, _notifications, (val) => setState(() => _notifications = val)),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, bool isSwitched, ValueChanged<bool> onChanged) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Switch(value: isSwitched, activeColor: Colors.white, activeTrackColor: kPrimaryBlue, onChanged: onChanged),
        Row(children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)), const SizedBox(width: 15), Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Theme.of(context).canvasColor, shape: BoxShape.circle), child: Icon(icon, color: isDark ? Colors.white : kPrimaryBlue, size: 20))]),
      ]),
    );
  }
}

// =============================================================================
// Helper: الهيدر الموحد
// =============================================================================
Widget _buildHeader(BuildContext context, {required String title, required String subtitle, required String verse, Widget? bottomWidget, double height = 280}) {
  return Container(
    height: height, width: double.infinity,
    decoration: const BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
    padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppInfoPage())), icon: const Icon(Icons.info_outline, color: Colors.white)), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12))])]),
        if (verse.isNotEmpty) ...[const Spacer(), Text(verse, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const Spacer()],
        if (bottomWidget != null) ...[const Spacer(), bottomWidget, const SizedBox(height: 20)]
      ],
    ),
  );
}