Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEACB359A6F
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384918; cv=none; b=baObH+L2bywYPbwLyRHqdGnBd3eNDuiUsFQFB/lxrhE3Qzy1kSSHvdRTmMPN0FalQyJG/DWwSUEbJw4fTa/FbNnC55MraDfBvMPWAhmFkMJmOJCtCsaP4NowBKDwQOKeKvnHA7GlTAZRf2fTzBHL8bDYwrhKMlLhi/Xmlm03a8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384918; c=relaxed/simple;
	bh=G+QH8Mv1sXQkYn6Q3gMncHpGBiuFGlEP3qvmnf0X4TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtQLxZzMgfOAN2JpPOcnSCJ8CdtGgKmhDGJZKA3t1BpO2yeSOI/Lh8MFGbcXsb1GNO2FiZElDYA/jx/JKzXeHlOumP5VTDHsisQGph2DHTlrnA3RDp6IFSj6niRQpBYqc7oAeXBCcqSOOC7yklj0Fo8+t4G819NNd2gv3h4qOR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=gGKNYGjE; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="gGKNYGjE"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D42B8D0F68;
	Tue, 02 Jun 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384411;
	bh=jKADVtROf0vQ43aH1Xe6H1MxCOHUxw7qwH7HL4aVwN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGKNYGjEIbcIJJ8/BH414muQKgbnvibQo1farJStD+pOyV3SS+WJ5obh8FA9JZ2Uo
	 tTE0N0GsrgOx1gBSMKm2GP6j9ZgCzHDc2JXw8on2mXJ9Wj2cHhX49cGaqJleS2KbHE
	 dCToWVoqbZtw1amijeqFNXMIWnAuMm9B1Q+k41oE=
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
Subject: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Date: Tue,  2 Jun 2026 07:12:52 +0000
Message-ID: <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add __nonnull_args() to unconditional guard constructors so the compiler
warns when NULL is statically known to be passed:

- DEFINE_GUARD(): re-declare the constructor with __nonnull_args().
- __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.

DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
pointer arguments (.lock is hardcoded to (void *)1).

Define the __nonnull_args() macro in compiler_attributes.h, following
the existing convention for attribute wrappers. Deliberately not named
'__nonnull', to avoid clashing with glibc's __nonnull() when kernel and
userspace headers are combined (User Mode Linux for example).

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
Miguel, I dropped your Acked-by due to the rename. Went with
__nonnull_args() (over __knonnull()). Happy to restore your tag if that
spelling works for you.

 include/linux/cleanup.h             | 4 +++-
 include/linux/compiler_attributes.h | 9 +++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index ea95ca4bc11c..4e60d519713c 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,6 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
+	static __always_inline __nonnull_args() _type class_##_name##_constructor(_type _T); \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
@@ -497,7 +498,8 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
-static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
+static __always_inline __nonnull_args()					\
+class_##_name##_t class_##_name##_constructor(_type *l)			\
 	__no_context_analysis						\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index c16d4199bf92..cffe09387ea6 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -230,6 +230,15 @@
  */
 #define   noinline                      __attribute__((__noinline__))
 
+/*
+ * Note: deliberately not named '__nonnull', to avoid clashing with glibc's
+ * __nonnull() when kernel and userspace headers are combined.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
+ */
+#define __nonnull_args(x...)		__attribute__((__nonnull__(x)))
+
 /*
  * Optional: only supported since gcc >= 8
  * Optional: not supported by clang
-- 
2.53.0-Meta

