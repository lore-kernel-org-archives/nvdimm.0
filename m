Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B94C2D97A6;
	Wed, 29 Jul 2026 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785320414; cv=none; b=cUJfQcilFC+KTHObk8Mm0l04k8fss1rdz93russ/kih/eCpsuCst8kFotgDDVXGJzHgOkF7uXSECsmwk2DhKixztA38uF1raAIuKGeueuodk/tKDOzSqTVYbqFYTKEb3S1b781zWBavMMX4yK50M74aG1rwiLZungUSoGqhq4gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785320414; c=relaxed/simple;
	bh=+1a/OT2481T+59sg8ufgIHScRUqYsFobhx+HNtK0Jvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=OpGVGBW5D0BmEjY0Wcdj/akidgFhjTUj8jWgc33TXuT7A1KYp8WFecQ0iXEl85VWA3wNbe9zCoRHrXc3HlVRk77BE1tZB46Me+C5aEJs33eG+l3g9o0d7X63yRYC1joAnpDY8/TCkynKP4qFRSbBn1t8pJvnUNOXrQYWThm2P/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eDWsTaNm; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eDWsTaNm"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260729102004epoutp04a6403b75b5e06d6cf3e472c8420bbbbc~Gu3LiDozw0592505925epoutp04P;
	Wed, 29 Jul 2026 10:20:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260729102004epoutp04a6403b75b5e06d6cf3e472c8420bbbbc~Gu3LiDozw0592505925epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785320404;
	bh=YCW02Jxoo99jpNlsyhoDkdRYpwZg1zR6VRHvl0BIrE8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=eDWsTaNmgcGwi1kazmv+E5CPogPPPr6vL2mmbeB1RfWehFQsKfcAB9zpXj77o3NNE
	 kIQwZVVXiHqiLsmtO/MXIpcWlp7GBSIvMnTfb59L4HkAZ30XCSg0iNP74B6djfVWXE
	 knTC/ZRw43C2ERbPsPMwRyLELRQ8MHVxrQnA+IW0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260729102004epcas5p2561f4970a332635bb0bcb22dc8aab55d~Gu3LO-Erh0974809748epcas5p2K;
	Wed, 29 Jul 2026 10:20:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h97cg6qpPz6B9mB; Wed, 29 Jul
	2026 10:20:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260729101729epcas5p22470163e142ebd0396fde02f3ab2532b~Gu07MoEUA0811408114epcas5p2g;
	Wed, 29 Jul 2026 10:17:29 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260729101724epsmtip20bd2616b77b7372e21c910f8cdc4cc60~Gu02psnJC1532915329epsmtip2D;
	Wed, 29 Jul 2026 10:17:24 +0000 (GMT)
Message-ID: <81412691.21785320403945.JavaMail.epsvc@epcpadp1new>
Date: Wed, 29 Jul 2026 15:47:23 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/14] nvme-pci: add SGL support for the dmabuf path
To: Christoph Hellwig <hch@lst.de>, Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Sagi
	Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Nitesh Shetty
	<nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, Tushar Gohad
	<tushar.gohad@intel.com>, William Power <william.power@intel.com>, Phil
	Cayton <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>, Damien Le
	Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin
	Marzinski <bmarzins@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, cpgs@samsung.com
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260729072117.GI9534@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260729101729epcas5p22470163e142ebd0396fde02f3ab2532b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260729072126epcas5p3ad4422a45f1274b71f15dec8bf487fcc
References: <cover.1785274111.git.asml.silence@gmail.com>
	<5c2e9c3bdd3e87c0c9a6e4395ea199002b83fd36.1785274111.git.asml.silence@gmail.com>
	<CGME20260729072126epcas5p3ad4422a45f1274b71f15dec8bf487fcc@epcas5p3.samsung.com>
	<20260729072117.GI9534@lst.de>

>> +static void nvme_pci_sgl_set_data_addr(struct nvme_sgl_desc *sge,
>> +				       dma_addr_t addr, u32 len)
>> +{
>> +	sge->addr = cpu_to_le64(addr);
>> +	sge->length = cpu_to_le32(len);
>> +	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
>> +}
>> +
>>   static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
>>   		struct blk_dma_iter *iter)
>>   {
>> -	sge->addr = cpu_to_le64(iter->addr);
>> -	sge->length = cpu_to_le32(iter->len);
>> -	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
>> +	nvme_pci_sgl_set_data_addr(sge, iter->addr, iter->len);
>>   }
> 
> The naming is a bit confusing (and me passing the iter to
> nvme_pci_sgl_set_data is probably at faul for that).  So maybe
> spin out a prep patch to rename the old nvme_pci_sgl_set_data
> to nvme_pci_dma_iter_set_sgl or so, and then add the new one
> as nvme_pci_sgl_set_data (as before the dma_iter conversion).
>

Thanks for the detailed review! Will split the rename into a prep patch.

>>
>> +static unsigned int nvme_pci_dmabuf_sgl_nents(struct request *req,
>> +					      dma_addr_t *first_dma,
>> +					      u32 *first_len)
> 
> This is a really good example why the aligning to the opening braces
> produces totally unreadble code..
> 
> But I also don't understand what the use case for this function
> is to start with.  struct sg_table tells us how many segments
> exist on the DMA side in the nents member, which should be just
> fine for the SGL threshold calculation.

sg_table->nents covers the entire exported buffer (<=1GiB), while a
request only covers a subrange[bi_offset, bi_offset+payload). Using
nents would overcount the request's segments.

> 
>> +{
>> +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>> +	struct bio *bio = req->bio;
>> +	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
>> +	size_t length = blk_rq_payload_bytes(req);
>> +	struct nvme_sgl_desc *sg_list = NULL;
>> +	dma_addr_t sgl_dma = 0, last_end = 0;
>> +	unsigned int mapped = 0;
>> +	unsigned long tmp;
>> +	struct scatterlist *sg;
>> +	size_t offset, remaining;
>> +	bool have = false;
>> +
>> +	if (!entries)
>> +		return BLK_STS_IOERR;
>> +	if (entries > NVME_MAX_SEGS)
>> +		return BLK_STS_AGAIN;
> 
> Given that the block layer enforced data in rw/command and the
> max_segments limit, why do we need the extra check here?

A dmabuf bio reports nsegs=1 (bio_split_io_at) to the block layer, so 
max_segments isn't enforced against the SG entries actually spanned by 
the request. Hence the explicit check.

> 
>> +			continue;
>> +		}
>> +
>> +		addr += offset;
>> +		sg_len -= offset;
>> +		offset = 0;
>> +
>> +		while (sg_len && remaining) {
> 
> These can't be false on the first iteration, so maybe turn this into
> a do {} while loop?

Will do.

> 
>> +			u32 chunk = min_t(size_t, remaining, sg_len);
>> +
>> +			if (have && last_end == addr) {
>> +				u32 old = le32_to_cpu(sg_list[mapped - 1].length);
>> +
>> +				sg_list[mapped - 1].length = cpu_to_le32(old + chunk);
> 
> Overly long line.
> 
>> +			} else {
>> +				if (WARN_ON_ONCE(mapped == entries))
>> +					goto err_free;
>> +				nvme_pci_sgl_set_data_addr(&sg_list[mapped++],
>> +							   addr, chunk);
>> +			}
> 
> Why do we need this merging?  dma_map_sg should have already done
> any interesting merging, or am I missing something?

Will drop it.

