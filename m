Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5375320298D;
	Thu, 22 Jan 2026 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769105067; cv=none; b=M86Woi1zwOpMHN9ZgbpuxYDGXJSVvcL9kATlq9iWrKirIAib5VflXrIJrw4er+XoqiF/WGttYV/ePbAHcAaTo1FAyn/GdyhmDCzoQuC3VkNMOFeCd4siaHJ3k7SUjsTvSrrR0Ab9KD7ZoIntimDo6/vCCZXzY69untz3K0TDW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769105067; c=relaxed/simple;
	bh=NRcfnBfc/uf0Kgun1SB8oAWnZ++/lrKR1XlM4gal20k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhaqKhDjSZqSAE1N+x9KnyyqY/OHZMkt+NMPaDRXeglaxAt6hor/7VxrvIYIVEAWTwdyciuzFrkFmD79WoJEHFKJ7rtPhCSQxwZo346a675PoqzhQymbbxZiZI8n/6VkAQ9S+ormo5+fmh2M6QvvHIYP8NaV7Iq7+e35QQoiq/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QODMgOqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QODMgOqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB5EC116C6;
	Thu, 22 Jan 2026 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769105064;
	bh=NRcfnBfc/uf0Kgun1SB8oAWnZ++/lrKR1XlM4gal20k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QODMgOqS1CoZDHQRoxAeZjfHZa3GlQYfTY58ZEkbbhrCLMNmT9uxNd6/sUzXluz0e
	 PDln5IwNp7FCRmz5DQ+hIUhBD1fWzHcvvBsc55i+Iw5ebXOH3bIa3M4aw4VHEDQnfQ
	 +NrPQ0ns+gHf9SDaf2GBJVEaldp7mj84kPGCBjYC1NzwbUJe2HmAznz+kr7hRVFm2x
	 9J2pe0g9wvkOoLkaYtJTzIrSnR2xPzOtJnjK+GLXPMJuHV1VpMLF9Wl+6nnysCpDLZ
	 LwkFVClSK5ZIZy3SlrXy1GJgEoKQ7UXVb0mgE7mBsY8QflczEBsCrno6zevpOLbEhD
	 7Y3d7TOkTpUSA==
Date: Thu, 22 Jan 2026 10:04:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/15] iomap: allow file systems to hook into buffered
 read bio submission
Message-ID: <20260122180424.GC5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-12-hch@lst.de>
 <20260122004933.GO5945@frogsfrogsfrogs>
 <20260122060114.GB24006@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122060114.GB24006@lst.de>

On Thu, Jan 22, 2026 at 07:01:14AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 21, 2026 at 04:49:33PM -0800, Darrick J. Wong wrote:
> > > verifying data checksums.  Allow file systems to hook into submission
> > > of the bio to allow for this processing by replacing the direct
> > > submit_bio call in iomap_read_alloc_bio with a call into ->submit_read
> > > and exporting iomap_read_alloc_bio.  Also add a new field to
> > > struct iomap_read_folio_ctx to track the file logic offset of the current
> > > read context.
> > 
> > Basically you're enabling filesystems to know what's the offset of a
> > read bio that iomap is about to start?
> 
> Yes.
> 
> > I guess that enables btrfs to
> > stash that info somewhere so that when the bio completes, it can go look
> > up the checksum or something, and compare?
> 
> Yes, where something in this series is the ioend that the bio is embedded
> into.
> 
> > Or for PI the filesystem can do the PI validation itself and if that
> > fails, decide if it's going to do something evil like ask another
> > replica to try reading the information?
> 
> Yeah.  If your file system can do it.  Nothing in this series does
> that, though.

<nod> and at this point we're never going to circle back to that project
either.  :/

In the meantime I think I've understood this patch well enough to say
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
