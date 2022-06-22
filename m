Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44E110A
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 07:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655882669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3Drt6mDJA7HcEg/a4hfKECbGalfYHTx1FOv9SRLRYk=;
	b=XZfXNiW9ZRMm0D1V6y8keL84Za8URCkeLaVvGitmcaBXBfcRIqN3B461BVPsesWYenY4g9
	VShaC/nHVFJ6nWYXJ3eu766/YQBl8QbU3PLDJj+osysvgPOCYU3jruwoItx+8+ygK+H0PG
	8Ju1D66+b1fR8Hr/9+Dz+rIYlVdGVs4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-rwyueP71NGuaZGVmn2bNDQ-1; Wed, 22 Jun 2022 03:24:28 -0400
X-MC-Unique: rwyueP71NGuaZGVmn2bNDQ-1
Received: by mail-lj1-f199.google.com with SMTP id u9-20020a2e91c9000000b0025569a92731so2174462ljg.3
        for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 00:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z3Drt6mDJA7HcEg/a4hfKECbGalfYHTx1FOv9SRLRYk=;
        b=xfwLolQMn0s/g9V5+LHZozPjdjOnJvecZh1zF3YMXWUN9kmESnRKcm81lsnZL3u+dm
         lnwNcMWPxyYlHI3c7u4l7rtLAMtnIqI6p5+IzDPGP8qdrgWfQObEJlTJ6n3IV1BKvOC/
         q1IpzEs3R2AU461NHY+gxvQxNt8Utaw398NX62DNO9jOFaS0Dl+V2MTFBHMi2FaXQ9TC
         gjHopA+B585gOBz5WwKA9lTzDWEx/U68KAaWDaBXDWCtMjyCoZqS6PPTwXT0bjHDPPMC
         fKexTKxEsDOqIj1VPtiOA4wjsd+S3D10km1bhBpoLMOCu3NZb49mzcHk2ExSWCmLMOaT
         Sc1Q==
X-Gm-Message-State: AJIora9UNWBBRrR/j0X3KELfh805vIBU7GkUUVEWRRjGplKCeUYz+03B
	RXrH6+r+78SAFFROjifAnMXV0/a0d0N6QljflEkPthe3g6ATdaIEsupVBjpsdlxhFa4It0CW1nt
	90aIEV8gk5pop/MX1WFEHFZ3Nxr6t8NB9
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id f5-20020ac251a5000000b0047f79a15c02mr1282764lfk.575.1655882666789;
        Wed, 22 Jun 2022 00:24:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v8O462BWZnYJc4NRwObs6+1jTaD0Ls39KGuQcZR4UgGD6MLjwooFYClpql61AcbzZdu0w4CYzkXU1ABnaZ3Yg=
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id
 f5-20020ac251a5000000b0047f79a15c02mr1282752lfk.575.1655882666568; Wed, 22
 Jun 2022 00:24:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <20220620081519.1494-2-jasowang@redhat.com>
 <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch> <20220622022324-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220622022324-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 22 Jun 2022 15:24:15 +0800
Message-ID: <CACGkMEtrhbVoNyAO54PDY6RvL+-OaF8A_ryj+17a6kz=uJxAqw@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	"Jiang, Dave" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 22, 2022 at 2:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 21, 2022 at 03:38:35PM -0700, Dan Williams wrote:
> > Jason Wang wrote:
> > > The NVDIMM region could be available before the virtio_device_ready()
> > > that is called by virtio_dev_probe(). This means the driver tries to
> > > use device before DRIVER_OK which violates the spec, fixing this by
> > > set device ready before the nvdimm_pmem_region_create().
> >
> > Can you clarify the failure path. What race is virtio_device_ready()
> > losing?
> >
> > >
> > > Note that this means the virtio_pmem_host_ack() could be triggered
> > > before the creation of the nd region, this is safe since the
> > > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > > check if we've added any buffer before trying to proceed.
> >
> > I got a little bit lost with the usage of "we" here. Can you clarify
> > which function / context is making which guarantee?
> >
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
> > >     ndr_desc.provider_data = vdev;
> > >     set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > >     set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > +   /*
> > > +    * The NVDIMM region could be available before the
> > > +    * virtio_device_ready() that is called by
> > > +    * virtio_dev_probe(), so we set device ready here.
> > > +    *
> > > +    * The callback - virtio_pmem_host_ack() is safe to be called
> > > +    * before the nvdimm_pmem_region_create() since the pmem_lock
> > > +    * has been initialized and legality of a used buffer is
> > > +    * validated before moving forward.
> >
> > This comment feels like changelog material. Just document why
> > virtio_device_ready() must be called before device_add() of the
> > nd_region.
>
> Agree here. More specifically if you are documenting why is it
> safe to invoke each callback then that belongs to the callback itself.

Ok, so I will move it to the callback and leave a simple comment like

" See comment in virtio_pmem_host_ack(), it is safe to be called
before nvdimm_pmem_region_create()"

Thanks

>
> > > +    */
> > > +   virtio_device_ready(vdev);
> > >     nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > >     if (!nd_region) {
> > >             dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > >     }
> > >     return 0;
> > >  out_nd:
> > > +   virtio_reset_device(vdev);
> > >     nvdimm_bus_unregister(vpmem->nvdimm_bus);
> > >  out_vq:
> > >     vdev->config->del_vqs(vdev);
> > > --
> > > 2.25.1
> > >
>

