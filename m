Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA3329CA
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 22:08:41 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id m26so885624pff.3
        for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 15:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7NZNUzkwqV8FV6bts50PDqCVbYsdeI9DWpW3UuuSetQ=;
        b=H9bYH617YjERR4qzzuhHKRD1sRRQFu+Q1Jh64kJ1djlfDal40fY+iY87u0l9uJoll9
         qKsSebVBrXVCpOAl8hvLF4LtB9qq5pdwDXayqDjbt2sUyexsxQbLG62BB3WNpfD87xZG
         IVyDddf9ZPTBcoPNghKtAs9E6jlQ28nDWusY81EErhC9J7IxJxP7uwjAdgVMD8py+u1P
         nxTuWeiGOBc+Tfc1qeRQ2kq5o5K9WUw6NdaVl+u6l7blBulIUS1a0b8Q01jOTrYRv73M
         znQKQv6MK8THCvnQOstYHUHj9L24gqn6pk51HjKJEQG0bWnijVmLYjUAaUC1yNQfLkfP
         bq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7NZNUzkwqV8FV6bts50PDqCVbYsdeI9DWpW3UuuSetQ=;
        b=lPAErdDVEzB3ZeCnxvNrXqtbOkb/zi1Y6Wq82eReuhuZ90yVr4tSYJ/mlieKzM51Hj
         wSX4TrrB5jwig33San9GM/QbFTsnam85RNBZ2R2TD4DHIntWL5r7OH6tEjfg2xK5DCOd
         gtdGKNgNJ2ftuCCxlYTkKGxkQqmetvv2myRUHL/a+85A4XHBdqRrzU36+aJMwwty4gls
         U+kOwpCoUdY4iB1XCpcKItSafuzxGmBiqkxlc7v/jss4NhYXlhho4N7VVdtb+g8cxfI6
         IH0YMjE880yoO4LqJ3YLpfI21kQb5UqYju4oVp5NnyufwXPmQwxvyShzqKc8MDF847tI
         /4KA==
X-Gm-Message-State: AOAM530dnRvBDrM/CCeDzZNFKHehhVOScS4I8M5nN4jIYfjO5+F9Evih
	SzqOT9QWHhmca97HSH4tVu4LfAXulUWDmpu80++3dBie70g=
X-Google-Smtp-Source: ABdhPJw2KP0i89pMalH0wosmc6VWGByLDHoPtHP3Rvh3Nqhuz6fCxv+quhVvh9yLawfYIETYtZ7Iyp0W5bbg6cwoq38=
X-Received: by 2002:a65:6642:: with SMTP id z2mr353069pgv.240.1629929320968;
 Wed, 25 Aug 2021 15:08:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
 <20210726060855.108250-2-pankaj.gupta.linux@gmail.com> <CAPcyv4inCFFXmg0r5+h0O6cADpt9HdboVDEL00XX-wGroy-7LQ@mail.gmail.com>
 <CAM9Jb+hqPBFUh9X4sKb9TUGXX1P0mC1xcuCNQx1BYvAvoP9uQg@mail.gmail.com>
 <CAPcyv4gUG1-y1u0ZyUkSGXg0eER_oTdexb8n-CYgb_rURvr8LA@mail.gmail.com> <CALzYo32AnNzENe414GDVivaF5wXQ7azaysBYkN9wHVYEW27NPw@mail.gmail.com>
