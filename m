Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAECD3ACEF6
	for <nvdimm@lists.linux.dev>; Fri, 17 Jul 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300628; cv=pass; b=Cj9psS5tDXvyUxW6SD+xo7eWGSvBFkMHzMPgbRSkfNxZ0sQcguYx/Y4sqJkrzJuLhhsdF9jP2TGFl9F3/+RJGm/1UEaF1Xnme2y51OgkBmmu6nLXNF5OEXxvMeq1TU2urameOn8GfhrR22kmJHV92IGBYifnRB+NqBIuOAU9Jh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300628; c=relaxed/simple;
	bh=4I5hTuD/iFXPg+NyVOkcJtrnXIHDXNgE/JDWa9xvQe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DJmqpgWN70IRbDMjuMpwOPiaMV29z+kanPl88dLTz1ZxhZy8tW+sthh2Y3skrCRLK0gRHlWQe57pFKos3xboS5BQF7f5U4mtHnLm9qAVO9qbW1ryWdWQk+plTCcOlsbwd2B5HOpEGjLiGl6pC8Cf53WO8tQHDst5bxsgfR9C2jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUsg/fXB; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUsg/fXB"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-456395f4e7bso1381906fac.0
        for <nvdimm@lists.linux.dev>; Fri, 17 Jul 2026 08:03:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784300625; cv=none;
        d=google.com; s=arc-20260327;
        b=HyZzi7BygTQ0eBWnGv2YW4imt+ANoSDwqj3VcpqOvM6q70JUw3UNF0JHSEjPTmUFjP
         BcTrh060B3wyaqOO8CbWSJ0XqTMdBDqQGutki0+a4HmzZZhEEZZBJgU3DGEpWRCpYX9M
         UaqXI0xaf1E0cgza7PS3kuH7F4HfKcSYMrmbX640Lj7ICVbS6g4WFFkDo6mlKIHaxp1q
         jrHjUy6XYjeScW4SL7UdeGd2nabAc7ktS0MVRXGvOxoQ6UzLX+1JdHRpitHA6/n0QKIK
         NpnkmlTG1WpPBFFn2Pgp5t+bIZHkgT1VStDMwJRajYt7SIGc5BG3YDLJPlELHr+aoFY5
         1Sww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=poYdYrQ7d60yOY7c10x2Y/P8RkUQTllTFQeSEPM/KwY=;
        fh=GOo3nzfefX5mvlnhSFSmNVkiRAFOkJYa90NgeetMHuQ=;
        b=YphS6DrwI9ttuKKGt4qwLJWTL2+iyTouK0WPvJ6fPnXQSKdDpY+nQvAxdeBoSz9b2j
         8LUHAVMAV1zBEkPYoz+KrAzFReaxnbS/3Bf1mYW4kauXeJx1uh1GKo8tUvCYQMduq/5r
         BCqQu7IAWGwlkcwB9M7VFtYzlI4kbotr9e2l7Hm6NndmVK6gfZEaNqGeirIaht1pv4Qt
         Rmrnm2pM7c5JnlFsDFJnj7sLVEbcbv7InP/Q60nnWxcUCOyF9bGDb7tVZRYG84HpiZsX
         PDp8bZFVLIxTVTOPxtKvoJ/O7Gr/rGDTllF3ChYfKY7dn3L1CJCtRMKGuK+CI/G201Cc
         Lo7w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784300625; x=1784905425; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=poYdYrQ7d60yOY7c10x2Y/P8RkUQTllTFQeSEPM/KwY=;
        b=VUsg/fXBULfRlTNfi0TT8EbWYiaDR6/Rf42J+0qkLYJfQLaLc8a0GDdPjVVc0v62yV
         jfH2c/6YP46gQMD0hjXNdi23+32PgTKTBxMeyVG4j//8p503pBCGC2u00AaSIvebSE3X
         209B0JIK8XWGgROfTVosv7KHdmZbqha+gY6SKRETzTRsjQpA2sZKajRENs3ILvTNBvwg
         2jSXPydiaEuIE9kkrkEkZLRvPXUkS9vAtiCIlk30nRZnlWQk0KV3lUcw4QE40AtjiarG
         4x6UaiMG+H+K1o88G65Q9Mx5zdXwG0/pZJt1OVJ1PDn+9uh4bWzKtMKRUYJTqHaZu+Q/
         s28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300625; x=1784905425;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=poYdYrQ7d60yOY7c10x2Y/P8RkUQTllTFQeSEPM/KwY=;
        b=bPWFC5C5jZsAX2eR3GEPdLZbVqfTnd/POvsUjYXJivjPuGKh5QhZhYq7StQ/Un4pZa
         wLWG86eHKGTT0PPjzmgzgMF/VJBJgHivkBSY5gliu0hi2SH99nHd9whycvAuz16XhM/D
         bmLnEEFoo19Y/xmCwNpIujBw59JHo5/hlixcaSBcG5KfA1p7EF8tl2a53mPJa9X0nbo+
         gWFSpaCmW/zmXBTt9bqfpZcj6ORTJrZcOpnvbox45PVyL1mt3LeLODx99ePJ+U5qR28L
         IY8Q+tm4K4puz3bTEsmkxrarWFh0okiOLuBfpNANchQR2ge8nBWT01T7xAeMLwXvGFNH
         9qPg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4F1AsNu4Dqfw6E3cm/tzPs5KfWUz7x7KjAM8YWX09xkB0d7eQRp4U+kmn/AcjuPZhavv+09U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyT65687W53JXcPjo+pdYvLrc44kUZ8dBGmNp8nefINXF6px8Vo
	mf57EZkmQ7jPG+VLlYFqH1pUhj0flto46G7AFz2KWY0svMqeghqvZtjC4Avt+dwr1WL/NVdwzQ9
	uKbuyKTExL3TiRWXWD5wfNSt3hbzL9nk=
