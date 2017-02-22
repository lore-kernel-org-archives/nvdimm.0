Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D79082244
 for <linux-nvdimm@lists.01.org>; Wed, 22 Feb 2017 14:48:43 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 2/3] ndctl: add a BTT check utility
Date: Wed, 22 Feb 2017 15:47:23 -0700
Message-Id: <20170222224724.7696-3-vishal.l.verma@intel.com>
In-Reply-To: <20170222224724.7696-1-vishal.l.verma@intel.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
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

Add the check-namespace command to ndctl. This will check the BTT
metadata layout for the given namespace, and if requested, correct any
errors found. Not all metadata corruption is detectable or fixable.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/Makefile.am               |   1 +
 Documentation/ndctl-check-namespace.txt |  64 +++
 Documentation/ndctl.txt                 |   1 +
 Makefile.am                             |   4 +-
 builtin.h                               |   1 +
 ccan/bitmap/LICENSE                     |   1 +
 ccan/bitmap/bitmap.c                    | 125 +++++
 ccan/bitmap/bitmap.h                    | 243 +++++++++
 contrib/ndctl                           |   3 +
 licenses/LGPL-2.1                       | 508 +++++++++++++++++
 ndctl.spec.in                           |   5 +-
 ndctl/Makefile.am                       |   1 +
 ndctl/builtin-check.c                   | 938 ++++++++++++++++++++++++++++++++
 ndctl/builtin-xaction-namespace.c       |  66 ++-
 ndctl/check.h                           | 123 +++++
 ndctl/ndctl.c                           |   1 +
 util/usage.c                            |  15 +
 util/util.h                             |   9 +
 18 files changed, 2105 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ndctl-check-namespace.txt
 create mode 120000 ccan/bitmap/LICENSE
 create mode 100644 ccan/bitmap/bitmap.c
 create mode 100644 ccan/bitmap/bitmap.h
 create mode 100644 licenses/LGPL-2.1
 create mode 100644 ndctl/builtin-check.c
 create mode 100644 ndctl/check.h

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 6daeb56..eea11e0 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -12,6 +12,7 @@ man1_MANS = \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
+	ndctl-check-namespace.1 \
 	ndctl-list.1 \
 	daxctl-list.1
 
diff --git a/Documentation/ndctl-check-namespace.txt b/Documentation/ndctl-check-namespace.txt
new file mode 100644
index 0000000..88f6086
--- /dev/null
+++ b/Documentation/ndctl-check-namespace.txt
@@ -0,0 +1,64 @@
+ndctl-check-namespace(1)
+=========================
+
+NAME
+----
+ndctl-check-namespace - check namespace metadata consistency
+
+SYNOPSIS
+--------
+[verse]
+'ndctl check-namespace' [<options>]
+
+DESCRIPTION
+-----------
+
+A namespace in the 'sector' mode will have metadata on it to describe
+the kernel BTT (Block Translation Table). The check-namespace command
+can be used to check the consistency of this metadata, and optionally,
+also attempt to repair it, if it has enough information to do so.
+
+The namespace being checked has to be disabled before initiating a
+check on it as a precautionary measure. The --force option can override
+this.
+
+EXAMPLES
+--------
+
+Check a namespace (only report errors)
+[verse]
+ndctl disable-namespace namespace0.0
+ndctl check-namespace namespace0.0
+
+Check a namespace, and perform repairs if possible
+[verse]
+ndctl disable-namespace namespace0.0
+ndctl check-namespace --repair namespace0.0
+
+OPTIONS
+-------
+-R::
+--repair::
+	Perform metadata repairs if possible. Without this option,
+	the raw namespace contents will not be touched.
+
+-f::
+--force::
+	Unless this option is specified, a check-namespace operation
+	will fail if the namespace is presently active. Specifying
+	--force causes the namespace to be disabled before checking.
+
+-v::
+--verbose::
+	Emit debug messages for the namespace check process.
+
+-r::
+--region=::
+include::xable-region-options.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-disable-namespace[1],
+linkndctl:ndctl-enable-namespace[1],
+http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
+Specification]
diff --git a/Documentation/ndctl.txt b/Documentation/ndctl.txt
index 883a59c..c26cc2f 100644
--- a/Documentation/ndctl.txt
+++ b/Documentation/ndctl.txt
@@ -34,6 +34,7 @@ SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1],
 linkndctl:ndctl-destroy-namespace[1],
+linkndctl:ndctl-check-namespace[1],
 linkndctl:ndctl-enable-region[1],
 linkndctl:ndctl-disable-region[1],
 linkndctl:ndctl-enable-dimm[1],
diff --git a/Makefile.am b/Makefile.am
index 5453b2a..26c7309 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -56,7 +56,9 @@ libccan_a_SOURCES = \
 	ccan/array_size/array_size.h \
 	ccan/minmax/minmax.h \
 	ccan/short_types/short_types.h \
-	ccan/endian/endian.h
+	ccan/endian/endian.h \
+	ccan/bitmap/bitmap.h \
+	ccan/bitmap/bitmap.c
 
 noinst_LIBRARIES += libutil.a
 libutil_a_SOURCES = \
diff --git a/builtin.h b/builtin.h
index 9b66196..200bd8e 100644
--- a/builtin.h
+++ b/builtin.h
@@ -13,6 +13,7 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx);
 int cmd_create_namespace(int argc, const char **argv, void *ctx);
 int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
 int cmd_disable_namespace(int argc, const char **argv, void *ctx);
+int cmd_check_namespace(int argc, const char **argv, void *ctx);
 int cmd_enable_region(int argc, const char **argv, void *ctx);
 int cmd_disable_region(int argc, const char **argv, void *ctx);
 int cmd_enable_dimm(int argc, const char **argv, void *ctx);
