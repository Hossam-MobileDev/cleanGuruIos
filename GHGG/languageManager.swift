//
//  languageManager.swift
//  GHGG
//
//  Created by test on 16/06/2025.
//

import SwiftUI
import Photos



class LanguageManager: ObservableObject {
    @Published var currentLanguage: String

//    @Published var currentLanguage: String = "English" {
//        didSet {
//            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
//            NotificationCenter.default.post(name: .languageChanged, object: nil)
//        }
//    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
                    currentLanguage = savedLanguage
                } else {
                    let detectedLanguage = LanguageManager.detectDeviceLanguage() // ✅ call as static
                    currentLanguage = detectedLanguage
                    UserDefaults.standard.set(detectedLanguage, forKey: "selectedLanguage")
                }
//        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
//            currentLanguage = savedLanguage
//        } else {
//            currentLanguage = detectDeviceLanguage()
//            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
//        }
    }
    static func detectDeviceLanguage() -> String {
        let preferredLanguages = Locale.preferredLanguages
        
        // Check primary language only
        guard let primaryLanguage = preferredLanguages.first else {
            return "English"
        }
        
        let languageCode = String(primaryLanguage.prefix(2))
        
        switch languageCode {
        case "ar":
            return "العربية"
        case "en":
            return "English"
        default:
            return "English" // Default fallback
        }
    }
