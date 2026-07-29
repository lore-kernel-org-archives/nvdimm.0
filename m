Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C4B3BED08;
	Wed, 29 Jul 2026 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309057; cv=none; b=sbryE5kDitwFIJf9fZ+zwwgsFaPM0c5eUkfM1hgLar+I1j0JvMffue26mvWtl5GI/X/pjXwjjU1eQ1pu7NMAeXaJe4B7zI/o8mOoz3UbV8DtXflGEbnGJnrjWr4az1cGV9znBERWj/RF4qs6j6UbYJ2diFqunBmnxnsIAcJo+gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309057; c=relaxed/simple;
	bh=WVZDQkhUnu9duG3GjcIsETE7tFgsSaQLorUhvqWmBNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRT4I0yf4SR15TVlh+U2ryCMWMjsGIFZ7HQK0q9nuvaJtGsruYGrH0gfikfds4aNxLy0Cuc0bsh0fRZeJoUPngMdKYUFk545W1oWR1m+c7Z7BoRQYiSfaABwYgASPYGJT7GnoTjuMX++mjdtV06/epO1JdWMhztHQw9qzX/pB9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4BC6668BEB; Wed, 29 Jul 2026 09:10:49 +0200 (CEST)
Date: Wed, 29 Jul 2026 09:10:48 +0200
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
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
Message-ID: <20260729071048.GH9534@lst.de>
References: <cover.1785274111.git.asml.silence@gmail.com> <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
> +				    struct dma_buf_io_ctx *ctx)

Please stick to two-tab indents for function declaration continuation
for the nvme code to keep the code easy to maintain.

> +#if defined(CONFIG_DMA_SHARED_BUFFER)

This should be good old #ifdef.  Same in a few other places over
the series.

Modulo these minor nits the patch looks good.