diff --git a/ccan/bitmap/LICENSE b/ccan/bitmap/LICENSE
new file mode 120000
index 0000000..dc314ec
--- /dev/null
+++ b/ccan/bitmap/LICENSE
@@ -0,0 +1 @@
+../../licenses/LGPL-2.1
\ No newline at end of file
diff --git a/ccan/bitmap/bitmap.c b/ccan/bitmap/bitmap.c
new file mode 100644
index 0000000..554e000
--- /dev/null
+++ b/ccan/bitmap/bitmap.c
@@ -0,0 +1,125 @@
+/* Licensed under LGPLv2.1+ - see LICENSE file for details */
+
+#include "config.h"
+
+#include <ccan/bitmap/bitmap.h>
+
+#include <assert.h>
+
+#define BIT_ALIGN_DOWN(n)	((n) & ~(BITMAP_WORD_BITS - 1))
+#define BIT_ALIGN_UP(n)		BIT_ALIGN_DOWN((n) + BITMAP_WORD_BITS - 1)
+
+void bitmap_zero_range(bitmap_t *bitmap, unsigned long n, unsigned long m)
+{
+	unsigned long an = BIT_ALIGN_UP(n);
+	unsigned long am = BIT_ALIGN_DOWN(m);
+	bitmap_word headmask = -1ULL >> (n % BITMAP_WORD_BITS);
+	bitmap_word tailmask = ~(-1ULL >> (m % BITMAP_WORD_BITS));
+
+	assert(m >= n);
+
+	if (am < an) {
+		BITMAP_WORD(bitmap, n) &= ~bitmap_bswap(headmask & tailmask);
+		return;
+	}
+
+	if (an > n)
+		BITMAP_WORD(bitmap, n) &= ~bitmap_bswap(headmask);
+
+	if (am > an)
+		memset(&BITMAP_WORD(bitmap, an), 0,
+		       (am - an) / BITMAP_WORD_BITS * sizeof(bitmap_word));
+
+	if (m > am)
+		BITMAP_WORD(bitmap, m) &= ~bitmap_bswap(tailmask);
+}
+
+void bitmap_fill_range(bitmap_t *bitmap, unsigned long n, unsigned long m)
+{
+	unsigned long an = BIT_ALIGN_UP(n);
+	unsigned long am = BIT_ALIGN_DOWN(m);
+	bitmap_word headmask = -1ULL >> (n % BITMAP_WORD_BITS);
+	bitmap_word tailmask = ~(-1ULL >> (m % BITMAP_WORD_BITS));
+
+	assert(m >= n);
+
+	if (am < an) {
+		BITMAP_WORD(bitmap, n) |= bitmap_bswap(headmask & tailmask);
+		return;
+	}
+
+	if (an > n)
+		BITMAP_WORD(bitmap, n) |= bitmap_bswap(headmask);
+
+	if (am > an)
+		memset(&BITMAP_WORD(bitmap, an), 0xff,
+		       (am - an) / BITMAP_WORD_BITS * sizeof(bitmap_word));
+
+	if (m > am)
+		BITMAP_WORD(bitmap, m) |= bitmap_bswap(tailmask);
+}
+
+static int bitmap_clz(bitmap_word w)
+{
+#if HAVE_BUILTIN_CLZL
+	return __builtin_clzl(w);
+#else
+	int lz = 0;
+	bitmap_word mask = 1UL << (BITMAP_WORD_BITS - 1);
+
+	while (!(w & mask)) {
+		lz++;
+		mask >>= 1;
+	}
+
+	return lz;
+#endif
+}
+
+unsigned long bitmap_ffs(const bitmap_t *bitmap,
+			 unsigned long n, unsigned long m)
+{
+	unsigned long an = BIT_ALIGN_UP(n);
+	unsigned long am = BIT_ALIGN_DOWN(m);
+	bitmap_word headmask = -1ULL >> (n % BITMAP_WORD_BITS);
+	bitmap_word tailmask = ~(-1ULL >> (m % BITMAP_WORD_BITS));
+
+	assert(m >= n);
+
+	if (am < an) {
+		bitmap_word w = bitmap_bswap(BITMAP_WORD(bitmap, n));
+
+		w &= (headmask & tailmask);
+
+		return w ? am + bitmap_clz(w) : m;
+	}
+
+	if (an > n) {
+		bitmap_word w = bitmap_bswap(BITMAP_WORD(bitmap, n));
+
+		w &= headmask;
+
+		if (w)
+			return BIT_ALIGN_DOWN(n) + bitmap_clz(w);
+	}
+
+	while (an < am) {
+		bitmap_word w = bitmap_bswap(BITMAP_WORD(bitmap, an));
+
+		if (w)
+			return an + bitmap_clz(w);
+
+		an += BITMAP_WORD_BITS;
+	}
+
+	if (m > am) {
+		bitmap_word w = bitmap_bswap(BITMAP_WORD(bitmap, m));
+
+		w &= tailmask;
+
+		if (w)
+			return am + bitmap_clz(w);
+	}
+
+	return m;
+}
diff --git a/ccan/bitmap/bitmap.h b/ccan/bitmap/bitmap.h
new file mode 100644
index 0000000..5498428
--- /dev/null
+++ b/ccan/bitmap/bitmap.h
@@ -0,0 +1,243 @@
+/* Licensed under LGPLv2+ - see LICENSE file for details */
+#ifndef CCAN_BITMAP_H_
+#define CCAN_BITMAP_H_
+
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+
+#include <ccan/endian/endian.h>
+
+typedef unsigned long bitmap_word;
+
+#define BITMAP_WORD_BITS	(sizeof(bitmap_word) * CHAR_BIT)
+#define BITMAP_NWORDS(_n)	\
+	(((_n) + BITMAP_WORD_BITS - 1) / BITMAP_WORD_BITS)
+
+/*
+ * We wrap each word in a structure for type checking.
+ */
+typedef struct {
+	bitmap_word w;
+} bitmap_t;
+
+#define BITMAP_DECLARE(_name, _nbits) \
+	bitmap_t (_name)[BITMAP_NWORDS(_nbits)]
+
+static inline size_t bitmap_sizeof(unsigned long nbits)
+{
+	return BITMAP_NWORDS(nbits) * sizeof(bitmap_word);
+}
+
+static inline bitmap_word bitmap_bswap(bitmap_word w)
+{
+	if (BITMAP_WORD_BITS == 32)
+		return (ENDIAN_CAST bitmap_word)cpu_to_be32(w);
+	else if (BITMAP_WORD_BITS == 64)
+		return (ENDIAN_CAST bitmap_word)cpu_to_be64(w);
+}
+
+#define BITMAP_WORD(_bm, _n)	((_bm)[(_n) / BITMAP_WORD_BITS].w)
+#define BITMAP_WORDBIT(_n) 	\
+	(bitmap_bswap(1UL << (BITMAP_WORD_BITS - ((_n) % BITMAP_WORD_BITS) - 1)))
+
+#define BITMAP_HEADWORDS(_nbits) \
+	((_nbits) / BITMAP_WORD_BITS)
+#define BITMAP_HEADBYTES(_nbits) \
+	(BITMAP_HEADWORDS(_nbits) * sizeof(bitmap_word))
+
+#define BITMAP_TAILWORD(_bm, _nbits) \
+	((_bm)[BITMAP_HEADWORDS(_nbits)].w)
+#define BITMAP_HASTAIL(_nbits)	(((_nbits) % BITMAP_WORD_BITS) != 0)
+#define BITMAP_TAILBITS(_nbits)	\
+	(bitmap_bswap(~(-1UL >> ((_nbits) % BITMAP_WORD_BITS))))
+#define BITMAP_TAIL(_bm, _nbits) \
+	(BITMAP_TAILWORD(_bm, _nbits) & BITMAP_TAILBITS(_nbits))
+
+static inline void bitmap_set_bit(bitmap_t *bitmap, unsigned long n)
+{
+	BITMAP_WORD(bitmap, n) |= BITMAP_WORDBIT(n);
+}
+
+static inline void bitmap_clear_bit(bitmap_t *bitmap, unsigned long n)
+{
+	BITMAP_WORD(bitmap, n) &= ~BITMAP_WORDBIT(n);
+}
+
+static inline void bitmap_change_bit(bitmap_t *bitmap, unsigned long n)
+{
+	BITMAP_WORD(bitmap, n) ^= BITMAP_WORDBIT(n);
+}
+
+static inline bool bitmap_test_bit(const bitmap_t *bitmap, unsigned long n)
+{
+	return !!(BITMAP_WORD(bitmap, n) & BITMAP_WORDBIT(n));
+}
+
+void bitmap_zero_range(bitmap_t *bitmap, unsigned long n, unsigned long m);
+void bitmap_fill_range(bitmap_t *bitmap, unsigned long n, unsigned long m);
+
+static inline void bitmap_zero(bitmap_t *bitmap, unsigned long nbits)
+{
+	memset(bitmap, 0, bitmap_sizeof(nbits));
+}
+
+static inline void bitmap_fill(bitmap_t *bitmap, unsigned long nbits)
+{
+	memset(bitmap, 0xff, bitmap_sizeof(nbits));
+}
+
+static inline void bitmap_copy(bitmap_t *dst, const bitmap_t *src,
+			       unsigned long nbits)
+{
+	memcpy(dst, src, bitmap_sizeof(nbits));
+}
+
+#define BITMAP_DEF_BINOP(_name, _op) \
+	static inline void bitmap_##_name(bitmap_t *dst, bitmap_t *src1, bitmap_t *src2, \
+					  unsigned long nbits)		\
+	{ \
+		unsigned long i = 0; \
+		for (i = 0; i < BITMAP_NWORDS(nbits); i++) { \
+			dst[i].w = src1[i].w _op src2[i].w; \
+		} \
+	}
+
+BITMAP_DEF_BINOP(and, &)
+BITMAP_DEF_BINOP(or, |)
+BITMAP_DEF_BINOP(xor, ^)
+BITMAP_DEF_BINOP(andnot, & ~)
+
+#undef BITMAP_DEF_BINOP
+
+static inline void bitmap_complement(bitmap_t *dst, const bitmap_t *src,
+				     unsigned long nbits)
+{
+	unsigned long i;
+
+	for (i = 0; i < BITMAP_NWORDS(nbits); i++)
+		dst[i].w = ~src[i].w;
+}
+
+static inline bool bitmap_equal(const bitmap_t *src1, const bitmap_t *src2,
+				unsigned long nbits)
+{
+	return (memcmp(src1, src2, BITMAP_HEADBYTES(nbits)) == 0)
+		&& (!BITMAP_HASTAIL(nbits)
+		    || (BITMAP_TAIL(src1, nbits) == BITMAP_TAIL(src2, nbits)));
+}
+
+static inline bool bitmap_intersects(const bitmap_t *src1, const bitmap_t *src2,
+				     unsigned long nbits)
+{
+	unsigned long i;
+
+	for (i = 0; i < BITMAP_HEADWORDS(nbits); i++) {
+		if (src1[i].w & src2[i].w)
+			return true;
+	}
+	if (BITMAP_HASTAIL(nbits) &&
+	    (BITMAP_TAIL(src1, nbits) & BITMAP_TAIL(src2, nbits)))
+		return true;
+	return false;
+}
+
+static inline bool bitmap_subset(const bitmap_t *src1, const bitmap_t *src2,
+				 unsigned long nbits)
+{
+	unsigned long i;
+
+	for (i = 0; i < BITMAP_HEADWORDS(nbits); i++) {
+		if (src1[i].w  & ~src2[i].w)
+			return false;
+	}
+	if (BITMAP_HASTAIL(nbits) &&
+	    (BITMAP_TAIL(src1, nbits) & ~BITMAP_TAIL(src2, nbits)))
+		return false;
+	return true;
+}
+
+static inline bool bitmap_full(const bitmap_t *bitmap, unsigned long nbits)
+{
+	unsigned long i;
+
+	for (i = 0; i < BITMAP_HEADWORDS(nbits); i++) {
+		if (bitmap[i].w != -1UL)
+			return false;
+	}
+	if (BITMAP_HASTAIL(nbits) &&
+	    (BITMAP_TAIL(bitmap, nbits) != BITMAP_TAILBITS(nbits)))
+		return false;
+
+	return true;
+}
+
+static inline bool bitmap_empty(const bitmap_t *bitmap, unsigned long nbits)
+{
+	unsigned long i;
+
+	for (i = 0; i < BITMAP_HEADWORDS(nbits); i++) {
+		if (bitmap[i].w != 0)
+			return false;
+	}
+	if (BITMAP_HASTAIL(nbits) && (BITMAP_TAIL(bitmap, nbits) != 0))
+		return false;
+
+	return true;
+}
+
+unsigned long bitmap_ffs(const bitmap_t *bitmap,
+			 unsigned long n, unsigned long m);
+
+/*
+ * Allocation functions
+ */
+static inline bitmap_t *bitmap_alloc(unsigned long nbits)
+{
+	return malloc(bitmap_sizeof(nbits));
+}
+
+static inline bitmap_t *bitmap_alloc0(unsigned long nbits)
+{
+	bitmap_t *bitmap;
+
+	bitmap = bitmap_alloc(nbits);
+	if (bitmap)
+		bitmap_zero(bitmap, nbits);
+	return bitmap;
+}
+
+static inline bitmap_t *bitmap_alloc1(unsigned long nbits)
+{
+	bitmap_t *bitmap;
+
+	bitmap = bitmap_alloc(nbits);
+	if (bitmap)
+		bitmap_fill(bitmap, nbits);
+	return bitmap;
+}
+
+static inline bitmap_t *bitmap_realloc0(bitmap_t *bitmap,
+				      unsigned long obits, unsigned long nbits)
+{
+	bitmap = realloc(bitmap, bitmap_sizeof(nbits));
+
+	if ((nbits > obits) && bitmap)
+		bitmap_zero_range(bitmap, obits, nbits);
+
+	return bitmap;
+}
+
+static inline bitmap_t *bitmap_realloc1(bitmap_t *bitmap,
+				      unsigned long obits, unsigned long nbits)
+{
+	bitmap = realloc(bitmap, bitmap_sizeof(nbits));
+
+	if ((nbits > obits) && bitmap)
+		bitmap_fill_range(bitmap, obits, nbits);
+
+	return bitmap;
+}
+
+#endif /* CCAN_BITMAP_H_ */
diff --git a/contrib/ndctl b/contrib/ndctl
index ea7303c..c97adcc 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -194,6 +194,9 @@ __ndctl_comp_non_option_args()
 	destroy-namespace)
 		opts="$(__ndctl_get_ns) all"
 		;;
