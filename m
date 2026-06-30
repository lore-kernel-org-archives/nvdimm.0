Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9123F075A
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 10:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782815298; cv=none; b=CxzemAur3iZz+LL5SVkuWhx63qkABcDFefPzaNVxDxfUMMXEbuh8H1c7C7VZunUNk1QRlfqS3O7li/7FeKxP5jx9FujbLSHV6Pcvp7MvVBdGk8rKAcsgPIGE1WwSNc88XorT24fETbZMjy2n8yAoPunvgtmtuaoCkTpbr49LgeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782815298; c=relaxed/simple;
	bh=gT2KJYO7rghPiFA5dV0zixKv2phCs86Y6fazb1kQzew=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mrD077vzUGRuVZuQp9ps8BZKUFVVvjVhhpzNfgXQwFReMdMIHVp7BpVrEKU5w9ynDtI7ZGSqLLHT5OQht+fIzncF/Cm+PUR4yfIgt+dJuewjNvUwekwP8VAjZpqiDrZEqEs0xaP+olANlGNUMsE8dY4O/zn0phW5AslS/hXFaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcJ0DR8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PcJ0DR8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA31F00A3A;
	Tue, 30 Jun 2026 10:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782815297;
	bh=TDFERgUAfmvkPdxHwm5lSZZd5jCw7kbpMz24hTurTcM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PcJ0DR8dSdcxs7IxOY8grNDrziq3NfdwPFr4rPGf6UjCkRzk2bVFOFaD7pVcutZhE
	 qUUiouDUCBOwn7FAo13h7gJstzTvwm0j4NmtHlOKRBiNkueVOKl1Ra6PDbMT/nT5gv
	 XGF5x4pRGyDMQ+FeQe881SFGUZU156jJnsZKsqWVkvc6VwvuF6EZYHqMeLBxEg79E+
	 gK09oq9UV/X88t/bgCgWXgWsOUVyphE1xJVxlWMv3fFuyIcpXrNcqhVx+eo1JknUsW
	 NazqSLP0rUxqfc3Wy8mL1lN3zA05tWR2lhrfRNxrf1Fh3WARQ48nxIF+cNQOGH92ua
	 9msPKa/XZEf6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/12] nvdimm: virtio_pmem: stop allocating child
 flush bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Chen" <me@linux.beauty>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260630092338.2094628-5-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
 <20260630092338.2094628-5-me@linux.beauty>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 10:28:16 +0000
Message-Id: <20260630102817.24AA31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Block I/O Forward Progress / Deadlock due to missing mempool backi=
ng for flush allocations
--

commit e290d67d3c09c47f258d895e86c79743d39db2c1
Author: Li Chen <me@linux.beauty>

nvdimm: virtio_pmem: stop allocating child flush bio

This commit avoids allocating a child PREFLUSH bio during REQ_FUA
submission by queuing an ordered WQ_MEM_RECLAIM work item. It allows
provider flush callbacks to return NVDIMM_FLUSH_ASYNC after taking
ownership of parent bio completion.

> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 4176046627beb..8e16b7780be1a 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c

[ ... ]

> @@ -107,30 +113,46 @@ static int virtio_pmem_flush(struct nd_region *nd_r=
egion)
>  	return err;
>  };
> =20
> +static void virtio_pmem_flush_work(struct work_struct *work)
> +{
> +	struct virtio_pmem_flush_work *flush;
> +	int err;
> +
> +	flush =3D container_of(work, struct virtio_pmem_flush_work, work);
> +	err =3D virtio_pmem_flush(flush->nd_region);

[ ... ]

>  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  {
> -	/*
> -	 * Create child bio for asynchronous flush and chain with
> -	 * parent bio. Otherwise directly call nd_region flush.
> -	 */
> -	if (bio && bio->bi_iter.bi_sector !=3D -1) {
> -		struct bio *child =3D bio_alloc(bio->bi_bdev, 0,
> -					      REQ_OP_WRITE | REQ_PREFLUSH,
> -					      GFP_ATOMIC);
> +	struct virtio_device *vdev =3D nd_region->provider_data;
> +	struct virtio_pmem *vpmem =3D vdev->priv;
> +	struct virtio_pmem_flush_work *flush;
> +	int err;
> =20
> -		if (!child)
> +	if (bio && bio->bi_iter.bi_sector !=3D -1) {
> +		flush =3D kmalloc_obj(*flush, GFP_NOIO);

[Severity: High]
Can this cause a deadlock during memory reclaim?

Order-0 allocations with GFP_NOIO (which includes __GFP_DIRECT_RECLAIM)
can loop indefinitely in the page allocator's slowpath rather than failing.

Since this lacks mempool backing and is directly in the block I/O
submission path, couldn't the block submission thread block waiting
for memory, deadlocking if memory cannot be freed without this block I/O
completing?

> +		if (!flush)
>  			return -ENOMEM;
> -		bio_clone_blkg_association(child, bio);
> -		child->bi_iter.bi_sector =3D -1;
> -		bio_chain(child, bio);
> -		submit_bio(child);
> -		return 0;
> +
> +		INIT_WORK(&flush->work, virtio_pmem_flush_work);
> +		flush->nd_region =3D nd_region;
> +		flush->bio =3D bio;
> +		queue_work(vpmem->flush_wq, &flush->work);

[Severity: High]
Is it safe to queue work on a WQ_MEM_RECLAIM workqueue when the worker
function performs a non-mempool-backed GFP_NOIO allocation?

If the system is under severe memory pressure, the workqueue falls back
to its rescuer thread to ensure forward progress. The rescuer executes
virtio_pmem_flush_work() -> virtio_pmem_flush(), which allocates memory:

drivers/nvdimm/nd_virtio.c:virtio_pmem_flush() {
    ...
    req_data =3D kmalloc_obj(*req_data, GFP_NOIO);
    ...
}

Since GFP_NOIO includes __GFP_DIRECT_RECLAIM, the rescuer thread could
block indefinitely in direct reclaim trying to allocate req_data. Doesn't
this stall the rescuer thread and prevent pending flush completions from
making forward progress?

> +		return NVDIMM_FLUSH_ASYNC;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630092338.2094=
628-1-me@linux.beauty?part=3D4
