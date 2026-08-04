Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785C43C7A5;
	Tue,  4 Aug 2026 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785850337; cv=none; b=JxeTsQxv2zb7ELt5CydqYwQYzq/Ht8rA/cUZxPLO6xJ/XiM749RBtgs4ssDWGH4G9Z2T5GyuKeGGtbD1qi8sXgqDLbLrB1dQQfjP2uPplIoSlN577ScvKCNJ/u8dpJCBPWph4smLMPOHTacJo20EN1ogMpVg3G2WepnoOYjQTU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785850337; c=relaxed/simple;
	bh=nTLiwxrMjLSfaiIVFmR3cQtrnNCiV4/Sy7TgcYaomcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/egnh4LgT9Coer74s7wB7kmErtaFw3tLMyQic3IZ9ozl/SxupLpeKl8tD95qVIHUDmsYzpj1hNdrnuNVmzch1as4sju8zmVjV1Bqalfvb3ClqsvWy9kIW9XPR2qTuotobipPtQ6f+i/UXB0Sap7HBIwd5D5jN64JbRllwB1kSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2ABD6732A; Tue,  4 Aug 2026 15:32:08 +0200 (CEST)
Date: Tue, 4 Aug 2026 15:32:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tao Cui <cui.tao@linux.dev>
Cc: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Message-ID: <20260804133208.GB8078@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 04, 2026 at 05:19:24PM +0800, Tao Cui wrote:
> While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
> gave it a try — and the WARN_ON_ONCE triggers every time for me.
> 
> I may well be missing something, but my worry is that the bio's ref on
> the blkg keeps the object alive, not its entry in the radix tree.
> blkg_destroy() runs throtl_pd_offline (which only schedules an async
> flush) before radix_tree_delete(), so the queued bio ends up dispatched
> (blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
> bio_pinned_blkg) after the blkg is already gone from the tree, and
> blkg_lookup() returns NULL.
> 
> I applied the series and wrote a small reproducer:
> 
>   - null_blk, cgroup v2, a child cgroup with io.max rbps=4096;
>   - a read issued in the child cgroup gets throttled and queued, pinning
>     the blkg;
>   - migrate the reader out and rmdir the cgroup; the queued bio is then
>     flushed after the blkg has left the tree.

Can you add this to blktests?

> Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
> the lookup can't miss?

That would grow the bio, which we try hard to avoid.  I think the way to
avoid this is to have active/passive refcounts on the blkg, where an
active one keeps it in the radix tree, but a 0 passive one would prevent
the caller from getting a new reference to it.  The users who rely on the
pin for the I/O completion path would then just keep the active reference
and use a pure lookup without getting a new passive reference in the
completion path.  This would remove the need for BIO_BLKG_REF which
feels a bit kludgy and eats up precious bio flag space.