+	check-namespace)
+		opts="$(__ndctl_get_ns -i) all"
+		;;
 	enable-region)
 		opts="$(__ndctl_get_regions -i) all"
 		;;
diff --git a/licenses/LGPL-2.1 b/licenses/LGPL-2.1
new file mode 100644
index 0000000..5522aa5
--- /dev/null
+++ b/licenses/LGPL-2.1
@@ -0,0 +1,508 @@
+
+                  GNU LESSER GENERAL PUBLIC LICENSE
+                       Version 2.1, February 1999
+
+ Copyright (C) 1991, 1999 Free Software Foundation, Inc.
+	51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+[This is the first released version of the Lesser GPL.  It also counts
+ as the successor of the GNU Library Public License, version 2, hence
+ the version number 2.1.]
+
+                            Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+Licenses are intended to guarantee your freedom to share and change
+free software--to make sure the software is free for all its users.
+
+  This license, the Lesser General Public License, applies to some
+specially designated software packages--typically libraries--of the
+Free Software Foundation and other authors who decide to use it.  You
+can use it too, but we suggest you first think carefully about whether
+this license or the ordinary General Public License is the better
+strategy to use in any particular case, based on the explanations
+below.
+
+  When we speak of free software, we are referring to freedom of use,
+not price.  Our General Public Licenses are designed to make sure that
+you have the freedom to distribute copies of free software (and charge
+for this service if you wish); that you receive source code or can get
+it if you want it; that you can change the software and use pieces of
+it in new free programs; and that you are informed that you can do
+these things.
+
+  To protect your rights, we need to make restrictions that forbid
+distributors to deny you these rights or to ask you to surrender these
+rights.  These restrictions translate to certain responsibilities for
+you if you distribute copies of the library or if you modify it.
+
+  For example, if you distribute copies of the library, whether gratis
+or for a fee, you must give the recipients all the rights that we gave
+you.  You must make sure that they, too, receive or can get the source
+code.  If you link other code with the library, you must provide
+complete object files to the recipients, so that they can relink them
+with the library after making changes to the library and recompiling
+it.  And you must show them these terms so they know their rights.
+
+  We protect your rights with a two-step method: (1) we copyright the
+library, and (2) we offer you this license, which gives you legal
+permission to copy, distribute and/or modify the library.
+
+  To protect each distributor, we want to make it very clear that
+there is no warranty for the free library.  Also, if the library is
+modified by someone else and passed on, the recipients should know
+that what they have is not the original version, so that the original
+author's reputation will not be affected by problems that might be
+introduced by others.
+

+  Finally, software patents pose a constant threat to the existence of
+any free program.  We wish to make sure that a company cannot
+effectively restrict the users of a free program by obtaining a
+restrictive license from a patent holder.  Therefore, we insist that
+any patent license obtained for a version of the library must be
+consistent with the full freedom of use specified in this license.
+
+  Most GNU software, including some libraries, is covered by the
+ordinary GNU General Public License.  This license, the GNU Lesser
+General Public License, applies to certain designated libraries, and
+is quite different from the ordinary General Public License.  We use
+this license for certain libraries in order to permit linking those
+libraries into non-free programs.
+
+  When a program is linked with a library, whether statically or using
+a shared library, the combination of the two is legally speaking a
+combined work, a derivative of the original library.  The ordinary
+General Public License therefore permits such linking only if the
+entire combination fits its criteria of freedom.  The Lesser General
+Public License permits more lax criteria for linking other code with
+the library.
+
+  We call this license the "Lesser" General Public License because it
+does Less to protect the user's freedom than the ordinary General
+Public License.  It also provides other free software developers Less
+of an advantage over competing non-free programs.  These disadvantages
+are the reason we use the ordinary General Public License for many
+libraries.  However, the Lesser license provides advantages in certain
+special circumstances.
+
+  For example, on rare occasions, there may be a special need to
+encourage the widest possible use of a certain library, so that it
+becomes a de-facto standard.  To achieve this, non-free programs must
+be allowed to use the library.  A more frequent case is that a free
+library does the same job as widely used non-free libraries.  In this
+case, there is little to gain by limiting the free library to free
+software only, so we use the Lesser General Public License.
+
+  In other cases, permission to use a particular library in non-free
+programs enables a greater number of people to use a large body of
+free software.  For example, permission to use the GNU C Library in
+non-free programs enables many more people to use the whole GNU
+operating system, as well as its variant, the GNU/Linux operating
+system.
+
+  Although the Lesser General Public License is Less protective of the
+users' freedom, it does ensure that the user of a program that is
+linked with the Library has the freedom and the wherewithal to run
+that program using a modified version of the Library.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.  Pay close attention to the difference between a
+"work based on the library" and a "work that uses the library".  The
+former contains code derived from the library, whereas the latter must
+be combined with the library in order to run.
+

+                  GNU LESSER GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License Agreement applies to any software library or other
+program which contains a notice placed by the copyright holder or
+other authorized party saying it may be distributed under the terms of
+this Lesser General Public License (also called "this License").
+Each licensee is addressed as "you".
+
+  A "library" means a collection of software functions and/or data
+prepared so as to be conveniently linked with application programs
+(which use some of those functions and data) to form executables.
+
+  The "Library", below, refers to any such software library or work
+which has been distributed under these terms.  A "work based on the
+Library" means either the Library or any derivative work under
+copyright law: that is to say, a work containing the Library or a
+portion of it, either verbatim or with modifications and/or translated
+straightforwardly into another language.  (Hereinafter, translation is
+included without limitation in the term "modification".)
+
+  "Source code" for a work means the preferred form of the work for
+making modifications to it.  For a library, complete source code means
+all the source code for all modules it contains, plus any associated
+interface definition files, plus the scripts used to control
+compilation and installation of the library.
+
+  Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running a program using the Library is not restricted, and output from
+such a program is covered only if its contents constitute a work based
+on the Library (independent of the use of the Library in a tool for
+writing it).  Whether that is true depends on what the Library does
+and what the program that uses the Library does.
+
+  1. You may copy and distribute verbatim copies of the Library's
+complete source code as you receive it, in any medium, provided that
+you conspicuously and appropriately publish on each copy an
+appropriate copyright notice and disclaimer of warranty; keep intact
+all the notices that refer to this License and to the absence of any
+warranty; and distribute a copy of this License along with the
+Library.
+
+  You may charge a fee for the physical act of transferring a copy,
+and you may at your option offer warranty protection in exchange for a
+fee.
+

+  2. You may modify your copy or copies of the Library or any portion
+of it, thus forming a work based on the Library, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) The modified work must itself be a software library.
+
+    b) You must cause the files modified to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    c) You must cause the whole of the work to be licensed at no
+    charge to all third parties under the terms of this License.
+
+    d) If a facility in the modified Library refers to a function or a
+    table of data to be supplied by an application program that uses
+    the facility, other than as an argument passed when the facility
+    is invoked, then you must make a good faith effort to ensure that,
+    in the event an application does not supply such function or
+    table, the facility still operates, and performs whatever part of
+    its purpose remains meaningful.
+
+    (For example, a function in a library to compute square roots has
+    a purpose that is entirely well-defined independent of the
+    application.  Therefore, Subsection 2d requires that any
+    application-supplied function or table used by this function must
+    be optional: if the application does not supply it, the square
+    root function must still compute square roots.)
+
+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Library,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Library, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote
+it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Library.
+
+In addition, mere aggregation of another work not based on the Library
+with the Library (or with a work based on the Library) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may opt to apply the terms of the ordinary GNU General Public
+License instead of this License to a given copy of the Library.  To do
+this, you must alter all the notices that refer to this License, so
+that they refer to the ordinary GNU General Public License, version 2,
+instead of to this License.  (If a newer version than version 2 of the
+ordinary GNU General Public License has appeared, then you can specify
+that version instead if you wish.)  Do not make any other change in
+these notices.
+

+  Once this change is made in a given copy, it is irreversible for
+that copy, so the ordinary GNU General Public License applies to all
+subsequent copies and derivative works made from that copy.
+
+  This option is useful when you wish to copy part of the code of
+the Library into a program that is not a library.
+
+  4. You may copy and distribute the Library (or a portion or
+derivative of it, under Section 2) in object code or executable form
+under the terms of Sections 1 and 2 above provided that you accompany
+it with the complete corresponding machine-readable source code, which
+must be distributed under the terms of Sections 1 and 2 above on a
+medium customarily used for software interchange.
+
+  If distribution of object code is made by offering access to copy
+from a designated place, then offering equivalent access to copy the
+source code from the same place satisfies the requirement to
+distribute the source code, even though third parties are not
+compelled to copy the source along with the object code.
+
+  5. A program that contains no derivative of any portion of the
+Library, but is designed to work with the Library by being compiled or
+linked with it, is called a "work that uses the Library".  Such a
+work, in isolation, is not a derivative work of the Library, and
+therefore falls outside the scope of this License.
+
+  However, linking a "work that uses the Library" with the Library
+creates an executable that is a derivative of the Library (because it
+contains portions of the Library), rather than a "work that uses the
+library".  The executable is therefore covered by this License.
+Section 6 states terms for distribution of such executables.
+
+  When a "work that uses the Library" uses material from a header file
+that is part of the Library, the object code for the work may be a
+derivative work of the Library even though the source code is not.
+Whether this is true is especially significant if the work can be
+linked without the Library, or if the work is itself a library.  The
+threshold for this to be true is not precisely defined by law.
+
+  If such an object file uses only numerical parameters, data
+structure layouts and accessors, and small macros and small inline
+functions (ten lines or less in length), then the use of the object
+file is unrestricted, regardless of whether it is legally a derivative
+work.  (Executables containing this object code plus portions of the
+Library will still fall under Section 6.)
+
+  Otherwise, if the work is a derivative of the Library, you may
+distribute the object code for the work under the terms of Section 6.
+Any executables containing that work also fall under Section 6,
+whether or not they are linked directly with the Library itself.
+

