Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842BA25524C
	for <nvdimm@lists.linux.dev>; Wed,  5 Aug 2026 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785891535; cv=none; b=NzPEa4f+yc0xOy3b5OWUGLfMw3vTtF2yskOV/LjVQVxoVNX8xhKH9Zq3GBpkhPzCokmBfkmGr5YOMnNL+yYO6lH88pWnWFWYXN9dXEjJc5TXaOWET6BGEexp5GTqcgJW8QRI4OGeSlISSKdBwVZAhH2enpf3S3F7vwWS+azo5t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785891535; c=relaxed/simple;
	bh=QXq+No4NCvplH5iP+cVU/DLqFEsEiO2ABlKqbYf8N0U=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aZmDUvaf2RIJrcjqOzQ4L/3fZ1SbAmELuLJ4GruHExnaWzAdYRFRes+BGSvJyXWFgE5Mp/rHAxuhnVHdlbYo4igMpR8qolHP4gBySUDUYq1xCM22Jd2dHjN/Y+lR4NFzJ6exMwSlHvBgZjTrpOl/wvbfbObHMZaE5y5PNTQZxxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UKD+o0Q9; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UKD+o0Q9"
Message-ID: <a340d525-5713-4cf4-b88c-77773ae349d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785891530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXCZx29YWK0KuSZTNZlcIo3NjcMPu1Ep/GSGxvMq9+g=;
	b=UKD+o0Q9O0GP/b1+xVPt8DW6AJyHnKdGgtR0kNlepREPLrvPQUsgmz6uhTn2BgsnwwgsW7
	6FERSa+9CQu0aEvQy/RHASDL9rD1MgLiRdBkudQn0F5tsVVNDL9YEXbEVMFS961KB/SsYE
	mzNcNjONJWNh0bFcrOTll82xxRN0PX0=
Date: Wed, 5 Aug 2026 08:58:09 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
 Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Nilay Shroff <nilay@linux.ibm.com>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
To: yukuai@fygo.io, Christoph Hellwig <hch@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
 <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
 <20260804133208.GB8078@lst.de> <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


Hi Kuai,Christoph,
在 2026/8/4 23:30, yu kuai 写道:
> Hi,
> 
> 在 2026/8/4 21:32, Christoph Hellwig 写道:
>> On Tue, Aug 04, 2026 at 05:19:24PM +0800, Tao Cui wrote:
>>> While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
>>> gave it a try — and the WARN_ON_ONCE triggers every time for me.
>>>
>>> I may well be missing something, but my worry is that the bio's ref on
>>> the blkg keeps the object alive, not its entry in the radix tree.
>>> blkg_destroy() runs throtl_pd_offline (which only schedules an async
>>> flush) before radix_tree_delete(), so the queued bio ends up dispatched
>>> (blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
>>> bio_pinned_blkg) after the blkg is already gone from the tree, and
>>> blkg_lookup() returns NULL.
>>>
>>> I applied the series and wrote a small reproducer:
>>>
>>>    - null_blk, cgroup v2, a child cgroup with io.max rbps=4096;
>>>    - a read issued in the child cgroup gets throttled and queued, pinning
>>>      the blkg;
>>>    - migrate the reader out and rmdir the cgroup; the queued bio is then
>>>      flushed after the blkg has left the tree.
>> Can you add this to blktests?
>>

yes, I'll turn the reproducer into a blktests case and send
it out. 

>>> Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
>>> the lookup can't miss?
> 
> The problem here is that blkg_destroy can be called while blkg is still pinned
> by blkg_get, in this case remove the cgroup directly remove the blkg from radix
> tree, that's why blkg_lookup can't find this blkg anymore, and the extra blkg ref
> is leaked :(
> 
>> That would grow the bio, which we try hard to avoid.  I think the way to
>> avoid this is to have active/passive refcounts on the blkg, where an
>> active one keeps it in the radix tree, but a 0 passive one would prevent
>> the caller from getting a new reference to it.  The users who rely on the
>> pin for the I/O completion path would then just keep the active reference
>> and use a pure lookup without getting a new passive reference in the
>> completion path.  This would remove the need for BIO_BLKG_REF which
>> feels a bit kludgy and eats up precious bio flag space.
> 
> The problem here is that remove a cgroup can also remove the blkg from radix tree,
> even through it still has active refcounts. I think this can be fixed by checking
> the cgroup online_pin first, if it's zero, we can search the blkg from the
> request_queue blkg list, where blkg will not be removed until blkg_free_workfn().
> What's better, if we can convert the blkg list to hash table with key as blk-cgroup,
> it will be much better as we can lookup from this table instead of blkcg radix tree.
> 

Both of your approaches go further than my store-the-pointer idea;
looking forward to the next version.

Thanks,
Tao

>>

