Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D9C3D8117
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780656428; cv=none; b=vGsz2To/pbvqbHAgr5LCH05ac1f1f40/EWb/wXK0s0Lq9ZuuzsroI3hHLH8RLO171YBNOpz205WnTVu4qojIRtGpfu35RZN71zQj19PLjdlEld68ALXKtsV6Ya4XJ7vHgPjzlzhOxtoYg9BWYBQLpwmfd1sTqghBNLE2mnKyHqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780656428; c=relaxed/simple;
	bh=GZEtDnuHNmDYCcYZbUIDDaq6IWHhusLGd1LPT18zCno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n36wTp6lmsHY5bX7FXCcwSYIWEqSrf9NlWUdnPNM3mi0TqdtwWu3IVM3wdvTymweDj75riyyL2p19MXqyaWYvKj5yftN7gbpNX5Aer1dhC4YmkGT1IPK/cBtmgq1JpGIAD7McB2yyvwes0zrkpHDYrSJ/4Rh9iBJ9EyNc64SxOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=c9a5EEXY; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="c9a5EEXY"
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 27DDED11F7;
	Fri, 05 Jun 2026 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780656419;
	bh=+zcuQvJC3/7xOL+Yo+LO6my0PF5BMauyh6lq359XSB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c9a5EEXYxNTUdd/FaPlFU+POGZlR683okhiAIY96m/VfrQD72YA/O2C15wxgYmiVd
	 9oKNkNWf1oklNIzv9f98Tchmgh5WtP/7y4h8L66m0Jg9MTFHyF6EQYnSfgpjYIlNVm
	 Z/mAdNdpLI0ZXQiEpKeNuEth9WAz/j7Nh7yvYqBA=
Date: Fri, 5 Jun 2026 10:46:55 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Message-ID: <aiKpH3cLBEj3TF2Q@shell.ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
 <aiJi0WcYE8FZt-jO@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJi0WcYE8FZt-jO@stanley.mountain>

On Fri, Jun 05, 2026 at 08:46:57AM +0300, Dan Carpenter wrote:
> On Tue, Jun 02, 2026 at 07:12:52AM +0000, Dmitry Ilvokhin wrote:
> > Add __nonnull_args() to unconditional guard constructors so the compiler
> > warns when NULL is statically known to be passed:
> > 
> > - DEFINE_GUARD(): re-declare the constructor with __nonnull_args().
> > - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> > 
> > DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> > pointer arguments (.lock is hardcoded to (void *)1).
> > 
> > Define the __nonnull_args() macro in compiler_attributes.h, following
> > the existing convention for attribute wrappers. Deliberately not named
> > '__nonnull', to avoid clashing with glibc's __nonnull() when kernel and
> > userspace headers are combined (User Mode Linux for example).
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> > Miguel, I dropped your Acked-by due to the rename. Went with
> > __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> > spelling works for you.
> > 
> 
> Sparse doesn't like an empty __nonnull_args() at all.
> 
> ./include/linux/spinlock.h:608:1: error: an expression is expected before ')'
> ./include/linux/spinlock.h:619:1: error: an expression is expected before ')'
> ./include/linux/spinlock.h:631:1: error: an expression is expected before ')'
> 
> Shouldn't we specify the arguments which are non-NULL?
> __nonnull_args(1)?

Thanks for the report, Dan.

That is interesting, it seems sparse trips over the empty-parens form
the guard macro expands to, nonnull(), but is fine with
__attribute__((nonnull)) without explicit arguments, that a few places
in-tree already use. GCC and clang accept both, so this probably
deserves a fix in sparse too.

Meanwhile, spelling the argument out explicitly is a simple and
reasonable fix (and arguably clearer). Patch below.

From 50f7e7eaad1d33773cee9a278625fdb4b451f53b Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Fri, 5 Jun 2026 03:06:22 -0700
Subject: [PATCH] cleanup: Specify nonnull argument index

The guard constructors were annotated with an empty __nonnull_args(),
relying on __nonnull__() marking every pointer parameter as non-NULL.
Sparse cannot parse the empty argument list.

Both constructors take the lock pointer as their first parameter, so
specify the index explicitly: __nonnull_args(1).

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/aiJi0WcYE8FZt-jO@stanley.mountain/
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 65416938e318..b1b5698cbf1b 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -397,7 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 	__DEFINE_GUARD_LOCK_PTR(_name, _T)
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
-	static __always_inline __nonnull_args() _type class_##_name##_constructor(_type _T); \
+	static __always_inline __nonnull_args(1) _type class_##_name##_constructor(_type _T); \
 	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
@@ -498,7 +498,7 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
-static __always_inline __nonnull_args()					\
+static __always_inline __nonnull_args(1)				\
 class_##_name##_t class_##_name##_constructor(_type *l)			\
 	__no_context_analysis						\
 {									\
-- 
2.53.0-Meta