X-Gm-Gg: AfdE7ckFvWtuerorofjy5SWSe62kAfYHHmwsBgIqR/6ZAfyednd7iOeeHF7a4ES8t3L
	dVrL9QO/NH+/kPCrVztC8+b582ubUQ3DonZpvh6SIIeOlLfmrFM9nPdlNddG9xje7SeTH+wXM34
	wPXStsctPfeR6VoL8IfLehzjq5cQx/8kdsxQ3txATez8CfZ9E1nMId5lgFuQfZiwIEFV/EVTOYf
	uEi73AyAEjrHgahAC9l+YFiaRE7e876dLyeV8cFsuISGoEZag7bFX1Qr4YDJ31PXT4IEB/0Hmo=
X-Received: by 2002:a05:6870:c695:b0:456:65b1:a226 with SMTP id
 586e51a60fabf-456905a565emr1171540fac.41.1784300625241; Fri, 17 Jul 2026
 08:03:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260709124455.1547912-1-joseph.qi@linux.alibaba.com>
In-Reply-To: <20260709124455.1547912-1-joseph.qi@linux.alibaba.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Fri, 17 Jul 2026 17:03:33 +0200
X-Gm-Features: AUfX_myPnm6hoDB2wsVDiOjsIb4vMF9folxx9WjFpkN0El1BM_Z84gVyqPqpkL4
Message-ID: <CAM9Jb+jXPPe2X98ADMHMzFFGgJKzM27+45Bnn8iRj1+KqJWjiQ@mail.gmail.com>
Subject: Re: [PATCH v2] virtio-pmem: allocate flush bio from a driver-private bio_set
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>, Baokun Li <libaokun@linux.alibaba.com>, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Dan Williams <djbw@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Alison Schofield <alison.schofield@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

+CC more folks

