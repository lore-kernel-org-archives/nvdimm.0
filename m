Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDDD10FF
	for <nvdimm@lists.linux.dev>; Wed, 22 Jun 2022 06:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655879377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LXb1x+FNHu9H/p6ncf6szB5us9GPESnMD9aaySnHiLM=;
	b=XFgFO+x2tYySbfN19jlENemrqp6JpIwLkatEZxsXwNRAvNZmDKSzPyco/8iXSqABeM4+GF
	IPnknK+BrAUnt4W+zdzDxplWjQDxqsxkjquJ54PbeuCaKyx/9EhDjoGhAlSG1AHe6vxJrQ
	Q70hJzBs2oRU0gzu5aCec96/WFAOeZM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-tTXPF4gjNUqcp01THY5riw-1; Wed, 22 Jun 2022 02:29:36 -0400
X-MC-Unique: tTXPF4gjNUqcp01THY5riw-1
Received: by mail-wm1-f70.google.com with SMTP id i5-20020a1c3b05000000b003a02b027e53so8820wma.7
        for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 23:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXb1x+FNHu9H/p6ncf6szB5us9GPESnMD9aaySnHiLM=;
        b=JmGit1MXiB3TQU+gn0u6NC7UZBxN+bFN1LTGtP+QTzGeCzPuC6KOr1UbiCIrraq24e
         ur8PH3LRLpCiZiPNcXW5inIjgWF5ibGRWuPlrr4LmvX5H3jVs963DWF+0/YR9yo/HeDj
         QPRuTR/ALw/GyTk/W9DjJUzs/jlFF/0NY1YmpfmyM9IG3V+d0Y72e58pdTXeRk4w5iU5
         NC/zfJXe+sYEMvtTUgEJKOZmPgbco3iV6VtgNzHK3yK33Nes0ZXkD89eZx8WGXJzpUeb
         w78lANANtu2cukdN8HW5gHcyXUhRMV6QbXylZMpwE8jmnHg1BKozZ3Dlc5yF7jkKLlXr
         /agQ==
X-Gm-Message-State: AJIora+2UXDfS9IOEe+e2vUH5UxOcX8u01jVuJEp2LYxPh7CEVz1B6tS
	v7CcIhCXlprXetkHYieTDnQT4bH8JaHqe1m8/jD8DA1p2ACm+LMr9YnGhRql6WwhRAsI/l5Dl2V
	iFvHsIPgOmYois0aT
X-Received: by 2002:a05:6000:a12:b0:21b:93b9:134f with SMTP id co18-20020a0560000a1200b0021b93b9134fmr1562144wrb.310.1655879375375;
        Tue, 21 Jun 2022 23:29:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sGgYJAQPlZb9gjb2aP74yMQrcxcsMiNv4NwobfIzC+JznxjODyBhLYYEDdD35ru8yghkqpVQ==
X-Received: by 2002:a05:6000:a12:b0:21b:93b9:134f with SMTP id co18-20020a0560000a1200b0021b93b9134fmr1562122wrb.310.1655879375065;
        Tue, 21 Jun 2022 23:29:35 -0700 (PDT)
Received: from redhat.com ([147.235.217.93])
        by smtp.gmail.com with ESMTPSA id l1-20020a1c2501000000b0039747cf8354sm19791750wml.39.2022.06.21.23.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 23:29:34 -0700 (PDT)
Date: Wed, 22 Jun 2022 02:29:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Wang <jasowang@redhat.com>, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
Message-ID: <20220622022324-mutt-send-email-mst@kernel.org>
References: <20220620081519.1494-1-jasowang@redhat.com>
 <20220620081519.1494-2-jasowang@redhat.com>
 <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 21, 2022 at 03:38:35PM -0700, Dan Williams wrote:
> Jason Wang wrote:
> > The NVDIMM region could be available before the virtio_device_ready()
> > that is called by virtio_dev_probe(). This means the driver tries to
> > use device before DRIVER_OK which violates the spec, fixing this by
> > set device ready before the nvdimm_pmem_region_create().
> 
> Can you clarify the failure path. What race is virtio_device_ready()
> losing?
> 
> > 
> > Note that this means the virtio_pmem_host_ack() could be triggered
> > before the creation of the nd region, this is safe since the
> > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > check if we've added any buffer before trying to proceed.
> 
> I got a little bit lost with the usage of "we" here. Can you clarify
> which function / context is making which guarantee?
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
> >  	ndr_desc.provider_data = vdev;
> >  	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> >  	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > +	/*
> > +	 * The NVDIMM region could be available before the
> > +	 * virtio_device_ready() that is called by
> > +	 * virtio_dev_probe(), so we set device ready here.
> > +	 *
> > +	 * The callback - virtio_pmem_host_ack() is safe to be called
> > +	 * before the nvdimm_pmem_region_create() since the pmem_lock
> > +	 * has been initialized and legality of a used buffer is
> > +	 * validated before moving forward.
> 
> This comment feels like changelog material. Just document why
> virtio_device_ready() must be called before device_add() of the
> nd_region.

Agree here. More specifically if you are documenting why is it
safe to invoke each callback then that belongs to the callback itself.

> > +	 */
> > +	virtio_device_ready(vdev);
> >  	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> >  	if (!nd_region) {
> >  		dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >  	}
> >  	return 0;
> >  out_nd:
> > +	virtio_reset_device(vdev);
> >  	nvdimm_bus_unregister(vpmem->nvdimm_bus);
> >  out_vq:
> >  	vdev->config->del_vqs(vdev);
> > -- 
> > 2.25.1
> > 

