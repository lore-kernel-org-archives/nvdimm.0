Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70AC1373
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 05:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645680501; x=1677216501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/zZ7yTw1hHT2Ai7RyNEMmpKKL7pXVpOZD3bbYkTy+zI=;
  b=YvrqY8CYabnVzgkrRg+jBOlJJkoIhYYl3ewhnzkFVekpnpti5E4YcXsd
   rjNgO71kZX48hwmVYkuUIz2wAHgLTT2dC3qXPE+rjimRpWWpBvogYTM/5
   biJr7VHW/4KCh9VYCw6U4zaxKPPN2Hr5CQEhnJiPUIQRak506UZ+SLy01
   I6Qta2BDny7crkGByL9c6CA9MRQkoDwGoK5fqTwFjfeHRVm+KzSOKUx7b
   Hsz1gIDYBJRUQCS4LIHt/0yVRJoQLd81S3pi7H4NqidXMwGQIcQt7/z0R
   4zhledNEHUVu0e0/C0rOlf/jJRsPeVONKverW4hiZgBhACgi3H0fxL9LV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="249734786"
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="249734786"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:28:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="508733769"
Received: from mmgiotto-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.212.17.173])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:28:15 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	<linux-cxl@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] util/size.h: fix build for older compilers
Date: Wed, 23 Feb 2022 22:28:05 -0700
Message-Id: <20220224052805.2462449-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6909; h=from:subject; bh=/zZ7yTw1hHT2Ai7RyNEMmpKKL7pXVpOZD3bbYkTy+zI=; b=owGbwMvMwCXGf25diOft7jLG02pJDEni4hFxa4PXSU2MeVymy/rc0nBZFPPs8h+tj+c8rJymZj2l dPrejlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzEWZfhf42G6sS+lRGGbw/s2m/F+7 5+ff17bvOXWX+KXyfuj9I9+Z2RYXKB+/RnB5hOhzK8Ljyx1V13/VMNpxns2/W/ObIlP+E0ZAAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a fallback for older compilers that lack __builtin_add_overflow()
and friends. Commit 7aa7c7be6e80 ("util: add the struct_size() helper from the
kernel") which added these helpers from the kernel neglected to copy
over the fallback code.

Fixes: 7aa7c7be6e80 ("util: add the struct_size() helper from the kernel")
Reported-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/size.h | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 159 insertions(+), 4 deletions(-)

diff --git a/util/size.h b/util/size.h
index e72467f..1cb0669 100644
--- a/util/size.h
+++ b/util/size.h
@@ -6,6 +6,7 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include <util/util.h>
+#include <ccan/short_types/short_types.h>
 
 #define SZ_1K     0x00000400
 #define SZ_4K     0x00001000
@@ -43,23 +44,177 @@ static inline bool is_power_of_2(unsigned long long v)
  * alias for __builtin_add_overflow, but add type checks similar to
  * below.
  */
-#define check_add_overflow(a, b, d) (({	\
+#define is_signed_type(type)       (((type)(-1)) < (type)1)
+#define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
+#define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
+#define type_min(T) ((T)((T)-type_max(T)-(T)1))
+
+#if GCC_VERSION >= 50100
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
+
+#if __clang__ && \
+    __has_builtin(__builtin_mul_overflow) && \
+    __has_builtin(__builtin_add_overflow)
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
+
+#if COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
+
+#define check_add_overflow(a, b, d) ({		\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_add_overflow(__a, __b, __d);	\
-}))
+})
 
-#define check_mul_overflow(a, b, d) (({	\
+#define check_sub_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_sub_overflow(__a, __b, __d);	\
+})
+
+#define check_mul_overflow(a, b, d) ({		\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
 	typeof(d) __d = (d);			\
 	(void) (&__a == &__b);			\
 	(void) (&__a == __d);			\
 	__builtin_mul_overflow(__a, __b, __d);	\
