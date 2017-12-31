--- dbus/property.cc.orig	2017-11-26 15:27:03.964616000 +0100
+++ dbus/property.cc	2017-11-26 15:28:33.496446000 +0100
@@ -564,6 +564,7 @@
   writer->CloseContainer(&variant_writer);
 }
 
+#if !defined(OS_BSD)
 //
 // Property<std::map<std::string, std::string>> specialization.
 //
@@ -788,6 +789,7 @@
   variant_writer.CloseContainer(&dict_writer);
   writer->CloseContainer(&variant_writer);
 }
+#endif
 
 template class Property<uint8_t>;
 template class Property<bool>;
@@ -803,8 +805,10 @@
 template class Property<std::vector<std::string> >;
 template class Property<std::vector<ObjectPath> >;
 template class Property<std::vector<uint8_t>>;
+#if !defined(OS_BSD)
 template class Property<std::map<std::string, std::string>>;
 template class Property<std::vector<std::pair<std::vector<uint8_t>, uint16_t>>>;
+#endif
 template class Property<std::unordered_map<std::string, std::vector<uint8_t>>>;
 template class Property<std::unordered_map<uint16_t, std::vector<uint8_t>>>;
 
