Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCCC23D2
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 17:04:31 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id q8so458116iod.2
        for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 09:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ebPURKf0/zwBkSiUOG+tDveD/Pc8B6gk0N6+zX/eOg=;
        b=caoErfXVMhneOKUMlH+nxW0INIgrQ6Nixn6Vi1TMYKcG/GLqZqDmKTDkIvgsRkeaD/
         D23NXdh9zJO3y9F+AUOh0pdkVYWp97CEqabIdSuNSwmPY2KhgQOKl9abEnjygdbzg99P
         E6SBxO32A89HTTbx9T25u753a5gO/G32bKzFmNSMSMmCaSiEcAZs5aFpsiN58JDbngj5
         vnsEUBUX5yYACAWkw/+xSiUT8cNiAtZLMaI7HBppC4OMvDGzV9d505sF/S4jqimQ5ifB
         /ow4wkKuqMsNRWj3gWER0cRP8hIeYPd5ohPLztTOaXC4IyOARvq/awhPGOlZRi72fLBz
         NwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ebPURKf0/zwBkSiUOG+tDveD/Pc8B6gk0N6+zX/eOg=;
        b=B4tN1rzjXEMoa09SUo4iObTLpvf6dPblnujkCGD0n8U+aBOK0QNvaqa91O8pE/NcNt
         EiQvsKCu4oqhqU4ljQxshrhvlyas2x1M+w0rZjf6ZMGeoDW8GcY5c6QOn+g+4WKtLBt+
         LaRRLAdND7uzXMaJHQ6V+v+uDuGKM86v/hdIejaS7ouClG9k4aUIdwvnmnnlR9fsvfCj
         P0VdezCNJA+qijuWKY+FQPCdAHx84vZbbIfCwZaUrlHCx+aauTH0dSAnS1aYoqbH+1+t
         tNutbvNGPpyaYqVBOgMvv63MLXWj5nP7zWH+PO3yXCG2Uw051gJctXgUT0LIJq+9l92o
         OFeA==
X-Gm-Message-State: AOAM53218CtwkhIzttZZsI2e63T3Hv0/fLlu5TuzxGsAvYJ/l/iQIIsH
	aMdZ/W50aWOIRakKuSl8loJssumJ6aeA1fPZCuc=
X-Google-Smtp-Source: ABdhPJx1pOzGdJ0I5ZGWUdukwje0VchP9Q2Dpzte/hebLd/x02Xsa9rd474WbNtX+50nkoXg8naKRuuHmHa3wNyQnkM=
X-Received: by 2002:a5e:8c15:0:b0:634:478e:450e with SMTP id
 n21-20020a5e8c15000000b00634478e450emr2504490ioj.56.1645031070215; Wed, 16
 Feb 2022 09:04:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220111161937.56272-1-pankaj.gupta.linux@gmail.com>
 <20220111161937.56272-2-pankaj.gupta.linux@gmail.com> <CAPcyv4jrVJ_B0N_-vtqgXaOMovUgnSLCNj228nWMRhGAC5PDhA@mail.gmail.com>
 <CAM9Jb+i0B2jZ0uCEDyiz8ujuMkioFgOA0r7Lz9wDK026Vq1Hxg@mail.gmail.com> <CAPcyv4gJGB8+acXKXbpEpMck_y=XBMR0B0c255MaSyLsH4+eZA@mail.gmail.com>
In-Reply-To: <CAPcyv4gJGB8+acXKXbpEpMck_y=XBMR0B0c255MaSyLsH4+eZA@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 16 Feb 2022 18:04:19 +0100
Message-ID: <CAM9Jb+hbds3b+nY9APU40Fpd9pt4CyFuZ3SU4ZB05subnaJQvQ@mail.gmail.com>
Subject: Re: [RFC v3 1/2] virtio-pmem: Async virtio-pmem flush
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, virtualization@lists.linux-foundation.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

> >
> > > >
> > > > Enable asynchronous flush for virtio pmem using work queue. Also,
> > > > coalesce the flush requests when a flush is already in process.
> > > > This functionality is copied from md/RAID code.
> > > >
> > > > When a flush is already in process, new flush requests wait till
> > > > previous flush completes in another context (work queue). For all
> > > > the requests come between ongoing flush and new flush start time, only
> > > > single flush executes, thus adhers to flush coalscing logic. This is
> > >
> > > s/adhers/adheres/
> > >
> > > s/coalscing/coalescing/
> > >
> > > > important for maintaining the flush request order with request coalscing.
> > >
> > > s/coalscing/coalescing/
> >
> > o.k. Sorry for the spelling mistakes.
> >
> > >
> > > >
> > > > Signed-off-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > > ---
> > > >  drivers/nvdimm/nd_virtio.c   | 74 +++++++++++++++++++++++++++---------
> > > >  drivers/nvdimm/virtio_pmem.c | 10 +++++
> > > >  drivers/nvdimm/virtio_pmem.h | 16 ++++++++
> > > >  3 files changed, 83 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> > > > index 10351d5b49fa..179ea7a73338 100644
> > > > --- a/drivers/nvdimm/nd_virtio.c
> > > > +++ b/drivers/nvdimm/nd_virtio.c
> > > > @@ -100,26 +100,66 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
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
> > > > +       int ret = -EINPROGRESS;
> > > > +
> > > > +       spin_lock_irq(&vpmem->lock);
> > >
> > > Why a new lock and not continue to use ->pmem_lock?
> >
> > This spinlock is to protect entry in 'wait_event_lock_irq'
> > and the Other spinlock is to protect virtio queue data.
>
> Understood, but md shares the mddev->lock for both purposes, so I
> would ask that you either document what motivates the locking split,
> or just reuse the lock until a strong reason to split them arises.

O.k. Will check again if we could use same lock Or document it.

Thanks,
Pankaj
