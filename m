Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9737F755
	for <nvdimm@lists.linux.dev>; Thu, 21 May 2026 07:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347904; cv=none; b=F4sndlLKfpxFtoYadtespcQr7+J3EUBqbphJhBudfo/2yLcQUcyxadgkjGdylaHchxjgH3R4lmlY/gGArNUSnm8269h9JFD4J0HyjR7X3etReI6SjsiJiO8fRswGhoetzj+Otokv6n33benqeNLOMK3NmfbKaBVeisjt6uoj3PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347904; c=relaxed/simple;
	bh=/B5HMV10BlZCudz8MDHeJBUBcrR5exaW2uy8l9BUG3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWgOXgSP5nWPA6XKJ51kpOJiGjkCU9DoZiW8XxAQVfZggGST486cP3ZI2+ot8MQrc36XHrS2xORsCUv4+8f6ctcOjxHy5BenrsbQv9Jps5CftedNxZN0FmR2lHa8xNaGTD/mJrQGBE5ZDhb+yR8sbwMrdlBvvGtjQDv5GKeNFUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=0BhumtCI; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="0BhumtCI"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4FE9DD0930;
	Thu, 21 May 2026 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347901;
	bh=3PMlovbl5QDd8E52nk+/Gka5Rv5cUQE0QYmiAeICQTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BhumtCI3qt/nu8cGcm5GhsrGynk+LBJqztZWuBaRC6ZU7E3w2/aFMfW3XWci4t0v
	 +WKKnawSUSNlXv4McrTVCMJDXWM7Q4XyokhEhZhLyFTx5Ja7s8P+2G6vW536CZ9o5T
	 6+Nd9cVrtY2tOdDJls1rqKmQ/uWjk/vjDc2oYFa4=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 3/4] cleanup: Annotate guard constructors with __nonnull()
Date: Thu, 21 May 2026 07:18:03 +0000
Message-ID: <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add __nonnull() to unconditional guard constructors so the compiler
warns when NULL is statically known to be passed:

- DEFINE_GUARD(): re-declare the constructor with __nonnull().
- __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.

DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
pointer arguments (.lock is hardcoded to (void *)1).

Define the __nonnull() macro in compiler_attributes.h, following the
existing convention for attribute wrappers.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/cleanup.h             | 4 +++-
 include/linux/compiler_attributes.h | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index ea95ca4bc11c..8f8d588b5595 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,6 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
+	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
@@ -497,7 +498,8 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
-static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
+static __always_inline __nonnull()					\
+class_##_name##_t class_##_name##_constructor(_type *l)			\
 	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index c16d4199bf92..10a1410eb3e2 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -230,6 +230,12 @@
  */
 #define   noinline                      __attribute__((__noinline__))
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
+ */
+#define __nonnull(x...)			__attribute__((__nonnull__(x)))
+
 /*
  * Optional: only supported since gcc >= 8
  * Optional: not supported by clang
-- 
2.53.0-Meta

