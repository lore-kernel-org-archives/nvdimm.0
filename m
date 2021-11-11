Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181692C8E
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:56 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253824"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253824"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:53 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579053"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:53 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 04/16] util: add the struct_size() helper from the kernel
Date: Thu, 11 Nov 2021 13:44:24 -0700
Message-Id: <20211111204436.1560365-5-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3386; h=from:subject; bh=yl0QoKztnEmVyVJpluvTFG+R54SauuTnM8pt39TqsFI=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DRunfWZvO/Z6QprtlIaYuy+WPVbbZ/qK1XnpvkUv1V9l 1koe6yhlYRDjYJAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEdnkw/LN+zqmq/nwlj/WpLT9PHn tx5offw6aiK0vXxdv/rtxR0vyB4Z/9O+eXCVyZ9SxKIUZT/sXWLzOP04l1VemNVj/GnOAkxgsA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add struct_size() from include/linux/overflow.h which calculates the
size of a struct with a trailing variable length array.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/size.h | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/util.h |  6 ++++++
 2 files changed, 68 insertions(+)

diff --git a/util/size.h b/util/size.h
index 646edae..a0f3593 100644
--- a/util/size.h
+++ b/util/size.h
@@ -4,6 +4,8 @@
 #ifndef _NDCTL_SIZE_H_
 #define _NDCTL_SIZE_H_
 #include <stdbool.h>
+#include <stdint.h>
+#include <util/util.h>
 
 #define SZ_1K     0x00000400
 #define SZ_4K     0x00001000
@@ -30,4 +32,64 @@ static inline bool is_power_of_2(unsigned long long v)
 #define BITS_PER_LONG (sizeof(unsigned long) * 8)
 #define HPAGE_SIZE (2 << 20)
 
+/*
+ * Helpers for struct_size() copied from include/linux/overflow.h (GPL-2.0)
+ *
+ * For simplicity and code hygiene, the fallback code below insists on
+ * a, b and *d having the same type (similar to the min() and max()
+ * macros), whereas gcc's type-generic overflow checkers accept
+ * different types. Hence we don't just make check_add_overflow an
+ * alias for __builtin_add_overflow, but add type checks similar to
+ * below.
+ */
+#define check_add_overflow(a, b, d) (({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_add_overflow(__a, __b, __d);	\
+}))
+
+#define check_mul_overflow(a, b, d) (({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_mul_overflow(__a, __b, __d);	\
+}))
+
+/*
+ * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for
+ * struct_size() below.
+ */
+static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(a, b, &bytes))
+		return SIZE_MAX;
+	if (check_add_overflow(bytes, c, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+/**
+ * struct_size() - Calculate size of structure with trailing array.
+ * @p: Pointer to the structure.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array.
+ *
+ * Calculates size of memory needed for structure @p followed by an
+ * array of @count number of @member elements.
+ *
+ * Return: number of bytes needed or SIZE_MAX on overflow.
+ */
+#define struct_size(p, member, count)					\
+	__ab_c_size(count,						\
+		    sizeof(*(p)->member) + __must_be_array((p)->member),\
+		    sizeof(*(p)))
+
 #endif /* _NDCTL_SIZE_H_ */
diff --git a/util/util.h b/util/util.h
index ae0e4e1..b2b4ae6 100644
--- a/util/util.h
+++ b/util/util.h
@@ -63,6 +63,12 @@
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
+/* Are two types/vars the same type (ignoring qualifiers)? */
+#define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
+
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
+
 enum {
 	READ, WRITE,
 };
-- 
2.31.1

