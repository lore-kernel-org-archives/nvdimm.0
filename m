Return-Path: <owner-linux-mm@kvack.org>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/2] vsprintf: Remove support for %pF and %pf in favour of %pS and %ps
Date: Fri, 22 Mar 2019 15:21:08 +0200
Message-Id: <20190322132108.25501-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, ceph-devel@vger.kernel.org, netdev@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

%pS and %ps are now the preferred conversion specifiers to print function
%names. The functionality is equivalent; remove the old, deprecated %pF
%and %pf support.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/core-api/printk-formats.rst | 10 ----------
 lib/vsprintf.c                            |  8 ++------
 scripts/checkpatch.pl                     |  5 -----
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index c37ec7cd9c06..c90826a1ff17 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -78,8 +78,6 @@ Symbols/Function Pointers
 
 	%pS	versatile_init+0x0/0x110
 	%ps	versatile_init
-	%pF	versatile_init+0x0/0x110
-	%pf	versatile_init
 	%pSR	versatile_init+0x9/0x110
 		(with __builtin_extract_return_addr() translation)
 	%pB	prev_fn_of_versatile_init+0x88/0x88
@@ -89,14 +87,6 @@ The ``S`` and ``s`` specifiers are used for printing a pointer in symbolic
 format. They result in the symbol name with (S) or without (s)
 offsets. If KALLSYMS are disabled then the symbol address is printed instead.
 
-Note, that the ``F`` and ``f`` specifiers are identical to ``S`` (``s``)
-and thus deprecated. We have ``F`` and ``f`` because on ia64, ppc64 and
-parisc64 function pointers are indirect and, in fact, are function
-descriptors, which require additional dereferencing before we can lookup
-the symbol. As of now, ``S`` and ``s`` perform dereferencing on those
-platforms (when needed), so ``F`` and ``f`` exist for compatibility
-reasons only.
-
 The ``B`` specifier results in the symbol name with offsets and should be
 used when printing stack backtraces. The specifier takes into
 consideration the effect of compiler optimisations which may occur
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 791b6fa36905..5f60b8d41277 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -797,7 +797,7 @@ char *symbol_string(char *buf, char *end, void *ptr,
 #ifdef CONFIG_KALLSYMS
 	if (*fmt == 'B')
 		sprint_backtrace(sym, value);
-	else if (*fmt != 'f' && *fmt != 's')
+	else if (*fmt != 's')
 		sprint_symbol(sym, value);
 	else
 		sprint_symbol_no_offset(sym, value);
@@ -1853,9 +1853,7 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
  *
  * - 'S' For symbolic direct pointers (or function descriptors) with offset
  * - 's' For symbolic direct pointers (or function descriptors) without offset
- * - 'F' Same as 'S'
- * - 'f' Same as 's'
- * - '[FfSs]R' as above with __builtin_extract_return_addr() translation
+ * - '[Ss]R' as above with __builtin_extract_return_addr() translation
  * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
@@ -1970,8 +1968,6 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 
 	switch (*fmt) {
-	case 'F':
-	case 'f':
 	case 'S':
 	case 's':
 		ptr = dereference_symbol_descriptor(ptr);
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5b756278df13..b4e456b48fd7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5993,11 +5993,6 @@ sub process {
 					my $stat_real = get_stat_real($linenr, $lc);
 					my $ext_type = "Invalid";
 					my $use = "";
-					if ($bad_specifier =~ /p[Ff]/) {
-						$ext_type = "Deprecated";
-						$use = " - use %pS instead";
-						$use =~ s/pS/ps/ if ($bad_specifier =~ /pf/);
-					}
 
 					WARN("VSPRINTF_POINTER_EXTENSION",
 					     "$ext_type vsprintf pointer extension '$bad_specifier'$use\n" . "$here\n$stat_real\n");
-- 
2.11.0
