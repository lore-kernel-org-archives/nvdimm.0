Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D628385;
	Wed, 12 Jun 2024 04:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718167983; cv=none; b=X72Gw3OZfpFUEs6Ll0SfwI5QDgXTAcZFZqVb9Ga7CQFY/ZiQ3HON5ZMFYkgzlb8aOtsnM8jFpfwggp2LNZRFS143tyg7MykN991lTtnQSvCjGDZcvk6L2Y3otr/ZV76YDS5I99UaPxk32u+swVeWYpszz4v6FZYaJARgQh8mPl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718167983; c=relaxed/simple;
	bh=3tIN/Y5HlYGnvHIMt6/UA43lDeC7r6tZjRz/SL4lnjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDlKe1Fbh5oMlScmB93ZNgCqKdKixWfNOIQMcrQQAwVBfB1jfJF8r5K4rOtfl2OJJ4v7TlM0EvLuu2pcyrn/DFY0ddf/6Pf89O4YMhWar2PT7SZDa/dNe61bGluREWxYfq0pKDTAQ+bSZ//EGciJKO6HdO7kEc9pulh9yVsLnPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D6EFD68BEB; Wed, 12 Jun 2024 06:52:57 +0200 (CEST)
Date: Wed, 12 Jun 2024 06:52:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
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
Subject: Re: [PATCH 13/26] block: move cache control settings out of
 queue->flags
Message-ID: <20240612045257.GA26776@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-14-hch@lst.de> <34a7b2a4-b0cb-4580-85c9-b598fd70449e@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34a7b2a4-b0cb-4580-85c9-b598fd70449e@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

A friendly reminder that I've skipped over the full quote.  Please
properly quote mails if you want your replies to be seen.

