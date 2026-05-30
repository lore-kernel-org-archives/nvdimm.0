Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165DE2080C1
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 14:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780150077; cv=none; b=JgFA9lzXrVPKV+r7byfv2kRh8h+XBdZXeqsXWzY4YLJDiCo6LdGY0Pb+mHlO0Rg1MBI6zwtyUPKdOMoOEUbOIRTIDgoF7G7Ge3qN1/QJ855KgOcKqwBwctQPpREQkX5uoJl5/Y3pjLzbRlTFRJpx1MpX/VEDF/jOYKNv1XeI3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780150077; c=relaxed/simple;
	bh=PPZRcehItjpi1cpcwVw3Fam6REWdbTtbxGlWECVMz/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSKdbpRPQ7AEDGcXgOPyGHhAjduj9XbSexrHANT1RLhNLGpto34cjV+DKSGK5+4LmgWNUyj35fF5L8dW4RhOz01mei0XkaMBEq/PmdqtplGjsEZ7nEH6kAqd3v+/6DCR+Aa06Q9O6Py3Hsw2P4q9sM+PrSEX+ARvFbWm7q1IJvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B0484038B;
	Sat, 30 May 2026 14:02:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf16.hostedemail.com (Postfix) with ESMTPA id 5EC0C2000F;
	Sat, 30 May 2026 14:02:03 +0000 (UTC)
Date: Sat, 30 May 2026 09:02:02 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 5/7] dax: fix holder_ops race in fs_put_dax()
Message-ID: <ahrrs8hg9mTpgePM@groves.net>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191917.79204-1-john@jagalactic.com>
 <0100019e5120c6c2-6fee7a58-7fb8-4c80-a229-4b5573e0e2c0-000000@email.amazonses.com>
 <e7655b88-c56d-4d9a-8ae1-68eb9448bb87@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7655b88-c56d-4d9a-8ae1-68eb9448bb87@intel.com>
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 5EC0C2000F
X-Stat-Signature: kg8dkt3djaypmpnxhx65j73m1z17yw81
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19USd7P0xcl9bP1DKa6t3dWaWoDdTzcGL4=
X-HE-Tag: 1780149723-893019
X-HE-Meta: U2FsdGVkX19VsXy/wZRbjCsWVLy2DMbz1vvJbz7m7lHeGr9txEfQpDdgeDI2/vttb8LKaGDwiDT5JyuSCVE6qdnUHEAjXBEzB+KgjYcaB1dCJlGw3a0EFqyXCjKbPMZ+KNZWQT1hnOLGxiLvaxQra69ab2hcb2JvZbtnQfnya+xHTqnB9mCZzBWQugYsck7i2MwJrD3fb01NKU2t1+RMiAqQAxxXwptb2QJrRW4DIpa1KHEU/2XL+gK/eTx9owvrhmu6OybPwWmV6wPOoQuPf6hIbARwWOZ8cs15SXdm68FJYqoFMugLoLjOd3dcC20meltiLaemOvrGX6HiQSy68V4sArKWgECcebba+bizy26lSCVPHz7aYq3qnoBAPy/6NoTWjVSteNHINWFU+z2+Dg==

On 26/05/26 05:16PM, Dave Jiang wrote:
> 
> 
> On 5/22/26 12:19 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Clear holder_ops before holder_data so that a concurrent fs_dax_get()
> > cannot have its newly installed holder_ops overwritten. Also add a
> > kerneldoc comment documenting that fs_put_dax() must only be called
> > by the current holder.
> > 
> > Fixes: eec38f5d86d27 ("dax: add fs_dax_get() for devdax")
> > Signed-off-by: John Groves <john@groves.net>
> 
> Couple things from Claude that may be worth taking a look at:
> 
>   1. Memory ordering is now load-bearing and missing
> 
>   The whole correctness argument depends on the reader observing holder_ops =
>   NULL before observing holder_data = NULL. The patch uses a plain store
>   followed by cmpxchg. On x86 plain stores are ordered, but on arm64/ppc they
>   are not — the reader can observe cmpxchg's release of holder_data while still
>   seeing the old holder_ops. That puts us back in the dangerous (holder_data ==
>   NULL, holder_ops == old) state on weakly-ordered arches.
> 
>   Required:
> 
>   smp_store_release(&dax_dev->holder_ops, NULL);   /* publish ops=NULL first */
>   cmpxchg(&dax_dev->holder_data, holder, NULL);    /* then release holder_data
>   */

Updating to WRITE_ONCE(), which I think is the right choice

> 
>   And the reader in dax_holder_notify_failure should use
>   smp_load_acquire/READ_ONCE because today it reads dax_dev->holder_ops twice
>   (line 334 and line 339), allowing tearing or stale-cache reads. Pre-existing
>   weakness, but this patch is what makes the ordering matter.
> 
>   kill_dax (line 461-462) has the same naked-store pattern — it should be made
>   consistent.

Will study this and post a separate patch for kill_dax if I think it's
warranted

> 
>   2. Unconditional holder_ops = NULL is a behavior regression
> 
>   Pre-patch was defensive: if a caller passed the wrong holder, the cmpxchg
>   failed and nothing got cleared.
> 
>   Post-patch clears holder_ops unconditionally whenever dax_dev && holder is
>   truthy. A wrong-holder fs_put_dax() now actively damages the legitimate
>   holder's state — sets holder_ops to NULL while holder_data retains the
>   legitimate holder's pointer. From that point, all dax_holder_notify_failure()
>   calls return -EOPNOTSUPP, silently breaking the legitimate holder's
>   poison-recovery path.

This is a bit of a sticky wicket. The API contract is that the caller 
of fs_dax_put() is the holder. To get the ordering right AND guard against
non-holder callers would require a lock.

Instead, I think the right answer is:

    WRITE_ONCE(dax_dev->holder_ops, NULL);
    WARN_ON(cmpxchg(&dax_dev->holder_data, holder, NULL) != holder);

If a non-holder calls this function, that's a bug and we'll get the 
WARN_ON(). If a holder calls this function twice, we'll get the WARN_ON()
(the second time).

And when the API contract is honored, we have correct ordering.

> 
> DJ

Thanks Dave!

John

<snip>

