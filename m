Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78781FD1
	for <nvdimm@lists.linux.dev>; Fri, 24 Jun 2022 06:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656053107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=anjH/goFMxTWH8yqmGIDJXnARCuuyOFfmdMbcb5H6f8=;
	b=HhtH6InahgXhxOo7WI+ZI0cbXGgNyO8QRzy4Kx4Dc1vazpaRNhS6xual5VrYeT6737abFp
	gCQ1D/WE4OSemlOS/BsSs3nlHupgC1CkyfqE4jOH+47MFhkaIACBypV5bqlsbZhuvpkZDq
	bFHdavSE9gYWVP5pqCYELNJEL9Au8I0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-wgwEcYiDNXmdX0PU0-iwCA-1; Fri, 24 Jun 2022 02:45:03 -0400
X-MC-Unique: wgwEcYiDNXmdX0PU0-iwCA-1
Received: by mail-wm1-f72.google.com with SMTP id r186-20020a1c44c3000000b003a02fa133ceso628487wma.2
        for <nvdimm@lists.linux.dev>; Thu, 23 Jun 2022 23:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=anjH/goFMxTWH8yqmGIDJXnARCuuyOFfmdMbcb5H6f8=;
        b=yvga3tvZrYaJAiDhmG6g1Xzdq/ZzD176nQRYR7hQiNddckBTd8i3QiTDHk/hL11zBy
         SszLOcMwFCUmiXvrB44Kz7UGAdC8YfNhxVMF4mdasOaCt48oPSbG1pTDA4h2lieXDasA
         Tu9fGXrNE8kmQXnfGLze39pkHg000mw5GS53yqY4zWMQapeXbJW1CE+vhzMLtOBUzT80
         4e2sZk6lrerQl0PgYKmWxWjhj+UstZQIwWOMky341NVfEBWY20xUu0/fzlAEhc4yh8Le
         vZbxvZpYLKxgZKQ7J1p1Z2G1jiXB+T+8UIDrOrQIQB73JOeFCo6dTY1rihb3F6Zw/AWD
         GDyA==
X-Gm-Message-State: AJIora+dI7KgUkqcJA43wnEIqtE5R5FdY/yow+iKOUX/NpJxoqroZGk8
	nIT3VI93wdTaGCICz0LhnPZBauSaLirRX0kxts2b1Vj9iC5hnP5rB+vhiq29c8l/KgiAHPqFqg/
	0+lbnn4Z8l7stFYn5
X-Received: by 2002:a5d:6812:0:b0:21b:8a2f:f732 with SMTP id w18-20020a5d6812000000b0021b8a2ff732mr11638709wru.202.1656053102450;
        Thu, 23 Jun 2022 23:45:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uxdA6lHAfhGjQ298fMHfYj1gG0JZfg1P4Ajd25QxReemWTZnoMis5Q6BlVyUSOta+uhmFVxA==
X-Received: by 2002:a5d:6812:0:b0:21b:8a2f:f732 with SMTP id w18-20020a5d6812000000b0021b8a2ff732mr11638698wru.202.1656053102191;
        Thu, 23 Jun 2022 23:45:02 -0700 (PDT)
Received: from redhat.com ([2.55.188.216])
        by smtp.gmail.com with ESMTPSA id z5-20020adfe545000000b0021b81855c1csm1665673wrm.27.2022.06.23.23.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:45:01 -0700 (PDT)
Date: Fri, 24 Jun 2022 02:44:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
Message-ID: <20220624024339-mutt-send-email-mst@kernel.org>
References: <20220620081519.1494-1-jasowang@redhat.com>
 <20220620081519.1494-2-jasowang@redhat.com>
 <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
 <20220622022324-mutt-send-email-mst@kernel.org>
 <CACGkMEtrhbVoNyAO54PDY6RvL+-OaF8A_ryj+17a6kz=uJxAqw@mail.gmail.com>
 <20220622082811-mutt-send-email-mst@kernel.org>
 <CACGkMEuhtkS4XCFb4sT_gkSyi8BNB6hYuH=adrQCr1q_VKOrFQ@mail.gmail.com>
 <CACGkMEsNVo0XP4nPC89-ZbiGxz2OSPf92WtNpYMEsPt-Sp_s_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CACGkMEsNVo0XP4nPC89-ZbiGxz2OSPf92WtNpYMEsPt-Sp_s_g@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 23, 2022 at 11:57:26AM +0800, Jason Wang wrote:
