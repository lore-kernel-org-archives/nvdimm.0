Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2443D0
	for <nvdimm@lists.linux.dev>; Thu, 23 Jun 2022 03:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655956660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WM/uGA6kRkkwRlLmlAYMI3DbWTCws1JpIbauEvCCKvY=;
	b=I6CN87Gtgy4G94Yua34+jf9H8mvjyi0mSQfteZ9rmxezkUHaukzNMg/8nPKeAAkJRrFAyT
	cv7WJPTAMOrIb+DhHs6bMwxNid39V6ELBdbAqVG3GtWdwaeR0s1o+HRuAuISmf3og3pazL
	YBYnzb6mKIm6D2psiv8v9Ur4UVjZhlQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-1VEAhEwIP3Si1IASfiQc2Q-1; Wed, 22 Jun 2022 23:57:39 -0400
X-MC-Unique: 1VEAhEwIP3Si1IASfiQc2Q-1
Received: by mail-lf1-f72.google.com with SMTP id o23-20020ac24357000000b0047f95f582c6so1982796lfl.7
        for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 20:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WM/uGA6kRkkwRlLmlAYMI3DbWTCws1JpIbauEvCCKvY=;
        b=fYMasOwEnNIks7C6fTXxvw1Ia8mpUDkbUCgPhPgQH5XZWle+vFDH9RoiBTF3kP4dUZ
         PoA1bmu7rpykppTSgMuYVDfhqsqNswQF/G0Uj0G6XStrAGh33p/wyMOqMjHb84Q/d6Cb
         ZPVETc/TZK04CXngteN0DZZuVce7kaHR+qZGovSwmrBzvKJ+eejlrn8A6S6FUNKaSLJG
         Iqo+4SxLbAisroNjQw5uy2i+Cz2cFkeIu6GENXqFpLxZmQRlfcdnXuce+qwUekWyC0Kr
         3Jj+eDiw5eih0ho102/DFO/O+O5GfM09qigeWoefnK5WejUel1U3fY21IcRAyWAU354u
         /0wQ==
X-Gm-Message-State: AJIora+FLkx9yf2nH9CP2vYObJHLrYLf0fpsUXV6ZjCRmj+MxV97qYmb
	vljQx1NbQHAFp+4qCIAj2kgX1FiOkRHnfQl93meTWFbH09hW8MMVYLYhoL4cWDPH1XWanuWb3I+
	BiXoNcJjD0xLH0Zk0MVnfB5+flsj+laiG
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id f5-20020ac251a5000000b0047f79a15c02mr4170464lfk.575.1655956658001;
        Wed, 22 Jun 2022 20:57:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v6kt2gHErYageAVvGT23OCqEfmiFMc5Q9xwuREA5YSMSiP/Hicco9tzyDtE+SqrSLSxL0Q3TkDYCG7p6Dc3gQ=
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id
 f5-20020ac251a5000000b0047f79a15c02mr4170453lfk.575.1655956657777; Wed, 22
 Jun 2022 20:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <20220620081519.1494-2-jasowang@redhat.com>
 <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch> <20220622022324-mutt-send-email-mst@kernel.org>
 <CACGkMEtrhbVoNyAO54PDY6RvL+-OaF8A_ryj+17a6kz=uJxAqw@mail.gmail.com>
 <20220622082811-mutt-send-email-mst@kernel.org> <CACGkMEuhtkS4XCFb4sT_gkSyi8BNB6hYuH=adrQCr1q_VKOrFQ@mail.gmail.com>
In-Reply-To: <CACGkMEuhtkS4XCFb4sT_gkSyi8BNB6hYuH=adrQCr1q_VKOrFQ@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 23 Jun 2022 11:57:26 +0800
Message-ID: <CACGkMEsNVo0XP4nPC89-ZbiGxz2OSPf92WtNpYMEsPt-Sp_s_g@mail.gmail.com>
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

On Thu, Jun 23, 2022 at 9:29 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Jun 22, 2022 at 8:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jun 22, 2022 at 03:24:15PM +0800, Jason Wang wrote:
> > > On Wed, Jun 22, 2022 at 2:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Jun 21, 2022 at 03:38:35PM -0700, Dan Williams wrote:
> > > > > Jason Wang wrote:
> > > > > > The NVDIMM region could be available before the virtio_device_ready()
> > > > > > that is called by virtio_dev_probe(). This means the driver tries to
> > > > > > use device before DRIVER_OK which violates the spec, fixing this by
> > > > > > set device ready before the nvdimm_pmem_region_create().
> > > > >
> > > > > Can you clarify the failure path. What race is virtio_device_ready()
> > > > > losing?
> > > > >
> > > > > >
> > > > > > Note that this means the virtio_pmem_host_ack() could be triggered
> > > > > > before the creation of the nd region, this is safe since the
> > > > > > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > > > > > check if we've added any buffer before trying to proceed.
> > > > >
> > > > > I got a little bit lost with the usage of "we" here. Can you clarify
> > > > > which function / context is making which guarantee?
> > > > >
> > > > > >
> > > > > > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > ---
> > > > > >  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
> > > > > >  1 file changed, 12 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > > > > index 48f8327d0431..173f2f5adaea 100644
> > > > > > --- a/drivers/nvdimm/virtio_pmem.c
> > > > > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > > > > @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > > > >     ndr_desc.provider_data = vdev;
> > > > > >     set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > > > > >     set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > > > > +   /*
> > > > > > +    * The NVDIMM region could be available before the
> > > > > > +    * virtio_device_ready() that is called by
> > > > > > +    * virtio_dev_probe(), so we set device ready here.
> > > > > > +    *
> > > > > > +    * The callback - virtio_pmem_host_ack() is safe to be called
> > > > > > +    * before the nvdimm_pmem_region_create() since the pmem_lock
> > > > > > +    * has been initialized and legality of a used buffer is
> > > > > > +    * validated before moving forward.
> > > > >
> > > > > This comment feels like changelog material. Just document why
> > > > > virtio_device_ready() must be called before device_add() of the
> > > > > nd_region.
> > > >
> > > > Agree here. More specifically if you are documenting why is it
> > > > safe to invoke each callback then that belongs to the callback itself.
> > >
> > > Ok, so I will move it to the callback and leave a simple comment like
> > >
> > > " See comment in virtio_pmem_host_ack(), it is safe to be called
> > > before nvdimm_pmem_region_create()"
> > >
> > > Thanks
> >
> > No, just document why virtio_device_ready() must be called before device_add()
> >
> > I don't think the idea of working around these issues by adding code
> > to  virtio_device_ready worked so far,
>
> Any issue you found in this approach?
>
> > not at all sure this approach
> > is here to stay.
>
> Or do you have other ideas to fix this issue?

Or do you think we can do something similar to harden the config
interrupt (down the road with the kconfig option)?

virtio_device_ready(); // set driver ok but delay the vring interrupt
subsystem_register();
virtio_enable_vq_callback(); // enable vring interrupt and raised
delayed interrupt

Thanks

>
> Thanks
>
> >
> >
> > > >
> > > > > > +    */
> > > > > > +   virtio_device_ready(vdev);
> > > > > >     nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> > > > > >     if (!nd_region) {
> > > > > >             dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > > > > > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > > > >     }
> > > > > >     return 0;
> > > > > >  out_nd:
> > > > > > +   virtio_reset_device(vdev);
> > > > > >     nvdimm_bus_unregister(vpmem->nvdimm_bus);
> > > > > >  out_vq:
> > > > > >     vdev->config->del_vqs(vdev);
> > > > > > --
> > > > > > 2.25.1
> > > > > >
> > > >
> >

