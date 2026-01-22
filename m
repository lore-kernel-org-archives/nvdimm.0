Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B9B33D6EA
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 06:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061679; cv=none; b=ihjAjWdp1vO1PZZikwsLw5+8Bl3sGThdaHq75wJe3u8qSW07CXEH+MO2KbpD0jMdot88xKouvMcvIgeQbjW04+CbH9sO8Wkuh8qkAgh2bGtFfTOLLcCI8O7nldME6Xr6ZfS9J/0uc9EjPInhU+bAmrP0ePfJweK+kyBGJdd30iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061679; c=relaxed/simple;
	bh=5gyp324L+eemR9mmccTPng8VqzG5D5J69adD9YIdKdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/93MnKeE6Fb+lVxsIqE3C2/ivILCyhF7OPIPSV+P4XFOQ4XJOlnfFPViBSuFhWrLElhfkMab9WMZXFgwkcyjEZYX38joKTctkv9VkdwgUhWevh49VC8FmITUOI2/d/5WUTdX+74ujjUiR8qDbAOyXJwsANY/mf0aQY+L9rL29M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 41570227AA8; Thu, 22 Jan 2026 07:01:15 +0100 (CET)
Date: Thu, 22 Jan 2026 07:01:14 +0100
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
Subject: Re: [PATCH 11/15] iomap: allow file systems to hook into buffered
 read bio submission
Message-ID: <20260122060114.GB24006@lst.de>
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-12-hch@lst.de> <20260122004933.GO5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122004933.GO5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 21, 2026 at 04:49:33PM -0800, Darrick J. Wong wrote:
> > verifying data checksums.  Allow file systems to hook into submission
> > of the bio to allow for this processing by replacing the direct
> > submit_bio call in iomap_read_alloc_bio with a call into ->submit_read
> > and exporting iomap_read_alloc_bio.  Also add a new field to
> > struct iomap_read_folio_ctx to track the file logic offset of the current
> > read context.
> 
> Basically you're enabling filesystems to know what's the offset of a
> read bio that iomap is about to start?

Yes.

> I guess that enables btrfs to
> stash that info somewhere so that when the bio completes, it can go look
> up the checksum or something, and compare?

Yes, where something in this series is the ioend that the bio is embedded
into.

> Or for PI the filesystem can do the PI validation itself and if that
> fails, decide if it's going to do something evil like ask another
> replica to try reading the information?

Yeah.  If your file system can do it.  Nothing in this series does
that, though.

