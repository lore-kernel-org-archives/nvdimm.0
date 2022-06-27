Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9792100
	for <nvdimm@lists.linux.dev>; Mon, 27 Jun 2022 08:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656318862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ba0dlHiyiiqZYNyYZRp/YOPV+CIztWSeAQmxbjkqJ6o=;
	b=N4q6a/VZOD97MaxQZGLXK4/3tYDvC3nKuFNo1idqViny7VI/V0lpKSBHM8eAiqR3x7BRIW
	jaPEqKMWFdOwwfTLyC2+r+qx72Bqudv3NCvmOnOWNtjE159zAWo6PtVzny/+q/XYQylSwX
	So7w43/D6hmKReKFuyIEO2bxxqnnSKg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-zUOURgA3NSO1BG0LTQHlIg-1; Mon, 27 Jun 2022 04:34:20 -0400
X-MC-Unique: zUOURgA3NSO1BG0LTQHlIg-1
Received: by mail-lf1-f72.google.com with SMTP id q22-20020a0565123a9600b0047f6b8e1babso4405086lfu.21
        for <nvdimm@lists.linux.dev>; Mon, 27 Jun 2022 01:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ba0dlHiyiiqZYNyYZRp/YOPV+CIztWSeAQmxbjkqJ6o=;
        b=OI/MsSn6wkLsxsD4WXf7SGuuyWrofKxmZtmEezHXx7ZVyUgW3PHwkOvnfJW7mVJfE0
         aLqT3XSgeOQNLUK1JaNf2I63QRmdieGP906XJZ4E8v+u1zVBTjWJmUjZSUEbGndl199c
         7HBOvw1xRIk84uFMDEswdOlOV4rVPHfZE95LiHEXhxrwQ5PZSXr64gS/wczLxoZMS8+s
         1R57fCTN5FsNrLJN0CDXe9PluFno82IlM9aiJI/IOme1JOICPchcIvOd7lWVdouG//9+
         wPM6AsvODx/CfPeJrNuPMPejAUqZZqLaDSkfHeCar9ubONqvuRIRQwDRFH3cq0I46oPn
         T61A==
X-Gm-Message-State: AJIora/ArEqUFXAthNJv8iZ3R6Jnoe3XOEzQnRm5DwYYsTbZe4ImqVsL
	FqiaMK4N52z5sTyEVMnjXI/BHSdqytrPJzr5vmozMd1ciYhzHXisXABjuK0D1gUjMnbAm2uFOQM
	cf5ji6W3hnlOVgM9dsBubErQ/PFVF4nEt
X-Received: by 2002:a05:6512:22c3:b0:47f:704b:3820 with SMTP id g3-20020a05651222c300b0047f704b3820mr7488519lfu.411.1656318858586;
        Mon, 27 Jun 2022 01:34:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uVASIFfeGulBKy+F9VDJcwQSZfcmHSg7/Mi80UUit2TT3P9+6R9xwL2uDQCfUmFoJnb8yemPftTjokkvUOW7U=
X-Received: by 2002:a05:6512:22c3:b0:47f:704b:3820 with SMTP id
 g3-20020a05651222c300b0047f704b3820mr7488501lfu.411.1656318858379; Mon, 27
 Jun 2022 01:34:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220627062941.52057-1-jasowang@redhat.com> <20220627062941.52057-2-jasowang@redhat.com>
 <20220627035854-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220627035854-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 27 Jun 2022 16:34:07 +0800
Message-ID: <CACGkMEvvCR_rH6PYToG8+a4YuL=yd1DQNSfY8WFYATsnsOnE8w@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] virtio_pmem: set device ready in probe()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	"Jiang, Dave" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-kernel <linux-kernel@vger.kernel.org>, 
	pankaj.gupta@amd.com
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 27, 2022 at 4:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jun 27, 2022 at 02:29:41PM +0800, Jason Wang wrote:
> > The NVDIMM region could be available before the virtio_device_ready()
> > that is called by virtio_dev_probe(). This means the driver tries to
> > use device before DRIVER_OK which violates the spec, fixing this by
>
> s/fixing this by/to fix this/
>
> > set device ready before the nvdimm_pmem_region_create().
> >
> > Note that this means the virtio_pmem_host_ack() could be triggered
> > before the creation of the nd region, this is safe since the
> > virtio_pmem_host_ack() since pmem_lock has been initialized and
>
> can't parse this sentence, since repeated twice confuses me

Should be a copy-paste error: how about:

Note that this means the virtio_pmem_host_ack() could be triggered
before the creation of the nd region, this is safe since the pmem_lock
has been initialized and whether or not any available buffer is added
before is validated by virtio_pmem_host_ack().

Thanks

>
> > whether or not any available buffer is added before is validated.
> >
> > Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > Changes since v1:
> > - Remove some comments per Dan
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index 48f8327d0431..20da455d2ef6 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -84,6 +84,12 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >       ndr_desc.provider_data = vdev;
> >       set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> >       set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > +     /*
> > +      * The NVDIMM region could be available before the
> > +      * virtio_device_ready() that is called by
> > +      * virtio_dev_probe(), so we set device ready here.
> > +      */
> > +     virtio_device_ready(vdev);
> >       nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> >       if (!nd_region) {
> >               dev_err(&vdev->dev, "failed to create nvdimm region\n");
> > @@ -92,6 +98,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >       }
> >       return 0;
> >  out_nd:
> > +     virtio_reset_device(vdev);
> >       nvdimm_bus_unregister(vpmem->nvdimm_bus);
> >  out_vq:
> >       vdev->config->del_vqs(vdev);
> > --
> > 2.25.1
>

