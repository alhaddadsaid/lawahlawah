# Release shrinker (R8) rules for Reelway.

# Google's ads SDK uses WorkManager, whose Room database is created by
# reflection. Without these rules R8 strips the generated constructor and the
# app closes on start: "Failed to create an instance of
# androidx.work.impl.WorkDatabase" (seen on the Android 14 emulator check).
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class androidx.work.** { *; }
-keep class androidx.room.** { *; }