> async_pmem_flush() allocates a child bio for the flush with GFP_ATOMIC.
> This runs from pmem_submit_bio(), a ->submit_bio callback that executes
> in a sleepable context, so there is no atomicity requirement here.
>
> bio_alloc() only guarantees success when __GFP_DIRECT_RECLAIM is set,
> because that is what lets it fall back to the mempool reserve. With
> GFP_ATOMIC the reclaim bit is absent, so the allocation can fail and
> return -ENOMEM whenever the fast paths (percpu cache and slab) are
> exhausted, which is common right after boot. A flush is issued from
> filesystem writeback and must not fail on a transient allocation
> shortage, otherwise the device can appear unmountable:
>
>   Buffer I/O error on dev pmem0, logical block 0, lost sync page write
>
> Switch to GFP_NOIO so __GFP_DIRECT_RECLAIM is set and the allocation can
> make forward progress. However, bio_alloc() draws from the shared
> fs_bio_set, and the incoming bio being flushed may itself have come from
> fs_bio_set; allocating a second bio from the same set while submitting
> underneath ->submit_bio can deadlock the mempool. Add a driver-private
> bio_set for the flush and allocate from it via bio_alloc_bioset(), so
> the flush bio has an independent reserve.
>
> With a dedicated mempool-backed bio_set and GFP_NOIO the allocation
> cannot fail, so drop the now-redundant NULL check.
>
> Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  drivers/nvdimm/nd_virtio.c   | 11 ++++++-----
>  drivers/nvdimm/virtio_pmem.c | 11 ++++++++++-
>  drivers/nvdimm/virtio_pmem.h |  4 ++++
>  3 files changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 4176046627beb..b4bd21edf5c1c 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -110,17 +110,18 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  /* The asynchronous flush callback function */
>  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  {
> +       struct virtio_device *vdev = nd_region->provider_data;
> +       struct virtio_pmem *vpmem = vdev->priv;
> +
>         /*
>          * Create child bio for asynchronous flush and chain with
>          * parent bio. Otherwise directly call nd_region flush.
>          */
>         if (bio && bio->bi_iter.bi_sector != -1) {
> -               struct bio *child = bio_alloc(bio->bi_bdev, 0,
> -                                             REQ_OP_WRITE | REQ_PREFLUSH,
> -                                             GFP_ATOMIC);
> +               struct bio *child = bio_alloc_bioset(bio->bi_bdev, 0,
> +                                       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
> +                                       &vpmem->flush_bio_set);
>
> -               if (!child)
> -                       return -ENOMEM;
>                 bio_clone_blkg_association(child, bio);
>                 child->bi_iter.bi_sector = -1;
>                 bio_chain(child, bio);
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 77b1966619059..136179506b478 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -65,12 +65,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>         }
>
>         mutex_init(&vpmem->flush_lock);
> +       err = bioset_init(&vpmem->flush_bio_set, BIO_POOL_SIZE, 0, 0);
> +       if (err) {
> +               dev_err(&vdev->dev, "failed to initialize flush bio_set\n");
> +               goto out_err;
> +       }
>         vpmem->vdev = vdev;
>         vdev->priv = vpmem;
>         err = init_vq(vpmem);
>         if (err) {
>                 dev_err(&vdev->dev, "failed to initialize virtio pmem vq's\n");
> -               goto out_err;
> +               goto out_bioset;
>         }
>
>         if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION)) {
> @@ -131,6 +136,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>         nvdimm_bus_unregister(vpmem->nvdimm_bus);
>  out_vq:
>         vdev->config->del_vqs(vdev);
> +out_bioset:
> +       bioset_exit(&vpmem->flush_bio_set);
>  out_err:
>         return err;
>  }
> @@ -138,10 +145,12 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  static void virtio_pmem_remove(struct virtio_device *vdev)
>  {
>         struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
> +       struct virtio_pmem *vpmem = vdev->priv;
>
>         nvdimm_bus_unregister(nvdimm_bus);
>         vdev->config->del_vqs(vdev);
>         virtio_reset_device(vdev);
> +       bioset_exit(&vpmem->flush_bio_set);
>  }
>
>  static int virtio_pmem_freeze(struct virtio_device *vdev)
> diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> index f72cf17f9518f..4ff2076f75047 100644
> --- a/drivers/nvdimm/virtio_pmem.h
> +++ b/drivers/nvdimm/virtio_pmem.h
> @@ -15,6 +15,7 @@
>  #include <linux/libnvdimm.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> +#include <linux/bio.h>
>
>  struct virtio_pmem_request {
>         struct virtio_pmem_req req;
> @@ -39,6 +40,9 @@ struct virtio_pmem {
>         /* Serialize flush requests to the device. */
>         struct mutex flush_lock;
>
> +       /* bio_set for allocating flush child bios */
> +       struct bio_set flush_bio_set;
> +
>         /* nvdimm bus registers virtio pmem device */
>         struct nvdimm_bus *nvdimm_bus;
>         struct nvdimm_bus_descriptor nd_desc;
> --
> 2.39.3
>
