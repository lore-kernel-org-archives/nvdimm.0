Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6F282F1;
	Wed, 12 Jun 2024 05:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718168627; cv=none; b=qtXInUhEFoJibzq5vuqB3tzthyfgZMTxtcgJxWhjszQ5x/GAK7gxuAMdaZJkGWQCohXVS4WQTFRUSu1coEBJQxhU2lTRAnKNoNN1YA3Jjnp55oMroIRuKHlAZmgwkvCvKIwrQ8o/04UY6xJW3p8Q3ZyeSe7n4qIXXPAgz1FyY9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718168627; c=relaxed/simple;
	bh=yideDWBgYhb8gdrUDek21Tjymn+mofyCK/oOHbACXbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAnmfMUG34tRaWqpD5u1On2mm9mjpXpSJcqEI3KeM7IsV29kwloOQnUQJ8q2k7Il+OZ84HGmrDZnws1NameBx5QPPWV7ycOsnnEiSdKv+3y2xhMMH51PDmD66wMOQrseOiDDLLmf2T/5uCc1bJ4+f0SSqLQlJj22Vb/mdb69sLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0069168C4E; Wed, 12 Jun 2024 07:03:41 +0200 (CEST)
Date: Wed, 12 Jun 2024 07:03:41 +0200
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
Subject: Re: [PATCH 21/26] block: move the poll flag to queue_limits
Message-ID: <20240612050341.GA27049@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-22-hch@lst.de> <d1775d3f-daaa-4193-9f68-06ec47563b35@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1775d3f-daaa-4193-9f68-06ec47563b35@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 05:21:07PM +0900, Damien Le Moal wrote:
> Kind of the same remark as for io_stat about this not really being a device
> feature. But I guess seeing "features" as a queue feature rather than just a
> device feature makes it OK to have poll (and io_stat) as a feature rather than
> a flag.

So unlike io_stat this very much is a feature and a feature only as
we don't even allow changing it.  It purely exposes a device (or
rather driver) capability.
