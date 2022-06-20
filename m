Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A457E6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655714381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RhD4xiFj8bqzRXaPqVNGIOgRLdEEneV01g32UMgwe4g=;
	b=bHpZNXWAaW/zgt/yMBiKyoq2SLT5mcR0GllcKltRjB5aEfAFWx3rJ2UgzqfSBBuBe0f9wO
	5WEgSkRsML8CIL1Jq99yIwIo/ODP91eFj2mxriHH6MbiNFWYf7hhOgWpujuAHPx9ASgmuf
	R9WLCiMu6YdzIY/sjtQ8qYTaHSEPNPc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-7X66NLp3PE-n-HgIgO_tRA-1; Mon, 20 Jun 2022 04:39:40 -0400
X-MC-Unique: 7X66NLp3PE-n-HgIgO_tRA-1
Received: by mail-lf1-f70.google.com with SMTP id h35-20020a0565123ca300b00479113319f9so5223046lfv.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 01:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RhD4xiFj8bqzRXaPqVNGIOgRLdEEneV01g32UMgwe4g=;
        b=prcXag2Ddl1woqqCMMD5Md2qU9RKQ9ncJdE4jCOqWzgAAqI0Y56BUxlDAYiDHa2qTb
         ckAij9EoxIKZXBv0BpM3eouH/+EUTuiVbhfN+hFw3gq+ZxcdiAPVHCORMR4KAJtF8K3I
         no/EEOd1q+4PwJSiPa5Drnu5bvEK5jBLGIg9d29K5rXd4ldJiqtyyOAvQumSLg2XHEVF
         +CGENYldf9Ybo3oXqlcXqtlwMDEzD7HAJsCY7YET2jZrEHk/hYEEiExb52s3wxi2RawE
         nAHafAeFtMXdkNt9BjSLGKnaVyW4NP7p5rNcL6KvTWRPK14Ye6ioSH2BcINf3ZJzYDTT
         iSAw==
X-Gm-Message-State: AJIora9eIMe5ZeAq3bSw6ylsuYzS006iMsBh9GS8/a99G1GYLTteiD67
	0XkgivrLZ54Had3kz662JN8h646aicVjAP+pXuACMBEDa9BmKY3Phml/kMf/szUI0XQvaIqm4Y+
	Gns6hrSEioeJvZPes2nEOZATQkgH4/67N
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id bp13-20020a056512158d00b0047f718c28b5mr1646206lfb.397.1655714378906;
        Mon, 20 Jun 2022 01:39:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sdDbxKPGn/fa9bpxxRUJOBIrdoSYk3dTvLY0iUY824lCAWtE2IKZ7kUTkksYd9748eRvBo7fjeC7ZrJU1xhrM=
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id
 bp13-20020a056512158d00b0047f718c28b5mr1646194lfb.397.1655714378717; Mon, 20
 Jun 2022 01:39:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <20220620081519.1494-2-jasowang@redhat.com>
 <20220620042610-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220620042610-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 20 Jun 2022 16:39:27 +0800
Message-ID: <CACGkMEvn5WYBKwGoJMaHLxABcQjerdOCKqJFFef1rYCBTqQ53w@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
To: "Michael S. Tsirkin" <mst@redhat.com>, pankaj.gupta.linux@gmail.com
Cc: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com, 
	"Jiang, Dave" <dave.jiang@intel.com>, ira.weiny@intel.com, nvdimm@lists.linux.dev
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 20, 2022 at 4:32 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> I think you should CC the maintainer, Pankaj Gupta.

Yes, I miss him accidentally.

>
> On Mon, Jun 20, 2022 at 04:15:19PM +0800, Jason Wang wrote:
> > The NVDIMM region could be available before the virtio_device_ready()
> > that is called by virtio_dev_probe(). This means the driver tries to
> > use device before DRIVER_OK which violates the spec, fixing this by
> > set device ready before the nvdimm_pmem_region_create().
> >
> > Note that this means the virtio_pmem_host_ack() could be triggered
> > before the creation of the nd region, this is safe since the
> > virtio_pmem_host_ack() since pmem_lock has been initialized and we
> > check if we've added any buffer before trying to proceed.
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
>
> virtio_dev_probe is not to blame here, right?

Yes and actually it's not to blame, it just describes what can happen now.

> I don't like copying its logic here as we won't remember to fix
> it if we change virtio_dev_probe to e.g. not call virtio_device_ready.
>
> is it nvdimm_pmem_region_create what makes it possible for
> the region to become available?

I think so.

> Then "The NVDIMM region could become available immediately
> after the call to nvdimm_pmem_region_create.
> Tell device we are ready to handle this case."

That's fine.

>
> > +      * The callback - virtio_pmem_host_ack() is safe to be called
> > +      * before the nvdimm_pmem_region_create() since the pmem_lock
> > +      * has been initialized and legality of a used buffer is
> > +      * validated before moving forward.
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
>
>
> Does this fix cleanup too?

Not sure I get this, we make the device ready before
nvdimm_pmem_region_create(), so we need to reset if
nvdimm_pmem_region_create() fails?

Thanks

>
> >       nvdimm_bus_unregister(vpmem->nvdimm_bus);
> >  out_vq:
> >       vdev->config->del_vqs(vdev);
> > --
> > 2.25.1
>