//    static func detectDeviceLanguage() -> String {
//        let preferredLanguages = Locale.preferredLanguages
//        
//        for languageCode in preferredLanguages {
//            let locale = Locale(identifier: languageCode)
//            
//            if languageCode.hasPrefix("ar") {
//                return "العربية"
//            }
//            
//            if let languageDisplayName = locale.localizedString(forLanguageCode: languageCode) {
//                if languageDisplayName.contains("العربية") || languageDisplayName.contains("Arabic") {
//                    return "العربية"
//                }
//            }
//        }
//        
//        let currentRegion = Locale.current.region?.identifier
//        let arabicRegions = ["SA", "AE", "EG", "JO", "LB", "SY", "IQ", "KW", "BH", "QA", "OM", "YE", "MA", "TN", "DZ", "LY", "SD", "PS"]
//        
//        if let region = currentRegion, arabicRegions.contains(region) {
//            return "العربية"
//        }
//        
//        return "English"
//    }
    
    func setLanguage(_ language: String) {
        currentLanguage = language
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    var isArabic: Bool {
        return currentLanguage == "العربية"
    }
    
    func resetToDeviceLanguage() {
        let detectedLanguage = LanguageManager.detectDeviceLanguage()
        setLanguage(detectedLanguage)
    }
    
    func getDeviceLanguageInfo() -> String {
        let preferredLanguages = Locale.preferredLanguages
        let currentRegion = Locale.current.regionCode ?? "Unknown"
        let currentLanguageCode = Locale.current.languageCode ?? "Unknown"
        
        return """
        Preferred Languages: \(preferredLanguages.joined(separator: ", "))
        Current Region: \(currentRegion)
        Current Language Code: \(currentLanguageCode)
        Detected Language: \(LanguageManager.detectDeviceLanguage())
        """
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

// MARK: - Localized Strings
struct LocalizedStrings {
    static func string(for key: String, language: String) -> String {
        if language == "العربية" {
            return arabicStrings[key] ?? englishStrings[key] ?? key
        } else {
            return englishStrings[key] ?? key
        }
    }
    
    // MARK: - English Strings Dictionary (Complete)
    private static let englishStrings: [String: String] = [
        // Tab bar items
        "dashboard": "Dashboard",
        "storage": "Storage",
        "settings": "Settings",
        "compress": "Compress",

        "Photos": "Photos",
            "Videos": "Videos",
            "Audio": "Audio",
        "muslim_qibla": "Muslim Qibla",
            "muslim_qibla_desc": "Accurate Qibla Direction",
            
            "speedtest": "Speedtest",
            "speedtest_desc": "Internet Speed Test",
            
            "product_finder": "Product Finder",
            "product_finder_desc": "Price Comparison",
            
            "kitaba": "Kitaba",
            "kitaba_desc": "Design Photos & Arabic Fonts",
            
       
        "try_again": "Try Again",
        
            "currency_converter": "Currency Converter",
            "currency_converter_desc": "Global Currency Exchange",
        //"clean_guru": "Clean GURU",     // English

            "zakhrafa": "Zakhrafa",
            "zakhrafa_desc": "Arabic Text Decoration",
        "select_image_to_preview": "Select an image to preview",
        "compressed": "Compressed",
        "original": "Original",
        
            "steps": "Steps",
            "steps_desc": "Daily Step Counter",
        
        "aboserwal":"Aboserwal",
        "aboserwal_desc":"I’m Abussrwal and Ffinelh",
        "hegry":"Hegry",
        "hegry_desc": "Your essential Islamic calendar app",
        
        "kaf":"Kaaf Nastaliq",
        "kaf_desc":"write in the beautiful Nastaliq font",
        "maany":"Names",
        "maany_desc":"Meanings of names",

        "moderelhesabat":"Account Manager",
        "moderelhesabat_desc":"To manage passwords and accounts",
        
        "rasm":"Draw on pictures",
        "rasm_desc":"To draw and write on photos",
        
        "rawateb":"Salary Time | Saudi Salaries",
       "rawateb_desc" : "With the help of the Saudi citizen employee",
        
        "tahwel":"Convert images to PDF 4+",
        "tahwel_desc":"Allow you to convert image into PDF ",
        
        " weather":"Weather - forecast ",
        "weather_desc":"Check the weather forecast",
        
        "budget":"Wallet budget",
        "budget_desc":"Your Ultimate Budget Tracke",
    
        // Settings View
        "main_settings": "Settings",
        "in_app": "In app",
        "language": "Language",
        "help_us_improve": "Help Us Improve",
        "rate_our_app": "Rate Our App",
        "have a problem? contact us": "Have a problem? contact us",
        "having_issues": "Having Issues?",
        "not_enjoying_app": "Not Enjoying the App?",
        "share_app_with_friends": "Share App with Friends",
        "check_our_apps": "Check Our Apps",
        "terms_of_use": "Terms of Use",
        "privacy_policy": "Privacy Policy",
        
        // Storage Analytics
        "storage_analytics": "Storage Analytics",
        "total_storage": "Total Storage",
        "available_space": "Available Space",
        "used_space": "Used Space",
        "used_storage": "Used Storage",
        "free_storage": "Free Storage",
        "total_ram": "Total RAM",
        "cpu_information": "CPU Information",
        "core_count": "Core Count",
        "cores": "cores",
        "architecture": "Architecture",
        "battery_information": "Battery Information",
        "battery_percentage": "Battery Percentage",
        "charging_state": "Charging State",
        "charging": "Charging",
        "fully_charged": "Fully Charged",
        "not_charging": "Not Charging",
        "unknown": "Unknown",
        "device_info": "Device Info",
        "model": "Model",
        "os_version": "OS Version",
        "upgrade": "Upgrade",
        "upgrade_to_premium": "Upgrade to Premium",
        "close": "Close",
        
        // Storage Optimization
        "storage_optimization": "Storage Optimization",
        "storage_analysis": "Storage Analysis",
        "duplicates": "Duplicates",
        "media_compression": "Media Compression",
        "clean_media": "Clean Media",
        "contacts_cleanup": "Contacts Cleanup",
        "calendar_cleaner": "Calendar Cleaner",
        "find_duplicate_photos": "Find Duplicate Photos",
        "start_scanning": "Start Scanning",
        "analyzing_photos": "Analyzing photos for duplicates...",
        "of": "of",
        "photos_analyzed": "photos analyzed",
        "no_duplicates_found": "No Duplicates Found",
        "scan_again": "Scan Again",
        "delete_duplicates": "Delete Duplicates",
        "delete": "Delete",
        "save": "Save",
        "photos": "Photos",
        "videos": "Videos",
        "audio": "Audio",
       
        "photo_access_required": "Photo Access Required",
        "please_allow_access_analyze": "Please allow access to analyze your photos for duplicates.",
        "grant_access": "Grant Access",
        "scan_photo_library_description": "Scan your photo library to find and remove duplicate images to free up storage space.",
        "great_no_duplicates": "Great! Your photo library doesn't have any duplicate images.",
        "duplicate_groups_found": "duplicate groups found",
        "potential_savings": "Potential savings",
        "loading_media": "Loading media...",
        "allow_access_photos_settings": "Please allow access to your photos in Settings.",
        "open_settings": "Open Settings",
        "no_media_found": "No media found",
        "best": "BEST",
        "duration": "Duration",
        "taken": "Taken",
        "photo": "Photo",
        "selected": "selected",
        "deselect_all": "Deselect All",
        "loading": "Loading",
        
        // Contacts
        "backup_contacts": "Backup Contacts",
        "restore_contacts": "Restore Contacts",
        "contacts_access_required": "Contacts Access Required",
        "duplicates_contacts_selected": "Duplicates Contacts selected",
        "merge_contacts": "Merge Contacts",
        "delete_contacts": "Delete Contacts",
        "backup_successful": "Backup Successful",
        "restore_successful": "Restore Successful",
        "error": "Error",
        "unknown_contact": "Unknown Contact",
        "merge_successful": "Contacts merged successfully",
        "delete_successful": "Contacts deleted successfully",
        "backup_created": "Backup created successfully",
        "restore_completed": "Contacts restored successfully",
        "no_backup_found": "No backup found",
        "contacts_permission_denied": "Contacts permission denied",
        
        // Calendar
        "old_events_selected": "Old events selected",
        "remove_events": "Remove Events",
        "permission_required": "Permission Required",
        "loading_events": "Loading events...",
        "untitled_event": "Untitled Event",
        
        // Media Compression
        "quality": "Quality",
        "Compressed":"Compressed",
        "Original":"Original",
        "low": "Low",
        "medium": "Medium",
        "high": "High",
        "original_size": "Original Size",
        "after_compression": "After Compression",
        "compress_all_media": "Compress All Media",
        "compressing": "Compressing...",
        "select_media": "Select Media",
        "compression_coming_soon": "Media compression feature coming soon",
        "contacts_coming_soon": "Contacts cleanup feature coming soon",
        "calendar_coming_soon": "Calendar cleaner feature coming soon",
        
        // Storage Units
        "bytes": "bytes",
        "kilobytes": "KB",
        "megabytes": "MB",
        "gigabytes": "GB",
        
        // Common
        "cancel": "Cancel",
        "ok": "OK",
        //"done": "Done",
        "get": "Get",
        "yes": "Yes",
        "no": "No",
        
        "Backup Contacts": "Backup Contacts",
        
        "Restore Contacts": "Restore Contacts",

        "Duplicates Contacts selected": "Duplicates Contacts selected",
        "Merge Contacts": "Merge Contacts",
        "Delete Contacts": "Delete Contacts",
        "Deselect All": "Deselect All",
        "Remove Events Count": "Remove %@ Events",
        "delete_selected_photos" : "Delete selected photos",
        "delete_selected_videos" :"Delete selected videos",
        "delete_selected_audio" :"Delete selected audio files",
        "skip": "Skip",
        "back": "Back",
        "next": "Next",
        "get_started": "Get Started",
        "clean_guru": "Clean GURU",
        "onboarding_welcome_title": "Welcome to Clean GURU",
        "onboarding_welcome_subtitle": "Boost your device's performance effortlessly. Manage storage, memory, and system health all in one place.",
        "onboarding_tools_title": "All-in-One Optimization Tools",
        "done": "Done",
        "onboarding_tools_subtitle": "Identify & clean up duplicate or large files. Enhance speed by freeing up RAM. Monitor & optimize your device's performance.",
        "onboarding_control_title": "Your Device, Your Control",
        "onboarding_control_subtitle": "Take control of your device's health today. Optimize in one tap for a faster, cleaner experience!",
        "image_compressed_successfully": "Image Compressed Successfully!",


    ]
    
    // MARK: - Arabic Strings Dictionary (Complete)
    private static let arabicStrings: [String: String] = [
        // Tab bar items
        "dashboard": "الرئيسية",
        "Remove Events Count": "حذف %@ من الأحداث",
       
       
        "image_compressed_successfully": "تم ضغط الصورة بنجاح",
        "size": "الحجم",
        "try_again": "حاول مرة أخرى",
        "storage": "التخزين",
        "settings": "الإعدادات",
        "Restore Contacts": "استعادة جهات الاتصال",
        "Merge Contacts": "دمج جهات الاتصال",
        "Delete Contacts": "حذف جهات الاتصال",
        "Deselect All": "إلغاء تحديد الكل",

        "Backup Contacts": "نسخ جهات الاتصال احتياطيًا",
        "Duplicates Contacts selected": "جهات اتصال مكررة محددة",

        "compress": "ضغط",
       // "clean_guru": "كلين جورو",      // Arabic

        "have a problem? contact us": "هل تواجه مشكلة؟ تواصل معنا",



        "Photos": "الصور",
           "Videos": "الفيديوهات",
           "Audio": "الصوتيات",
        
        // Settings View
        "main_settings": "الإعدادات الرئيسية",
        "in_app": "في التطبيق",
        "language": "اللغة",
        "help_us_improve": "ساعدنا في التحسين",
        "rate_our_app": "قيم تطبيقنا",
        "share_your_feedback": "شارك رأيك",
        "having_issues": "تواجه مشاكل؟",
        "not_enjoying_app": "لا تستمتع بالتطبيق؟",
        "share_app_with_friends": "شارك التطبيق مع الأصدقاء",
        "check_our_apps": "تحقق من تطبيقاتنا",
        "terms_of_use": "شروط الاستخدام",
        "privacy_policy": "سياسة الخصوصية",
        "select_image_to_preview": "اختر صورة للمعاينة",
        "compressed": "مضغوط",
        "original": "أصلي",
        // Storage Analytics
        "storage_analytics": "تحليل التخزين",


        "total_storage": "إجمالي التخزين",
        "available_space": "المساحة المتاحة",
        "used_space": "المساحة المستخدمة",
        "used_storage": "التخزين المستخدم",
        "free_storage": "المساحة الحرة",
        "total_ram": "إجمالي الذاكرة",
        "cpu_information": "معلومات المعالج",
        "core_count": "عدد الأنوية",
        "cores": "أنوية",
        "architecture": "المعمارية",
        "battery_information": "معلومات البطارية",
        "battery_percentage": "نسبة البطارية",
        "charging_state": "حالة الشحن",
        "charging": "يشحن",
        "fully_charged": "مشحون بالكامل",
        "not_charging": "لا يشحن",
        "unknown": "غير معروف",
        "device_info": "معلومات الجهاز",
        "model": "الطراز",
        "os_version": "إصدار النظام",
        "upgrade": "ترقية",
        "upgrade_to_premium": "ترقية إلى النسخة المميزة",
        "close": "إغلاق",
        
        // Storage Optimization
        "storage_optimization": "تحسين التخزين",
        "storage_analysis": "تحليل التخزين",
        "duplicates": "المكررات",
        "media_compression": "ضغط الوسائط",
        "clean_media": "تنظيف الوسائط",
        "contacts_cleanup": "تنظيف جهات الاتصال",
        "calendar_cleaner": "منظف التقويم",
        "find_duplicate_photos": "البحث عن الصور المكررة",
        "start_scanning": "بدء المسح",
        "analyzing_photos": "جاري تحليل الصور للبحث عن المكررات...",
        "of": "من",
        "photos_analyzed": "صورة تم تحليلها",
        "no_duplicates_found": "لم يتم العثور على مكررات",
        "scan_again": "مسح مرة أخرى",
        "delete_duplicates": "حذف المكررات",
        "delete": "حذف",
        "save": "حفظ",
        "photos": "الصور",
        "videos": "الفيديوهات",
        "audio": "الصوت",
        "delete_selected_photos": "حذف الصور المحددة",
        "photo_access_required": "مطلوب الوصول للصور",
        "please_allow_access_analyze": "يرجى السماح بالوصول لتحليل صورك للبحث عن المكررات.",
        "grant_access": "منح الوصول",
        "scan_photo_library_description": "امسح مكتبة الصور الخاصة بك للعثور على الصور المكررة وإزالتها لتحرير مساحة التخزين.",
        "great_no_duplicates": "رائع! مكتبة الصور الخاصة بك لا تحتوي على أي صور مكررة.",
        "duplicate_groups_found": "مجموعة مكررة تم العثور عليها",
        "potential_savings": "التوفير المحتمل",
        "loading_media": "جاري تحميل الوسائط...",
        "allow_access_photos_settings": "يرجى السماح بالوصول لصورك في الإعدادات.",
        "open_settings": "فتح الإعدادات",
        "no_media_found": "لم يتم العثور على وسائط",
        "best": "الأفضل",
        "duration": "المدة",
        "taken": "تم التقاط",
        "photo": "صورة",
        "selected": "محدد",
        "deselect_all": "إلغاء تحديد الكل",
        "loading": "جاري التحميل",
        
        // Contacts
        "backup_contacts": "نسخ احتياطي لجهات الاتصال",
        "restore_contacts": "استعادة جهات الاتصال",
        "contacts_access_required": "مطلوب الوصول لجهات الاتصال",
        "duplicates_contacts_selected": "جهات الاتصال المكررة المحددة",
        "merge_contacts": "دمج جهات الاتصال",
        "delete_contacts": "حذف جهات الاتصال",
        "backup_successful": "نجح النسخ الاحتياطي",
        "restore_successful": "نجحت الاستعادة",
        "error": "خطأ",
        "unknown_contact": "جهة اتصال غير معروفة",
        "merge_successful": "تم دمج جهات الاتصال بنجاح",
        "delete_successful": "تم حذف جهات الاتصال بنجاح",
        "backup_created": "تم إنشاء النسخة الاحتياطية بنجاح",
        "restore_completed": "تم استعادة جهات الاتصال بنجاح",
        "no_backup_found": "لم يتم العثور على نسخة احتياطية",
        "contacts_permission_denied": "تم رفض إذن جهات الاتصال",
        
        // Calendar
        "old_events_selected": "الأحداث القديمة المحددة",
        "remove_events": "إزالة الأحداث",
        "permission_required": "مطلوب إذن",
        "loading_events": "جاري تحميل الأحداث...",
        "untitled_event": "حدث بدون عنوان",
        
        // Media Compression
        "quality": "الجودة",
        "Low": "منخفضة",
        "Medium": "متوسطة",
        "High": "عالية",
        "original_size": "الحجم الأصلي",
        "after_compression": "بعد الضغط",
        "compress_all_media": "ضغط جميع الوسائط",
        "compressing": "جاري الضغط...",
        "select_media": "اختر الوسائط",
        "compression_coming_soon": "ميزة ضغط الوسائط قادمة قريباً",
        "contacts_coming_soon": "ميزة تنظيف جهات الاتصال قادمة قريباً",
        "calendar_coming_soon": "ميزة منظف التقويم قادمة قريباً",
        
        // Storage Units
        "bytes": "بايت",
        "kilobytes": "كيلوبايت",
        "megabytes": "ميجابايت",
        "gigabytes": "جيجابايت",
        
        // Common
        "cancel": "إلغاء",
        "ok": "موافق",
        "done": "تم",
        "get": "تحميل",
        "yes": "نعم",
        "no": "لا",
        
        "Original":"اصلي",
        "Compressed":"مضغوط",
        
        "muslim_qibla": "القبلة الإسلامية",
            "muslim_qibla_desc": "اتجاه القبلة بدقة",
            
            "speedtest": "اختبار سرعة الإنترنت",
            "speedtest_desc": "قياس سرعة الاتصال",
            
            "product_finder": "البحث عن المنتجات",
            "product_finder_desc": "مقارنة الأسعار",
            
            "kitaba": "كتابة",
            "kitaba_desc": "تصميم صور وخطوط عربية",
            
            "currency_converter": "محوّل العملات",
            "currency_converter_desc": "أسعار الصرف العالمية",
            
            "zakhrafa": "زخرفة",
            "zakhrafa_desc": "زخرفة النصوص العربية",
            
            "steps": "خطواتي",
            "steps_desc": "عداد الخطوات اليومي",
        
        "aboserwal": "أبوسروال",
          "aboserwal_desc": "أنا أبوسروال وفينيله",
          "hegry": "هجري",
          "hegry_desc": "تطبيق التقويم الإسلامي الأساسي",
          
          "kaf": "كاف نستعليق",
          "kaf_desc": "اكتب بخط نستعليق الجميل",
          "maany": "أسماء",
          "maany_desc": "معاني الأسماء",
          
          "moderelhesabat": "مدير الحسابات",
          "moderelhesabat_desc": "لإدارة كلمات المرور والحسابات",
          
          "rasm": "الرسم على الصور",
          "rasm_desc": "للرسم والكتابة على الصور",
          
          "rawateb": "مواعيد الرواتب | رواتب السعودية",
          "rawateb_desc": "بمساعدة الموظف المواطن السعودي",
          
          "tahwel": "تحويل الصور إلى PDF 4+",
          "tahwel_desc": "يسمح لك بتحويل الصور إلى PDF",
          
          "weather": "الطقس - التوقعات",
          "weather_desc": "تحقق من توقعات الطقس",
          
          "budget": "ميزانية المحفظة",
          "budget_desc": "أداة تتبع الميزانية المثالية",
        "skip": "تخطي",
        "back": "رجوع",
        "next": "التالي",
        "get_started": "ابدأ الآن",
        "clean_guru": "كلين جورو",
        "onboarding_welcome_title": "مرحباً بك في كلين جورو",
        "onboarding_welcome_subtitle": "عزز أداء جهازك بسهولة. إدارة التخزين والذاكرة وصحة النظام في مكان واحد.",
        "onboarding_tools_title": "أدوات التحسين الشاملة",
        "onboarding_tools_subtitle": "تحديد وتنظيف الملفات المكررة أو الكبيرة. تحسين السرعة بتحرير الذاكرة. مراقبة وتحسين أداء جهازك.",
        "onboarding_control_title": "جهازك، تحكمك",
        "onboarding_control_subtitle": "تحكم في صحة جهازك اليوم. تحسين بنقرة واحدة للحصول على تجربة أسرع وأنظف!"

    ]
}

// MARK: - Localized Text View
struct LocalizedText: View {
    let key: String
    @EnvironmentObject var languageManager: LanguageManager
    
    init(_ key: String) {
        self.key = key
    }
    
    var body: some View {
        Text(LocalizedStrings.string(for: key, language: languageManager.currentLanguage))
    }
}

// MARK: - String Extensions for Singular Forms
extension String {
    func singularForm(language: String) -> String {
        if language == "العربية" {
            // Arabic singular forms
            if self == LocalizedStrings.string(for: "photos", language: language) {
                return "صورة"
            } else if self == LocalizedStrings.string(for: "videos", language: language) {
                return "فيديو"
            } else if self == LocalizedStrings.string(for: "audio", language: language) {
                return "ملف صوتي"
            }
        } else {
            // English singular forms
            if self == LocalizedStrings.string(for: "photos", language: language) {
                return "photo"
            } else if self == LocalizedStrings.string(for: "videos", language: language) {
                return "video"
            } else if self == LocalizedStrings.string(for: "audio", language: language) {
                return "audio file"
            }
        }
        return self
    }
}
