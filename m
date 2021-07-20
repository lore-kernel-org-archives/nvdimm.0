Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0300D173
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 09:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626774400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BIVnW/uDAdcXmCFrobY6tL1B1XK1MolYys5+3oUZpiw=;
	b=CU8I827Qqlg6mEH2yzR29gf1v3tbh99cs2ucu1GiqRxo+DX492cfAvZPhGN7eQiuCDiWS0
	geiDgMQ6dTF9dYQYJAJO8NO1QnuUpBhiFf+fJqhNxNaJeCm0YbOPMY4smpRIPlgExuXxC7
	bufe1y14nG5VyRGMFlRcl5mVYZqkXVM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-m4s4ADXROEuc8Fl7PnYfEA-1; Tue, 20 Jul 2021 05:46:38 -0400
X-MC-Unique: m4s4ADXROEuc8Fl7PnYfEA-1
Received: by mail-ed1-f69.google.com with SMTP id c21-20020aa7d6150000b02903ab03a06e86so10595877edr.14
        for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 02:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BIVnW/uDAdcXmCFrobY6tL1B1XK1MolYys5+3oUZpiw=;
        b=JyldFew8bQzat9pRBxCS4fMutJj/KGMB7Vqk7MN2Qq77xnMcvy1rEqsZFX5jhP7V1Y
         n2laDjvGDBNH5baqb7s/SRX4++9M1JyyELuwZj9ljOxDHgD8TS7mFn4elEXAh/6X13Ji
         hzj2umEcSr2W0icP3Xh/D2H3/tiyQu5SWQngrzw9xAYvQLWCzJNqBMqr/bDwImPenF+z
         nWMRBIBsZlUMMUYM+31oXoq3CNCvRDfyRgDbUn/i+UUnRu8l2OV9GJZDgsxvv83XH4c3
         FTQ29v7gg+ELEvizHxS1zRpAfJCc8vLQ500QLR0yTt7H9+/5184yZvjEbc/ePIb+oC7H
         suOQ==
X-Gm-Message-State: AOAM530WaqohSZBCWVyc3XeI0+1ZMgdT4gxSZ10XH1EjuqLKqKFF0SKB
	Xs4dKxF4FA9YG7HtKlqxSnolpEbhmD/zmh/pYApGouf2k3UUJjTCtNggLkluXXt8ZMspq8NH5AO
	sMFHdepIkn0475Xt5
X-Received: by 2002:a17:906:1c43:: with SMTP id l3mr31953795ejg.291.1626774397225;
        Tue, 20 Jul 2021 02:46:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/oGe8FCLJwjYcyRJYXF4Yoj8vZq5Hn/0cipxgWua57BmpFUZn03/PMpdIJjhfp5X1lvpkiA==
X-Received: by 2002:a17:906:1c43:: with SMTP id l3mr31953777ejg.291.1626774397034;
        Tue, 20 Jul 2021 02:46:37 -0700 (PDT)
Received: from redhat.com ([2.55.139.106])
        by smtp.gmail.com with ESMTPSA id nc29sm6822929ejc.10.2021.07.20.02.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 02:46:36 -0700 (PDT)
Date: Tue, 20 Jul 2021 05:46:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	apais@microsoft.com, tyhicks@microsoft.com, jamorris@microsoft.com,
	benhill@microsoft.com, sunilmut@microsoft.com,
	grahamwo@microsoft.com, tstark@microsoft.com
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210720054518-mutt-send-email-mst@kernel.org>
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20210719171533-mutt-send-email-mst@kernel.org>
 <20210720064103.GC8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210720064103.GC8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 19, 2021 at 11:41:03PM -0700, Taylor Stark wrote:
> On Mon, Jul 19, 2021 at 05:17:00PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Jul 15, 2021 at 03:35:05PM -0700, Taylor Stark wrote:
> > > Update virtio-pmem to allow for the pmem region to be specified in either
> > > guest absolute terms or as a PCI BAR-relative address. This is required
> > > to support virtio-pmem in Hyper-V, since Hyper-V only allows PCI devices
> > > to operate on PCI memory ranges defined via BARs.
> > > 
> > > Virtio-pmem will check for a shared memory window and use that if found,
> > > else it will fallback to using the guest absolute addresses in
> > > virtio_pmem_config. This was chosen over defining a new feature bit,
> > > since it's similar to how virtio-fs is configured.
> > > 
> > > Signed-off-by: Taylor Stark <tstark@microsoft.com>
> > 
> > This needs to be added to the device spec too.
> > Can you send a spec patch please?
> > It's a subscriber-only list virtio-comment@lists.oasis-open.org
> 
> Absolutely! I tried looking on the virtio-spec repo on github but
> I couldn't find a spec for virtio-pmem to update. There is this
> issue (https://github.com/oasis-tcs/virtio-spec/issues/78) which
> seems to indicate the virtio-pmem spec hasn't been added yet.
> Any suggestions for where to send a patch?
> 
> Thanks,
> Taylor 

Just apply that patch (whichever you think is right)
and do yours on top and indicate this in the email.
Send it to virtio-comments.

> > > ---
> > >  drivers/nvdimm/virtio_pmem.c | 21 +++++++++++++++++----
> > >  drivers/nvdimm/virtio_pmem.h |  3 +++
> > >  2 files changed, 20 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > index 726c7354d465..43c1d835a449 100644
> > > --- a/drivers/nvdimm/virtio_pmem.c
> > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > @@ -37,6 +37,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > >  	struct virtio_pmem *vpmem;
> > >  	struct resource res;
> > >  	int err = 0;
> > > +	bool have_shm_region;
> > > +	struct virtio_shm_region pmem_region;
> > >  
> > >  	if (!vdev->config->get) {
> > >  		dev_err(&vdev->dev, "%s failure: config access disabled\n",
> > > @@ -58,10 +60,21 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > >  		goto out_err;
> > >  	}
> > >  
> > > -	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > -			start, &vpmem->start);
> > > -	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > -			size, &vpmem->size);
> > > +	/* Retrieve the pmem device's address and size. It may have been supplied
> > > +	 * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> > > +	 */
> > > +	have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> > > +						VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> > > +
> > > +	if (have_shm_region) {
> > > +		vpmem->start = pmem_region.addr;
> > > +		vpmem->size = pmem_region.len;
> > > +	} else {
> > > +		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > +				start, &vpmem->start);
> > > +		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > +				size, &vpmem->size);
> > > +	}
> > >  
> > >  	res.start = vpmem->start;
> > >  	res.end   = vpmem->start + vpmem->size - 1;
> > > diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> > > index 0dddefe594c4..62bb564e81cb 100644
> > > --- a/drivers/nvdimm/virtio_pmem.h
> > > +++ b/drivers/nvdimm/virtio_pmem.h
> > > @@ -50,6 +50,9 @@ struct virtio_pmem {
> > >  	__u64 size;
> > >  };
> > >  
> > > +/* For the id field in virtio_pci_shm_cap */
> > > +#define VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION 0
> > > +
> > >  void virtio_pmem_host_ack(struct virtqueue *vq);
> > >  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
> > >  #endif
> > > -- 
> > > 2.32.0

