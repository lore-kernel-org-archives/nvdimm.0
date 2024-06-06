Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B8A1EB3E;
	Thu,  6 Jun 2024 04:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717649352; cv=none; b=VpoaeRCirhDybQ7EO7NzyfO89SlTTOW4w9aVdywRQaQTftFtjHDsbqb1C4P2T+yIhoGopp4/ZBzxkkCNPRBHPgK1Xr4mG1dGOuz9uOyqKZAg0vbS//ZdMLNvdT9AbnCmDl1Hd4iSVydGQAuWgv253pf0P0A/TsQ9VdcW22Kzf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717649352; c=relaxed/simple;
	bh=c6GvMVP0yu6KTtnXXYAqCdebQm4YZ699GLf9d5FxmMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+K9qXWwNpIdkW4RN4ZxnpWIBwIgqdwzSfDXQUagO3pBGGL6FpdPjjEfd1QPCECtSpnc+vQ9Yykvred7HsG0QycgEhehbdZ8Urw4xcOG3Z0PYL4i9fOG5ttXrkTgJ2s2wm0G+DiZfYjNjESOaHxkPg6TmAHg4hJYjRDPJkXrM6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BCAAF68CFE; Thu,  6 Jun 2024 06:49:06 +0200 (CEST)
Date: Thu, 6 Jun 2024 06:49:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshiiitr@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 04/12] block: remove the blk_integrity_profile structure
Message-ID: <20240606044906.GB8395@lst.de>
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-5-hch@lst.de> <CA+1E3rJn3uNfkoFtm_am9qwQmwWvhu3nPVMaM63AJ2GBdxZTmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJn3uNfkoFtm_am9qwQmwWvhu3nPVMaM63AJ2GBdxZTmQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 05, 2024 at 08:05:20PM +0530, Kanchan Joshi wrote:
> On Wed, Jun 5, 2024 at 12:01???PM Christoph Hellwig <hch@lst.de> wrote:
> > @@ -446,13 +446,14 @@ bool bio_integrity_prep(struct bio *bio)
> >         if (bio_integrity(bio))
> >                 return true;
> >
> > +       if (!bi->csum_type)
> > +               return true;
> 
> Changes look mostly good, but trigger a behavior change for non-PI
> metadata format.
> 
> Earlier nop profile was registered for that case. And the block-layer
> continued to attach an appropriately sized meta buffer to incoming IO, even
> though it did not generate/verify. Hence, IOs don't fail.
> 
> Now also we show that the nop profile is set, but the above
> "csum_type" check ensures that
> meta buffer is not attached and REQ_INTEGRITY is not set in the bio.
> NVMe will start failing IOs with BLK_STS_NOTSUPP now [*].

Yes.  I didn't remember that odd case and failed to test it, but I can
trivially reproduce it now.

Which brings up another issue: bio_integrity_prep allocates the metadata
buffer using kmalloc, so we'll leak write random kernel memory to the
devices for this case which is ... not good.  I guess for stable fixes
and backports I'll add a real generate_fn that just zeroes all the
memory for now.

