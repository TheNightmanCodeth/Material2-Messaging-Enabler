#!/system/bin/sh

am force-stop com.google.android.apps.messaging

if [ $1 = 'enable' ]; then
  # Force-stop messaging
  am force-stop com.google.android.apps.messaging
  # Modify the `bugle_phenotype__enable_m2` property in the PhenotypePrefs file using sed.
  sed -i '/<boolean name="bugle_phenotype__enable_m2" value="false" \/\>/c\    <boolean name="bugle_phenotype__enable_m2" value="true" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml
  # Modify the `bugle_phenotype__enable_phenotype_override` property, still using sed.
  sed -i '/<boolean name="bugle_phenotype__enable_phenotype_override" value="false" \/\>/c\    <boolean name="bugle_phenotype__enable_phenotype_override" value="true" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml
elif [ $1 = 'disable' ]; then
  # Force-stop messaging
  am force-stop com.google.android.apps.messaging
  # Modify the `bugle_phenotype__enable_m2` property in the PhenotypePrefs file using sed.
  sed -i '/<boolean name="bugle_phenotype__enable_m2" value="true" \/\>/c\    <boolean name="bugle_phenotype__enable_m2" value="false" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml
  # Modify the `bugle_phenotype__enable_phenotype_override` property, still using sed.
  sed -i '/<boolean name="bugle_phenotype__enable_phenotype_override" value="true" \/\>/c\    <boolean name="bugle_phenotype__enable_phenotype_override" value="false" \/\>' /data/data/com.google.android.apps.messaging/shared_prefs/PhenotypePrefs.xml
fi

am force-stop com.google.android.apps.messaging