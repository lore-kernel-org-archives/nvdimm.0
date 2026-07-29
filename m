Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C703D48D87D
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332323; cv=none; b=dIBuY0NF7VIwR9oUTjEKi319xEXYrY4+xN5F2Mao/vsIFmg2uxnUcDhI/KHVfsmYTVM4TzOAdBXabvYpyKSDXauVz3NwqK2c0kvvwd1ItCoAQHKUxsyjAzVx2mtNxqvHhb1Pc+32Gh+mcoQDc0Rf+xSpYDnrrKyMXqRwnQZDsW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332323; c=relaxed/simple;
	bh=u+9R3X2V5UeZkHzMCRvsnM9b0a1uTz3ZLvCmabq8lAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=NTavSgpnRUdR4S1z3PQ5JuDfLbg8F36Slmd7ELiQzBSl15W4R7FmZ5NbB3le6Jx6Acx32WpmwMM96KdfKZd+I1pXyyLCbGS+mwlxffMU+YnBf4pjBC9URfAA8JRo1tjnA8PLf+5m/7olwNp7vX7bkFybbkopCuNtOIIzHiFHoHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HsWwrPXX; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HsWwrPXX"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260729133056epoutp028e636d4c66253536b2ed6f048e5eb6e8~Gxd1XtdTO2070420704epoutp02W
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:30:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260729133056epoutp028e636d4c66253536b2ed6f048e5eb6e8~Gxd1XtdTO2070420704epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785331856;
	bh=DFEWI+h+ujBl3AuAySkQO2sTC26NrP8SbkAb+UIr3F0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=HsWwrPXXRrp/O6gwT2CU2W6MRSa3y4QEz2T9FZg7HvlUguP/w914PJzUXRCbt5/7G
	 UKefM+7DXd9/6vIbCBl2WSX95poBvNMbvIoBPakrN0cJpiKKqEpLUvoNlCcwEX/r3P
	 ccFIxzAri1rej6D74bRxn/e3Nag1sqkfn5YWR2k4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260729133055epcas5p1ffb351ee3ef2c6b1de5218d34cae5f2c~Gxdz91yo90832108321epcas5p1C;
	Wed, 29 Jul 2026 13:30:55 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h9Crt1xWTz6B9m4; Wed, 29 Jul
	2026 13:30:54 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260729133052epcas5p21fab8c8ffc58e9b13b267e5af8bbbb63~Gxdx2A4v01143011430epcas5p21;
	Wed, 29 Jul 2026 13:30:52 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260729133048epsmtip16941ede4dcd7309490d22dae2d039c4d~GxdtThzIP1847018470epsmtip1c;
	Wed, 29 Jul 2026 13:30:47 +0000 (GMT)
Message-ID: <583fdfb2-5368-467f-a388-6d388859c995@samsung.com>
Date: Wed, 29 Jul 2026 19:00:46 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered
 buffers
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi
	Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sumit
	Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>, Jason Gunthorpe <jgg@nvidia.com>, Damien Le
	Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Benjamin
	Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, Ilya
	Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260729133052epcas5p21fab8c8ffc58e9b13b267e5af8bbbb63
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260728213020epcas5p1721e72ba5544abf0b61482da005120d9
References: <cover.1785274111.git.asml.silence@gmail.com>
	<CGME20260728213020epcas5p1721e72ba5544abf0b61482da005120d9@epcas5p1.samsung.com>
	<26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>

On 7/29/2026 2:59 AM, Pavel Begunkov wrote:
> +static struct io_rsrc_node *io_register_dmabuf(struct io_ring_ctx *ctx,
> +						struct io_uring_regbuf_desc *desc)
> +{
> +	struct io_rsrc_node *node = NULL;
> +	struct io_mapped_ubuf *imu = NULL;
> +	struct io_regbuf_dma *regbuf = NULL;
> +	struct file *target_file = NULL;
> +	struct dma_buf *dmabuf = NULL;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> +		return ERR_PTR(-EOPNOTSUPP);
> +	if (ctx->flags & IORING_SETUP_IOPOLL)
> +		return ERR_PTR(-EOPNOTSUPP);
> +	if (desc->uaddr || desc->size)
> +		return ERR_PTR(-EINVAL);
> +
> +	ret = -ENOMEM;
> +	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> +	if (!node)
> +		return ERR_PTR(-ENOMEM);
> +	imu = io_alloc_imu(ctx, 0);
> +	if (!imu)
> +		goto err;
> +	regbuf = kzalloc(sizeof(*regbuf), GFP_KERNEL);
> +	if (!regbuf)
> +		goto err;
> +
> +	ret = -EBADF;
> +	target_file = fget(desc->target_fd);
> +	if (!target_file)
> +		goto err;
> +
> +	dmabuf = dma_buf_get(desc->dmabuf_fd);
> +	if (IS_ERR(dmabuf)) {
> +		ret = PTR_ERR(dmabuf);
> +		dmabuf = NULL;
> +		goto err;
> +	}
> +	if (dmabuf->size > SZ_1G) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	ret = dma_buf_io_ctx_create(target_file, &regbuf->ctx, dmabuf,
> +				    DMA_BIDIRECTIONAL);
> +	if (ret)
> +		goto err;
> +
> +	regbuf->target_file = target_file;
> +	imu->nr_bvecs = 1;

There is no bvec backing a dmabuf imu - should this be 0?

> +	imu->ubuf = 0;
> +	imu->len = dmabuf->size;
> +	imu->folio_shift = 0;
> +	imu->release = io_release_reg_dmabuf;
> +	imu->priv = regbuf;
> +	imu->flags = IO_REGBUF_F_DMABUF;
> +	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
> +	refcount_set(&imu->refs, 1);
> +	node->buf = imu;
> +	dma_buf_put(dmabuf);
> +	return node;
> +err:
> +	kfree(regbuf);
> +	if (imu)
> +		io_free_imu(ctx, imu);
> +	if (node)
> +		io_cache_free(&ctx->node_cache, node);
> +	if (target_file)
> +		fput(target_file);
> +	if (dmabuf)
> +		dma_buf_put(dmabuf);
> +	return ERR_PTR(ret);
> +}
> +
> +

nit: extra newline here

> +static int io_import_dmabuf(struct io_kiocb *req,
> +			   int ddir, struct iov_iter *iter,
> +			   struct io_mapped_ubuf *imu,
> +			   size_t len, size_t offset,
> +			   unsigned issue_flags)
> +{
> +	struct io_regbuf_dma *db = imu->priv;
> +	struct dma_buf_io_map *map;
> +
> +	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> +		return -EOPNOTSUPP;
> +	if (!len)
> +		return -EFAULT;
> +	if (req->file != db->target_file)
> +		return -EBADF;
> +
> +	if (req->flags & REQ_F_DROP_DMABUF) {
> +		map = req->dmabuf_map;
> +		goto init_iter;
> +	}

O_DIRECT is checked only during registration; we should recheck
(file->f_flags & O_DIRECT) per request.

