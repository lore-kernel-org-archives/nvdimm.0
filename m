Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3B53C3F75;
	Wed, 29 Jul 2026 11:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324677; cv=none; b=buAnVLzm6M7YGi9bmc+Vlcict5Gt789l/Izp/UgHYYsIIMIJV6sUy786E3Jsujyu8iwuqy2SwzK0HzHL4Jji5fITzkBrolaELnhl/EqbUPyXjpUOMDl0+eMbqvjqXjRZtPlrpH4sSZMdayeAgiYHB+WPFpE3ATolF7vQ64NRQB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324677; c=relaxed/simple;
	bh=b50IKAQgfgwsG+JdGuW7oU4E2uu3SbJ/PfImyYL915c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mx6DKvDk96avlijL7H49sPf6sGkMbDZ6/bY9YDjP23Q9dU0Tvj+l3z8JdT7XA0jn5vscIRbbJGdn3GbwZqkGIOLV2iSO8pa9Mt6Ol6gdMDQyH9U076B6cB6q0wkThXkQrbwfVw3Nxw1yQTI3Dx6iJGjBK4FJIwdIHqWxssLcfU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEE3A68AFE; Wed, 29 Jul 2026 13:31:08 +0200 (CEST)
Date: Wed, 29 Jul 2026 13:31:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	cpgs@samsung.com
Subject: Re: [PATCH v4 09/14] nvme-pci: add SGL support for the dmabuf path
Message-ID: <20260729113108.GA31120@lst.de>
References: <cover.1785274111.git.asml.silence@gmail.com> <5c2e9c3bdd3e87c0c9a6e4395ea199002b83fd36.1785274111.git.asml.silence@gmail.com> <CGME20260729072126epcas5p3ad4422a45f1274b71f15dec8bf487fcc@epcas5p3.samsung.com> <20260729072117.GI9534@lst.de> <81412691.21785320403945.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81412691.21785320403945.JavaMail.epsvc@epcpadp1new>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 03:47:23PM +0530, Anuj Gupta/Anuj Gupta wrote:
> > But I also don't understand what the use case for this function
> > is to start with.  struct sg_table tells us how many segments
> > exist on the DMA side in the nents member, which should be just
> > fine for the SGL threshold calculation.
> 
> sg_table->nents covers the entire exported buffer (<=1GiB), while a
> request only covers a subrange[bi_offset, bi_offset+payload). Using
> nents would overcount the request's segments.

Urgg, yes.

> >> +	if (!entries)
> >> +		return BLK_STS_IOERR;
> >> +	if (entries > NVME_MAX_SEGS)
> >> +		return BLK_STS_AGAIN;
> > 
> > Given that the block layer enforced data in rw/command and the
> > max_segments limit, why do we need the extra check here?
> 
> A dmabuf bio reports nsegs=1 (bio_split_io_at) to the block layer, so 
> max_segments isn't enforced against the SG entries actually spanned by 
> the request. Hence the explicit check.

We'll need to expose the actual nsegs to the block layer and split
based on that.  Otherwise I/O might work or fail based on the device
capabilities.

