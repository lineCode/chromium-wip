--- content/browser/memory/swap_metrics_driver_impl_linux.cc.orig	2017-12-24 12:51:59.156521000 +0100
+++ content/browser/memory/swap_metrics_driver_impl_linux.cc	2017-12-24 12:52:25.787197000 +0100
@@ -16,10 +16,12 @@
 namespace {
 
 bool HasSwap() {
+#if !defined(OS_BSD)
   base::SystemMemoryInfoKB memory_info;
   if (!base::GetSystemMemoryInfo(&memory_info))
     return false;
   return memory_info.swap_total > 0;
+#endif
 }
 
 }  // namespace
