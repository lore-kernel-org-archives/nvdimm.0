Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D910E2919
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 16:23:31 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id v4so2888462pjh.2
        for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 08:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0HINq0/oRgYesXUSAlumWGA0q6P8NqHQhhmtUR68N4=;
        b=J9YwKXa69Vx93oiJ1A6rlmnGuFdnsxujdFBTp7p5n2AVfGclIZJedCzdp3JuNllZ5p
         /4DwwtInokF0YaJpFjG8OP4VoaXb54xKiINkKTUf3s8lKp/It+QnvmSoKoX6hk37yxbP
         20FWPOBPewVz6VIBvoDV0nV1jdNJYCrl1VTskEJko/ycBtHwRMwS3ssIUlbbPEKnd+fU
         n8ksrm06t4LoVbQUj+bwgem0q8NM+siAqj7OIJx6NGoi37N1LcGxVogf7FK448AFAjpW
         GV9NydPog9US56VH9Z092ZEsZuPf4nAxDvCl2YzJuNt+IDG9OCIl0WUf4o8rLdgOW/Qm
         t6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0HINq0/oRgYesXUSAlumWGA0q6P8NqHQhhmtUR68N4=;
        b=L/BOJ7g+yTV/JchJvQSUhjTlfKId8C0XGX2DDN3IGxGujhmIZMPaEVKyO6hf8l3akQ
         1xfe9g8MZcNn+9arBmceX0qTuAdfsLqOl8ShGgALB7eWXaehZArav/KvVSAqknfnPcVl
         aenKSJAFlZPEnOrDrk2+V0QV4gmqrDdiulvbN+hocVAp4yFqndWL6dgemK0rrCoJAdmg
         Cuba1fRrCDGVqx6Dw4wqEfn33GIEz/Kc+5NC33t/2TqiSF0ONG/yJ8wdpFpoYqG/6uFT
         NKS8prHJIatnhCIKXz8viHQvH2Mh81cEfyHvG0s0kiSSrlZaSH4DWXZRcsd78mreBz+P
         Rwiw==
X-Gm-Message-State: AOAM5335hMbW+1dqCR5vbGBCl+/uVsGmGup3UAoRElXKOvrt6AadkZed
	5N8z0O8fPviQ+OjYU6rMHJQVYGWie9RLaa4aEs68/g==
X-Google-Smtp-Source: ABdhPJxe/5E4aU9afUfIgArHENgQctMJhdSdorYTvJU7ovSC4TrhiVgmB6dk+evKsAK0xdx0h9QkI7DI7MpfI+ufsbE=
X-Received: by 2002:a17:90a:d901:b0:1b8:a92c:34fe with SMTP id
 c1-20020a17090ad90100b001b8a92c34femr2642696pjv.8.1645028611229; Wed, 16 Feb
 2022 08:23:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
 <20220111161937.56272-2-pankaj.gupta.linux@gmail.com> <CAPcyv4jrVJ_B0N_-vtqgXaOMovUgnSLCNj228nWMRhGAC5PDhA@mail.gmail.com>
 <CAM9Jb+i0B2jZ0uCEDyiz8ujuMkioFgOA0r7Lz9wDK026Vq1Hxg@mail.gmail.com>
In-Reply-To: <CAM9Jb+i0B2jZ0uCEDyiz8ujuMkioFgOA0r7Lz9wDK026Vq1Hxg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Feb 2022 08:23:19 -0800
Message-ID: <CAPcyv4gJGB8+acXKXbpEpMck_y=XBMR0B0c255MaSyLsH4+eZA@mail.gmail.com>
Subject: Re: [RFC v3 1/2] virtio-pmem: Async virtio-pmem flush
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 12:47 AM Pankaj Gupta
<pankaj.gupta.linux@gmail.com> wrote:
>
> > >
> > > Enable asynchronous flush for virtio pmem using work queue. Also,
> > > coalesce the flush requests when a flush is already in process.
> > > This functionality is copied from md/RAID code.
> > >
> > > When a flush is already in process, new flush requests wait till
> > > previous flush completes in another context (work queue). For all
> > > the requests come between ongoing flush and new flush start time, only
> > > single flush executes, thus adhers to flush coalscing logic. This is
> >
> > s/adhers/adheres/
> >
> > s/coalscing/coalescing/
> >
> > > important for maintaining the flush request order with request coalscing.
> >
> > s/coalscing/coalescing/
>
> o.k. Sorry for the spelling mistakes.
>
> >
> > >
> > > Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > ---
> > >  drivers/nvdimm/nd_virtio.c   | 74 +++++++++++++++++++++++++++---------
> > >  drivers/nvdimm/virtio_pmem.c | 10 +++++
> > >  drivers/nvdimm/virtio_pmem.h | 16 ++++++++
> > >  3 files changed, 83 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > index 10351d5b49fa..179ea7a73338 100644
> > > --- a/drivers/nvdimm/nd_virtio.c
> > > +++ b/drivers/nvdimm/nd_virtio.c
> > > @@ -100,26 +100,66 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
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
> > > +       int ret = -EINPROGRESS;
> > > +
> > > +       spin_lock_irq(&vpmem->lock);
> >
> > Why a new lock and not continue to use ->pmem_lock?
>
> This spinlock is to protect entry in 'wait_event_lock_irq'
> and the Other spinlock is to protect virtio queue data.

Understood, but md shares the mddev->lock for both purposes, so I
would ask that you either document what motivates the locking split,
or just reuse the lock until a strong reason to split them arises.
