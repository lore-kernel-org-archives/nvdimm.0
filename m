Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C83915AA
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 06:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148213; cv=none; b=MZXqrTXlsQzHWDrUnWpdRGCTjb6YT1fuQX8w20YKseNXfpT53BmrdBWDo48fz2kMYcXLsK9hcccL8O8jT+RRG3cciqR5Wj/5aZc8yNEZ7rFwp2AfJnwfKcewFp3wDNXXyGJGFIitdjk4yGpUQg3yUoEDw2eSOGOPD0vVBmWW5Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148213; c=relaxed/simple;
	bh=8zXevHCiQlwD1YM0UVR6IlpunPXzvwjAu7tMywiNfZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKe/LEhOo1bt44gRviI8YpEBdofPU+R5pVvk158X7k3vfh5mWZHCjGTtHlQAtlCk3qIp9UevESaUrHs8LSIi3Z3WDJTxqHriwiCXzICrxW999xuXSf18obbJZbASMGLxGxh+Uz9Ezq6DoMT6GA9auJMRsjUhU8CJ1qKmubNWpP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D4C0C227AAF; Fri, 23 Jan 2026 07:03:24 +0100 (CET)
Date: Fri, 23 Jan 2026 07:03:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] block: factor out a bio_integrity_action helper
Message-ID: <20260123060324.GA25239@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-2-hch@lst.de> <20260123000113.GF5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123000113.GF5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 04:01:13PM -0800, Darrick J. Wong wrote:
> >  /**
> >   * bio_integrity_prep - Prepare bio for integrity I/O
> >   * @bio:	bio to prepare
> > + * @action:	preparation action needed
> 
> What is @action?

Yes.

> Is it a bitset of BI_ACT_* values?  If yes, then can
> the comment please say that explicitly?

Is this good enough?

 * @action:     preparation action needed (BI_ACT_*)

> > +static bool bi_offload_capable(struct blk_integrity *bi)
> > +{
> > +	return bi->metadata_size == bi->pi_tuple_size;
> > +}
> 
> Just out of curiosity, what happens if metadata_size > pi_tuple_size?

Then we still have to provide a buffer as the automatic insert/strip
doesn't work. (I find the offload name rather confusing for this)

> Can it be the case that metadata_size < pi_tuple_size?

No.  See blk_validate_integrity_limits:

	if (bi->pi_offset + bi->pi_tuple_size > bi->metadata_size) {
		pr_warn("pi_offset (%u) + pi_tuple_size (%u) exceeds metadata_size (%u)\n",
			bi->pi_offset, bi->pi_tuple_size,
			bi->metadata_size);
		return -EINVAL;
	}


> 
> > +unsigned int __bio_integrity_action(struct bio *bio)
> 
> Hrm, this function returns a bitset of BI_ACT_* flags, doesn't it?
> 
> Would be kinda nice if a comment could say that.

Is this ok?

/**
 * bio_integrity_action - return the integrity action needed for a bio
 * @bio:        bio to operate on
 *
 * Returns the mask of integrity actions (BI_ACT_*) that need to be performed
 * for @bio.
 */


> > +		/*
> > +		 * Zero the memory allocated to not leak uninitialized kernel
> > +		 * memory to disk for non-integrity metadata where nothing else
> > +		 * initializes the memory.
> 
> Er... does someone initialize it eventually?  Such as the filesystem?
> Or maybe an io_uring caller?

For integrity metadata?  The code called later fills it out.  But it
doesn't fill non-integrity metadata, so we need to zero it.

> > +		 */
> > +		if (bi->flags & BLK_INTEGRITY_NOGENERATE) {
> > +			if (bi_offload_capable(bi))
> > +				return 0;
> > +			return BI_ACT_BUFFER | BI_ACT_ZERO;
> > +		}
> > +
> > +		if (bi->metadata_size > bi->pi_tuple_size)
> > +			return BI_ACT_BUFFER | BI_ACT_CHECK | BI_ACT_ZERO;
> > +		return BI_ACT_BUFFER | BI_ACT_CHECK;
> 
> "check" feels like a weird name for a write, where we're generating the
> PI information.  It really means "block layer takes care of PI
> generation and validation", right?  As opposed to whichever upper layer
> is using the block device?
> 
> BI_ACT_YOUDOIT <snerk>
> 
> How about BI_ACT_BDEV /* block layer checks/validates PI */

I think BI_ACT_BDEV is not very useful.  Check is supposed to
include generate and verify, but I'm not sure how we could word this
in a nice way.

