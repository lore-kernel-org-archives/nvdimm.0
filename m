Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC673D8119;
	Wed, 29 Jul 2026 07:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309697; cv=none; b=aUNWfZ4l+Rxjm6eT4DpcJONdV/T41WNfEXpvu+VgBGRifoEXGE8SHQbp2lAPHTNQDT1BOG6a1jcoOpVBAbJcoGr/oKIQLz4xAqYtl7eRoDhHF1PQaoVtKv1iGmUZwN/TVEFnFTtshJvJ2r3fLXr4lE8VuKhQ7e7a0/r1wC8wTBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309697; c=relaxed/simple;
	bh=jm63ujggDGcJk+nobtNkRB8tEtWZgchyj+8aoHeZa7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3YjM2AsS/BFjZsUNkqIlGpje1ayXxd+WNzn7apSFzVY8bwIhRn8NmHVadlYqmy2T52s/AEheIsvwMrM8EHJuC85+Y0hvKH21vURcg3qB9e747fviZYfb3oaaNy2kF8KB6ZEM8icdYTUZO6q69ywDZpBUlBgqLQ733W8HN0S0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC54468AFE; Wed, 29 Jul 2026 09:21:17 +0200 (CEST)
Date: Wed, 29 Jul 2026 09:21:17 +0200
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
Subject: Re: [PATCH v4 09/14] nvme-pci: add SGL support for the dmabuf path
Message-ID: <20260729072117.GI9534@lst.de>
References: <cover.1785274111.git.asml.silence@gmail.com> <5c2e9c3bdd3e87c0c9a6e4395ea199002b83fd36.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c2e9c3bdd3e87c0c9a6e4395ea199002b83fd36.1785274111.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 28, 2026 at 10:29:21PM +0100, Pavel Begunkov wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add SGL support in addition to PRP for dmabuf-backed requests,
> coalescing the mapping's sg_table into NVMe SGL data descriptors.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> [pavel: rebased]
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/nvme/host/pci.c | 191 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 187 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index f1b67c191892..cbb321fb7c50 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -1287,12 +1287,18 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
>  	return BLK_STS_IOERR;
>  }
>  
> +static void nvme_pci_sgl_set_data_addr(struct nvme_sgl_desc *sge,
> +				       dma_addr_t addr, u32 len)
> +{
> +	sge->addr = cpu_to_le64(addr);
> +	sge->length = cpu_to_le32(len);
> +	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
> +}
> +
>  static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
>  		struct blk_dma_iter *iter)
>  {
> -	sge->addr = cpu_to_le64(iter->addr);
> -	sge->length = cpu_to_le32(iter->len);
> -	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
> +	nvme_pci_sgl_set_data_addr(sge, iter->addr, iter->len);
>  }

The naming is a bit confusing (and me passing the iter to
nvme_pci_sgl_set_data is probably at faul for that).  So maybe
spin out a prep patch to rename the old nvme_pci_sgl_set_data
to nvme_pci_dma_iter_set_sgl or so, and then add the new one
as nvme_pci_sgl_set_data (as before the dma_iter conversion).

>
> +static unsigned int nvme_pci_dmabuf_sgl_nents(struct request *req,
> +					      dma_addr_t *first_dma,
> +					      u32 *first_len)

This is a really good example why the aligning to the opening braces
produces totally unreadble code..

But I also don't understand what the use case for this function
is to start with.  struct sg_table tells us how many segments
exist on the DMA side in the nents member, which should be just
fine for the SGL threshold calculation.

> +{
> +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +	struct bio *bio = req->bio;
> +	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
> +	size_t length = blk_rq_payload_bytes(req);
> +	struct nvme_sgl_desc *sg_list = NULL;
> +	dma_addr_t sgl_dma = 0, last_end = 0;
> +	unsigned int mapped = 0;
> +	unsigned long tmp;
> +	struct scatterlist *sg;
> +	size_t offset, remaining;
> +	bool have = false;
> +
> +	if (!entries)
> +		return BLK_STS_IOERR;
> +	if (entries > NVME_MAX_SEGS)
> +		return BLK_STS_AGAIN;

Given that the block layer enforced data in rw/command and the
max_segments limit, why do we need the extra check here?

> +			continue;
> +		}
> +
> +		addr += offset;
> +		sg_len -= offset;
> +		offset = 0;
> +
> +		while (sg_len && remaining) {

These can't be false on the first iteration, so maybe turn this into
a do {} while loop?

> +			u32 chunk = min_t(size_t, remaining, sg_len);
> +
> +			if (have && last_end == addr) {
> +				u32 old = le32_to_cpu(sg_list[mapped - 1].length);
> +
> +				sg_list[mapped - 1].length = cpu_to_le32(old + chunk);

Overly long line.

> +			} else {
> +				if (WARN_ON_ONCE(mapped == entries))
> +					goto err_free;
> +				nvme_pci_sgl_set_data_addr(&sg_list[mapped++],
> +							   addr, chunk);
> +			}

Why do we need this merging?  dma_map_sg should have already done
any interesting merging, or am I missing something?

> +		if (use_sgl != SGL_UNSUPPORTED) {
> +			dma_addr_t first_dma;
> +			u32 first_len;
> +			unsigned int entries;
> +
> +			entries = nvme_pci_dmabuf_sgl_nents(req, &first_dma,
> +							    &first_len);
> +
> +			if (use_sgl == SGL_FORCED) {
> +				ret = nvme_rq_setup_dmabuf_sgl(req, nvmeq,
> +								entries, first_dma, first_len);
> +				return ret == BLK_STS_AGAIN ? BLK_STS_IOERR : ret;
> +			}
> +
> +			if (sgl_threshold && entries &&
> +			    DIV_ROUND_UP(blk_rq_payload_bytes(req), entries) >=
> +			    sgl_threshold) {
> +				ret = nvme_rq_setup_dmabuf_sgl(req, nvmeq,
> +								entries, first_dma, first_len);
> +				if (ret != BLK_STS_AGAIN)
> +					return ret;
> +			}
> +		}

Various overly long lines.  Please factor out a helper for the
decisions to use sgl vs not instead of open coding it here.


