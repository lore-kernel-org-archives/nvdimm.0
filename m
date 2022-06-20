Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AB07F6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655715234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuvjh/PQE1tUBtQ1vbIQHDaQolN735MKlqLygUsScrg=;
	b=Dg7EdpbKnI/rGEBpORiSWqzAnEl/MxCSviKahbXJ/eCEcuzgB23hClTrRCb4VvmEIPdNMr
	Q8UJAtDZzqwRKiSBzJJU79SqCD9sty7ed76Sa1NZVaDrJr4Vaa+Mx7q6JohhUH3BJeVVGt
	o+Exp74n9CQ983a4mmwD8AGUb+Zn3kg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-eY61spRZP0i6T5B21O1wPA-1; Mon, 20 Jun 2022 04:53:53 -0400
X-MC-Unique: eY61spRZP0i6T5B21O1wPA-1
Received: by mail-lj1-f199.google.com with SMTP id m20-20020a2ea594000000b00258f0218017so1175726ljp.2
        for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 01:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vuvjh/PQE1tUBtQ1vbIQHDaQolN735MKlqLygUsScrg=;
        b=WNrrFALBkvf5e1aKAwJJ8Qk2Tf5XYH7rycqUl2Rbi7mbCaIEI2QGJc2N50PIFAxxGg
         hifleL3gF95eVoYISZC1eY0bsGqiU8N+gHRD3sd0/ImrbBeBM2c0JKoC/1/bOa5xmNz8
         4X88/3mS/22h/F3zzU10G44C2AzwSLXHtcmALsYK2E5R/KDra2oFdSmzyQ2D2GGkQK7H
         IvCQDelsNLn3Jgql7izE4FPhWO7ue7nu1IrRbDAFtxZKeCoEDjU+N+Fiha1eWdzuxn2u
         yZ7hWMjGq05wg+5Hq4+KJCuc6Wx5K+L+zw64TsiU6+6u/f1f3BQ8xqg/Lq2K2AmeMXam
         y9Cg==
X-Gm-Message-State: AJIora9UeMO+HlD+lHa+XxnlW9ecp9PZRq935hCZVJFklIgprRWIRsSg
	5+3+2Mp3kSwAy/7+WrurRUu2G5TYggr1vtcnGmmHnrw5HPT4wk6lYbV+fuTX9QZpX2irjxXyW7O
	VS8vxy4Nei2AcR+Ar
X-Received: by 2002:a05:6512:6e:b0:47f:7725:d445 with SMTP id i14-20020a056512006e00b0047f7725d445mr566935lfo.237.1655715232127;
        Mon, 20 Jun 2022 01:53:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1slB6dMPwXyRPvHvBrgMIuAMj3XPiln6GEhHVy3dX9YwuSEjPtChdOh8DwL78zKvKcYlmntxA==
X-Received: by 2002:a17:907:6e25:b0:711:c6ce:b7bc with SMTP id sd37-20020a1709076e2500b00711c6ceb7bcmr20796439ejc.752.1655715221001;
        Mon, 20 Jun 2022 01:53:41 -0700 (PDT)
Received: from redhat.com ([2.52.146.221])
        by smtp.gmail.com with ESMTPSA id r13-20020a05640251cd00b0042ab4e20543sm9875449edd.48.2022.06.20.01.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 01:53:40 -0700 (PDT)
Date: Mon, 20 Jun 2022 04:53:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: pankaj.gupta.linux@gmail.com, Dan Williams <dan.j.williams@intel.com>,
	vishal.l.verma@intel.com, "Jiang, Dave" <dave.jiang@intel.com>,
	ira.weiny@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
Message-ID: <20220620045121-mutt-send-email-mst@kernel.org>
References: <20220620081519.1494-1-jasowang@redhat.com>
 <20220620081519.1494-2-jasowang@redhat.com>
 <20220620042610-mutt-send-email-mst@kernel.org>
 <CACGkMEvn5WYBKwGoJMaHLxABcQjerdOCKqJFFef1rYCBTqQ53w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CACGkMEvn5WYBKwGoJMaHLxABcQjerdOCKqJFFef1rYCBTqQ53w@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 20, 2022 at 04:39:27PM +0800, Jason Wang wrote:
> On Mon, Jun 20, 2022 at 4:32 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > I think you should CC the maintainer, Pankaj Gupta.
> 
> Yes, I miss him accidentally.
> 
> >
> > On Mon, Jun 20, 2022 at 04:15:19PM +0800, Jason Wang wrote:
> > > The NVDIMM region could be available before the virtio_device_ready()
> > > that is called by virtio_dev_probe(). This means the driver tries to
> > > use device before DRIVER_OK which violates the spec, fixing this by
> > > set device ready before the nvdimm_pmem_region_create().
> > >
> > > Note that this means the virtio_pmem_host_ack() could be triggered
> > > before the creation of the nd region, this is safe since the
> > > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > > check if we've added any buffer before trying to proceed.
> > >
> > > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > index 48f8327d0431..173f2f5adaea 100644
> > > --- a/drivers/nvdimm/virtio_pmem.c
> > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > >       ndr_desc.provider_data = vdev;
> > >       set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > >       set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > +     /*
> > > +      * The NVDIMM region could be available before the
> > > +      * virtio_device_ready() that is called by
> > > +      * virtio_dev_probe(), so we set device ready here.
> > > +      *
> >
> > virtio_dev_probe is not to blame here, right?
> 
> Yes and actually it's not to blame, it just describes what can happen now.
> 
> > I don't like copying its logic here as we won't remember to fix
> > it if we change virtio_dev_probe to e.g. not call virtio_device_ready.
> >
> > is it nvdimm_pmem_region_create what makes it possible for
> > the region to become available?
> 
> I think so.
> 
> > Then "The NVDIMM region could become available immediately
> > after the call to nvdimm_pmem_region_create.
> > Tell device we are ready to handle this case."
> 
> That's fine.
> 
> >
> > > +      * The callback - virtio_pmem_host_ack() is safe to be called
> > > +      * before the nvdimm_pmem_region_create() since the pmem_lock
> > > +      * has been initialized and legality of a used buffer is
> > > +      * validated before moving forward.
> > > +      */
> > > +     virtio_device_ready(vdev);
> > >       nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > >       if (!nd_region) {
> > >               dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > >       }
> > >       return 0;
> > >  out_nd:
> > > +     virtio_reset_device(vdev);
> >
> >
> > Does this fix cleanup too?
> 
> Not sure I get this, we make the device ready before
> nvdimm_pmem_region_create(), so we need to reset if
> nvdimm_pmem_region_create() fails?
> 
> Thanks

Oh, right.

> >
> > >       nvdimm_bus_unregister(vpmem->nvdimm_bus);
> > >  out_vq:
> > >       vdev->config->del_vqs(vdev);
> > > --
> > > 2.25.1
> >