+  6. As an exception to the Sections above, you may also combine or
+link a "work that uses the Library" with the Library to produce a
+work containing portions of the Library, and distribute that work
+under terms of your choice, provided that the terms permit
+modification of the work for the customer's own use and reverse
+engineering for debugging such modifications.
+
+  You must give prominent notice with each copy of the work that the
+Library is used in it and that the Library and its use are covered by
+this License.  You must supply a copy of this License.  If the work
+during execution displays copyright notices, you must include the
+copyright notice for the Library among them, as well as a reference
+directing the user to the copy of this License.  Also, you must do one
+of these things:
+
+    a) Accompany the work with the complete corresponding
+    machine-readable source code for the Library including whatever
+    changes were used in the work (which must be distributed under
+    Sections 1 and 2 above); and, if the work is an executable linked
+    with the Library, with the complete machine-readable "work that
+    uses the Library", as object code and/or source code, so that the
+    user can modify the Library and then relink to produce a modified
+    executable containing the modified Library.  (It is understood
+    that the user who changes the contents of definitions files in the
+    Library will not necessarily be able to recompile the application
+    to use the modified definitions.)
+
+    b) Use a suitable shared library mechanism for linking with the
+    Library.  A suitable mechanism is one that (1) uses at run time a
+    copy of the library already present on the user's computer system,
+    rather than copying library functions into the executable, and (2)
+    will operate properly with a modified version of the library, if
+    the user installs one, as long as the modified version is
+    interface-compatible with the version that the work was made with.
+
+    c) Accompany the work with a written offer, valid for at least
+    three years, to give the same user the materials specified in
+    Subsection 6a, above, for a charge no more than the cost of
+    performing this distribution.
+
+    d) If distribution of the work is made by offering access to copy
+    from a designated place, offer equivalent access to copy the above
+    specified materials from the same place.
+
+    e) Verify that the user has already received a copy of these
+    materials or that you have already sent this user a copy.
+
+  For an executable, the required form of the "work that uses the
+Library" must include any data and utility programs needed for
+reproducing the executable from it.  However, as a special exception,
+the materials to be distributed need not include anything that is
+normally distributed (in either source or binary form) with the major
+components (compiler, kernel, and so on) of the operating system on
+which the executable runs, unless that component itself accompanies
+the executable.
+
+  It may happen that this requirement contradicts the license
+restrictions of other proprietary libraries that do not normally
+accompany the operating system.  Such a contradiction means you cannot
+use both them and the Library together in an executable that you
+distribute.
+

+  7. You may place library facilities that are a work based on the
+Library side-by-side in a single library together with other library
+facilities not covered by this License, and distribute such a combined
+library, provided that the separate distribution of the work based on
+the Library and of the other library facilities is otherwise
+permitted, and provided that you do these two things:
+
+    a) Accompany the combined library with a copy of the same work
+    based on the Library, uncombined with any other library
+    facilities.  This must be distributed under the terms of the
+    Sections above.
+
+    b) Give prominent notice with the combined library of the fact
+    that part of it is a work based on the Library, and explaining
+    where to find the accompanying uncombined form of the same work.
+
+  8. You may not copy, modify, sublicense, link with, or distribute
+the Library except as expressly provided under this License.  Any
+attempt otherwise to copy, modify, sublicense, link with, or
+distribute the Library is void, and will automatically terminate your
+rights under this License.  However, parties who have received copies,
+or rights, from you under this License will not have their licenses
+terminated so long as such parties remain in full compliance.
+
+  9. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Library or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Library (or any work based on the
+Library), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Library or works based on it.
+
+  10. Each time you redistribute the Library (or any work based on the
+Library), the recipient automatically receives a license from the
+original licensor to copy, distribute, link with or modify the Library
+subject to these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties with
+this License.
+

+  11. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Library at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Library by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Library.
+
+If any portion of this section is held invalid or unenforceable under
+any particular circumstance, the balance of the section is intended to
+apply, and the section as a whole is intended to apply in other
+circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+
+  12. If the distribution and/or use of the Library is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Library under this License
+may add an explicit geographical distribution limitation excluding those
+countries, so that distribution is permitted only in or among
+countries not thus excluded.  In such case, this License incorporates
+the limitation as if written in the body of this License.
+
+  13. The Free Software Foundation may publish revised and/or new
+versions of the Lesser General Public License from time to time.
+Such new versions will be similar in spirit to the present version,
+but may differ in detail to address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Library
+specifies a version number of this License which applies to it and
+"any later version", you have the option of following the terms and
+conditions either of that version or of any later version published by
+the Free Software Foundation.  If the Library does not specify a
+license version number, you may choose any version ever published by
+the Free Software Foundation.
+

