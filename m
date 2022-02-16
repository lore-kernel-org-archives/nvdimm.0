Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88905187D
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 17:01:39 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id z2so412443iow.8
        for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 09:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I5FGz9UopDmOr/sS+hUAyFgI3PwHIeG5FXWhjwGlyJI=;
        b=GcZdvidaiUJh4QJe+8knJfUEKZ0kHu1Ekr7Fo/prc3WQlwk5azLOhn2N99tiJ9KyqC
         BRkRSS3c9Dqv7LlyetYkHxm1DUijOeBruzahYgv4QAUclx4iFN1jef3U+Lv1YU6WveS2
         0LyiMYhUsTil26XK8Vw7ZyqH/3QPg21CoHIHEW97CgZzYZacGpLar/wPlxeUgji34ELu
         cc3fNOn8UudSzs1eZT9yUYDDcL31fxZyor0Hly0uxoXwxw548ce+RVQ+SQdanEzwrFRn
         PCsU77mVX/1LvHrMZs8uieuHXsc7loALHhc7rZu06F+9nuAPHEMkizvNdmela1m/Uzf5
         Jy1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I5FGz9UopDmOr/sS+hUAyFgI3PwHIeG5FXWhjwGlyJI=;
        b=kjBxeAfyExl4Rt5V2hCQWFTrPQfCjHoTv/MR4BcjxzqDVa7PCei1z8FBL240+7JLZk
         sDtDD3Z0KCqDVAty2iA26kQWDMWkCebsGysVO2cGvJVBOYYPPyApFRfb1yLteWq0JuJM
         LBS9CFTYHBdRFJRt+pFhw0M3o/2nxDvEgFiRQDf6Ytz+ZPdqB9HSdFtY2iOz1O16xBre
         gniQelZd81Akf279aeFZ/Rd/T5FmVREYTpZgfQ0cv5Pk6L7a2tu8feBNscmc+mmDZiV4
         2wc7VhpVoaWabJ4VPiDTrzhPW31kcgFvWG/hY+M5skDclecAfcED9JfIo87ZYd37dWjr
         C9zg==
X-Gm-Message-State: AOAM532f9tjKRxLDVWOrqjhG1je06Gq7e6h/jP7lxKCmmsg26C9QMnAO
	pUJ/2/oDCe0rTwCo6YGJBCcAiBYBD1B+mXDL4dU=
X-Google-Smtp-Source: ABdhPJzr7cU4QtjSQruJcWOgXa70ZC97Rs4vkdBEVjN4FdiXcQIJTnXQyNRfRuCN+qgNR3EKTpFdrSCgTjHah089l7E=
X-Received: by 2002:a5e:8c15:0:b0:634:478e:450e with SMTP id
 n21-20020a5e8c15000000b00634478e450emr2495232ioj.56.1645030898651; Wed, 16
 Feb 2022 09:01:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
 <20220111161937.56272-3-pankaj.gupta.linux@gmail.com> <CAPcyv4gM99M8Waw9uEZefvpK0BsTkjGznLxUOMcMkGpk6SuHyA@mail.gmail.com>
 <CAM9Jb+iYXn+Diq-vou+_hXdxXLR9rEXm6GOsd2tZpAg9zXn1Fw@mail.gmail.com> <CAPcyv4iPhtbhAfpjCtbt9RGFOXuGCj-q3Gm_y7zaNk44Z7uq9Q@mail.gmail.com>
In-Reply-To: <CAPcyv4iPhtbhAfpjCtbt9RGFOXuGCj-q3Gm_y7zaNk44Z7uq9Q@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 16 Feb 2022 18:01:27 +0100
Message-ID: <CAM9Jb+i_p44q=sS4P=B3Pr-T_jsM9Q-mUHg6i657dT7bSqKULw@mail.gmail.com>
Subject: Re: [RFC v3 2/2] pmem: enable pmem_submit_bio for asynchronous flush
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

> > > > Return from "pmem_submit_bio" when asynchronous flush is
> > > > still in progress in other context.
> > > >
> > > > Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > > ---
> > > >  drivers/nvdimm/pmem.c        | 15 ++++++++++++---
> > > >  drivers/nvdimm/region_devs.c |  4 +++-
> > > >  2 files changed, 15 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > > > index fe7ece1534e1..f20e30277a68 100644
> > > > --- a/drivers/nvdimm/pmem.c
> > > > +++ b/drivers/nvdimm/pmem.c
> > > > @@ -201,8 +201,12 @@ static void pmem_submit_bio(struct bio *bio)
> > > >         struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
> > > >         struct nd_region *nd_region = to_region(pmem);
> > > >
> > > > -       if (bio->bi_opf & REQ_PREFLUSH)
> > > > +       if (bio->bi_opf & REQ_PREFLUSH) {
> > > >                 ret = nvdimm_flush(nd_region, bio);
> > > > +               /* asynchronous flush completes in other context */
> > >
> > > I think a negative error code is a confusing way to capture the case
> > > of "bio successfully coalesced to previously pending flush request.
> > > Perhaps reserve negative codes for failure, 0 for synchronously
> > > completed, and > 0 for coalesced flush request.
> >
> > Yes. I implemented this way previously, will revert it to. Thanks!
> >
> > >
> > > > +               if (ret == -EINPROGRESS)
> > > > +                       return;
> > > > +       }
> > > >
> > > >         do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
> > > >         if (do_acct)
> > > > @@ -222,13 +226,18 @@ static void pmem_submit_bio(struct bio *bio)
> > > >         if (do_acct)
> > > >                 bio_end_io_acct(bio, start);
> > > >
> > > > -       if (bio->bi_opf & REQ_FUA)
> > > > +       if (bio->bi_opf & REQ_FUA) {
> > > >                 ret = nvdimm_flush(nd_region, bio);
> > > > +               /* asynchronous flush completes in other context */
> > > > +               if (ret == -EINPROGRESS)
> > > > +                       return;
> > > > +       }
> > > >
> > > >         if (ret)
> > > >                 bio->bi_status = errno_to_blk_status(ret);
> > > >
> > > > -       bio_endio(bio);
> > > > +       if (bio)
> > > > +               bio_endio(bio);
> > > >  }
> > > >
> > > >  static int pmem_rw_page(struct block_device *bdev, sector_t sector,
> > > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > > > index 9ccf3d608799..8512d2eaed4e 100644
> > > > --- a/drivers/nvdimm/region_devs.c
> > > > +++ b/drivers/nvdimm/region_devs.c
> > > > @@ -1190,7 +1190,9 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
> > > >         if (!nd_region->flush)
> > > >                 rc = generic_nvdimm_flush(nd_region);
> > > >         else {
> > > > -               if (nd_region->flush(nd_region, bio))
> > > > +               rc = nd_region->flush(nd_region, bio);
> > > > +               /* ongoing flush in other context */
> > > > +               if (rc && rc != -EINPROGRESS)
> > > >                         rc = -EIO;
> > >
> > > Why change this to -EIO vs just let the error code through untranslated?
> >
> > The reason was to be generic error code instead of returning host side
> > return codes to guest?
>
> Ok, maybe a comment to indicate the need to avoid exposing these error
> codes toa guest so someone does not ask the same question in the
> future?

Sure.

Thanks,
Pankaj
