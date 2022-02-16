Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE7C1FB9
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 03:34:36 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id f8so974056pgc.8
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 19:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lNEQbX7Cj1rLSUqainzZr7y+UqvteHBg1pncfSDBI3k=;
        b=caJo9iQpPyQndEH8t/TtZgVuvQs22W8ChZtpwz4wZ3RAkyQTwRiJJabOoIsohB6wiQ
         0DNIGiie+oouidsCrrJbAsT+gbJhOve1QLyxQ23wQ+1ehTetEFomDe8jrVh4lPsmPU1k
         zDSb1AWpLqGL5KRx42diDUkQZXncQytm8MdeXia6uPexwMxq22luAg60sMefZvz7WJxA
         1RGLQxxbJ0A11J9UPbqvTGB2/zu+yz7T04+ze4aGeyODubIGEri5xS4vhqdTrOZlwBZ1
         9FYdZI8vkBsVmLQLya4lm+l782oJOZZP5a5HoqeMXM74NYgbW/ZI5ssG5WxFcfWvj/Tc
         LBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lNEQbX7Cj1rLSUqainzZr7y+UqvteHBg1pncfSDBI3k=;
        b=epJDa37f4jZuW6ahKy4eNfoR7KJK04Ow4lKCaD/VhWZ0XVP2SVSLqEEkuul0gePtRc
         202kiKXEit8WS3MoZplSo8jYVrPBMj8lpxNXhmTN/NQGEZdssRttaxuWxLOlB94LRAwH
         1Rh/trFj4KBVaY91EHmLwPbpSjZ7xG8Y1ZDSBdnG1XrR75sN7LNMr5LTfl8FLqW3trP1
         /1V9vl9COHoANSCJugNWqJAhcQXiF57sFWLYSWzK902M8zD+sDvO7xOLEjGTypfaYFPs
         nvbPKnw8lS22GqOAviLFSD6mP6Xg6ANnSkhBanYBIxXo6eYUupHZiBC9/YjRkj2+ir6i
         z7Gw==
X-Gm-Message-State: AOAM530pZ+j+twMPmOB86oYFHkZq5A1Iw2QCM3FmhgDnVrD78XTet4lk
	5ZBv33CwaM5QzB/9S9Rvkngd2skBMQhOaaxORon3cA==
X-Google-Smtp-Source: ABdhPJyW5VadiIqwRQ3iKfUXmEC5cECaeAdHWWepcPZds282RWLRRT48Qng+4A1cZK9GKSDl7THuSiMwL+NG5Ttwo/o=
X-Received: by 2002:a05:6a00:8ca:b0:4e0:2ed3:5630 with SMTP id
 s10-20020a056a0008ca00b004e02ed35630mr1067520pfu.3.1644982475928; Tue, 15 Feb
 2022 19:34:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com> <20220111161937.56272-3-pankaj.gupta.linux@gmail.com>
In-Reply-To: <20220111161937.56272-3-pankaj.gupta.linux@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 19:34:24 -0800
Message-ID: <CAPcyv4gM99M8Waw9uEZefvpK0BsTkjGznLxUOMcMkGpk6SuHyA@mail.gmail.com>
Subject: Re: [RFC v3 2/2] pmem: enable pmem_submit_bio for asynchronous flush
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 11, 2022 at 8:21 AM Pankaj Gupta
<pankaj.gupta.linux@gmail.com> wrote:
>
> Return from "pmem_submit_bio" when asynchronous flush is
> still in progress in other context.
>
> Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> ---
>  drivers/nvdimm/pmem.c        | 15 ++++++++++++---
>  drivers/nvdimm/region_devs.c |  4 +++-
>  2 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index fe7ece1534e1..f20e30277a68 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -201,8 +201,12 @@ static void pmem_submit_bio(struct bio *bio)
>         struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
>         struct nd_region *nd_region = to_region(pmem);
>
> -       if (bio->bi_opf & REQ_PREFLUSH)
> +       if (bio->bi_opf & REQ_PREFLUSH) {
>                 ret = nvdimm_flush(nd_region, bio);
> +               /* asynchronous flush completes in other context */

I think a negative error code is a confusing way to capture the case
of "bio successfully coalesced to previously pending flush request.
Perhaps reserve negative codes for failure, 0 for synchronously
completed, and > 0 for coalesced flush request.

> +               if (ret == -EINPROGRESS)
> +                       return;
> +       }
>
>         do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
>         if (do_acct)
> @@ -222,13 +226,18 @@ static void pmem_submit_bio(struct bio *bio)
>         if (do_acct)
>                 bio_end_io_acct(bio, start);
>
> -       if (bio->bi_opf & REQ_FUA)
> +       if (bio->bi_opf & REQ_FUA) {
>                 ret = nvdimm_flush(nd_region, bio);
> +               /* asynchronous flush completes in other context */
> +               if (ret == -EINPROGRESS)
> +                       return;
> +       }
>
>         if (ret)
>                 bio->bi_status = errno_to_blk_status(ret);
>
> -       bio_endio(bio);
> +       if (bio)
> +               bio_endio(bio);
>  }
>
>  static int pmem_rw_page(struct block_device *bdev, sector_t sector,
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 9ccf3d608799..8512d2eaed4e 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1190,7 +1190,9 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
>         if (!nd_region->flush)
>                 rc = generic_nvdimm_flush(nd_region);
>         else {
> -               if (nd_region->flush(nd_region, bio))
> +               rc = nd_region->flush(nd_region, bio);
> +               /* ongoing flush in other context */
> +               if (rc && rc != -EINPROGRESS)
>                         rc = -EIO;

Why change this to -EIO vs just let the error code through untranslated?

>         }
>
> --
> 2.25.1
>
>
