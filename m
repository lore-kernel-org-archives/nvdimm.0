Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8813403F8
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384918; cv=none; b=DAICBv0QgrugeMNMK49NdcM7WGzQcvYWS4Fz5nT2/vgg3wLmS5X0PGZgVpsWCk94dQFzzCHktIiQPKhBuHwyro/iKpcl+MJMbF+TSTx1hXA3R4KsfqBMT8OZTWgOqE/SPRdAVDwKiBBMAyL5gg2E6KlQ7Vv71Ew+8c6GvrE/dtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384918; c=relaxed/simple;
	bh=mcvj+8lOeLGrpyvRQQKjTlbXgdUQb58WT2ZOQaIZbvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVIhGPa5uuX/LT8B9mkIvYb+s/Ccz9MggHXiHYGicv1C+D2tFzLiD/iWwcyEcCR0w+DfU1YBJ/ijA5ZAuvv4wDYsSg/ipmBWygpKj2KeKHEzu6ZjUvOeg5/lh3GzLCQAlhrDY53RvpF6KYCeNDGQVcoQu8tMzSJ+iSx7NFLnqpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=O5PmzJPQ; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="O5PmzJPQ"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 29631D0F6C;
	Tue, 02 Jun 2026 07:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384411;
	bh=wLXXDlJ/Kxp3Cp2KJoa7FnY+i+nRO7rY9YwMwddxJq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5PmzJPQQm9wQcEZ2Jqis/QLMEQOkkjveUjH0SpE2xGnFIA/WeL8h25Z6fWKhp+Uo
	 SR2OjmkoIyffFaGReFL1Wzn2jWkgJFvTSJDAcAqfaJ3dOiTOWfKaGcGO+lbK1zDFJR
	 EqvxDWzR2ygXNycgzNDV3NlplOHbGlc+D0dg6iTs=
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
Subject: [PATCH v5 4/4] cleanup: Remove NULL check from unconditional guards
Date: Tue,  2 Jun 2026 07:12:53 +0000
Message-ID: <0503a089389b2270c478a873e095cf0a4ff26d24.1780064327.git.d@ilvokhin.com>
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
index 4e60d519713c..65416938e318 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -398,7 +398,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	static __always_inline __nonnull_args() _type class_##_name##_constructor(_type _T); \
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

