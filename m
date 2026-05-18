Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347A378825
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779117718; cv=none; b=XpWcYT27KLF/evF/Fkk0hNupX57dRVf/gpDSBCxkKdXRZOa5o17brGNP58RkLdQr54/KTTqCn74d/BbnLyHCEXIKMSOhActorv64qNVJy/B+3W4arZzVggtuBbMdTKV2IDQ8ml2vcSa0iB5Ma3gjciw0RfFEpqyjn9hnHyEx5Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779117718; c=relaxed/simple;
	bh=U46C/BpM2vEnvjIIsJtWek75An3X80SCFk7DqgK5MC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYEjLT6bqyPHdbOJINqm1RreAGUd2GfzrReyQVbN9yiYqPhW14JbvnAmxiFER/HbtvpauEZs6moeyAvopq5zqlKqAnd2OicvBxroBAvxPvoj1lprzcgTnkf+pW+s/MK7QZpgwCRpjKN1u2feFENvqKtQ51eGeiZ+QkPI9hpKf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=yhlEb+F3; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="yhlEb+F3"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id CEEA5D0748;
	Mon, 18 May 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779117710;
	bh=H0ERgf6l48k7n+RO+vxMZwZ2/ZJGp5WzvOOMr4YqH/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhlEb+F3dkiBTEdGUmXOrLopbvO2vdxDXaIMh60I5Zs+WRbdQf6tiMg/lbqqujfQQ
	 wh+OnH7kP11vAxgLRybOnRiYFjQoY5oftKGKTT5Wgd71k0uw5lBn5masXTlEmXuV2N
	 hvUIKvvZ6T27GzOlkuGV9cYLDVa+awY/E/yx16WY=
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
Subject: [PATCH v3 4/4] cleanup: Remove NULL check from unconditional guards
Date: Mon, 18 May 2026 15:21:30 +0000
Message-ID: <bb5ae15641b6930b779620265aea3c55b4ea6ef5.1779116497.git.d@ilvokhin.com>
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

The unconditional guard destructors check whether the lock pointer is
NULL before unlocking. This check is dead code because unconditional
guards guarantee a non-NULL lock pointer at destructor time.

DEFINE_GUARD() runs the lock operation unconditionally in the
constructor. If the pointer were NULL, the lock operation (e.g.
mutex_lock(NULL)) would crash before the constructor returns. The
destructor never runs with a NULL pointer. All DEFINE_GUARD() users
dereference the pointer in their lock. Verified by auditing every
instance found by: git grep -n -A 1 'DEFINE_GUARD('. The only exception
is xe_pm_runtime_release_only, whose constructor is a noop, but it has
no callers.

__DEFINE_UNLOCK_GUARD() has only a few usages outside of
include/linux/cleanup.h: tty_port_tty (NULL-checks in its tty_kref_put()
call), irqdesc_lock (fixed earlier) and two guards in
kernel/sched/sched.h (dereference the pointer unconditionally in their
lock constructors).

DEFINE_LOCK_GUARD_1() sets .lock from its argument and runs the lock
operation in the constructor. Same reasoning applies. All
DEFINE_LOCK_GUARD_1() users dereference the pointer in their lock. Also,
verified by auditing every match of: git grep -n 'DEFINE_LOCK_GUARD_1('.

DEFINE_LOCK_GUARD_0() hardcodes .lock = (void *)1 in the constructor,
so it is never NULL by construction.

Conditional (_try) variants: DEFINE_GUARD_COND() and
DEFINE_LOCK_GUARD_1_COND() use EXTEND_CLASS_COND(), whose wrapper
destructor returns early when the lock was not acquired, before reaching
the base destructor since commit 2deccd5c862a ("cleanup: Optimize
guards"):

    if (_cond) return; class_##_name##_destructor(_T);

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 8f8d588b5595..1f6d1a97617a 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -398,7 +398,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
-	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
 #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
@@ -492,7 +492,7 @@ typedef struct {							\
 static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 	__no_context_analysis						\
 {									\
-	if (_T->lock) { _unlock; }					\
+	_unlock;							\
 }									\
 									\
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
-- 
2.53.0-Meta