+  14. If you wish to incorporate parts of the Library into other free
+programs whose distribution conditions are incompatible with these,
+write to the author to ask for permission.  For software which is
+copyrighted by the Free Software Foundation, write to the Free
+Software Foundation; we sometimes make exceptions for this.  Our
+decision will be guided by the two goals of preserving the free status
+of all derivatives of our free software and of promoting the sharing
+and reuse of software generally.
+
+                            NO WARRANTY
+
+  15. BECAUSE THE LIBRARY IS LICENSED FREE OF CHARGE, THERE IS NO
+WARRANTY FOR THE LIBRARY, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
+EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR
+OTHER PARTIES PROVIDE THE LIBRARY "AS IS" WITHOUT WARRANTY OF ANY
+KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
+IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
+LIBRARY IS WITH YOU.  SHOULD THE LIBRARY PROVE DEFECTIVE, YOU ASSUME
+THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
+
+  16. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN
+WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY
+AND/OR REDISTRIBUTE THE LIBRARY AS PERMITTED ABOVE, BE LIABLE TO YOU
+FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR
+CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
+LIBRARY (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
+RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
+FAILURE OF THE LIBRARY TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
+SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
+DAMAGES.
+
+                     END OF TERMS AND CONDITIONS
+

+           How to Apply These Terms to Your New Libraries
+
+  If you develop a new library, and you want it to be of the greatest
+possible use to the public, we recommend making it free software that
+everyone can redistribute and change.  You can do so by permitting
+redistribution under these terms (or, alternatively, under the terms
+of the ordinary General Public License).
+
+  To apply these terms, attach the following notices to the library.
+It is safest to attach them to the start of each source file to most
+effectively convey the exclusion of warranty; and each file should
+have at least the "copyright" line and a pointer to where the full
+notice is found.
+
+
+    <one line to give the library's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This library is free software; you can redistribute it and/or
+    modify it under the terms of the GNU Lesser General Public
+    License as published by the Free Software Foundation; either
+    version 2.1 of the License, or (at your option) any later version.
+
+    This library is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+    Lesser General Public License for more details.
+
+    You should have received a copy of the GNU Lesser General Public
+    License along with this library; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+
+Also add information on how to contact you by electronic and paper mail.
+
+You should also get your employer (if you work as a programmer) or
+your school, if any, to sign a "copyright disclaimer" for the library,
+if necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the
+  library `Frob' (a library for tweaking knobs) written by James
+  Random Hacker.
+
+  <signature of Ty Coon>, 1 April 1990
+  Ty Coon, President of Vice
+
+That's all there is to it!
diff --git a/ndctl.spec.in b/ndctl.spec.in
index b481762..57a3d90 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -112,7 +112,7 @@ make check
 
 %files
 %defattr(-,root,root)
-%license util/COPYING licenses/BSD-MIT licenses/CC0
+%license util/COPYING licenses/BSD-MIT licenses/CC0 licenses/LGPL-2.1
 %{_bindir}/ndctl
 %{_mandir}/man1/ndctl*
 %{bashcompdir}/
@@ -151,6 +151,9 @@ make check
 
 
 %changelog
+* Tue Feb 21 2017 Vishal Verma <vishal.l.verma@intel.com> - 57-1
+- Add licenses/LGPL-2.1 for ccan/bitmap in the ndctl utility
+
 * Fri May 27 2016 Dan Williams <dan.j.williams@intel.com> - 53-1
 - add daxctl-libs + daxctl-devel packages
 - add bash completion
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index c563e94..f9158d9 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -5,6 +5,7 @@ bin_PROGRAMS = ndctl
 ndctl_SOURCES = ndctl.c \
 		builtin-create-nfit.c \
 		builtin-xaction-namespace.c \
+		builtin-check.c \
 		builtin-xable-region.c \
 		builtin-dimm.c \
 		 ../util/log.c \
diff --git a/ndctl/builtin-check.c b/ndctl/builtin-check.c
new file mode 100644
index 0000000..ff7e8c1
--- /dev/null
+++ b/ndctl/builtin-check.c
@@ -0,0 +1,938 @@
+/*
+ * Copyright(c) 2015-2016 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <sys/mman.h>
+#include <uuid/uuid.h>
+#include <sys/types.h>
+#include <util/json.h>
+#include <util/size.h>
+#include <util/util.h>
+#include <util/fletcher.h>
+#include <ndctl/libndctl.h>
+#include <ccan/bitmap/bitmap.h>
+#include <ccan/endian/endian.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/array_size/array_size.h>
+#include <ccan/short_types/short_types.h>
+#include "check.h"
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+static int repair_msg(void)
+{
+	inform("  Run with --repair to make the changes");
+	return 0;
+}
+
+/**
+ * btt_read_info - read an info block from a given offset
+ * @bttc:	the main btt_chk structure for this btt
+ * @btt_sb:	struct btt_sb where the info block will be copied into
+ * @offset:	offset in the raw namespace to read the info block from
+ *
+ * The initial 4K offset will get added in by this routine. This will
+ * also use 'pread' to read the info block, and not mmap+loads as this
+ * is used before the mappings are set up.
+ */
+static int btt_read_info(struct btt_chk *bttc, struct btt_sb *btt_sb, u64 off)
+{
+	ssize_t size;
+	int rc = 0;
+
+	size = pread(bttc->fd, btt_sb, sizeof(*btt_sb), off + SZ_4K);
+	if (size < 0) {
+		error("unable to read first info block: %s\n", strerror(errno));
+		rc = -errno;
+	}
+	if (size != sizeof(*btt_sb)) {
+		error("short read of first info block: %ld\n", size);
+		rc = -ENXIO;
+	}
+	return rc;
+}
+
+/**
+ * btt_write_info - write an info block to the given offset
+ * @bttc:	the main btt_chk structure for this btt
+ * @btt_sb:	struct btt_sb where the info block will be copied from
+ * @offset:	offset in the raw namespace to write the info block to
+ *
+ * The initial 4K offset will get added in by this routine. This will
+ * also use 'pwrite' to write the info block, and not mmap+stores as this
+ * is used before the mappings are set up.
+ */
+static int btt_write_info(struct btt_chk *bttc, struct btt_sb *btt_sb, u64 off)
+{
+	ssize_t size;
+	int rc = 0;
+
+	if (!bttc->opts->repair) {
+		error("BTT info block at offset %#lx needs to be restored\n", off);
+		repair_msg();
+		return -1;
+	}
+	printf("Restoring BTT info block at offset %#lx\n", off);
+
+	size = pwrite(bttc->fd, btt_sb, sizeof(*btt_sb), off + SZ_4K);
+	if (size != sizeof(*btt_sb)) {
+		error("unable to write the info block: %s\n", strerror(errno));
+		rc = -errno;
+	}
+	return rc;
+}
+
+/**
+ * btt_copy_to_info2 - restore the backup info block using the main one
+ * @a:		the arena_info handle for this arena
+ *
+ * Called when a corrupted backup info block is detected. Copies the
+ * main info block over to the backup location. This is done using
+ * mmap + stores, and thus needs a msync.
+ */
+static int btt_copy_to_info2(struct arena_info *a)
+{
+	void *ms_align;
+	size_t ms_size;
+
+	if (!a->bttc->opts->repair) {
+		error("Arena %d: BTT info2 needs to be restored\n", a->num);
+		return repair_msg();
+	}
+	printf("Arena %d: Restoring BTT info2\n", a->num);
+	memcpy(a->map.info2, a->map.info, BTT_PG_SIZE);
+
+	ms_align = (void *)rounddown((u64)a->map.info2,
+			sysconf(_SC_PAGESIZE));
+	ms_size = max(BTT_PG_SIZE, sysconf(_SC_PAGESIZE));
+	if (msync(ms_align, ms_size, MS_SYNC) < 0)
+		return errno;
+
+	return 0;
+}
+
+/*
+ * btt_map_lookup - given a pre-map Arena Block Address, return the post-map ABA
+ * @a:		the arena_info handle for this arena
+ * @lba:	the logical block address for which we are performing the lookup
+ *
+ * This will correctly account for map entries in the 'initial state'
+ */
+static u32 btt_map_lookup(struct arena_info *a, u32 lba)
+{
+	u32 raw_mapping;
+
+	raw_mapping = le32_to_cpu(a->map.map[lba]);
+	if (raw_mapping & MAP_ENT_NORMAL)
+		return raw_mapping & MAP_LBA_MASK;
+	else
+		return lba;
+}
+
+static int btt_map_write(struct arena_info *a, u32 lba, u32 mapping)
+{
+	void *ms_align;
+
+	if (!a->bttc->opts->repair) {
+		error("Arena %d: map[%#x] needs to be updated to %#x\n",
+			a->num, lba, mapping);
+		return repair_msg();
+	}
+	printf("Arena %d: Updating map[%#x] to %#x\n", a->num, lba, mapping);
+
+	/*
+	 * We want to set neither of the Z or E flags, and in the actual
+	 * layout, this means setting the bit positions of both to '1' to
+	 * indicate a 'normal' map entry
+	 */
+	mapping |= MAP_ENT_NORMAL;
+	a->map.map[lba] = cpu_to_le32(mapping);
+
+	ms_align = (void *)rounddown((u64)&a->map.map[lba],
+			sysconf(_SC_PAGESIZE));
+	if (msync(ms_align, sysconf(_SC_PAGESIZE), MS_SYNC) < 0)
+		return errno;
+
+	return 0;
+}
+
+static void btt_log_read_pair(struct arena_info *a, u32 lane,
+			struct log_entry *ent)
+{
+	memcpy(ent, &a->map.log[lane * 2], 2 * sizeof(struct log_entry));
+}
+
+/*
+ * This function accepts two log entries, and uses the sequence number to
+ * find the 'older' entry. The return value indicates which of the two was
+ * the 'old' entry
+ */
+static int btt_log_get_old(struct log_entry *ent)
+{
+	int old;
+
+	if (ent[0].seq == 0) {
+		ent[0].seq = cpu_to_le32(1);
+		return 0;
+	}
+
+	if (le32_to_cpu(ent[0].seq) < le32_to_cpu(ent[1].seq)) {
+		if (le32_to_cpu(ent[1].seq) - le32_to_cpu(ent[0].seq) == 1)
+			old = 0;
+		else
+			old = 1;
+	} else {
+		if (le32_to_cpu(ent[0].seq) - le32_to_cpu(ent[1].seq) == 1)
+			old = 1;
+		else
+			old = 0;
+	}
+
+	return old;
+}
+
+static int btt_log_read(struct arena_info *a, u32 lane, struct log_entry *ent)
+{
+	int new_ent;
+	struct log_entry log[2];
+
+	if (ent == NULL)
+		return -EINVAL;
+	btt_log_read_pair(a, lane, log);
+	new_ent = 1 - btt_log_get_old(log);
+	memcpy(ent, &log[new_ent], sizeof(struct log_entry));
+	return 0;
+}
+
+static int btt_checksum_verify(struct btt_sb *btt_sb)
+{
+	uint64_t sum;
+	le64 sum_save;
+
+	BUILD_BUG_ON(sizeof(struct btt_sb) != SZ_4K);
+
+	sum_save = btt_sb->checksum;
+	btt_sb->checksum = 0;
+	sum = fletcher64(btt_sb, sizeof(*btt_sb), 1);
+	if (sum != sum_save)
+		return 1;
+	/* restore the checksum in the buffer */
+	btt_sb->checksum = sum_save;
+
+	return 0;
+}
+
+/*
+ * Never pass a mmapped buffer to this as it will attempt to write to
+ * the buffer, and we want writes to only happened in a controlled fashion.
+ * In the non --repair case, even if such a buffer is passed, the write will
+ * result in a fault due to the readonly mmap flags.
+ */
+static int btt_info_verify(struct btt_chk *bttc, struct btt_sb *btt_sb)
+{
+	if (memcmp(btt_sb->signature, BTT_SIG, BTT_SIG_LEN) != 0)
+		return -ENXIO;
+
+	if (!uuid_is_null(btt_sb->parent_uuid))
+		if (uuid_compare(bttc->parent_uuid, btt_sb->parent_uuid) != 0)
+			return -ENXIO;
+
+	if (btt_checksum_verify(btt_sb))
+		return -ENXIO;
+
+	return 0;
+}
+
+static int btt_info_read_verify(struct btt_chk *bttc, struct btt_sb *btt_sb,
+	u64 off)
+{
+	int rc;
+
+	rc = btt_read_info(bttc, btt_sb, off);
+	if (rc)
+		return rc;
+	rc = btt_info_verify(bttc, btt_sb);
+	if (rc)
+		return rc;
+	return 0;
+}
+
+enum btt_errcodes {
+	BTT_OK = 0,
+	BTT_LOG_EQL_SEQ = 0x100,
+	BTT_LOG_OOB_SEQ,
+	BTT_LOG_OOB_LBA,
+	BTT_LOG_OOB_OLD,
+	BTT_LOG_OOB_NEW,
+	BTT_LOG_MAP_ERR,
+	BTT_MAP_OOB,
+	BTT_BITMAP_ERROR,
+};
+
+static void btt_xlat_status(struct arena_info *a, int errcode)
+{
+	switch(errcode) {
+	case BTT_OK:
+		break;
+	case BTT_LOG_EQL_SEQ:
+		error("arena %d: found a pair of log entries with the same sequence number\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_SEQ:
+		error("arena %d: found a log entry with an out of bounds sequence number\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_LBA:
+		error("arena %d: found a log entry with an out of bounds LBA\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_OLD:
+		error("arena %d: found a log entry with an out of bounds 'old' mapping\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_NEW:
+		error("arena %d: found a log entry with an out of bounds 'new' mapping\n",
+			a->num);
+		break;
+	case BTT_LOG_MAP_ERR:
+		inform("arena %d: found a log entry that does not match with a map entry\n",
+			a->num);
+		break;
+	case BTT_MAP_OOB:
+		error("arena %d: found a map entry that is out of bounds\n",
+			a->num);
+		break;
+	case BTT_BITMAP_ERROR:
+		error("arena %d: bitmap error: internal blocks are incorrectly referenced\n",
+			a->num);
+		break;
+	default:
+		error("arena %d: unknown error: %d\n", a->num, errcode);
+	}
+}
+
+/* Check that log entries are self consistent */
+static int btt_check_log_entries(struct arena_info *a)
+{
+	unsigned int i;
+	int rc = 0;
+
+	/*
+	 * First, check both 'slots' for sequence numbers being distinct
+	 * and in bounds
+	 */
+	for (i = 0; i < (2 * a->nfree); i+=2) {
+		if (a->map.log[i].seq == a->map.log[i + 1].seq)
+			return BTT_LOG_EQL_SEQ;
+		if (a->map.log[i].seq > 3 || a->map.log[i + 1].seq > 3)
+			return BTT_LOG_OOB_SEQ;
+	}
+	/*
+	 * Next, check only the 'new' slot in each lane for the remaining
+	 * entries being in bounds
+	 */
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			return rc;
+
+		if (log.lba >= a->external_nlba)
+			return BTT_LOG_OOB_LBA;
+		if (log.old_map >= a->internal_nlba)
+			return BTT_LOG_OOB_OLD;
+		if (log.new_map >= a->internal_nlba)
+			return BTT_LOG_OOB_NEW;
+	}
+	return rc;
+}
+
+/* Check that log entries are self consistent */
+static int btt_check_map_entries(struct arena_info *a)
+{
+	unsigned int i;
+	u32 mapping;
+
+	for (i = 0; i < a->external_nlba; i++) {
+		mapping = btt_map_lookup(a, i);
+		if (mapping >= a->internal_nlba)
+			return BTT_MAP_OOB;
+	}
+	return 0;
+}
+
+/* Check that each flog entry has the correct corresponding map entry */
+static int btt_check_log_map(struct arena_info *a)
+{
+	unsigned int i;
+	u32 mapping;
+	int rc = 0;
+
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			return rc;
+		mapping = btt_map_lookup(a, log.lba);
+
+		/*
+		 * Case where the flog was written, but map couldn't be updated.
+		 * The kernel should also be able to detect and fix this condition
+		 */
+		if (log.new_map != mapping && log.old_map == mapping) {
+			inform("arena %d: log[%d].new_map (%#x) doesn't match map[%#x] (%#x)",
+				a->num, i, log.new_map, log.lba, mapping);
+			rc = btt_map_write(a, log.lba, log.new_map);
+			if (rc)
+				return BTT_LOG_MAP_ERR;
+		}
+	}
+	return rc;
+}
+
+static int btt_check_info2(struct arena_info *a)
+{
+	/*
+	 * Repair info2 if needed. The main info-block can be trusted
+	 * as it has been verified during arena discovery
+	 */
+	if(memcmp(a->map.info2, a->map.info, BTT_PG_SIZE))
+		return btt_copy_to_info2(a);
+	return 0;
+}
+
+/*
+ * This will create a bitmap where each bit corresponds to an internal
+ * 'block'. Between the BTT map and flog (representing 'free' blocks),
+ * every single internal block must be represented exactly once. This
+ * check will detect cases where either one or more blocks are never
+ * referenced, or if a block is referenced more than once.
+ */
+static int btt_check_bitmap(struct arena_info *a)
+{
+	bitmap_t *bm;
+	u32 i, mapping;
+	int rc;
+
+	bm = bitmap_alloc0(a->internal_nlba);
+	if (bm == NULL)
+		return -ENOMEM;
+
+	/* map 'external_nlba' number of map entries */
+	for (i = 0; i < a->external_nlba; i++) {
+		mapping = btt_map_lookup(a, i);
+		if (bitmap_test_bit(bm, mapping)) {
+			inform("arena %d: internal block %#x is referenced by two map entries",
+				a->num, mapping);
+			rc = BTT_BITMAP_ERROR;
+			goto out;
+		}
+		bitmap_set_bit(bm, mapping);
+	}
+
+	/* map 'nfree' number of flog entries */
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			goto out;
+		if (bitmap_test_bit(bm, log.old_map)) {
+			inform("arena %d: internal block %#x is referenced by two map/log entries",
+				a->num, log.old_map);
+			rc = BTT_BITMAP_ERROR;
+			goto out;
+		}
+		bitmap_set_bit(bm, log.old_map);
+	}
+
+	/* check that the bitmap is full */
+	if (!bitmap_full(bm, a->internal_nlba))
+		rc = BTT_BITMAP_ERROR;
+ out:
+	free(bm);
+	return rc;
+}
+
+static int btt_check_arenas(struct btt_chk *bttc)
+{
+	struct arena_info *a = NULL;
+	int i, rc;
+
+	for(i = 0; i < bttc->num_arenas; i++) {
+		printf("checking arena %d\n", i);
+		a = &bttc->arena[i];
+		rc = btt_check_log_entries(a);
+		if (rc)
+			break;
+		rc = btt_check_map_entries(a);
+		if (rc)
+			break;
+		rc = btt_check_log_map(a);
+		if (rc)
+			break;
+		rc = btt_check_info2(a);
+		if (rc)
+			break;
+		/*
+		 * bitmap test has to be after check_log_map so that any
+		 * pending log updates have been performed. Otherwise the
+		 * bitmap test may result in a false positive
+		 */
+		rc = btt_check_bitmap(a);
+		if (rc)
+			break;
+	}
+
+	btt_xlat_status(a, rc);
+	if (rc)
+		return -ENXIO;
+	return 0;
+}
+
+static int btt_parse_meta(struct arena_info *arena, struct btt_sb *btt_sb,
+				u64 arena_off)
+{
+	arena->internal_nlba = le32_to_cpu(btt_sb->internal_nlba);
+	arena->internal_lbasize = le32_to_cpu(btt_sb->internal_lbasize);
+	arena->external_nlba = le32_to_cpu(btt_sb->external_nlba);
+	arena->external_lbasize = le32_to_cpu(btt_sb->external_lbasize);
+	arena->nfree = le32_to_cpu(btt_sb->nfree);
+
+	if (arena->internal_nlba - arena->external_nlba != arena->nfree)
+		return -ENXIO;
+	if (arena->internal_lbasize != arena->external_lbasize)
+		return -ENXIO;
+
+	arena->version_major = le16_to_cpu(btt_sb->version_major);
+	arena->version_minor = le16_to_cpu(btt_sb->version_minor);
+
+	arena->nextoff = (btt_sb->nextoff == 0) ? 0 : (arena_off +
+			le64_to_cpu(btt_sb->nextoff));
+	arena->infooff = arena_off;
+	arena->dataoff = arena_off + le64_to_cpu(btt_sb->dataoff);
+	arena->mapoff = arena_off + le64_to_cpu(btt_sb->mapoff);
+	arena->logoff = arena_off + le64_to_cpu(btt_sb->logoff);
+	arena->info2off = arena_off + le64_to_cpu(btt_sb->info2off);
+
+	arena->size = (le64_to_cpu(btt_sb->nextoff) > 0)
+		? (le64_to_cpu(btt_sb->nextoff))
+		: (arena->info2off - arena->infooff + BTT_PG_SIZE);
+
+	arena->flags = le32_to_cpu(btt_sb->flags);
+	if (btt_sb->flags & IB_FLAG_ERROR_MASK) {
+		error("Info block error flag is set, aborting");
+		return -ENXIO;
+	}
+	return 0;
+}
+
+static int btt_discover_arenas(struct btt_chk *bttc)
+{
+	int ret = 0;
+	struct arena_info *arena;
+	struct btt_sb *btt_sb;
+	size_t remaining = bttc->rawsize;
+	u64 cur_nlba = 0;
+	size_t cur_off = 0;
+	int  i = 0;
+
+	btt_sb = calloc(1, sizeof(*btt_sb));
+	if (!btt_sb)
+		return -ENOMEM;
+
+	while (remaining) {
+		/* Alloc memory for arena */
+		arena = realloc(bttc->arena, (i + 1) * sizeof(*arena));
+		if (!arena) {
+			ret = -ENOMEM;
+			goto out;
+		} else {
+			bttc->arena = arena;
+			arena = &bttc->arena[i];
+			/* zero the new memory */
+			memset(arena, 0, sizeof(*arena));
+		}
+
+		arena->infooff = cur_off;
+		ret = btt_read_info(bttc, btt_sb, cur_off);
+		if (ret)
+			goto out;
+
+		if (btt_info_verify(bttc, btt_sb) != 0) {
+			u64 offset;
+
+			/* Try to find the backup info block */
+			if (remaining <= ARENA_MAX_SIZE)
+				offset = rounddown(bttc->rawsize, BTT_PG_SIZE) -
+					BTT_PG_SIZE - SZ_4K;
+			else
+				offset = cur_off + ARENA_MAX_SIZE - BTT_PG_SIZE;
+
+			printf("Arena %d: Attempting recover info-block using info2\n", i);
+			ret = btt_read_info(bttc, btt_sb, offset);
+			if (ret) {
+				error("Unable to read backup info block (offset %#lx)\n",
+					offset);
+				goto out;
+			}
+			ret = btt_info_verify(bttc, btt_sb);
+			if (ret) {
+				error("Backup info block (offset %#lx) verification failed\n",
+					offset);
+				goto out;
+			}
+			ret = btt_write_info(bttc, btt_sb, cur_off);
+			if (ret) {
+				error("Restoration of the info block failed: %d\n", ret);
+				goto out;
+			}
+		}
+
+		ret = btt_parse_meta(arena, btt_sb, cur_off);
+		if (ret) {
+			error("Problem parsing arena[%d] metadata\n", i);
+			goto out;
+		}
+		arena->external_lba_start = cur_nlba;
+		remaining -= arena->size;
+		cur_off += arena->size;
+		cur_nlba += arena->external_nlba;
+		arena->num = i;
+		arena->bttc = bttc;
+		i++;
+
+		if (arena->nextoff == 0)
+			break;
+	}
+	bttc->num_arenas = i;
+	bttc->nlba = cur_nlba;
+	printf("found %d BTT arena%s\n", bttc->num_arenas,
+		(bttc->num_arenas > 1) ? "s" : "");
+	free(btt_sb);
+	return ret;
+
+ out:
+	free(bttc->arena);
+	free(btt_sb);
+	return ret;
+}
+
+static int btt_create_mappings(struct btt_chk *bttc)
+{
+	struct arena_info *a;
+	int mmap_flags;
+	int i;
+
+	if (!bttc->opts->repair)
+		mmap_flags = PROT_READ;
+	else
+		mmap_flags = PROT_READ|PROT_WRITE;
+
+	for (i = 0; i < bttc->num_arenas; i++) {
+		a = &bttc->arena[i];
+		a->map.info_len = BTT_PG_SIZE;
+		a->map.info = mmap(NULL, a->map.info_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->infooff + SZ_4K);
+		if (a->map.info == MAP_FAILED) {
+			error("mmap arena[%d].info [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.info_len, a->infooff + SZ_4K, errno);
+			return -errno;
+		}
+
+		a->map.data_len = a->mapoff - a->dataoff;
+		a->map.data = mmap(NULL, a->map.data_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->dataoff + SZ_4K);
+		if (a->map.data == MAP_FAILED) {
+			error("mmap arena[%d].data [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.data_len, a->dataoff + SZ_4K, errno);
+			return -errno;
+		}
+
+		a->map.map_len = a->logoff - a->mapoff;
+		a->map.map = mmap(NULL, a->map.map_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->mapoff + SZ_4K);
+		if (a->map.map == MAP_FAILED) {
+			error("mmap arena[%d].map [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.map_len, a->mapoff + SZ_4K, errno);
+			return -errno;
+		}
+
+		a->map.log_len = a->info2off - a->logoff;
+		a->map.log = mmap(NULL, a->map.log_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->logoff + SZ_4K);
+		if (a->map.log == MAP_FAILED) {
+			error("mmap arena[%d].log [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.log_len, a->logoff + SZ_4K, errno);
+			return -errno;
+		}
+
+		a->map.info2_len = BTT_PG_SIZE;
+		a->map.info2 = mmap(NULL, a->map.info2_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->info2off + SZ_4K);
+		if (a->map.info2 == MAP_FAILED) {
+			error("mmap arena[%d].info2 [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.info2_len, a->info2off + SZ_4K, errno);
+			return -errno;
+		}
+	}
+
+	return 0;
+}
+
+static void btt_remove_mappings(struct btt_chk *bttc)
+{
+	struct arena_info *a;
+	int i;
+
+	for (i = 0; i < bttc->num_arenas; i++) {
+		a = &bttc->arena[i];
+		if (a->map.info)
+			munmap(a->map.info, a->map.info_len);
+		if (a->map.data)
+			munmap(a->map.data, a->map.data_len);
+		if (a->map.map)
+			munmap(a->map.map, a->map.map_len);
+		if (a->map.log)
+			munmap(a->map.log, a->map.log_len);
+		if (a->map.info2)
+			munmap(a->map.info2, a->map.info2_len);
+	}
+}
+
+static int btt_recover_first_sb(struct btt_chk *bttc)
+{
+	u64 offset, remaining = bttc->rawsize;
+	int rc, est_arenas = 0;
+	struct btt_sb *btt_sb;
+
+	/* Estimate the number of arenas */
+	while (remaining) {
+		if (remaining < ARENA_MIN_SIZE && est_arenas == 0)
+			return -EINVAL;
+		if (remaining > ARENA_MAX_SIZE) {
+			remaining -= ARENA_MAX_SIZE;
+			est_arenas++;
+			continue;
+		}
+		if (remaining < ARENA_MIN_SIZE)
+			break;
+		else {
+			remaining = 0;
+			est_arenas++;
+			break;
+		}
+	}
+
+	btt_sb = malloc(2 * sizeof(*btt_sb));
+	if (btt_sb == NULL)
+		return -ENOMEM;
+	/* Read the original first info block into btt_sb[0] */
+	rc = btt_read_info(bttc, &btt_sb[0], 0);
+	if (rc)
+		goto out;
+
+	/* Attepmt 1: try recovery from expected end of the first arena */
+	/*
+	 * Offset calculation has to account for btt_read_info adding the
+	 * extra 4K, so subtract it here
+	 */
+	if (est_arenas == 1)
+		offset = rounddown(bttc->rawsize - remaining, BTT_PG_SIZE) -
+			BTT_PG_SIZE - SZ_4K;
+	else
+		offset = ARENA_MAX_SIZE - BTT_PG_SIZE - SZ_4K;
+
+	printf("Attempting recover info-block using info2 at offset %#lx\n", offset);
+	rc = btt_info_read_verify(bttc, &btt_sb[1], offset);
+	if (rc == 0) {
+		rc = btt_write_info(bttc, &btt_sb[1], 0);
+		goto out;
+	}
+
+	/*
+	 * Attempt 2: From the very end of 'rawsize', try to copy the fields
+	 * that are constant in every arena (only valid when multiple arenas
+	 * are present)
+	 */
+	if (est_arenas > 1) {
+		offset = rounddown(bttc->rawsize - remaining, BTT_PG_SIZE) -
+			BTT_PG_SIZE - SZ_4K;
+		printf("Attempting to recover info-block from end offset %#lx\n", offset);
+		rc = btt_info_read_verify(bttc, &btt_sb[1], offset);
+		if (rc)
+			goto out;
+		/* copy over the arena0 specific fields from btt_sb[0] */
+		btt_sb[1].flags = btt_sb[0].flags;
+		btt_sb[1].external_nlba = btt_sb[0].external_nlba;
+		btt_sb[1].internal_nlba = btt_sb[0].internal_nlba;
+		btt_sb[1].nextoff = btt_sb[0].nextoff;
+		btt_sb[1].dataoff = btt_sb[0].dataoff;
+		btt_sb[1].mapoff = btt_sb[0].mapoff;
+		btt_sb[1].logoff = btt_sb[0].logoff;
+		btt_sb[1].info2off = btt_sb[0].info2off;
+		btt_sb[1].checksum = btt_sb[0].checksum;
+		rc = btt_info_verify(bttc, &btt_sb[1]);
+		if (rc == 0) {
+			rc = btt_write_info(bttc, &btt_sb[1], 0);
+			goto out;
+		}
+	}
+
+	/*
+	 * Attempt 3: use info2off as-is, and check if we find a valid info
+	 * block at that location.
+	 */
+	offset = le32_to_cpu(btt_sb[0].info2off);
+	if (offset > min((bttc->rawsize - BTT_PG_SIZE - SZ_4K),
+			(ARENA_MAX_SIZE - BTT_PG_SIZE - SZ_4K))) {
+		rc = -ENXIO;
+		goto out;
+	}
+	if (offset) {
+		printf("Attempting to recover info-block from info2 offset (as-is) %#lx\n", offset);
+		rc = btt_info_read_verify(bttc, &btt_sb[1], offset);
+		if (rc == 0) {
+			rc = btt_write_info(bttc, &btt_sb[1], 0);
+			goto out;
+		}
+	} else
+		rc = -ENXIO;
+ out:
+	free(btt_sb);
+	return rc;
+}
+
+int namespace_check(struct ndctl_region *region, struct ndctl_namespace *ndns,
+		struct check_opts *opts)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	int raw_mode, rc, disabled_flag = 0, open_flags;
+	struct btt_chk *bttc;
+	struct btt_sb *btt_sb;
+	char path[50];
+
+	printf("checking %s\n", devname);
+	if (util_namespace_active(ndns)) {
+		if (opts->force) {
+			rc = ndctl_namespace_disable_invalidate(ndns);
+			if (rc)
+				return rc;
+			disabled_flag = 1;
+		} else {
+			error("%s: check aborted, namespace online\n", devname);
+			return -EBUSY;
+		}
+	}
+
+	/* In typical usage, the current raw_mode should be false. */
+	raw_mode = ndctl_namespace_get_raw_mode(ndns);
+
+	/*
+	 * Putting the namespace into raw mode will allow us to access
+	 * the btt metadata.
+	 */
+	rc = ndctl_namespace_set_raw_mode(ndns, 1);
+	if (rc < 0) {
+		error("%s: failed to set the raw mode flag: %d\n", devname, rc);
+		goto out;
+	}
+	/*
+	 * Now enable the namespace.  This will result in a pmem device
+	 * node showing up in /dev that is in raw mode.
+	 */
+	rc = ndctl_namespace_enable(ndns);
+	if (rc != 0) {
+		error("%s: failed to enable in raw mode: %d\n", devname, rc);
+		goto out;
+	}
+
+	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
+
+	btt_sb = malloc(sizeof(*btt_sb));
+	if (btt_sb == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	bttc = calloc(1, sizeof(*bttc));
+	if (bttc == NULL) {
+		rc = -ENOMEM;
+		goto out_sb;
+	}
+	bttc->path = path;
+	bttc->opts = opts;
+	bttc->rawsize = ndctl_namespace_get_size(ndns);
+	ndctl_namespace_get_uuid(ndns, bttc->parent_uuid);
+
+	if (!bttc->opts->repair)
+		open_flags = O_RDONLY|O_EXCL;
+	else
+		open_flags = O_RDWR|O_EXCL;
+
+	bttc->fd = open(bttc->path, open_flags);
+	if (bttc->fd < 0) {
+		error("unable to open %s: %s\n", bttc->path, strerror(errno));
+		rc = -errno;
+		goto out_bttc;
+	}
+
+	rc = btt_info_read_verify(bttc, btt_sb, 0);
+	if (rc) {
+		rc = btt_recover_first_sb(bttc);
+		if (rc) {
+			inform("Unable to recover any BTT info blocks, aborting\n");
+			goto out_close;
+		}
+		rc = btt_info_read_verify(bttc, btt_sb, 0);
+		if (rc)
+			goto out_close;
+	}
+	rc = btt_discover_arenas(bttc);
+	if (rc)
+		goto out_close;
+
+	rc = btt_create_mappings(bttc);
+	if (rc)
+		goto out_close;
+
+	rc = btt_check_arenas(bttc);
+
+	btt_remove_mappings(bttc);
+ out_close:
+	close(bttc->fd);
+ out_bttc:
+	free(bttc);
+ out_sb:
+	free(btt_sb);
+ out:
+	ndctl_namespace_set_raw_mode(ndns, raw_mode);
+	ndctl_namespace_disable_invalidate(ndns);
+	if (disabled_flag)
+		if(ndctl_namespace_enable(ndns) < 0)
+			inform("%s: failed to re-enable the namespace\n",
+				devname);
+	return rc;
+}
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 46d651e..e64e0bc 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -28,6 +28,7 @@
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
+#include "check.h"
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -37,6 +38,7 @@
 
 static bool verbose;
 static bool force;
+static bool repair;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
@@ -112,6 +114,10 @@ OPT_STRING('a', "align", &param.align, "align", \
 	"specify the namespace alignment in bytes (default: 2M)"), \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
 
+#define CHECK_OPTIONS() \
+OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
+OPT_BOOLEAN('f', "force", &force, "check namespace even if currently active")
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -130,11 +136,18 @@ static const struct option create_options[] = {
 	OPT_END(),
 };
 
+static const struct option check_options[] = {
+	BASE_OPTIONS(),
+	CHECK_OPTIONS(),
+	OPT_END(),
+};
+
 enum namespace_action {
 	ACTION_ENABLE,
 	ACTION_DISABLE,
 	ACTION_CREATE,
 	ACTION_DESTROY,
+	ACTION_CHECK,
 };
 
 static int set_defaults(enum namespace_action mode)
@@ -268,8 +281,26 @@ static const char *parse_namespace_options(int argc, const char **argv,
 	rc = set_defaults(mode);
 
 	if (argc == 0 && mode != ACTION_CREATE) {
-		error("specify a namespace to %s, or \"all\"\n",
-				mode == ACTION_ENABLE ? "enable" : "disable");
+		char *action_string;
+
+		switch (mode) {
+			case ACTION_ENABLE:
+				action_string = "enable";
+				break;
+			case ACTION_DISABLE:
+				action_string = "disable";
+				break;
+			case ACTION_DESTROY:
+				action_string = "destroy";
+				break;
+			case ACTION_CHECK:
+				action_string = "check";
+				break;
+			default:
+				action_string = "<>";
+				break;
+		}
+		error("specify a namespace to %s, or \"all\"\n", action_string);
 		rc = -EINVAL;
 	}
 	for (i = mode == ACTION_CREATE ? 0 : 1; i < argc; i++) {
@@ -823,6 +854,7 @@ static int do_xaction_namespace(const char *namespace,
 	struct ndctl_namespace *ndns, *_n;
 	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
+	struct check_opts opts;
 	const char *ndns_name;
 	struct ndctl_bus *bus;
 
@@ -877,6 +909,14 @@ static int do_xaction_namespace(const char *namespace,
 				case ACTION_DESTROY:
 					rc = namespace_destroy(region, ndns);
 					break;
+				case ACTION_CHECK:
+					opts.verbose = verbose;
+					opts.repair = repair;
+					opts.force = force;
+					rc = namespace_check(region, ndns, &opts);
+					if (rc < 0)
+						return rc;
+					break;
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc < 0)
@@ -995,3 +1035,25 @@ int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 		return 0;
 	}
 }
+
+int cmd_check_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
+{
+	char *xable_usage = "ndctl check-namespace <namespace> [<options>]";
+	const char *namespace = parse_namespace_options(argc, argv,
+			ACTION_CHECK, check_options, xable_usage);
+	int checked;
+
+	checked = do_xaction_namespace(namespace, ACTION_CHECK, ctx);
+	if (checked < 0) {
+		fprintf(stderr, "error checking namespaces: %s\n",
+				strerror(-checked));
+		return checked;
+	} else if (checked == 0) {
+		fprintf(stderr, "checked 0 namespaces\n");
+		return 0;
+	} else {
+		fprintf(stderr, "checked %d namespace%s\n", checked,
+				checked > 1 ? "s" : "");
+		return 0;
+	}
+}
diff --git a/ndctl/check.h b/ndctl/check.h
new file mode 100644
index 0000000..e669192
--- /dev/null
+++ b/ndctl/check.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _CHECK_H
+#define _CHECK_H
+
+#include <ccan/endian/endian.h>
+#include <ccan/short_types/short_types.h>
+
+#define BTT_SIG_LEN 16
+#define BTT_SIG "BTT_ARENA_INFO\0"
+#define MAP_TRIM_SHIFT 31
+#define MAP_ERR_SHIFT 30
+#define MAP_LBA_MASK (~((1 << MAP_TRIM_SHIFT) | (1 << MAP_ERR_SHIFT)))
+#define MAP_ENT_NORMAL 0xC0000000
+#define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
+#define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
+#define BTT_PG_SIZE 4096
+#define IB_FLAG_ERROR_MASK 0x00000001
+
+struct log_entry {
+	le32 lba;
+	le32 old_map;
+	le32 new_map;
+	le32 seq;
+	le64 padding[2];
+};
+
+struct btt_sb {
+	u8 signature[BTT_SIG_LEN];
+	u8 uuid[16];
+	u8 parent_uuid[16];
+	le32 flags;
+	le16 version_major;
+	le16 version_minor;
+	le32 external_lbasize;
+	le32 external_nlba;
+	le32 internal_lbasize;
+	le32 internal_nlba;
+	le32 nfree;
+	le32 infosize;
+	le64 nextoff;
+	le64 dataoff;
+	le64 mapoff;
+	le64 logoff;
+	le64 info2off;
+	u8 padding[3968];
+	le64 checksum;
+};
+
+struct free_entry {
+	u32 block;
+	u8 sub;
+	u8 seq;
+};
+
+struct arena_map {
+	struct btt_sb *info;
+	size_t info_len;
+	void *data;
+	size_t data_len;
+	u32 *map;
+	size_t map_len;
+	struct log_entry *log;
+	size_t log_len;
+	struct btt_sb *info2;
+	size_t info2_len;
+};
+
+struct check_opts {
+	bool verbose;
+	bool force;
+	bool repair;
+};
+
+struct btt_chk {
+	char *path;
+	int fd;
+	uuid_t parent_uuid;
+	unsigned long long rawsize;
+	unsigned long long nlba;
+	int num_arenas;
+	struct arena_info *arena;
+	struct check_opts *opts;
+};
+
+
+struct arena_info {
+	struct arena_map map;
+	u64 size;	/* Total bytes for this arena */
+	u64 external_lba_start;
+	u32 internal_nlba;
+	u32 internal_lbasize;
+	u32 external_nlba;
+	u32 external_lbasize;
+	u32 nfree;
+	u16 version_major;
+	u16 version_minor;
+	u64 nextoff;
+	u64 infooff;
+	u64 dataoff;
+	u64 mapoff;
+	u64 logoff;
+	u64 info2off;
+	u32 flags;
+	int num;
+	struct btt_chk *bttc;
+};
+
+int namespace_check(struct ndctl_region *region, struct ndctl_namespace *ndns,
+		struct check_opts *opts);
+
+#endif
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 80a0491..0678a9a 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -57,6 +57,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-namespace", cmd_disable_namespace },
 	{ "create-namespace", cmd_create_namespace },
 	{ "destroy-namespace", cmd_destroy_namespace },
+	{ "check-namespace", cmd_check_namespace },
 	{ "enable-region", cmd_enable_region },
 	{ "disable-region", cmd_disable_region },
 	{ "enable-dimm", cmd_enable_dimm },
diff --git a/util/usage.c b/util/usage.c
index 9e0da8a..3c4a0f3 100644
--- a/util/usage.c
+++ b/util/usage.c
@@ -40,12 +40,18 @@ static void warn_builtin(const char *warn, va_list params)
 	report(" Warning: ", warn, params);
 }
 
+static void info_builtin(const char *info, va_list params)
+{
+	report(" Info: ", info, params);
+}
+
 /* If we are in a dlopen()ed .so write to a global variable would segfault
  * (ugh), so keep things static. */
 static void (*usage_routine)(const char *err) NORETURN = usage_builtin;
 static void (*die_routine)(const char *err, va_list params) NORETURN = die_builtin;
 static void (*error_routine)(const char *err, va_list params) = error_builtin;
 static void (*warn_routine)(const char *err, va_list params) = warn_builtin;
+static void (*info_routine)(const char *err, va_list params) = info_builtin;
 
 void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN)
 {
@@ -84,3 +90,12 @@ void warning(const char *warn, ...)
 	warn_routine(warn, params);
 	va_end(params);
 }
+
+void inform(const char *info, ...)
+{
+	va_list params;
+
+	va_start(params, info);
+	info_routine(info, params);
+	va_end(params);
+}
diff --git a/util/util.h b/util/util.h
index e0e5f26..5680033 100644
--- a/util/util.h
+++ b/util/util.h
@@ -23,6 +23,13 @@
 
 #define alloc_nr(x) (((x)+16)*3/2)
 
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
@@ -44,6 +51,7 @@
 #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
 
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
@@ -55,6 +63,7 @@ void usage(const char *err) NORETURN;
 void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
 int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
 void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
+void inform(const char *err, ...) __attribute__((format (printf, 1, 2)));
 void set_die_routine(void (*routine)(const char *err, va_list params) NORETURN);
 char *xstrdup(const char *str);
 void *xrealloc(void *ptr, size_t size);
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
