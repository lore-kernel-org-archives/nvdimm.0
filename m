Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D3C681E1B
 for <linux-nvdimm@lists.01.org>; Mon, 21 Nov 2016 16:22:19 -0800 (PST)
Subject: [PATCH] x86: fix kaslr and memmap collision
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 21 Nov 2016 17:22:18 -0700
Message-ID: <147977413859.13657.2181994710415174471.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
However it does not take into account the memmap= parameter passed in from
the kernel commandline. This results in the kernel sometimes being put in
the middle of the user memmap. Check has been added in the kaslr in order
to avoid the region marked by memmap.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/boot/boot.h             |    2 ++
 arch/x86/boot/compressed/kaslr.c |   45 ++++++++++++++++++++++++++++++++++++++
 arch/x86/boot/string.c           |   25 +++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index e5612f3..0d5fe5b 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -332,6 +332,8 @@ int strncmp(const char *cs, const char *ct, size_t count);
 size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
+long simple_strtol(const char *cp, char **endp, unsigned int base);
 size_t strlen(const char *s);
 
 /* tty.c */
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index a66854d..6fb8f1ec 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -11,6 +11,7 @@
  */
 #include "misc.h"
 #include "error.h"
+#include "../boot.h"
 
 #include <generated/compile.h>
 #include <linux/module.h>
@@ -61,6 +62,7 @@ enum mem_avoid_index {
 	MEM_AVOID_INITRD,
 	MEM_AVOID_CMDLINE,
 	MEM_AVOID_BOOTPARAMS,
+	MEM_AVOID_MEMMAP,
 	MEM_AVOID_MAX,
 };
 
@@ -77,6 +79,37 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 	return true;
 }
 
+#include "../../../../lib/cmdline.c"
+
+static int
+parse_memmap(char *p, unsigned long long *start, unsigned long long *size)
+{
+	char *oldp;
+
+	if (!p)
+		return -EINVAL;
+
+	/* we don't care about this option here */
+	if (!strncmp(p, "exactmap", 8))
+		return -EINVAL;
+
+	oldp = p;
+	*size = memparse(p, &p);
+	if (p == oldp)
+		return -EINVAL;
+
+	switch (*p) {
+	case '@':
+	case '#':
+	case '$':
+	case '!':
+		*start = memparse(p+1, &p);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 /*
  * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
  * The mem_avoid array is used to store the ranges that need to be avoided
@@ -158,6 +191,8 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
 	char *ptr;
+	char arg[38];
+	unsigned long long memmap_start, memmap_size;
 
 	/*
 	 * Avoid the region that is unsafe to overlap during
@@ -195,6 +230,16 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	add_identity_map(mem_avoid[MEM_AVOID_BOOTPARAMS].start,
 			 mem_avoid[MEM_AVOID_BOOTPARAMS].size);
 
+	/* see if we have any memmap areas */
+	if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
+		int rc = parse_memmap(arg, &memmap_start, &memmap_size);
+
+		if (!rc) {
+			mem_avoid[MEM_AVOID_MEMMAP].start = memmap_start;
+			mem_avoid[MEM_AVOID_MEMMAP].size = memmap_size;
+		}
+	}
+
 	/* We don't need to set a mapping for setup_data. */
 
 #ifdef CONFIG_X86_VERBOSE_BOOTUP
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index cc3bd58..7a376c1 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -122,6 +122,31 @@ unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int bas
 }
 
 /**
+ * simple_strtoul - convert a string to an unsigned long
+ * @cp: The start of the string
+ * @endp: A pointer to the end of the parsed string will be placed here
+ * @base: The number base to use
+ */
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
+{
+	return simple_strtoull(cp, endp, base);
+}
+
+/**
+ * simple_strtol - convert a string to a signed long
+ * @cp: The start of the string
+ * @endp: A pointer to the end of the parsed string will be placed here
+ * @base: The number base to use
+ */
+long simple_strtol(const char *cp, char **endp, unsigned int base)
+{
+	if (*cp == '-')
+		return -simple_strtoul(cp + 1, endp, base);
+
+	return simple_strtoul(cp, endp, base);
+}
+
+/**
  * strlen - Find the length of a string
  * @s: The string to be sized
  */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
