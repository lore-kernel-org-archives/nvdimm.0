Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BA610F0
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655901076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F2xQP4rqDja0eyG0j3YADtf0ZNknwH6S17BXvTIyWok=;
	b=YaQgE0OkPVpq/g1oYwOsn8pDPfjwTSSK98zxDHVk5dGestTAarFb375u0fW07B0nTx8SBA
	/CRnlSJoUybgqtZflehRNG8m0oPQzWUmi5EyWAlHBbBOPAlJDfmNYR4mrmiWniqLjPdt+4
	Mq59n1slGvOHvwHlhkd/SJRPcDr9YW0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-VVuQ0bfAO9aIa3B1giMLSg-1; Wed, 22 Jun 2022 08:31:15 -0400
X-MC-Unique: VVuQ0bfAO9aIa3B1giMLSg-1
Received: by mail-wm1-f71.google.com with SMTP id l4-20020a05600c1d0400b0039c60535405so5482580wms.6
        for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 05:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F2xQP4rqDja0eyG0j3YADtf0ZNknwH6S17BXvTIyWok=;
        b=U5Xg7nh5Y5vh2q1GTx7UjI0meglANULHZ69c9bXT6e6G7MMmaR5feYGTQlLqdN2h4N
         BhEA7yVU8Bm+U+6ii8uzju72UH6XT3BEewrAiNGDf5MiCKzAopFRDsfQjFbXnvoUbgKM
         2EGK7dxY5SoJetwJ6lqpvnyERNhfe8bApBXOHAue9H/noCNRTBqZIcobFc1LE33rvBET
         R180GKodQUxUkIPoExDnrOgVN/Sv0nk29oc8bKbZCTmy1Eyb7YZiPLFSWNUL/IMrK1i0
         yLbY4mSqSROHGBJ6v7urKQ3kl28F5mHvCQ0m9AsONenm11csKREgvaWDEBf/SXz7ByIa
         1Qog==
X-Gm-Message-State: AJIora+k7OsJ8NjGc9QnDP1edBnEPvXfxuJHzbxlvploforC27ikP+hi
	unXxWwwE55jhCWjTEJczbbKokK9HndWYEcRQlfcWOzp/KlRl6b+DXd+f9NNdTt0VMNF+uUd+Kst
	Pn5qye0zpTULNHxBq
X-Received: by 2002:adf:ef42:0:b0:21b:8e58:f24b with SMTP id c2-20020adfef42000000b0021b8e58f24bmr3107334wrp.257.1655901074046;
        Wed, 22 Jun 2022 05:31:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vSbKkV3PVXP2BiSZ/bc1te6+gAY4nooRijb5UD0GYswwybjJ+A+BhWzkfCCVHtOvAemGRXXQ==
X-Received: by 2002:adf:ef42:0:b0:21b:8e58:f24b with SMTP id c2-20020adfef42000000b0021b8e58f24bmr3107303wrp.257.1655901073728;
        Wed, 22 Jun 2022 05:31:13 -0700 (PDT)
Received: from redhat.com ([147.235.217.93])
        by smtp.gmail.com with ESMTPSA id u3-20020adfeb43000000b0021a34023ca3sm18829702wrn.62.2022.06.22.05.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 05:31:13 -0700 (PDT)
Date: Wed, 22 Jun 2022 08:31:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
Message-ID: <20220622082811-mutt-send-email-mst@kernel.org>
References: <20220620081519.1494-1-jasowang@redhat.com>
 <20220620081519.1494-2-jasowang@redhat.com>
 <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
 <20220622022324-mutt-send-email-mst@kernel.org>
 <CACGkMEtrhbVoNyAO54PDY6RvL+-OaF8A_ryj+17a6kz=uJxAqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CACGkMEtrhbVoNyAO54PDY6RvL+-OaF8A_ryj+17a6kz=uJxAqw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 22, 2022 at 03:24:15PM +0800, Jason Wang wrote:
> On Wed, Jun 22, 2022 at 2:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jun 21, 2022 at 03:38:35PM -0700, Dan Williams wrote:
> > > Jason Wang wrote:
> > > > The NVDIMM region could be available before the virtio_device_ready()
> > > > that is called by virtio_dev_probe(). This means the driver tries to
> > > > use device before DRIVER_OK which violates the spec, fixing this by
> > > > set device ready before the nvdimm_pmem_region_create().
> > >
> > > Can you clarify the failure path. What race is virtio_device_ready()
> > > losing?
> > >
> > > >
> > > > Note that this means the virtio_pmem_host_ack() could be triggered
> > > > before the creation of the nd region, this is safe since the
> > > > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > > > check if we've added any buffer before trying to proceed.
> > >
> > > I got a little bit lost with the usage of "we" here. Can you clarify
> > > which function / context is making which guarantee?
> > >
> > > >
> > > > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > >  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > >
> > > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > > index 48f8327d0431..173f2f5adaea 100644
> > > > --- a/drivers/nvdimm/virtio_pmem.c
> > > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > > @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > >     ndr_desc.provider_data = vdev;
> > > >     set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > > >     set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > > +   /*
> > > > +    * The NVDIMM region could be available before the
> > > > +    * virtio_device_ready() that is called by
> > > > +    * virtio_dev_probe(), so we set device ready here.
> > > > +    *
> > > > +    * The callback - virtio_pmem_host_ack() is safe to be called
> > > > +    * before the nvdimm_pmem_region_create() since the pmem_lock
> > > > +    * has been initialized and legality of a used buffer is
> > > > +    * validated before moving forward.
> > >
> > > This comment feels like changelog material. Just document why
> > > virtio_device_ready() must be called before device_add() of the
> > > nd_region.
> >
> > Agree here. More specifically if you are documenting why is it
> > safe to invoke each callback then that belongs to the callback itself.
> 
> Ok, so I will move it to the callback and leave a simple comment like
> 
> " See comment in virtio_pmem_host_ack(), it is safe to be called
> before nvdimm_pmem_region_create()"
> 
> Thanks

No, just document why virtio_device_ready() must be called before device_add()

I don't think the idea of working around these issues by adding code
to  virtio_device_ready worked so far, not at all sure this approach
is here to stay.


> >
> > > > +    */
> > > > +   virtio_device_ready(vdev);
> > > >     nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > > >     if (!nd_region) {
> > > >             dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > > > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > >     }
> > > >     return 0;
> > > >  out_nd:
> > > > +   virtio_reset_device(vdev);
> > > >     nvdimm_bus_unregister(vpmem->nvdimm_bus);
> > > >  out_vq:
> > > >     vdev->config->del_vqs(vdev);
> > > > --
> > > > 2.25.1
> > > >
> >

