Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABAE1849
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 08:39:21 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id s1so1486118ioe.0
        for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 00:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zJXMODhdBkf6vc06+F5pCVIh6APP23M3j8CKu88q15Q=;
        b=lbe3CEMY4Ub6K+wUXjtSitO/K59lr9Uwcr3f2MOly1/EFqOcdg9hh6zgANZJMnKb5t
         V0kqoetuywmUQaekwAvi9m9/9QFqN0hdHOU7Mw7h0i2/HgZ+zm+dI9cCWkwJBQZiqbRL
         e8DC14oGb66dR2Sg2M4m9CoXPiUV1p1EKAPNsHb9Qs9bVQOvzdV3p3Mn0AdMqDR7Qenm
         NjBRQUispRluhY2+I9XNvnNZ+PLbtHB7Tk0H88qMXvQzksmcbKuCCLGsxnY3ocE0U72W
         KOY35PYY2qMF/1MOnkfNHnz2hWVP5oy76EFp1eb3SVVS2dFP69GygTzMRJkQn7ACIm6m
         drXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zJXMODhdBkf6vc06+F5pCVIh6APP23M3j8CKu88q15Q=;
        b=LYFLiPPrZNhkjbgtdFvEoDPYabg4kSP4dB7IQwIBXdJLghNgNbocpm79pfz1smvcp8
         LJluqYM+5MCrpvatNR78zuCvnFYEEdNuqKuLs5oBU8G8RIZufOxcrr/Op0Ke6/n4rY++
         B/X4zBosxZy+saqVwsjXBW2torABFga3G45e7L1IRsdgwcF8Mp63fpbhARGYTqn5brCw
         htIiw9UxWn33K4KJrKxbO1hVWXQfh89PXTGk+v0VNVP4WlDY0l7QwSdARlvs1DkFoF9v
         hlOgWgRWPzGSzOxUHHWtaZ0Qiy7i/yyaSvtkc4rPi1W/plNb1PEXsGF8+YQunsx9kj5x
         sRgQ==
X-Gm-Message-State: AOAM530GJippANtTwP7O5eN7UpvkbEAu7DTAeyAfxZBccpyGLBY3LeZm
	aFKeX3qWXj1eCa9Bb+JcLJAtOxOREsA9B7et6nk=
X-Google-Smtp-Source: ABdhPJzsgi7vs4zYUQ1swAAlrRQXus7Yogb4FnBlstHft4Vp4wbVq460y3slrxK9XiJLK3Tu1TfnHv5zSql+Sm8rqrs=
X-Received: by 2002:a02:a190:0:b0:314:ed7:c072 with SMTP id
 n16-20020a02a190000000b003140ed7c072mr1086474jah.130.1645000760419; Wed, 16
 Feb 2022 00:39:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
 <20220111161937.56272-3-pankaj.gupta.linux@gmail.com> <CAPcyv4gM99M8Waw9uEZefvpK0BsTkjGznLxUOMcMkGpk6SuHyA@mail.gmail.com>
In-Reply-To: <CAPcyv4gM99M8Waw9uEZefvpK0BsTkjGznLxUOMcMkGpk6SuHyA@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 16 Feb 2022 09:39:09 +0100
Message-ID: <CAM9Jb+iYXn+Diq-vou+_hXdxXLR9rEXm6GOsd2tZpAg9zXn1Fw@mail.gmail.com>
Subject: Re: [RFC v3 2/2] pmem: enable pmem_submit_bio for asynchronous flush
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

> >
> > Return from "pmem_submit_bio" when asynchronous flush is
> > still in progress in other context.
> >
> > Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > ---
> >  drivers/nvdimm/pmem.c        | 15 ++++++++++++---
> >  drivers/nvdimm/region_devs.c |  4 +++-
> >  2 files changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index fe7ece1534e1..f20e30277a68 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> > @@ -201,8 +201,12 @@ static void pmem_submit_bio(struct bio *bio)
> >         struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
> >         struct nd_region *nd_region = to_region(pmem);
> >
> > -       if (bio->bi_opf & REQ_PREFLUSH)
> > +       if (bio->bi_opf & REQ_PREFLUSH) {
> >                 ret = nvdimm_flush(nd_region, bio);
> > +               /* asynchronous flush completes in other context */
>
> I think a negative error code is a confusing way to capture the case
> of "bio successfully coalesced to previously pending flush request.
> Perhaps reserve negative codes for failure, 0 for synchronously
> completed, and > 0 for coalesced flush request.

Yes. I implemented this way previously, will revert it to. Thanks!

>
> > +               if (ret == -EINPROGRESS)
> > +                       return;
> > +       }
> >
> >         do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
> >         if (do_acct)
> > @@ -222,13 +226,18 @@ static void pmem_submit_bio(struct bio *bio)
> >         if (do_acct)
> >                 bio_end_io_acct(bio, start);
> >
> > -       if (bio->bi_opf & REQ_FUA)
> > +       if (bio->bi_opf & REQ_FUA) {
> >                 ret = nvdimm_flush(nd_region, bio);
> > +               /* asynchronous flush completes in other context */
> > +               if (ret == -EINPROGRESS)
> > +                       return;
> > +       }
> >
> >         if (ret)
> >                 bio->bi_status = errno_to_blk_status(ret);
> >
> > -       bio_endio(bio);
> > +       if (bio)
> > +               bio_endio(bio);
> >  }
> >
> >  static int pmem_rw_page(struct block_device *bdev, sector_t sector,
> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > index 9ccf3d608799..8512d2eaed4e 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -1190,7 +1190,9 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
> >         if (!nd_region->flush)
> >                 rc = generic_nvdimm_flush(nd_region);
> >         else {
> > -               if (nd_region->flush(nd_region, bio))
> > +               rc = nd_region->flush(nd_region, bio);
> > +               /* ongoing flush in other context */
> > +               if (rc && rc != -EINPROGRESS)
> >                         rc = -EIO;
>
> Why change this to -EIO vs just let the error code through untranslated?

The reason was to be generic error code instead of returning host side
return codes to guest?

Thanks!
Pankaj
>
> >         }
> >
> > --
> > 2.25.1
> >
> >
