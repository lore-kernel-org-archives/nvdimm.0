Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051D64582D8;
	Wed, 29 Jul 2026 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785326148; cv=none; b=URLbuTPz1h2Cf2B/kCa4rRUAczxBOdKc7q9tgd7id6GQPBX6AbyULO7Xj3CO+y8oAOfnZ0qFsdjWudA3Q/yVRAaV69LmICcWOCKcxKb8rk5YhOqICcNlnu0qcRzNw9dDyBZ1y2cEtp30GxIzLYgoX8ETB8iT22x8TKg7dPD8eq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785326148; c=relaxed/simple;
	bh=IgJeNbcJWhLgp9jPwkDrqPnMWpkvOoIXM4oTSeGkqxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zg5zD1X/dF94ov0k6+vDvnn7oXO5xR/tXyoVhKqz5HSQ10eYtpKrRrm0gTb+/Ah9+8gCyiYd6mS5WpRVf0IC4H/Yo1IpQqTwiLwBx4B7eXCRm1Zr1w/oO6YGtrMqAtmP3e1r7laxmo6dTt4AY/bWN+r1iak0HsdlLUpurULl4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B73F168AFE; Wed, 29 Jul 2026 13:55:40 +0200 (CEST)
Date: Wed, 29 Jul 2026 13:55:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>,
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
Message-ID: <20260729115540.GA32573@lst.de>
References: <cover.1785274111.git.asml.silence@gmail.com> <5c2e9c3bdd3e87c0c9a6e4395ea199002b83fd36.1785274111.git.asml.silence@gmail.com> <CGME20260729072126epcas5p3ad4422a45f1274b71f15dec8bf487fcc@epcas5p3.samsung.com> <20260729072117.GI9534@lst.de> <81412691.21785320403945.JavaMail.epsvc@epcpadp1new> <20260729113108.GA31120@lst.de> <b03bba6f-0a8f-41fc-af59-2a69d271f28b@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b03bba6f-0a8f-41fc-af59-2a69d271f28b@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 12:45:47PM +0100, Pavel Begunkov wrote:
> It was exposed in early version as I was passing a [{dma,len}, ...]
> array, but we moved from that. Maybe I should put the minimum
> segment size in the map structure, and (possibly over) split using
> that for now? Keith had this chunk in his patches:
>
> +		int offset = offset_in_page(bio->bi_iter.bi_bvec_done);
> +
> +		nsegs = ALIGN(bio->bi_iter.bi_size + offset, PAGE_SIZE) >>
> +								PAGE_SHIFT;
> +		if (bio->bi_iter.bi_size > max_bytes) {
> +			bytes = max_bytes;
> +			nsegs = (bytes + offset) >> PAGE_SHIFT;
> +		} else if (nsegs > lim->max_segments) {
> +			nsegs = lim->max_segments;
> +			bytes = PAGE_SIZE * nsegs - offset;
> +		} else {
> +			*segs = nsegs;
> +			return NULL;
> +		}

This seems very pessimistic, especially for the case of the registration
only having a single segment, which I'd expect to be fairly common due
to P2P bar mappings, huge pages or IOMMU coalescing.  So at very least
we'd want to special case that, but in an idea world the caller would
be required to provide a useful nr_segments for the I/O.

