Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993A117085D;
	Tue, 11 Jun 2024 05:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085297; cv=none; b=hH1WMwoQ6/me3Irr9F+HxPIDgaT6WNmslFcFfaGzqGcptuMRrwWg7GPsENu+sM9G67+qzpFonfXIkJ5XQtOtIFOr1bKTd7P6n/sq6DFROfh3yYQJyJEN/IBjCpWJWPOokmn86puTpjeEi1q0AIQUDNuflfU8fccw4bzvlPTP29k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085297; c=relaxed/simple;
	bh=NKElyT0W8Njjwhy6wZ6e9p7e2rQH52zdXt2CykxF8Cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmXw4v8RTOJJm7ZOcWAqhAWgFTJCLRjYEWvyOf8VDtG7Yjasgy+NYOLCNW+J9ijxcoEVFtJrZG2WOcmqhukn3BOoUq+GVXSjb7OI2/Vp00+R7tQiz6iT6zFKNSRpcHuf6Lo3iXx6UvrlKkbD+S6HaltxvCjHkQqpBrJD8Ag/Y6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A7EA968BEB; Tue, 11 Jun 2024 07:54:53 +0200 (CEST)
Date: Tue, 11 Jun 2024 07:54:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph B??hmwalder <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Roger Pau Monn?? <roger.pau@citrix.com>,
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
Subject: Re: [PATCH 03/26] loop: stop using loop_reconfigure_limits in
 __loop_clr_fd
Message-ID: <20240611055453.GA3384@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-4-hch@lst.de> <ca5a3441-768a-4331-a1c2-a4bdadf2f150@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca5a3441-768a-4331-a1c2-a4bdadf2f150@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 02:53:19PM +0900, Damien Le Moal wrote:
> > +	/* reset the block size to the default */
> > +	lim = queue_limits_start_update(lo->lo_queue);
> > +	lim.logical_block_size = 512;
> 
> Nit: SECTOR_SIZE ? maybe ?

Yes.  I was following the existing code, but SECTOR_SIZE is probably
a better choice here.