In-Reply-To: <CALzYo32AnNzENe414GDVivaF5wXQ7azaysBYkN9wHVYEW27NPw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Aug 2021 15:08:30 -0700
Message-ID: <CAPcyv4idY7GDYjXsvjduQ4rjfKo-qDgQoj5r6=Rr9poXqHEzeg@mail.gmail.com>
Subject: Re: [RFC v2 1/2] virtio-pmem: Async virtio-pmem flush
To: Pankaj Gupta <pankaj.gupta@ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	David Hildenbrand <david@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 25, 2021 at 3:01 PM Pankaj Gupta <pankaj.gupta@ionos.com> wrote:
>
> > > Hi Dan,
> > >
> > > Thank you for the review. Please see my reply inline.
> > >
> > > > > Implement asynchronous flush for virtio pmem using work queue
> > > > > to solve the preflush ordering issue. Also, coalesce the flush
> > > > > requests when a flush is already in process.
> > > > >
> > > > > Signed-off-by: Pankaj Gupta <pankaj.gupta@ionos.com>
> > > > > ---
> > > > >  drivers/nvdimm/nd_virtio.c   | 72 ++++++++++++++++++++++++++++--------
> > > > >  drivers/nvdimm/virtio_pmem.c | 10 ++++-
> > > > >  drivers/nvdimm/virtio_pmem.h | 14 +++++++
> > > > >  3 files changed, 79 insertions(+), 17 deletions(-)
> > > > >
> > > > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > > > index 10351d5b49fa..61b655b583be 100644
> > > > > --- a/drivers/nvdimm/nd_virtio.c
> > > > > +++ b/drivers/nvdimm/nd_virtio.c
> > > > > @@ -97,29 +97,69 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> > > > >         return err;
> > > > >  };
> > > > >
> > > > > +static void submit_async_flush(struct work_struct *ws);
> > > > > +
> > > > >  /* The asynchronous flush callback function */
> > > > >  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
> > > > >  {
> > > > > -       /*
> > > > > -        * Create child bio for asynchronous flush and chain with
> > > > > -        * parent bio. Otherwise directly call nd_region flush.
> > > > > +       /* queue asynchronous flush and coalesce the flush requests */
> > > > > +       struct virtio_device *vdev = nd_region->provider_data;
> > > > > +       struct virtio_pmem *vpmem  = vdev->priv;
> > > > > +       ktime_t req_start = ktime_get_boottime();
> > > > > +
> > > > > +       spin_lock_irq(&vpmem->lock);
> > > > > +       /* flush requests wait until ongoing flush completes,
> > > > > +        * hence coalescing all the pending requests.
> > > > >          */
> > > > > -       if (bio && bio->bi_iter.bi_sector != -1) {
> > > > > -               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> > > > > -
> > > > > -               if (!child)
> > > > > -                       return -ENOMEM;
> > > > > -               bio_copy_dev(child, bio);
> > > > > -               child->bi_opf = REQ_PREFLUSH;
> > > > > -               child->bi_iter.bi_sector = -1;
> > > > > -               bio_chain(child, bio);
> > > > > -               submit_bio(child);
> > > > > -               return 0;
> > > > > +       wait_event_lock_irq(vpmem->sb_wait,
> > > > > +                           !vpmem->flush_bio ||
> > > > > +                           ktime_before(req_start, vpmem->prev_flush_start),
> > > > > +                           vpmem->lock);
> > > > > +       /* new request after previous flush is completed */
> > > > > +       if (ktime_after(req_start, vpmem->prev_flush_start)) {
> > > > > +               WARN_ON(vpmem->flush_bio);
> > > > > +               vpmem->flush_bio = bio;
> > > > > +               bio = NULL;
> > > > > +       }
> > > >
> > > > Why the dance with ->prev_flush_start vs just calling queue_work()
> > > > again. queue_work() is naturally coalescing in that if the last work
> > > > request has not started execution another queue attempt will be
> > > > dropped.
> > >
> > > How parent flush request will know when corresponding flush is completed?
> >
> > The eventual bio_endio() is what signals upper layers that the flush
> > completed...
> >
> >
> > Hold on... it's been so long that I forgot that you are copying
> > md_flush_request() here. It would help immensely if that was mentioned
> > in the changelog and at a minimum have a comment in the code that this
> > was copied from md. In fact it would be extra helpful if you
>
> My bad. I only mentioned this in the cover letter.

Yeah, sorry about that. Having come back to this after so long I just
decided to jump straight into the patches, but even if I had read that
cover I still would have given the feedback that md_flush_request()
heritage should also be noted with a comment in the code.
