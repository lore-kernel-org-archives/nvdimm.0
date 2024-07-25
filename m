Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E919AD81;
	Thu, 25 Jul 2024 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721912423; cv=none; b=piVj1rTmLYtf1++ZRODRnHx7Ds/O9ucw5nNe8mFL4auLxrkUZo0+qQKXRI6gH/5YUiis/VdzXXeXWB/680bixFgqnqsWweCA87NsquOMEvoToEl6TbNLFePmSxpnFTSr1hAO78GNUq0NR/VDko8PgeMc9wgjgwwOlk1g2tizUFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721912423; c=relaxed/simple;
	bh=PsfRIOEWhAwEg2ifRiPfWEr2fzxq7OMgmm0RVDf/xgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TznT/GtLh9k2WTiOyvPCvcSj1AubLHRF1xxgRWrD7cl6T8d3z9aupRQvYOPa/R2F1aH3wOh+kuIPjbyayg8UDBZBJ7uBT95sR7mvvQvmsVhmFAOOu0oAYZA1JvuPj5FYs50zZ/MSYmItsl7JGgXCWFKvt+cuQlswkZuEeDWW7YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C4CD1227A8E; Thu, 25 Jul 2024 15:00:09 +0200 (CEST)
Date: Thu, 25 Jul 2024 15:00:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Wouter Verhelst <w@uter.be>
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
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 14/26] block: move the nonrot flag to queue_limits
Message-ID: <20240725130008.GA22625@lst.de>
References: <20240617060532.127975-1-hch@lst.de> <20240617060532.127975-15-hch@lst.de> <ZqI4kosy20WkLC2P@pc220518.home.grep.be>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqI4kosy20WkLC2P@pc220518.home.grep.be>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 25, 2024 at 01:35:46PM +0200, Wouter Verhelst wrote:
> NBD actually exports a flag for rotational devices; it's defined in
> nbd.h in the NBD userland source as
> 
> #define NBD_FLAG_ROTATIONAL     (1 << 4)        /* Use elevator algorithm - rotational media */
> 
> which is passed in the same flags field which also contains the
> NBD_FLAG_SEND_FLUSH and NBD_FLAG_SEND_FUA flags.
> 
> Perhaps we might want to look at that flag and set the device to
> rotational if it is specified?

Yes, that sounds good.  Can you send a patch?

