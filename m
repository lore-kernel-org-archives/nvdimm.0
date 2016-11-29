Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B85AE81EC9
 for <linux-nvdimm@lists.01.org>; Tue, 29 Nov 2016 11:26:41 -0800 (PST)
Subject: [PATCH v2] x86: fix kaslr and memmap collision
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 29 Nov 2016 12:26:40 -0700
Message-ID: <148044760044.153060.616417783293212181.stgit@djiang5-desk3.ch.intel.com>
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
the kernel cmdline. This results in the kernel sometimes being put in
the middle of the user memmap. Teaching kaslr to not insert the kernel in
memmap defined regions. We will support up to 4 memmap regions. Any
additional regions will cause kaslr to disable. The mem_avoid set has
been augmented to add up to 4 regions of memmaps provided by the user
to exclude those regions from the set of valid address range to insert
the uncompressed kernel image.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/boot/boot.h             |    3 +
 arch/x86/boot/compressed/kaslr.c |   82 ++++++++++++++++++++++++++++++++++++++
 arch/x86/boot/string.c           |   38 ++++++++++++++++++
 3 files changed, 123 insertions(+)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index e5612f3..59c2075 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -332,7 +332,10 @@ int strncmp(const char *cs, const char *ct, size_t count);
 size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
+long simple_strtol(const char *cp, char **endp, unsigned int base);
 size_t strlen(const char *s);
+char *strchr(const char *s, int c);
 
 /* tty.c */
 void puts(const char *);
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index a66854d..915509f 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -11,6 +11,7 @@
  */
 #include "misc.h"
 #include "error.h"
+#include "../boot.h"
 
 #include <generated/compile.h>
 #include <linux/module.h>
@@ -61,9 +62,16 @@ enum mem_avoid_index {
 	MEM_AVOID_INITRD,
 	MEM_AVOID_CMDLINE,
 	MEM_AVOID_BOOTPARAMS,
+	MEM_AVOID_MEMMAP1,
+	MEM_AVOID_MEMMAP2,
+	MEM_AVOID_MEMMAP3,
+	MEM_AVOID_MEMMAP4,
 	MEM_AVOID_MAX,
 };
 
+/* only supporting at most 4 memmap regions with kaslr */
+#define MAX_MEMMAP_REGIONS	4
+
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
 static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
@@ -77,6 +85,72 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
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
+		*start = memparse(p + 1, &p);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int mem_avoid_memmap(void)
+{
+	char arg[128];
+	int rc = 0;
+
+	/* see if we have any memmap areas */
+	if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
+		int i = 0;
+		char *str = arg;
+
+		while (str && (i < MAX_MEMMAP_REGIONS)) {
+			unsigned long long start, size;
+			char *k = strchr(str, ',');
+
+			if (k)
+				*k++ = 0;
+
+			rc = parse_memmap(str, &start, &size);
+			if (rc < 0)
+				break;
+			str = k;
+
+			mem_avoid[MEM_AVOID_MEMMAP1 + i].start = start;
+			mem_avoid[MEM_AVOID_MEMMAP1 + i].size = size;
+			i++;
+		}
+
+		/* more than 4 memmaps, fail kaslr */
+		if ((i >= MAX_MEMMAP_REGIONS) && str)
+			rc = -EINVAL;
+	}
+
+	return rc;
+}
+
 /*
  * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
  * The mem_avoid array is used to store the ranges that need to be avoided
@@ -429,6 +503,7 @@ void choose_random_location(unsigned long input,
 			    unsigned long *virt_addr)
 {
 	unsigned long random_addr, min_addr;
+	int rc;
 
 	/* By default, keep output position unchanged. */
 	*virt_addr = *output;
@@ -438,6 +513,13 @@ void choose_random_location(unsigned long input,
 		return;
 	}
 
+	/* Mark the memmap regions we need to avoid */
+	rc = mem_avoid_memmap();
+	if (rc < 0) {
+		warn("KASLR disabled: memmap exceeds limit of 4, giving up.");
+		return;
+	}
+
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
 	/* Prepare to add new identity pagetables on demand. */
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index cc3bd58..0464aaa 100644
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
@@ -155,3 +180,16 @@ char *strstr(const char *s1, const char *s2)
 	}
 	return NULL;
 }
+
+/**
+ * strchr - Find the first occurrence of the character c in the string s.
+ * @s: the string to be searched
+ * @c: the character to search for
+ */
+char *strchr(const char *s, int c)
+{
+	while (*s != (char)c)
+		if (*s++ == '\0')
+			return NULL;
+	return (char *)s;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
