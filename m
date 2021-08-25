Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C2B3FC0
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 22:00:53 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id y34so1972178lfa.8
        for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 15:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LyrKkumEkwEMDLh/lomBQ6UNoS8fGGdqSS8DRTWgeNs=;
        b=XZ9yePpBYZ+hsqixZh49OCL+8k+Mo+exo5AoM8gAWr4lvuFKby02lhsyFeyv5JV15Q
         xY+nh+XEEu8nF/lyLVCJnwtz4YyMhoxmvXAtqi31M8lzyoA0kqYTMDgp6qicQm3Yweqi
         +b0BxlZFsJkVQXoiz5O2d3BHZwyuSYS08AELBzQPt7Et1GcOzynLgxJTLG1n/gYi+Bur
         KKpX3N2KEbaIJQEp0748LFlNKq3r2FzgAx/bY/79hynqhgyFrfLdt7qRivVoZezRtUP2
         Zqgxwg4RtcDqOET0+nnvO39J3AVOhD6p5Jtz5sqofwbSU1o+LH9H1d1ti5vWkiG/zDFh
         TgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LyrKkumEkwEMDLh/lomBQ6UNoS8fGGdqSS8DRTWgeNs=;
        b=RWJFR1XMXv5+41+Ad8EgxvkdjbBuhrsTacKJPiFKSSMgfHDjUc9iT4L1niYr2q4ziM
         +Gpt+/bNZY6e0uJBfklLezpnxG+F9eDU435+hXjiJHomcqDt0+Vp29uaimbyppCEw0ly
         mCt56ZxRCYfjatoaBABtl+u5d2QEDiyfslvUBavJSae8UFQ/EZQ8wZDb2XzrIIotTDUT
         9vwE4X3vsR8oMTFkg4BRSgBsBQTqkepoCX2VDPa+erVGko0p+BoItoDB/3WP3C54drmZ
         MtgsZfMv+exX7HyAbwM5uBHAzsTd5PPUvSo1C9AJONx+Cap/cbm491ACOHRrw0aym73X
         mCtA==
X-Gm-Message-State: AOAM533GmVugO8DN3GWKASaiUTLOimaXzvSC6skCdiKY9zarjlb4JW9v
	13Fz5dh+X8lO+7W3YHAgksLcyRd4+Jjqc2E93AJBjA==
X-Google-Smtp-Source: ABdhPJyjMR9ZAySxwy5cAfJqrm1A2sVYPT8Hk5QlSFg7tu/Nu4ApkzLG2672U0XAriv/LFRQZouDtb4MrPacs47prKE=
X-Received: by 2002:a05:6512:3250:: with SMTP id c16mr183684lfr.465.1629928851245;
 Wed, 25 Aug 2021 15:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
 <20210726060855.108250-2-pankaj.gupta.linux@gmail.com> <CAPcyv4inCFFXmg0r5+h0O6cADpt9HdboVDEL00XX-wGroy-7LQ@mail.gmail.com>
 <CAM9Jb+hqPBFUh9X4sKb9TUGXX1P0mC1xcuCNQx1BYvAvoP9uQg@mail.gmail.com> <CAPcyv4gUG1-y1u0ZyUkSGXg0eER_oTdexb8n-CYgb_rURvr8LA@mail.gmail.com>
In-Reply-To: <CAPcyv4gUG1-y1u0ZyUkSGXg0eER_oTdexb8n-CYgb_rURvr8LA@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta@ionos.com>
Date: Thu, 26 Aug 2021 00:00:40 +0200
Message-ID: <CALzYo32AnNzENe414GDVivaF5wXQ7azaysBYkN9wHVYEW27NPw@mail.gmail.com>
Subject: Re: [RFC v2 1/2] virtio-pmem: Async virtio-pmem flush
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	David Hildenbrand <david@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

> > Hi Dan,
> >
> > Thank you for the review. Please see my reply inline.
> >
> > > > Implement asynchronous flush for virtio pmem using work queue
> > > > to solve the preflush ordering issue. Also, coalesce the flush
> > > > requests when a flush is already in process.
> > > >
> > > > Signed-off-by: Pankaj Gupta <pankaj.gupta@ionos.com>
> > > > ---
> > > >  drivers/nvdimm/nd_virtio.c   | 72 ++++++++++++++++++++++++++++--------
> > > >  drivers/nvdimm/virtio_pmem.c | 10 ++++-
> > > >  drivers/nvdimm/virtio_pmem.h | 14 +++++++
> > > >  3 files changed, 79 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > > index 10351d5b49fa..61b655b583be 100644
> > > > --- a/drivers/nvdimm/nd_virtio.c
> > > > +++ b/drivers/nvdimm/nd_virtio.c
> > > > @@ -97,29 +97,69 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> > > >         return err;
> > > >  };
> > > >
> > > > +static void submit_async_flush(struct work_struct *ws);
> > > > +
> > > >  /* The asynchronous flush callback function */
> > > >  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
> > > >  {
> > > > -       /*
> > > > -        * Create child bio for asynchronous flush and chain with
> > > > -        * parent bio. Otherwise directly call nd_region flush.
> > > > +       /* queue asynchronous flush and coalesce the flush requests */
> > > > +       struct virtio_device *vdev = nd_region->provider_data;
> > > > +       struct virtio_pmem *vpmem  = vdev->priv;
> > > > +       ktime_t req_start = ktime_get_boottime();
> > > > +
> > > > +       spin_lock_irq(&vpmem->lock);
> > > > +       /* flush requests wait until ongoing flush completes,
> > > > +        * hence coalescing all the pending requests.
> > > >          */
> > > > -       if (bio && bio->bi_iter.bi_sector != -1) {
> > > > -               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> > > > -
> > > > -               if (!child)
> > > > -                       return -ENOMEM;
> > > > -               bio_copy_dev(child, bio);
> > > > -               child->bi_opf = REQ_PREFLUSH;
> > > > -               child->bi_iter.bi_sector = -1;
> > > > -               bio_chain(child, bio);
> > > > -               submit_bio(child);
> > > > -               return 0;
> > > > +       wait_event_lock_irq(vpmem->sb_wait,
> > > > +                           !vpmem->flush_bio ||
> > > > +                           ktime_before(req_start, vpmem->prev_flush_start),
> > > > +                           vpmem->lock);
> > > > +       /* new request after previous flush is completed */
> > > > +       if (ktime_after(req_start, vpmem->prev_flush_start)) {
> > > > +               WARN_ON(vpmem->flush_bio);
> > > > +               vpmem->flush_bio = bio;
> > > > +               bio = NULL;
> > > > +       }
> > >
> > > Why the dance with ->prev_flush_start vs just calling queue_work()
> > > again. queue_work() is naturally coalescing in that if the last work
> > > request has not started execution another queue attempt will be
> > > dropped.
> >
> > How parent flush request will know when corresponding flush is completed?
>
> The eventual bio_endio() is what signals upper layers that the flush
> completed...
>
>
> Hold on... it's been so long that I forgot that you are copying
> md_flush_request() here. It would help immensely if that was mentioned
> in the changelog and at a minimum have a comment in the code that this
> was copied from md. In fact it would be extra helpful if you

My bad. I only mentioned this in the cover letter.

> refactored a common helper that bio based block drivers could share
> for implementing flush handling, but that can come later.

Sure.
>
> Let me go re-review this with respect to whether the md case is fully
> applicable here.

o.k.

Best regards,
Pankaj
