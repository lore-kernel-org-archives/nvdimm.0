Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316703FC0
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 21:50:34 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id e1so377422plt.11
        for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 14:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gljV3X+X4bcwcQ/X8uaiX4fSjzUiwO9jzr2JlYeYJ/Q=;
        b=eIe+Cu5Qjp2Vl97D+4LwgaQOmHr58x6p4ed/bciRqULxLtcx+2DM2xenPiGmP64ooH
         4UQzFmoIRwN4M53n04lIeG0eArNxM/c0W/+N6WjA1XsRO4ED16HGXVEmnSuHTOm9Tybr
         eKX0jaL/wKY3vItRJcMJtO1Q52ODeKQFJeUQYvQI5Srj4UxjW8yZypx7SBMqFzBoJ2pV
         wxee9r5NzwLqys+VSSp7Z7tvw7QvCwk2IkBip6QfpHwFqMZ/Ts+PQoWNveYheRbsJVoi
         loXfNAFtuRcW7kUeTXZcatz8UV/LM+vDtbayO4Wd4ztixnYrOY1k6JDWTw5UM5OFakv2
         90TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gljV3X+X4bcwcQ/X8uaiX4fSjzUiwO9jzr2JlYeYJ/Q=;
        b=drvQfcHCq3u0QZHRkClPAYrjnimu5pANPwSMsDjBQKTl4y+DN7a+oTGxTESimnaLaP
         C/4hjha2ga1gR2JMHmoeDm4XVKdcu/H47ypwRYIj8Bnoaz4i/F1makNVDi8XUAUd2kdE
         Se7sFaoTh9GlmcECs0Ne+0T3a5Lz+5jnG7PojCWPRnEDgHXvu3wlQxhMNP3YTYW4Ejra
         K5BGFt1XxnWpzmYoIeK7oXM7bze/7Pwba2lrthMwiz94Pu5y8IIGXbz86w4CehL83vzj
         Tb6B7l/p0ZJaW7CGIOa9jHF70jJycHRJUbhIw1nwnFqav/oLJ2ZkfyBnunx/vNeg4lJj
         cAUQ==
X-Gm-Message-State: AOAM532tRK1/TL/U/i13V0R8me9J0MsSNlGeJHHObHAG1C3fWmd/GP67
	KM82H5czsV8n+OvsspF2elgVVqZo6S8xKMyeK1aiig==
X-Google-Smtp-Source: ABdhPJwoEKzFBbH3OVx9BphGbywbL+BVEhVsHKGJpbnIABdGEF8xoAhf7jkbiVSsY9kNWunFvIKniut7EFRcHCGA1qI=
X-Received: by 2002:a17:90a:1991:: with SMTP id 17mr4259027pji.149.1629928233668;
 Wed, 25 Aug 2021 14:50:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
 <20210726060855.108250-2-pankaj.gupta.linux@gmail.com> <CAPcyv4inCFFXmg0r5+h0O6cADpt9HdboVDEL00XX-wGroy-7LQ@mail.gmail.com>
 <CAM9Jb+hqPBFUh9X4sKb9TUGXX1P0mC1xcuCNQx1BYvAvoP9uQg@mail.gmail.com>
In-Reply-To: <CAM9Jb+hqPBFUh9X4sKb9TUGXX1P0mC1xcuCNQx1BYvAvoP9uQg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Aug 2021 14:50:22 -0700
Message-ID: <CAPcyv4gUG1-y1u0ZyUkSGXg0eER_oTdexb8n-CYgb_rURvr8LA@mail.gmail.com>
Subject: Re: [RFC v2 1/2] virtio-pmem: Async virtio-pmem flush
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	David Hildenbrand <david@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 25, 2021 at 1:02 PM Pankaj Gupta
<pankaj.gupta.linux@gmail.com> wrote:
>
> Hi Dan,
>
> Thank you for the review. Please see my reply inline.
>
> > > Implement asynchronous flush for virtio pmem using work queue
> > > to solve the preflush ordering issue. Also, coalesce the flush
> > > requests when a flush is already in process.
> > >
> > > Signed-off-by: Pankaj Gupta <pankaj.gupta@ionos.com>
> > > ---
> > >  drivers/nvdimm/nd_virtio.c   | 72 ++++++++++++++++++++++++++++--------
> > >  drivers/nvdimm/virtio_pmem.c | 10 ++++-
> > >  drivers/nvdimm/virtio_pmem.h | 14 +++++++
> > >  3 files changed, 79 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > index 10351d5b49fa..61b655b583be 100644
> > > --- a/drivers/nvdimm/nd_virtio.c
> > > +++ b/drivers/nvdimm/nd_virtio.c
> > > @@ -97,29 +97,69 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
> > >         return err;
> > >  };
> > >
> > > +static void submit_async_flush(struct work_struct *ws);
> > > +
> > >  /* The asynchronous flush callback function */
> > >  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
> > >  {
> > > -       /*
> > > -        * Create child bio for asynchronous flush and chain with
> > > -        * parent bio. Otherwise directly call nd_region flush.
> > > +       /* queue asynchronous flush and coalesce the flush requests */
> > > +       struct virtio_device *vdev = nd_region->provider_data;
> > > +       struct virtio_pmem *vpmem  = vdev->priv;
> > > +       ktime_t req_start = ktime_get_boottime();
> > > +
> > > +       spin_lock_irq(&vpmem->lock);
> > > +       /* flush requests wait until ongoing flush completes,
> > > +        * hence coalescing all the pending requests.
> > >          */
> > > -       if (bio && bio->bi_iter.bi_sector != -1) {
> > > -               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> > > -
> > > -               if (!child)
> > > -                       return -ENOMEM;
> > > -               bio_copy_dev(child, bio);
> > > -               child->bi_opf = REQ_PREFLUSH;
> > > -               child->bi_iter.bi_sector = -1;
> > > -               bio_chain(child, bio);
> > > -               submit_bio(child);
> > > -               return 0;
> > > +       wait_event_lock_irq(vpmem->sb_wait,
> > > +                           !vpmem->flush_bio ||
> > > +                           ktime_before(req_start, vpmem->prev_flush_start),
> > > +                           vpmem->lock);
> > > +       /* new request after previous flush is completed */
> > > +       if (ktime_after(req_start, vpmem->prev_flush_start)) {
> > > +               WARN_ON(vpmem->flush_bio);
> > > +               vpmem->flush_bio = bio;
> > > +               bio = NULL;
> > > +       }
> >
> > Why the dance with ->prev_flush_start vs just calling queue_work()
> > again. queue_work() is naturally coalescing in that if the last work
> > request has not started execution another queue attempt will be
> > dropped.
>
> How parent flush request will know when corresponding flush is completed?

The eventual bio_endio() is what signals upper layers that the flush
completed...


Hold on... it's been so long that I forgot that you are copying
md_flush_request() here. It would help immensely if that was mentioned
in the changelog and at a minimum have a comment in the code that this
was copied from md. In fact it would be extra helpful if you
refactored a common helper that bio based block drivers could share
for implementing flush handling, but that can come later.

Let me go re-review this with respect to whether the md case is fully
applicable here.
