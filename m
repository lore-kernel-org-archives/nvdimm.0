Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22716187C
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 16:26:00 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id y9so2902957pjf.1
        for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 08:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nhaYDK+1Xr6t09RUwH9LeVyAOy0Iet12ql37UN6Cqhc=;
        b=huC9bfgtZYgR0waRD90zBZ7prMLMTt7FD+a2+9d2+TIBXgL2AW3c8Y015ZUo7lcaXB
         TdSot7kLqIIuKZjQh+E13tmxNcXdqTYm6+1xOabpaFwjOoMi+SwtASpEIrhbbYvbbDVR
         yNbiB2oA1/1UW936CyPSH6+nfK4N90eCDArpC70C06QsB64ySwEGaIJlTtq0z5zG9d0v
         f2d6KdwQObESSeE6YyI+i9sfl9ThC0In8Nab6u7HeGkN60np51jogEsJAksc8ocI3XTT
         qGOcdd7kwIGhFU75ArDBjllyGIdC8A02ZUw3cYiEHL0iMXQYYLgjMlmhFM0s1AL/HZ87
         0sNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nhaYDK+1Xr6t09RUwH9LeVyAOy0Iet12ql37UN6Cqhc=;
        b=B85lBh4MddH8uZghAuSpXV2f5hwD+aqGV5rIflShqsVKHkvI6+4uGllJVe1YetU7y2
         Q+tJA8A+aLEwm7UnP/SplDVJ8tCoCuOuz2NQZPiypnRICt41BhQzhN5TQ/V4/S1f2ezh
         Az4Csm9DERS3kjfqZcpORi49xeiVR/7e8vo4ANP7RCrZX9zJByKOjosT4gg7TwStHGe0
         7txRUiRFW9U58sZ2ErZyIlE5t+WKc1z0kfi789OcDj0HrfVOpww1vb6mzFmcCdU8NDJs
         /rPYb/qCrIGMOoGUV8hVtOYdzwwsyH8W9EwO3NdxkL/gyJ2rP2nWLKEYm3luXpxSeCL4
         XXZA==
X-Gm-Message-State: AOAM530O6zI7iZBnMXSUaXkK/kV8HiYJAEzC/mPoHUTDgTMTXUUZ82xN
	ZW2bN0aERmYRvUWdSeCLc6BR15Gi0rbk+qwCJYVJUQ==
X-Google-Smtp-Source: ABdhPJyFUOkJTyrN8eu8zcICrEiE34OEQNOcRXQ+qA8yo+FR28x8Y4H92pXGSQhwBQsV7Fb99hRe47pP0GdnEaG91iQ=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr3589396pll.132.1645028760530; Wed, 16
 Feb 2022 08:26:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
 <20220111161937.56272-3-pankaj.gupta.linux@gmail.com> <CAPcyv4gM99M8Waw9uEZefvpK0BsTkjGznLxUOMcMkGpk6SuHyA@mail.gmail.com>
 <CAM9Jb+iYXn+Diq-vou+_hXdxXLR9rEXm6GOsd2tZpAg9zXn1Fw@mail.gmail.com>
In-Reply-To: <CAM9Jb+iYXn+Diq-vou+_hXdxXLR9rEXm6GOsd2tZpAg9zXn1Fw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Feb 2022 08:25:48 -0800
Message-ID: <CAPcyv4iPhtbhAfpjCtbt9RGFOXuGCj-q3Gm_y7zaNk44Z7uq9Q@mail.gmail.com>
Subject: Re: [RFC v3 2/2] pmem: enable pmem_submit_bio for asynchronous flush
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 12:39 AM Pankaj Gupta
<pankaj.gupta.linux@gmail.com> wrote:
>
> > >
> > > Return from "pmem_submit_bio" when asynchronous flush is
> > > still in progress in other context.
> > >
> > > Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > ---
> > >  drivers/nvdimm/pmem.c        | 15 ++++++++++++---
> > >  drivers/nvdimm/region_devs.c |  4 +++-
> > >  2 files changed, 15 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > > index fe7ece1534e1..f20e30277a68 100644
> > > --- a/drivers/nvdimm/pmem.c
> > > +++ b/drivers/nvdimm/pmem.c
> > > @@ -201,8 +201,12 @@ static void pmem_submit_bio(struct bio *bio)
> > >         struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
> > >         struct nd_region *nd_region = to_region(pmem);
> > >
> > > -       if (bio->bi_opf & REQ_PREFLUSH)
> > > +       if (bio->bi_opf & REQ_PREFLUSH) {
> > >                 ret = nvdimm_flush(nd_region, bio);
> > > +               /* asynchronous flush completes in other context */
> >
> > I think a negative error code is a confusing way to capture the case
> > of "bio successfully coalesced to previously pending flush request.
> > Perhaps reserve negative codes for failure, 0 for synchronously
> > completed, and > 0 for coalesced flush request.
>
> Yes. I implemented this way previously, will revert it to. Thanks!
>
> >
> > > +               if (ret == -EINPROGRESS)
> > > +                       return;
> > > +       }
> > >
> > >         do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
> > >         if (do_acct)
> > > @@ -222,13 +226,18 @@ static void pmem_submit_bio(struct bio *bio)
> > >         if (do_acct)
> > >                 bio_end_io_acct(bio, start);
> > >
> > > -       if (bio->bi_opf & REQ_FUA)
> > > +       if (bio->bi_opf & REQ_FUA) {
> > >                 ret = nvdimm_flush(nd_region, bio);
> > > +               /* asynchronous flush completes in other context */
> > > +               if (ret == -EINPROGRESS)
> > > +                       return;
> > > +       }
> > >
> > >         if (ret)
> > >                 bio->bi_status = errno_to_blk_status(ret);
> > >
> > > -       bio_endio(bio);
> > > +       if (bio)
> > > +               bio_endio(bio);
> > >  }
> > >
> > >  static int pmem_rw_page(struct block_device *bdev, sector_t sector,
> > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > > index 9ccf3d608799..8512d2eaed4e 100644
> > > --- a/drivers/nvdimm/region_devs.c
> > > +++ b/drivers/nvdimm/region_devs.c
> > > @@ -1190,7 +1190,9 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
> > >         if (!nd_region->flush)
> > >                 rc = generic_nvdimm_flush(nd_region);
> > >         else {
> > > -               if (nd_region->flush(nd_region, bio))
> > > +               rc = nd_region->flush(nd_region, bio);
> > > +               /* ongoing flush in other context */
> > > +               if (rc && rc != -EINPROGRESS)
> > >                         rc = -EIO;
> >
> > Why change this to -EIO vs just let the error code through untranslated?
>
> The reason was to be generic error code instead of returning host side
> return codes to guest?

Ok, maybe a comment to indicate the need to avoid exposing these error
codes toa guest so someone does not ask the same question in the
future?