-}))
+})
+
+
+#else /* !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
+
+/* Checking for unsigned overflow is relatively easy without causing UB. */
+#define __unsigned_add_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = __a + __b;			\
+	*__d < __a;				\
+})
+#define __unsigned_sub_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = __a - __b;			\
+	__a < __b;				\
+})
+/*
+ * If one of a or b is a compile-time constant, this avoids a division.
+ */
+#define __unsigned_mul_overflow(a, b, d) ({		\
+	typeof(a) __a = (a);				\
+	typeof(b) __b = (b);				\
+	typeof(d) __d = (d);				\
+	(void) (&__a == &__b);				\
+	(void) (&__a == __d);				\
+	*__d = __a * __b;				\
+	__builtin_constant_p(__b) ?			\
+	  __b > 0 && __a > type_max(typeof(__a)) / __b : \
+	  __a > 0 && __b > type_max(typeof(__b)) / __a;	 \
+})
+
+/*
+ * For signed types, detecting overflow is much harder, especially if
+ * we want to avoid UB. But the interface of these macros is such that
+ * we must provide a result in *d, and in fact we must produce the
+ * result promised by gcc's builtins, which is simply the possibly
+ * wrapped-around value. Fortunately, we can just formally do the
+ * operations in the widest relevant unsigned type (u64) and then
+ * truncate the result - gcc is smart enough to generate the same code
+ * with and without the (u64) casts.
+ */
+
+/*
+ * Adding two signed integers can overflow only if they have the same
+ * sign, and overflow has happened iff the result has the opposite
+ * sign.
+ */
+#define __signed_add_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = (u64)__a + (u64)__b;		\
+	(((~(__a ^ __b)) & (*__d ^ __a))	\
+		& type_min(typeof(__a))) != 0;	\
+})
+
+/*
+ * Subtraction is similar, except that overflow can now happen only
+ * when the signs are opposite. In this case, overflow has happened if
+ * the result has the opposite sign of a.
+ */
+#define __signed_sub_overflow(a, b, d) ({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	*__d = (u64)__a - (u64)__b;		\
+	((((__a ^ __b)) & (*__d ^ __a))		\
+		& type_min(typeof(__a))) != 0;	\
+})
+
+/*
+ * Signed multiplication is rather hard. gcc always follows C99, so
+ * division is truncated towards 0. This means that we can write the
+ * overflow check like this:
+ *
+ * (a > 0 && (b > MAX/a || b < MIN/a)) ||
+ * (a < -1 && (b > MIN/a || b < MAX/a) ||
+ * (a == -1 && b == MIN)
+ *
+ * The redundant casts of -1 are to silence an annoying -Wtype-limits
+ * (included in -Wextra) warning: When the type is u8 or u16, the
+ * __b_c_e in check_mul_overflow obviously selects
+ * __unsigned_mul_overflow, but unfortunately gcc still parses this
+ * code and warns about the limited range of __b.
+ */
+
+#define __signed_mul_overflow(a, b, d) ({				\
+	typeof(a) __a = (a);						\
+	typeof(b) __b = (b);						\
+	typeof(d) __d = (d);						\
+	typeof(a) __tmax = type_max(typeof(a));				\
+	typeof(a) __tmin = type_min(typeof(a));				\
+	(void) (&__a == &__b);						\
+	(void) (&__a == __d);						\
+	*__d = (u64)__a * (u64)__b;					\
+	(__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||	\
+	(__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
+	(__b == (typeof(__b))-1 && __a == __tmin);			\
+})
+
+
+#define check_add_overflow(a, b, d)					\
+	__builtin_choose_expr(is_signed_type(typeof(a)),		\
+			__signed_add_overflow(a, b, d),			\
+			__unsigned_add_overflow(a, b, d))
+
+#define check_sub_overflow(a, b, d)					\
+	__builtin_choose_expr(is_signed_type(typeof(a)),		\
+			__signed_sub_overflow(a, b, d),			\
+			__unsigned_sub_overflow(a, b, d))
+
+#define check_mul_overflow(a, b, d)					\
+	__builtin_choose_expr(is_signed_type(typeof(a)),		\
+			__signed_mul_overflow(a, b, d),			\
+			__unsigned_mul_overflow(a, b, d))
+
+#endif
 
 /*
  * Compute a*b+c, returning SIZE_MAX on overflow. Internal helper for

base-commit: 3e4a66f0dfb02046f6d3375d637840b6da9c71d1
-- 
2.34.1

