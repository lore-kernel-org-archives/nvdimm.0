Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0390937882A
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779117719; cv=none; b=UoP6Y+aNA4lSyXpNEFzo/FOVP5fuonJfGFHRLPXdjga61++AHdke6xd542ikOWhIG94syyJil6csVlWKbtvlyr3HG9rgGvXx/uGoCE2g7fv0gnoG2FV7QXAnrzOtIwLQqVWiKpYSjOsVk9GIPhpsRw85ISNMH6V8eBO4okTwC9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779117719; c=relaxed/simple;
	bh=V4q/SYkOeuRKvJr2ZtDhjkO/nACQTKyR+XkRLC8de9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSFidSXrWl+gD0yieMeXH4cqwBEk6Bgw+sdzaL14rEQ4jOLmXlr+te/aKTYKMU/2CHOiCE6zT7winXbAAliKhoFEDuOW59cmgp/ZQa0DgOyfoJ9whEH6PmKCb7YhBj7grlvPuM1Kebqg95tu/W9/u3nTNIswlzg8aHaHEsJhbQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=dLKjMx8C; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="dLKjMx8C"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 929F3D0744;
	Mon, 18 May 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779117709;
	bh=N2a1OThy1n23ro/uvU4wqNdlrb58ANUh0JllmehKuio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLKjMx8CbTCWtm9Ls3ZrjaABN5yHjxKv24qBFc5UFxy7eEghdKxMmwNR/ANgjGpXi
	 MtLGmS9zBmTEto3IvSda78JmGobDL6sOgyzZep83eBougy+06BJgW0Li/fjFK1cdS9
	 VxLkBQZM8W0AxAizx9BNEWYQFu47RUXGMYuNuqlE=
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
Subject: [PATCH v3 3/4] cleanup: Annotate guard constructors with __nonnull()
Date: Mon, 18 May 2026 15:21:29 +0000
Message-ID: <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779116497.git.d@ilvokhin.com>
References: <cover.1779116497.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add __nonnull() to unconditional guard constructors so the compiler
verifies at each call site that NULL is never passed:

- DEFINE_GUARD(): re-declare the constructor with __nonnull().
- __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.

DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
pointer arguments (.lock is hardcoded to (void *)1).

This provides automated, compiler-enforced verification that no
unconditional guard constructor receives NULL.

Define the __nonnull() macro in compiler_attributes.h, following the
existing convention for attribute wrappers.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
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
index c16d4199bf92..85f08d6137a2 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -176,6 +176,12 @@
  */
 #define __mode(x)                       __attribute__((__mode__(x)))
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-nonnull-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
+ */
+#define __nonnull(x...)			__attribute__((__nonnull__(x)))
+
 /*
  * Optional: only supported since gcc >= 7
  *
-- 
2.53.0-Meta

