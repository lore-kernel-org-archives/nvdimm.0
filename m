Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA25422FDE6;
	Wed, 29 Jul 2026 06:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785308399; cv=none; b=cIQOr7e1M1uLxZi4VtK/r5tDbosfvUv7U6JBMCexXpc1oAQ5JNMzjOfc2U5YfnoFokLv15EUbjDNP0e0OOGStbRkgIOgLmf+NiauFkHzgAq5bM2p1Lp06abAWsj60JABGzYyD0ZXHatRBpQofWh9MFLwppznsAGRjO+SBTe1YF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785308399; c=relaxed/simple;
	bh=RWPI2TwzGVTfRFjDW7N5KTR9xNzdLf72Zzf9mDAykfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiBeWLZif/x2y9XKjmXBBSBQLrDar5RTu4qhRWJYMLp8kovhK7rFLFh5jed7F0ytcN/bfuSHFCNMdYQq07lEDeSCZXpVE1scxnHvBijqrHZd7ABMZdhYcn5BRA/p1ORl5cR1nP48SyP/xEQG4L/sQ4Idpy/0tNsH8pT3ZQ6qQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1F37368AFE; Wed, 29 Jul 2026 08:59:54 +0200 (CEST)
Date: Wed, 29 Jul 2026 08:59:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
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
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v4 02/14] iov_iter: add iterator type for dmabuf maps
Message-ID: <20260729065953.GB9534@lst.de>
References: <cover.1785274111.git.asml.silence@gmail.com> <132442812a40277a5904cb2a8ca1e02f4f6e82a2.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <132442812a40277a5904cb2a8ca1e02f4f6e82a2.1785274111.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 28, 2026 at 10:29:14PM +0100, Pavel Begunkov wrote:
> Introduce a new iterator type for dmabuf maps. The map in an opaque
> object with internals and format specific to the subsystem / driver, and
> only it can use that subsystem / driver for issuing IO. The task of the
> middle layers is to pass the map / iterator further down, maybe doing
> basic splitting and length checking. The iterator can only be used by
> operations of the file the associated map was created for.
> 
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'm also pretty sure I reviewed this and vairous other patches
before..

