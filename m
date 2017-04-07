Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1154020D77DB3
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 16:19:39 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 4/6] util: add util/bitmap in preparation for the BTT
 checker
Date: Fri,  7 Apr 2017 17:18:01 -0600
Message-Id: <20170407231803.14936-5-vishal.l.verma@intel.com>
In-Reply-To: <20170407231803.14936-1-vishal.l.verma@intel.com>
References: <20170407231803.14936-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The BTT checker will include a bitmap test where we mark a bit for
each post-map and free block, and check if the bitmap is full. Add
util/bitmap based on the kernels bitmap code to facilitate this.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am   |   3 +-
 util/bitmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/bitmap.h |  32 ++++++++++++++++
 util/util.h   |  11 ++++++
 4 files changed, 160 insertions(+), 1 deletion(-)
 create mode 100644 util/bitmap.c
 create mode 100644 util/bitmap.h

diff --git a/Makefile.am b/Makefile.am
index 5453b2a..2b46736 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -69,6 +69,7 @@ libutil_a_SOURCES = \
 	util/strbuf.c \
 	util/wrapper.c \
 	util/filter.c \
-	util/fletcher.c
+	util/fletcher.c\
+	util/bitmap.c
 
 nobase_include_HEADERS = daxctl/libdaxctl.h
diff --git a/util/bitmap.c b/util/bitmap.c
new file mode 100644
index 0000000..31e8c3a
--- /dev/null
+++ b/util/bitmap.c
@@ -0,0 +1,115 @@
+#include <stdlib.h>
+#include <util/size.h>
+#include <util/util.h>
+#include <util/bitmap.h>
+#include <ccan/endian/endian.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/short_types/short_types.h>
+
+unsigned long *bitmap_alloc(unsigned long nbits)
+{
+	return calloc(BITS_TO_LONGS(nbits), sizeof(unsigned long));
+}
+
+void bitmap_set(unsigned long *map, unsigned int start, int len)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const unsigned int size = start + len;
+	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
+
+	while (len - bits_to_set >= 0) {
+		*p |= mask_to_set;
+		len -= bits_to_set;
+		bits_to_set = BITS_PER_LONG;
+		mask_to_set = ~0UL;
+		p++;
+	}
+	if (len) {
+		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
+		*p |= mask_to_set;
+	}
+}
+
+void bitmap_clear(unsigned long *map, unsigned int start, int len)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const unsigned int size = start + len;
+	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
+
+	while (len - bits_to_clear >= 0) {
+		*p &= ~mask_to_clear;
+		len -= bits_to_clear;
+		bits_to_clear = BITS_PER_LONG;
+		mask_to_clear = ~0UL;
+		p++;
+	}
+	if (len) {
+		mask_to_clear &= BITMAP_LAST_WORD_MASK(size);
+		*p &= ~mask_to_clear;
+	}
+}
+
+/**
+ * test_bit - Determine whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+int test_bit(unsigned int nr, const volatile unsigned long *addr)
+{
+	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+}
+
+/*
+ * This is a common helper function for find_next_bit and
+ * find_next_zero_bit.  The difference is the "invert" argument, which
+ * is XORed with each fetched word before searching it for one bits.
+ */
+static unsigned long _find_next_bit(const unsigned long *addr,
+		unsigned long nbits, unsigned long start, unsigned long invert)
+{
+	unsigned long tmp;
+
+	if (!nbits || start >= nbits)
+		return nbits;
+
+	tmp = addr[start / BITS_PER_LONG] ^ invert;
+
+	/* Handle 1st word. */
+	tmp &= BITMAP_FIRST_WORD_MASK(start);
+	start = round_down(start, BITS_PER_LONG);
+
+	while (!tmp) {
+		start += BITS_PER_LONG;
+		if (start >= nbits)
+			return nbits;
+
+		tmp = addr[start / BITS_PER_LONG] ^ invert;
+	}
+
+	return min(start + __builtin_ffsl(tmp), nbits);
+}
+
+/*
+ * Find the next set bit in a memory region.
+ */
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	return _find_next_bit(addr, size, offset, 0UL);
+}
+
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset)
+{
+	return _find_next_bit(addr, size, offset, ~0UL);
+}
+
+int bitmap_full(const unsigned long *src, unsigned int nbits)
+{
+	if (small_const_nbits(nbits))
+		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
+
+	return find_next_zero_bit(src, nbits, 0UL) == nbits;
+}
diff --git a/util/bitmap.h b/util/bitmap.h
new file mode 100644
index 0000000..826ae28
--- /dev/null
+++ b/util/bitmap.h
@@ -0,0 +1,32 @@
+#ifndef _NDCTL_BITMAP_H_
+#define _NDCTL_BITMAP_H_
+
+#include <util/size.h>
+#include <ccan/short_types/short_types.h>
+
+#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+#define BIT(nr)			(1UL << (nr))
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
+#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
+
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
+
+unsigned long *bitmap_alloc(unsigned long nbits);
+void bitmap_set(unsigned long *map, unsigned int start, int len);
+void bitmap_clear(unsigned long *map, unsigned int start, int len);
+int test_bit(unsigned int nr, const volatile unsigned long *addr);
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset);
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset);
+int bitmap_full(const unsigned long *src, unsigned int nbits);
+
+
+#endif /* _NDCTL_BITMAP_H_ */
diff --git a/util/util.h b/util/util.h
index e0e5f26..620eb1c 100644
--- a/util/util.h
+++ b/util/util.h
@@ -23,6 +23,17 @@
 
 #define alloc_nr(x) (((x)+16)*3/2)
 
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
+#define rounddown(x, y) (				\
+{							\
+	typeof(x) __x = (x);				\
+	__x - (__x % (y));				\
+}							\
+)
+
 /*
  * Realloc the buffer pointed at by variable 'x' so that it can hold
  * at least 'nr' entries; the number of entries currently allocated
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
