Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E86913F42C;
	Thu, 13 Jun 2024 09:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718271565; cv=none; b=ojO7gHJvxHOJhne6hF9+qCE6lzsx2FPgVICTPq+tw8GUNue17YmhqSxUKGNkz2x1h3VoRCYwTeScaqTjKYQ/l1/Pn3ZeWImXvB7L1R+OKYMM1mkvb7f9BQJ+pcchgUTBu1jsH23KVjKUJ/BL3ZSndEcToSMdr9pGVzf+hVGvskY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718271565; c=relaxed/simple;
	bh=pRWDt1CymWhiVCIQGhuTbaxcmQTdtnlTPpKr9sPmjbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ex/Jme3fvnER6u8TU9SaKrIrz7g9uzhB5sCEZMO4sM+QeOZXpSWcTL5PyCZYX5h0IDN8A9Oh1kGPI245HP9r1Exu871yYhhVWitkSKo5B/qUYVX+zcO9snkyOUhCMn8LpQQAeAsa/N4W3Vw/NP1BGx7wsWjI5vsbWDXy4PxQ2ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7DE0E68B05; Thu, 13 Jun 2024 11:39:18 +0200 (CEST)
Date: Thu, 13 Jun 2024 11:39:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 02/26] sd: move zone limits setup out of
 sd_read_block_characteristics
Message-ID: <20240613093918.GA27629@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-3-hch@lst.de> <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 02:51:24PM +0900, Damien Le Moal wrote:
> > +	if (sdkp->device->type == TYPE_ZBC)
> 
> Nit: use sd_is_zoned() here ?

Actually - is there much in even keeping sd_is_zoned now that the
host aware support is removed?  Just open coding the type check isn't
any more code, and probably easier to follow.

