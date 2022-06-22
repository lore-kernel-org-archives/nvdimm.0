Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FA910F1
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 03:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655868874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nCgiPtUGpFr6GeJPczlkC3ccHFgcKR3IxElNX8Io6o=;
	b=KXNTUeukdHkRPgr92TYV80qtKvqes2bryw3ZThmVf7IxOreNZmk+APyuPJq5XEVFFOdUV1
	7dNDeuQ5g+Mb89i0tF78okpvQuoF8W42yiVdjvhCpjH1/YDL6FnM2BSCTbZoqYb+ytJZ8m
	9eFKZdW7bCDNWa1FKY8YU+0SVuLp0eI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-bqvTw1W_NxeC8LAbrhE2iw-1; Tue, 21 Jun 2022 23:34:33 -0400
X-MC-Unique: bqvTw1W_NxeC8LAbrhE2iw-1
Received: by mail-lj1-f199.google.com with SMTP id b40-20020a05651c0b2800b002555cc8cef4so2087915ljr.16
        for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 20:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+nCgiPtUGpFr6GeJPczlkC3ccHFgcKR3IxElNX8Io6o=;
        b=G0hMmheoJwjq6v3cMMJq4Zi5FLKGTA2/Wycd+sc7NFMjbye/7f6FYR+rLNEuumGGUK
         igNX4AazbyiYDIH+a/sattjstZBJVvZaJaYfJQSTbgz7h7QzbVzDRLY/9OWy6yzvBvwK
         DtKGHsg+t2uRuJLsVaHJcFk6kT2SqnC8AD0A4dSNpOMWxVYlNlAt3Y5Hm+iEAZLomfa4
         EgOHvkJBJMYmSRWmVFg8bWYxNTd1qM2q+9lR3EBF9oP5qboCpnViXCKbsf8BVwuAAIGq
         xMcZPxrr0Yar15ADX69C0Odba8kmfESZ18t4JpyPjA+mcyn9ngPkQd+dlLsasm12snvJ
         L8jA==
X-Gm-Message-State: AJIora8+Pu5LdKPFen2GyKbsN5u/Zz/PETbbgZd1ZHebbV29IGVFQdGN
	NwY3hetQZd6OccOkgiCDgdUljYHqmJQ1mqGK7p1ZXeMgMKfnsGBW5caafaDtaaSHPOVAT+nUQGb
	XbyLney6tTMNvlzp/1qna1P5AgXUxwLEX
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id f5-20020ac251a5000000b0047f79a15c02mr851228lfk.575.1655868871891;
        Tue, 21 Jun 2022 20:34:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u90irmX7BGyFGC5hiYBMqmEvJDaGfOP3dXw+zgD3t4BPyWXz1CrR3YPnYraeJNcDCCIKo0in/3A9RJTt4L0uo=
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id
 f5-20020ac251a5000000b0047f79a15c02mr851213lfk.575.1655868871676; Tue, 21 Jun
 2022 20:34:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <20220620081519.1494-2-jasowang@redhat.com>
 <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
In-Reply-To: <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 22 Jun 2022 11:34:20 +0800
Message-ID: <CACGkMEuh+RPeAgE=uqe206iA9WbegO4J0ruid_i3j2Uuv5F19g@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, "Jiang, Dave" <dave.jiang@intel.com>, ira.weiny@intel.com, 
	nvdimm@lists.linux.dev, mst <mst@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 22, 2022 at 6:38 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Jason Wang wrote:
> > The NVDIMM region could be available before the virtio_device_ready()
> > that is called by virtio_dev_probe(). This means the driver tries to
> > use device before DRIVER_OK which violates the spec, fixing this by
> > set device ready before the nvdimm_pmem_region_create().
>
> Can you clarify the failure path. What race is virtio_device_ready()
> losing?

So it's something like this:

1) virtio_device_ready() will set DRIVER_OK to the device.
2) virtio spec disallow device to process a virtqueue without DRIVER_OK to set

But the nd_region is available to user after nd_region_create(), and a
flush could be issued before virtio_device_ready().

This means the hypervisor gets a kick on the virtqueue before
DRIVER_OK. The hypervisor should choose not to respond to that kick
according to the spec. This will result in infinite wait in
virtio_pmem_flush().

Fortunately, qemu doesn't check DRIVER_OK and can process the
virtqueue without DRIVER_OK (which is kind of a spec violation), so we
survive for the past few years. But there's no guarantee it can work
for other hypervisor.

So we need to set DRIVER_OK before nd_region_create() to make sure flush works.

>
> >
> > Note that this means the virtio_pmem_host_ack() could be triggered
> > before the creation of the nd region, this is safe since the
> > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > check if we've added any buffer before trying to proceed.
>
> I got a little bit lost with the usage of "we" here. Can you clarify
> which function / context is making which guarantee?

By "we" I meant the callback for the req_vq that is virtio_pmem_host_ack().

If we do virtio_device_ready() before nd_region_create(). A buggy or
malicious hypervisor can raise the notification before
nd_region_create(). We need to make sure virtio_pmem_host_ack() can
survive from this. And since we've checked whether we've submitted any
request before, so in the case where guest memory is protected from
the host, we're safe here.

>
> >
> > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index 48f8327d0431..173f2f5adaea 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >       ndr_desc.provider_data = vdev;
> >       set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> >       set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > +     /*
> > +      * The NVDIMM region could be available before the
> > +      * virtio_device_ready() that is called by
> > +      * virtio_dev_probe(), so we set device ready here.
> > +      *
> > +      * The callback - virtio_pmem_host_ack() is safe to be called
> > +      * before the nvdimm_pmem_region_create() since the pmem_lock
> > +      * has been initialized and legality of a used buffer is
> > +      * validated before moving forward.
>
> This comment feels like changelog material.

I had this in the changelog:

> > Note that this means the virtio_pmem_host_ack() could be triggered
> > before the creation of the nd region, this is safe since the
> > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > check if we've added any buffer before trying to proceed.

> Just document why
> virtio_device_ready() must be called before device_add() of the
> nd_region.

This comment wants to explain the side effect of having
virtio_device_ready() before nvdimm_pmem_region_create() and why we
can survive from that.

Thanks

>
> > +      */
> > +     virtio_device_ready(vdev);
> >       nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> >       if (!nd_region) {
> >               dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >       }
> >       return 0;
> >  out_nd:
> > +     virtio_reset_device(vdev);
> >       nvdimm_bus_unregister(vpmem->nvdimm_bus);
> >  out_vq:
> >       vdev->config->del_vqs(vdev);
> > --
> > 2.25.1
> >
>

