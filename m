Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B23AA98
	for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 08:35:45 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-bd729434fa0so6874120276.1
        for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 01:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687422944; x=1690014944;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ml/gLb06BnApHnxHlA0l9KKOIGUf2TY1ELv59h6NJA=;
        b=IKA0XTp46XrrBlVqCSvjK6iItAugZKKTisGkLIz5Dl7uQO5SHEjhKIhx2eh+7Mj7kv
         4CI73ItXa2ihD9KYKaOdexpK6nsiSf/pOagQQRcZMOGXx6xW965e+dpidDwH1ZF5q0Pm
         c9edwYN7sAvkKkD5CiWcyJ1ITVoRM2sr6w3DikfIkiLwBufp9CpDJsFZidMaOwOWDI95
         Illnnwv7cD9PJ3HTkrKpELHeLDZsp8YAXN/2YVkoHHk7WN38c9TpOGJNrXCSyiKr5IjE
         PaTB2WfZVNUELRJRY0dvWxS0XL2WAbSay4ph5y2pmSMJJ7RG/WX94+e9Ql3OYtUT6Cz2
         Tu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687422944; x=1690014944;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Ml/gLb06BnApHnxHlA0l9KKOIGUf2TY1ELv59h6NJA=;
        b=ZCfYTd/6c4S+JQqClAEYD8FVsudm4SA3URR44vKwOEPyhq3VxtqkWyVDhcyisShvYs
         Kx6/iX9il14bURi1pDctRpwvWILkC0uxpDPUB8dpip/STWFxZSNMuoVHHzvxgyc6QgCn
         Js17BBeC+Y2K8GF1WgtKVkdASudel2qg181XBO1KaHCnVb5+bkhrzAaI8lD+hkihYVhW
         vOQVecBnFgwtmgK3/iCa3N7ZdYtIMm7rGr94NVxvtkKvJJy1sana+J1utN3OqB+Z0Bo+
         YlcuyGOCI009wfiHV4mMD5i08maVEi9RCMKMiPrPfdv5E2dKD2NOvxTIKHWnBKo1ygF/
         uDiQ==
X-Gm-Message-State: AC+VfDytPnE/pyK4QG1Aa8wElXS5ajHUhD7WEN/tT6PU2n34t8U2+jNg
	yXmc4mreeeURJe+Zn0JyXkKAouLp+uyFAuFRnLI=
X-Google-Smtp-Source: ACHHUZ5K/tdOf9g2jqlyhMD05CNG8iL0mdd9NIDMe8ANR3AC5fIjH62WgtnvncBE2rAGeDA7pzEzqROVWIEQcgmb4rA=
X-Received: by 2002:a25:da94:0:b0:bc7:d7ba:4e8b with SMTP id
 n142-20020a25da94000000b00bc7d7ba4e8bmr18303109ybf.13.1687422944349; Thu, 22
 Jun 2023 01:35:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZJLpYMC8FgtZ0k2k@infradead.org> <20230621134340.878461-1-houtao@huaweicloud.com>
In-Reply-To: <20230621134340.878461-1-houtao@huaweicloud.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 22 Jun 2023 10:35:32 +0200
Message-ID: <CAM9Jb+j8-DWdRMsXJNiHm_UK5Nx6L2=a2PnRL=m3sMyQz4cXLw@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
To: Hou Tao <houtao@huaweicloud.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux-foundation.org, houtao1@huawei.com
Content-Type: text/plain; charset="UTF-8"

> The following warning was reported when doing fsync on a pmem device:
>
>  ------------[ cut here ]------------
>  WARNING: CPU: 2 PID: 384 at block/blk-core.c:751 submit_bio_noacct+0x340/0x520
>  Modules linked in:
>  CPU: 2 PID: 384 Comm: mkfs.xfs Not tainted 6.4.0-rc7+ #154
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>  RIP: 0010:submit_bio_noacct+0x340/0x520
>  ......
>  Call Trace:
>   <TASK>
>   ? asm_exc_invalid_op+0x1b/0x20
>   ? submit_bio_noacct+0x340/0x520
>   ? submit_bio_noacct+0xd5/0x520
>   submit_bio+0x37/0x60
>   async_pmem_flush+0x79/0xa0
>   nvdimm_flush+0x17/0x40
>   pmem_submit_bio+0x370/0x390
>   __submit_bio+0xbc/0x190
>   submit_bio_noacct_nocheck+0x14d/0x370
>   submit_bio_noacct+0x1ef/0x520
>   submit_bio+0x55/0x60
>   submit_bio_wait+0x5a/0xc0
>   blkdev_issue_flush+0x44/0x60
>
> The root cause is that submit_bio_noacct() needs bio_op() is either
> WRITE or ZONE_APPEND for flush bio and async_pmem_flush() doesn't assign
> REQ_OP_WRITE when allocating flush bio, so submit_bio_noacct just fail
> the flush bio.
>
> Simply fix it by adding the missing REQ_OP_WRITE for flush bio. And we
> could fix the flush order issue and do flush optimization later.
>
> Fixes: b4a6bb3a67aa ("block: add a sanity check for non-write flush/fua bios")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> v2:
>   * do a minimal fix first (Suggested by Christoph)
> v1: https://lore.kernel.org/linux-block/ZJLpYMC8FgtZ0k2k@infradead.org/T/#t
>
> Hi Jens & Dan,
>
> I found Pankaj was working on the fix and optimization of virtio-pmem
> flush bio [0], but considering the last status update was 1/12/2022, so
> could you please pick the patch up for v6.4 and we can do the flush fix
> and optimization later ?
>
> [0]: https://lore.kernel.org/lkml/20220111161937.56272-1-pankaj.gupta.linux@gmail.com/T/
>
>  drivers/nvdimm/nd_virtio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index c6a648fd8744..97098099f8a3 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -105,7 +105,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>          * parent bio. Otherwise directly call nd_region flush.
>          */
>         if (bio && bio->bi_iter.bi_sector != -1) {
> -               struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_PREFLUSH,
> +               struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH,
>                                               GFP_ATOMIC);
>
>                 if (!child)

Fix looks good to me. Will give a run soon.

Yes, [0] needs to be completed. Curious to know if you guys using
virtio-pmem device?

Thanks,
Pankaj
