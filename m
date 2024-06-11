Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8598488;
	Tue, 11 Jun 2024 05:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085591; cv=none; b=aXqtaoEvZwOpZnMphmDXEA40+S7xdQbNDLuR4Be8MbvJrhkdVQvlsjfnJneoq+RKm8M1ntjNKbF6m9gLZCNLKlPPAKrEpQyTrQefKJZeUV4GthMz77l3pJ4sDfhyfirgCOAo4R2UwuUM9yj8WGUYItzhHd9RayuGpL4Drf2jMlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085591; c=relaxed/simple;
	bh=VcH7Wt7CoRkVc7ktdYMf1ddCxD4z50RLoU3OgFUbLZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dILlpIqGvwEgdf6rGtIm66yvL42DoGd4CPljFFcrWtGITPvC4FTyDOh2KHgcuQ2hB+U+q+WwpYW2fXe7mJzlRHFM/tTtPLblt1IklmfC9XnGemhSIHf/TxhjdXO6Scc+O7p3IMnes6WT8KadlSJ23Jei5HQPMbrw8Bj3ahOJtaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B1AFB68C4E; Tue, 11 Jun 2024 07:59:46 +0200 (CEST)
Date: Tue, 11 Jun 2024 07:59:46 +0200
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
Subject: Re: [PATCH 06/26] loop: also use the default block size from an
 underlying block device
Message-ID: <20240611055946.GA3777@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-7-hch@lst.de> <27e76310-1831-473e-803a-e0294b91463c@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27e76310-1831-473e-803a-e0294b91463c@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 02:58:56PM +0900, Damien Le Moal wrote:
> > +	if (S_ISBLK(inode->i_mode))
> > +		backing_bdev = I_BDEV(inode);
> > +	else if (inode->i_sb->s_bdev)
> > +		backing_bdev = inode->i_sb->s_bdev;
> > +
> 
> Why not move this hunk inside the below "if" ? (backing_dev declaration can go
> there too).

Because another use will pop up a bit later :)

