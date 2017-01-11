Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96E9781BC0
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jan 2017 15:20:02 -0800 (PST)
Subject: [PATCH v7] x86: fix kaslr and memmap collision
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Jan 2017 16:20:01 -0700
Message-ID: <148417664156.131935.2248592164852799738.stgit@djiang5-desk3.ch.intel.com>
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
Cc: keescook@chromium.org, bhe@redhat.com, linux-nvdimm@lists.01.org, x86@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
However it does not take into account the memmap= parameter passed in from
the kernel cmdline. This results in the kernel sometimes being put in
the middle of memmap. Teaching kaslr to not insert the kernel in
memmap defined regions. We will support up to 4 memmap regions. Any
additional regions will cause kaslr to disable. The mem_avoid set has
been augmented to add up to 4 unusable regions of memmaps provided by the
user to exclude those regions from the set of valid address range to insert
the uncompressed kernel image. The nn@ss ranges will be skipped by the
mem_avoid set since it indicates memory useable.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/boot.h             |    1 
 arch/x86/boot/compressed/kaslr.c |  140 +++++++++++++++++++++++++++++++++++++-
 arch/x86/boot/string.c           |   13 ++++
 3 files changed, 151 insertions(+), 3 deletions(-)

v2:
Addressed comments from Ingo.
- Handle entire list of memmaps
v3:
Fix 32bit build issue
v4:
Addressed comments from Baoquan
- Not exclude nn@ss ranges
v5:
Addressed additional comments from Baoquan
- Update commit header and various coding style changes
v6:
Addressed comments from Kees
- Only fail for physical address randomization
v7:
Addressed comments from Thomas
- Dropped unused functions
- Made address and size in memmap_avoid unsigned long long
- Style fixes

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index e5612f3..9b42b6d 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -333,6 +333,7 @@ size_t strnlen(const char *s, size_t maxlen);
 unsigned int atou(const char *s);
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
 size_t strlen(const char *s);
+char *strchr(const char *s, int c);
 
 /* tty.c */
 void puts(const char *);
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index a66854d..8b7c9e7 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -11,6 +11,7 @@
  */
 #include "misc.h"
 #include "error.h"
+#include "../boot.h"
 
 #include <generated/compile.h>
 #include <linux/module.h>
@@ -52,15 +53,22 @@ static unsigned long get_boot_seed(void)
 #include "../../lib/kaslr.c"
 
 struct mem_vector {
-	unsigned long start;
-	unsigned long size;
+	unsigned long long start;
+	unsigned long long size;
 };
 
+/* Only supporting at most 4 unusable memmap regions with kaslr */
+#define MAX_MEMMAP_REGIONS	4
+
+static bool memmap_too_large;
+
 enum mem_avoid_index {
 	MEM_AVOID_ZO_RANGE = 0,
 	MEM_AVOID_INITRD,
 	MEM_AVOID_CMDLINE,
 	MEM_AVOID_BOOTPARAMS,
+	MEM_AVOID_MEMMAP_BEGIN,
+	MEM_AVOID_MEMMAP_END = MEM_AVOID_MEMMAP_BEGIN + MAX_MEMMAP_REGIONS - 1,
 	MEM_AVOID_MAX,
 };
 
@@ -77,6 +85,123 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 	return true;
 }
 
+/**
+ *	_memparse - Parse a string with mem suffixes into a number
+ *	@ptr: Where parse begins
+ *	@retptr: (output) Optional pointer to next char after parse completes
+ *
+ *	Parses a string into a number.  The number stored at @ptr is
+ *	potentially suffixed with K, M, G, T, P, E.
+ */
+static unsigned long long _memparse(const char *ptr, char **retptr)
+{
+	char *endptr;	/* Local pointer to end of parsed string */
+
+	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
+
+	switch (*endptr) {
+	case 'E':
+	case 'e':
+		ret <<= 10;
+	case 'P':
+	case 'p':
+		ret <<= 10;
+	case 'T':
+	case 't':
+		ret <<= 10;
+	case 'G':
+	case 'g':
+		ret <<= 10;
+	case 'M':
+	case 'm':
+		ret <<= 10;
+	case 'K':
+	case 'k':
+		ret <<= 10;
+		endptr++;
+	default:
+		break;
+	}
+
+	if (retptr)
+		*retptr = endptr;
+
+	return ret;
+}
+
+static int
+parse_memmap(char *p, unsigned long long *start, unsigned long long *size)
+{
+	char *oldp;
+
+	if (!p)
+		return -EINVAL;
+
+	/* We don't care about this option here */
+	if (!strncmp(p, "exactmap", 8))
+		return -EINVAL;
+
+	oldp = p;
+	*size = _memparse(p, &p);
+	if (p == oldp)
+		return -EINVAL;
+
+	switch (*p) {
+	case '@':
+		/* Skip this region, usable */
+		*start = 0;
+		*size = 0;
+		return 0;
+	case '#':
+	case '$':
+	case '!':
+		*start = _memparse(p + 1, &p);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void mem_avoid_memmap(void)
+{
+	char arg[128];
+	int rc;
+	int i;
+	char *str;
+
+	/* See if we have any memmap areas */
+	rc = cmdline_find_option("memmap", arg, sizeof(arg));
+	if (rc <= 0)
+		return;
+
+	i = 0;
+	str = arg;
+	while (str && (i < MAX_MEMMAP_REGIONS)) {
+		int rc;
+		unsigned long long start, size;
+		char *k = strchr(str, ',');
+
+		if (k)
+			*k++ = 0;
+
+		rc = parse_memmap(str, &start, &size);
+		if (rc < 0)
+			break;
+		str = k;
+		/* A usable region that should not be skipped */
+		if (size == 0)
+			continue;
+
+		mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].start = start;
+		mem_avoid[MEM_AVOID_MEMMAP_BEGIN + i].size = size;
+		i++;
+	}
+
+	/* More than 4 memmaps, fail kaslr */
+	if ((i >= MAX_MEMMAP_REGIONS) && str)
+		memmap_too_large = true;
+}
+
 /*
  * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
  * The mem_avoid array is used to store the ranges that need to be avoided
@@ -197,6 +322,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 
 	/* We don't need to set a mapping for setup_data. */
 
+	/* Mark the memmap regions we need to avoid */
+	mem_avoid_memmap();
+
 #ifdef CONFIG_X86_VERBOSE_BOOTUP
 	/* Make sure video RAM can be used. */
 	add_identity_map(0, PMD_SIZE);
@@ -379,6 +507,12 @@ static unsigned long find_random_phys_addr(unsigned long minimum,
 	int i;
 	unsigned long addr;
 
+	/* Check if we had too many memmaps. */
+	if (memmap_too_large) {
+		debug_putstr("Aborted e820 scan (more than 4 memmap= args)!\n");
+		return 0;
+	}
+
 	/* Make sure minimum is aligned. */
 	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
 
@@ -456,7 +590,7 @@ void choose_random_location(unsigned long input,
 	/* Walk e820 and find a random address. */
 	random_addr = find_random_phys_addr(min_addr, output_size);
 	if (!random_addr) {
-		warn("KASLR disabled: could not find suitable E820 region!");
+		warn("Physical KASLR disabled: no suitable memory region!");
 	} else {
 		/* Update the new physical address location. */
 		if (*output != random_addr) {
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index cc3bd58..93d9b99 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -155,3 +155,16 @@ char *strstr(const char *s1, const char *s2)
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
