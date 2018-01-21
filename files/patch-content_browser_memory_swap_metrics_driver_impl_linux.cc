--- content/browser/memory/swap_metrics_driver_impl_linux.cc.orig	2018-01-04 21:05:50.000000000 +0100
+++ content/browser/memory/swap_metrics_driver_impl_linux.cc	2018-01-21 02:27:03.864066000 +0100
@@ -16,14 +16,17 @@
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
 
+#if !defined(OS_BSD)
 // static
 std::unique_ptr<SwapMetricsDriver> SwapMetricsDriver::Create(
     std::unique_ptr<Delegate> delegate,
@@ -62,5 +65,6 @@
 
   return SwapMetricsDriver::SwapMetricsUpdateResult::kSwapMetricsUpdateSuccess;
 }
+#endif
 
 }  // namespace content
