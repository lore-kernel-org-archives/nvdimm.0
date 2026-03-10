Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EEA3E95B5;
	Tue, 10 Mar 2026 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773137792; cv=none; b=YQD29rwvR8uZzkexu83tdTAAU+Ptz6jbPCE/mmNJ8AY2Y/3NcYGZ5nnoa+hcaZuNjlN3J2HXUQWBikWtiZt3vaea9zgMfi4Rr/xvMBhQVUFSwkyZB9JVzNy0zFCZd/9Um6/j7WYu3eDact3BQeLGxuSytrmtwpHNozhMjJEAiMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773137792; c=relaxed/simple;
	bh=JpVHMfmsxruFspBgacpNIqbvFeaSkGXgdMYZvL9c94I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdAZlfo7mAMPOHq3I388+eQ6cjE8ahRqlW9gPvx3rl/oYmU22m1a68eJPSdBiYCyx94dVWJEitb2jBmIL/FA3qF4Q5pDXi9jm+w/2EnByo2q3L0IAO2IvFfXkjO0wTI1nnUfXD0twEFYCq2reUxiy5AXC945IvpSltGlDH3gnyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n955BlsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n955BlsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92825C2BC86;
	Tue, 10 Mar 2026 10:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773137791;
	bh=JpVHMfmsxruFspBgacpNIqbvFeaSkGXgdMYZvL9c94I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n955BlsMwAmB0f7NP3jhKxgG8bcVxp0amdN8yBPyoTLVAQNr6Dl+Tzt5nio5S5ivK
	 Ozgmu3hGMzbDWrzs4yFj9BEngYcb30JZRYtychA8ieDEFpxvrDLQbgsKepKO6W6mX5
	 r4l9acPKbBcCSn/jDM7cXKh4n9D4n4yNwMnvKooYwCoOez+rPgmLHB6MbK6q/w5TiV
	 D15DpfldnR0QIVQiBQotQDKIn3xE15Nj0+PdigVhEUVsVb5gnJ930JxIpWk/1JvQky
	 68bn47XGKBmv5wgsUL8xb1fLKBWBc9pD4xraxNSjxIBmZtOiSvLLENy/hK8Yw7esXN
	 w5mVHT7cd6Gsg==
Date: Tue, 10 Mar 2026 11:16:25 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, ntfs3@lists.linux.dev, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: (subset) support file system generated / verified integrity
 information v4
Message-ID: <20260310-beengt-galant-e82b95450cc5@brauner>
References: <20260223132021.292832-1-hch@lst.de>
 <177306794392.32482.9164747646721806111.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <177306794392.32482.9164747646721806111.b4-ty@kernel.dk>

On Mon, Mar 09, 2026 at 08:52:23AM -0600, Jens Axboe wrote:
> 
> On Mon, 23 Feb 2026 05:20:00 -0800, Christoph Hellwig wrote:
> > this series adds support to generate and verify integrity information
> > (aka T10 PI) in the file system, instead of the automatic below the
> > covers support that is currently used.
> > 
> > There two reasons for this:
> > 
> >   a) to increase the protection enveloped.  Right now this is just a
> >      minor step from the bottom of the block layer to the file system,
> >      but it is required to support io_uring integrity data passthrough in
> >      the file system similar to the currently existing support for block
> >      devices, which will follow next.  It also allows the file system to
> >      directly see the integrity error and act upon in, e.g. when using
> >      RAID either integrated (as in btrfs) or by supporting reading
> >      redundant copies through the block layer.
> >   b) to make the PI processing more efficient.  This is primarily a
> >      concern for reads, where the block layer auto PI has to schedule a
> >      work item for each bio, and the file system them has to do it again
> >      for bounce buffering.  Additionally the current iomap post-I/O
> >      workqueue handling is a lot more efficient by supporting merging and
> >      avoiding workqueue scheduling storms.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [01/16] block: factor out a bio_integrity_action helper
>         commit: 7ea25eaad5ae3a6c837a3df9bdb822194f002565
> [02/16] block: factor out a bio_integrity_setup_default helper
>         commit: a936655697cd8d1bab2fd5189e2c33dd6356a266
> [03/16] block: add a bdev_has_integrity_csum helper
>         commit: 7afe93946dff63aa57c6db81f5eb43ac8233364e
> [04/16] block: prepare generation / verification helpers for fs usage
>         commit: 3f00626832a9f85fc5a04b25898157a6d43cb236
> [05/16] block: make max_integrity_io_size public
>         commit: 8c56ef10150ed7650cf4105539242c94c156148c
> [06/16] block: add fs_bio_integrity helpers
>         commit: 0bde8a12b5540572a7fd6d2867bee6de15e4f289
> [07/16] block: pass a maxlen argument to bio_iov_iter_bounce
>         commit: a9aa6045abde87b94168c3ba034b953417e27272

I've pulled the shared branch and also updated my base to v7.0-rc3 as
per Christoph's request in the other mail.
