Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7686C358D2A
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 06:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061805; cv=none; b=GqmmAQ5deIdcvd/p+2n44rsefShMBmdXri81/K2GHiPHc7wGF+jgmfQ3sZVfRBxEXLPMBPsStvvePSvYgFgcxIjS8wz0Gje34kCBbEEMga/V9pZX2k/IDk0j3p3BPKmVzJIpyIATnfiK3WmpvF3rlK2J8o8fKGsNiJkNzJekCtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061805; c=relaxed/simple;
	bh=+yjQYWa7iJyv4X6MBny1qgJzOqihi99a5v9S+vI4p+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ritG6X+AsROZFM5LwgleljV40RObto8C5JlKQA6rs9WivxpXLJcrC0iCCFYU4uQdu/wtKK1l44QwbFbHrM0giAWVrNBJ022YUz6WPP+88d8YEl+Hx6It64cyizjucInCwubThkKxKYmoCDjNgrcWMZRseB3I4TnkEomFVXrfAIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEADB227AA8; Thu, 22 Jan 2026 07:03:19 +0100 (CET)
Date: Thu, 22 Jan 2026 07:03:19 +0100
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
Subject: Re: [PATCH 14/15] iomap: support T10 protection information
Message-ID: <20260122060319.GC24006@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-15-hch@lst.de> <20260122005936.GR5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122005936.GR5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 21, 2026 at 04:59:36PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 21, 2026 at 07:43:22AM +0100, Christoph Hellwig wrote:
> > Add support for generating / verifying protection information in iomap.
> > This is done by hooking into the bio submission and then using the
> > generic PI helpers.  Compared to just using the block layer auto PI
> > this extends the protection envelope and also prepares for eventually
> > passing through PI from userspace at least for direct I/O.
> > 
> > To generate or verify PI, the file system needs to set the
> > IOMAP_F_INTEGRITY flag on the iomap for the request, and ensure the
> > ioends are used for all integrity I/O.  Additionally the file system
> > should defer read I/O completions to user context so that the guard
> 
>   must ?

Well, the copy isn't actually blocking.  So a small copy might actually
work from hardirq context, but you're not going to make friends with
anyone caring about latency.  I guess that means I should upgrade this
to a "must" :)

> >  {
> >  	struct iomap_ioend *ioend = wpc->wb_ctx;
> >  
> > +	if (ioend->io_bio.bi_iter.bi_size >
> > +	    iomap_max_bio_size(&wpc->iomap) - map_len)
> > +		return false;
> >  	if (ioend_flags & IOMAP_IOEND_BOUNDARY)
> >  		return false;
> >  	if ((ioend_flags & IOMAP_IOEND_NOMERGE_FLAGS) !=
> 
> Unrelated question: should iomap_can_add_to_ioend return false if it did
> an IOMAP_F_ANON_WRITE and the bdevs aren't the same, even if the sectors
> match?  Currently not a problem for XFS, but some day we might want to
> have a file that maps to zones on different devices.

For IOMAP_F_ANON_WRITE the bdev doesn't really matter at this level,
as it applies the actual mapping is done below.  So the bdev is really
just a placeholder here.

