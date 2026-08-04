Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEBD39B943
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785857478; cv=none; b=pTtfi7c406lkhRZrPVfoVlLgj05/XSeyu84phNntsQJvzMmkRwNoXBHQfGJyOOb0+WC2dYjW2q3pW+jKz0B3P4OP8pmrjuHXIIlSQ8XGC4gZubhYJdARptb5KcbUYe+nWyP50JhjVGAJA5hA5MjqJuyr/0pB5XVa9Ru5ckWz3Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785857478; c=relaxed/simple;
	bh=by/fcGncfc5OCuRW9skgJuC6t1LUujBBm0TnhfUwb/o=;
	h=From:Mime-Version:References:To:Cc:In-Reply-To:Content-Type:
	 Subject:Date:Message-Id; b=R4MARJReefF5VbG2SnFEI3qwOz0qDbAUSmKEBuy9LLvsK3RRf7FYOQICIdL2wUIrTYWbNJyzF6eU8BBUqJkCdsJULNCW+BKx5XawtpdDTe7DWkkwfnO5Fu0KdkP35HSZMjPbr/GXD85kexQmXr2ptIYluaeLvLNy21TO9YUOuOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=euw8Hfe9; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="euw8Hfe9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785857464;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LX/Wg0tks/cc/fTlAyp1t5QsfNTLQnLsZm1iWKs61Hs=;
 b=euw8Hfe9zlE4dKSwWSGjPHpD1X+DCz38LT6s0DsrO8ZRHaCJXTSXSCSLrs9bG3IF75n5nR
 nInnxDU4rVSUc5Phrmlu4bRo1Z9Ibr2/Kx628xpu0XqSc4GPlxgULOmSg6TuTBPLdgnIaB
 wZl/0JsxB9khWCAGOpkbHWQqVaJMpEaXdhX56YUVpJmiHyIIOR/mSYvICXyYkgehZM9CbT
 dNx+dxBY360Cdtd3bOWox8lgL6OEhDmi/FpZbNoArlEJC9QASuTTNvn7GMLexoeMO73U0S
 1EH+YzRG+67JSLg5VbmhwIQZs56nqz59yMKX8wGnARnwTr57Om/1hK6HiwGz0A==
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev> <20260804133208.GB8078@lst.de>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 15:31:03 +0000
User-Agent: Mozilla Thunderbird
To: "Christoph Hellwig" <hch@lst.de>, "Tao Cui" <cui.tao@linux.dev>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>, 
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>, 
	<gfs2@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260804133208.GB8078@lst.de>
X-Lms-Return-Path: <lba+26a7205b8+265e26+lists.linux.dev+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
Date: Tue, 4 Aug 2026 23:30:55 +0800
Message-Id: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>

Hi,

=E5=9C=A8 2026/8/4 21:32, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 05:19:24PM +0800, Tao Cui wrote:
>> While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
>> gave it a try =E2=80=94 and the WARN_ON_ONCE triggers every time for me.
>>
>> I may well be missing something, but my worry is that the bio's ref on
>> the blkg keeps the object alive, not its entry in the radix tree.
>> blkg_destroy() runs throtl_pd_offline (which only schedules an async
>> flush) before radix_tree_delete(), so the queued bio ends up dispatched
>> (blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
>> bio_pinned_blkg) after the blkg is already gone from the tree, and
>> blkg_lookup() returns NULL.
>>
>> I applied the series and wrote a small reproducer:
>>
>>    - null_blk, cgroup v2, a child cgroup with io.max rbps=3D4096;
>>    - a read issued in the child cgroup gets throttled and queued, pinnin=
g
>>      the blkg;
>>    - migrate the reader out and rmdir the cgroup; the queued bio is then
>>      flushed after the blkg has left the tree.
> Can you add this to blktests?
>
>> Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
>> the lookup can't miss?

The problem here is that blkg_destroy can be called while blkg is still pin=
ned
by blkg_get, in this case remove the cgroup directly remove the blkg from r=
adix
tree, that's why blkg_lookup can't find this blkg anymore, and the extra bl=
kg ref
is leaked :(

> That would grow the bio, which we try hard to avoid.  I think the way to
> avoid this is to have active/passive refcounts on the blkg, where an
> active one keeps it in the radix tree, but a 0 passive one would prevent
> the caller from getting a new reference to it.  The users who rely on the
> pin for the I/O completion path would then just keep the active reference
> and use a pure lookup without getting a new passive reference in the
> completion path.  This would remove the need for BIO_BLKG_REF which
> feels a bit kludgy and eats up precious bio flag space.

The problem here is that remove a cgroup can also remove the blkg from radi=
x tree,
even through it still has active refcounts. I think this can be fixed by ch=
ecking
the cgroup online_pin first, if it's zero, we can search the blkg from the
request_queue blkg list, where blkg will not be removed until blkg_free_wor=
kfn().
What's better, if we can convert the blkg list to hash table with key as bl=
k-cgroup,
it will be much better as we can lookup from this table instead of blkcg ra=
dix tree.

>
--=20
Thanks,
Kuai
