Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDF238228B
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 12:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885050; cv=none; b=u4+NAr5lRXD8AMH7qucDTyCBtU3DdZeud99ofGiuLeDwG1zs3PTQJgbjiDdZVl0702CvOThkv9PeL30cpjsd4GmiOm8rrg0FZx3yYRuHp6IrQI7K6KOMqlkDuuNNzL2bWFoAJpR1DEC0VTfiQl5sr/wRmmJ/b4ptXO+LWAwbasE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885050; c=relaxed/simple;
	bh=OVfBB3C8yIrSAzQvJGEl8Us6CHCtmTWW6EcO3NyhgFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCMUJTYoDWEb/uY2pVhcFnX5NFbVZ+m9GxFn/bU3/F8SGe0uho+Ru2c0JUwZANLAbrkCCteLMPkvV/o00qzHBhL1BSLBZwm8064iS65o13j/bN6TDS0Pj6G5cl+A/8NR/xolGbvOMFNBr6VgrtFom98wmXqSRI39pYSOeZCYwIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=xuYR9/c6; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="xuYR9/c6"
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id C17A9D0CF9;
	Wed, 27 May 2026 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779885047;
	bh=N/POtajBoUC3mFgumqgLA3FGG1S8oPKBOTiGe1Z230s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xuYR9/c6ST25csVo6ZStcfjbm+kUWzldNx2yWwJhOlAki++quTWs40fv4A5uToe5/
	 sQ+Uxj1uNRRueZcFHjPvRxTZgez4Nb8r1sVWOHrF9XjROTkbJLiNnYYFKdiDTFJS3I
	 8ElLpfpJtWX8Q6AxaVQUzxJA4rTYThRSdaGHfpqI=
Date: Wed, 27 May 2026 12:30:43 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <ahbj86sKJON-41GF@shell.ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
 <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
 <CANiq72mZn7GZ6TbNoSuVUXsprJSrpPWA9oAcUQrYzzCj-dFnew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mZn7GZ6TbNoSuVUXsprJSrpPWA9oAcUQrYzzCj-dFnew@mail.gmail.com>

On Tue, May 26, 2026 at 07:54:16PM +0200, Miguel Ojeda wrote:
> On Tue, May 26, 2026 at 5:13 PM Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >
> > They usually don't collide, except for User Mode Linux builds, which
> > include both kernel and userspace headers.
> 
> :(
> 
> What about other similar names? i.e. a variation of your option 2,
> e.g. just `nonnull` (we also have others like that, i.e. no
> underscore, e.g. `noinline`), or `___nonnull` (triple underscore, but
> may be confusing), or a suffix/prefix letter, e.g. `__knonnull` (for
> kernel nonnull)...
> 
> i.e. it would be nice to have a "standard" spelling for ourselves, and
> also replace the existing `__attribute__((nonnull))`s we have
> elsewhere in the tree.

Yes, a different name might work as well. The main question is which
name to pick.

Plain nonnull() is a bit dangerous. It might collide with existing
identifiers (now or in the future) and is not great for a kernel-wide
macro. I think we got away with plain noinline, because it was there
forever. There are also at least 24 nonnull attribute usages in the
kernel that need to be converted atomically. This can be done, but it
increases the scope of the patchset, which I'd rather avoid.

___nonnull() with triple underscore might be a bit confusing, I agree.

__knonnull() might work. I like __nonnull_args() better: it gives the
reader a hint about the semantics, while __knonnull() is just a
collision-avoidance trick without conveying any additional meaning. That
being said, I can totally do __knonnull().

> 
> Cheers,
> Miguel
