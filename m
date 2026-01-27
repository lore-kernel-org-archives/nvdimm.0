Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B991C862E
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 05:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769490931; cv=none; b=uhx0+Bt6Qf9AerPRsOn3IJnCc5pjMwwqP+zpdwKjX+31p7GxKxnrYRzqp35f8mZER6Xfu3CWLubKS4unE73BavMx5SSlp8QiPh4vGoaVbSMMoG4bam2Vjq9pzDB/jbuGLCxLV4Ev7ZoT0tV/FjkP9wdnb+zu5t7O6V5109vZiv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769490931; c=relaxed/simple;
	bh=99BYu56z6D3LCwKbPFsn/k9SNWDkPoPd7iHuyxFdNnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDA4Z1CG5mwf0LzYL3gAoqdZz9alKRw+0eAPKEP/VOS5TptA15ICiXy+ryZKSqtzGPkRkNpEI5lOUgdHevy8ozkzTRwTo2QjZllPMpXwzSUyZ/kO56/58aArYUlJxgjn0q0v7yxu7SS7+5Iy/CzDOZbdZO8a7yetb/FiyDyqb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D908227AAE; Tue, 27 Jan 2026 06:15:28 +0100 (CET)
Date: Tue, 27 Jan 2026 06:15:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] block: add fs_bio_integrity helpers
Message-ID: <20260127051527.GA24364@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <CGME20260121064416epcas5p3aa66a19640d8d7411016e34a1fee0592@epcas5p3.samsung.com> <20260121064339.206019-7-hch@lst.de> <95af59e3-fe94-4d62-8931-5b8a9c7f8429@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95af59e3-fe94-4d62-8931-5b8a9c7f8429@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 11:42:10PM +0530, Kanchan Joshi wrote:
> On 1/21/2026 12:13 PM, Christoph Hellwig wrote:
> > +void fs_bio_integrity_alloc(struct bio *bio)
> > +{
> > +	struct fs_bio_integrity_buf *iib;
> > +	unsigned int action;
> > +
> > +	action = bio_integrity_action(bio);
> > +	if (!action)
> > +		return;
> 
> So this may return from here, but <below>

> > +void fs_bio_integrity_generate(struct bio *bio)
> > +{
> > +	fs_bio_integrity_alloc(bio);
> 
> no check here. A potential null pointer deference in the next line as 
> bio has no bip?
> > +	bio_integrity_generate(bio);
> > +}

fs_bio_integrity_alloc is only called when the device has PI metadata
with checksums.  So this case can't really happen.  That being said,
handling it in one case and not the other seems suboptimal and confusing.