> On Thu, Jun 23, 2022 at 9:29 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Wed, Jun 22, 2022 at 8:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jun 22, 2022 at 03:24:15PM +0800, Jason Wang wrote:
> > > > On Wed, Jun 22, 2022 at 2:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Tue, Jun 21, 2022 at 03:38:35PM -0700, Dan Williams wrote:
> > > > > > Jason Wang wrote:
> > > > > > > The NVDIMM region could be available before the virtio_device_ready()
> > > > > > > that is called by virtio_dev_probe(). This means the driver tries to
> > > > > > > use device before DRIVER_OK which violates the spec, fixing this by
> > > > > > > set device ready before the nvdimm_pmem_region_create().
> > > > > >
> > > > > > Can you clarify the failure path. What race is virtio_device_ready()
> > > > > > losing?
> > > > > >
> > > > > > >
> > > > > > > Note that this means the virtio_pmem_host_ack() could be triggered
> > > > > > > before the creation of the nd region, this is safe since the
> > > > > > > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > > > > > > check if we've added any buffer before trying to proceed.
> > > > > >
> > > > > > I got a little bit lost with the usage of "we" here. Can you clarify
> > > > > > which function / context is making which guarantee?
> > > > > >
> > > > > > >
> > > > > > > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > ---
> > > > > > >  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
> > > > > > >  1 file changed, 12 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > > > > > index 48f8327d0431..173f2f5adaea 100644
> > > > > > > --- a/drivers/nvdimm/virtio_pmem.c
> > > > > > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > > > > > @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > > > > >     ndr_desc.provider_data = vdev;
> > > > > > >     set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > > > > > >     set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > > > > > +   /*
> > > > > > > +    * The NVDIMM region could be available before the
> > > > > > > +    * virtio_device_ready() that is called by
> > > > > > > +    * virtio_dev_probe(), so we set device ready here.
> > > > > > > +    *
> > > > > > > +    * The callback - virtio_pmem_host_ack() is safe to be called
> > > > > > > +    * before the nvdimm_pmem_region_create() since the pmem_lock
> > > > > > > +    * has been initialized and legality of a used buffer is
> > > > > > > +    * validated before moving forward.
> > > > > >
> > > > > > This comment feels like changelog material. Just document why
> > > > > > virtio_device_ready() must be called before device_add() of the
> > > > > > nd_region.
> > > > >
> > > > > Agree here. More specifically if you are documenting why is it
> > > > > safe to invoke each callback then that belongs to the callback itself.
> > > >
> > > > Ok, so I will move it to the callback and leave a simple comment like
> > > >
> > > > " See comment in virtio_pmem_host_ack(), it is safe to be called
> > > > before nvdimm_pmem_region_create()"
> > > >
> > > > Thanks
> > >
> > > No, just document why virtio_device_ready() must be called before device_add()
> > >
> > > I don't think the idea of working around these issues by adding code
> > > to  virtio_device_ready worked so far,
> >
> > Any issue you found in this approach?
> >
> > > not at all sure this approach
> > > is here to stay.
> >
> > Or do you have other ideas to fix this issue?
> 
> Or do you think we can do something similar to harden the config
> interrupt (down the road with the kconfig option)?
> 
> virtio_device_ready(); // set driver ok but delay the vring interrupt
> subsystem_register();
> virtio_enable_vq_callback(); // enable vring interrupt and raised
> delayed interrupt
> 
> Thanks

Yes and from API POV I think we should do

virtio_disable_vq_callback();
virtio_device_ready();
subsystem_register();
virtio_enable_vq_callback();

this way we won't break all drivers that aren't careful like
previous hardening patches did.


> >
> > Thanks
> >
> > >
> > >
> > > > >
> > > > > > > +    */
> > > > > > > +   virtio_device_ready(vdev);
> > > > > > >     nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > > > > > >     if (!nd_region) {
> > > > > > >             dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > > > > > > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > > > > >     }
> > > > > > >     return 0;
> > > > > > >  out_nd:
> > > > > > > +   virtio_reset_device(vdev);
> > > > > > >     nvdimm_bus_unregister(vpmem->nvdimm_bus);
> > > > > > >  out_vq:
> > > > > > >     vdev->config->del_vqs(vdev);
> > > > > > > --
> > > > > > > 2.25.1
> > > > > > >
> > > > >
> > >

