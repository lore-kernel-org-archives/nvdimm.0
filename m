Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DC5627
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655713927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5NoU03u/pPxWjmX7I9pnu2/hF+FS1Cv40mQJJ5j7jTc=;
	b=Gg4Sv/tjpgR+h+MuZWi8/bGpvwdy6S1S0JkhEbKbArybnR3p946443+06tIBcfowl+mVqA
	4eXRUVkMPGhQFaV3pTi2RB3r3x0YlcHgNQr8AHvliNHiI1oG+glAky8qxDhCPhNmBhDkc0
	u4W9TuZ6xBRIRTgYcH4823bjCRZCLUQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-h8NDZa5_NLicAcr7U6VxFA-1; Mon, 20 Jun 2022 04:32:06 -0400
X-MC-Unique: h8NDZa5_NLicAcr7U6VxFA-1
Received: by mail-wm1-f71.google.com with SMTP id c187-20020a1c35c4000000b003970013833aso3116626wma.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 01:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5NoU03u/pPxWjmX7I9pnu2/hF+FS1Cv40mQJJ5j7jTc=;
        b=MFH+xsOF+tHB+Qg3sV4IIBaX9bWpS5WihIMpIu9MQ07+Zs1MZnr1b2EHsfDvxSjXLR
         N7QkJhacwrOqLPdwNDetSRqsgwnx/Hnr4XT/j4XiFEi7bQuZXrctkK6IlIhzSInsbBkK
         dQgYVxV2x+0Ilpr7Z9BDTNyN6M0ABap9S6r3wTny1EMplFqjR/6mPTVammajFVjkve7g
         1dJJSQCHHkBkGNlqx1UNwhiM22mtgZ1rAe6Dl862wMSUk28ctnY565KAQE363ZZher+E
         bq2boR4Tt2YJkd7MNHvwPEKRhnPndzpVwBcfctSPoR7u5YPfwdsiPRvoVxU3A1lmhWBb
         Fc4Q==
X-Gm-Message-State: AJIora9i3G4Ap27f4kwyAsVvzax6Uqqmv4sMd6R8roA3XwrkCsTsFwrs
	bV88a77K95aMeFUCuzTbk+Azz15EnAd+Pj5jnxew5Fw9I8Lkrorw4g5mz52VkYH9ui/n/5+GGBT
	344pn8BOaKcEY3i4F
X-Received: by 2002:a5d:47a8:0:b0:217:b5ea:bdfb with SMTP id 8-20020a5d47a8000000b00217b5eabdfbmr22600977wrb.492.1655713924796;
        Mon, 20 Jun 2022 01:32:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uFq2ufxViZYrxO8TOLAaPJ2J4wU75ffDbcROq3md49YwgzuFNH09QZRKYAFqLwybHc0UA4RQ==
X-Received: by 2002:a5d:47a8:0:b0:217:b5ea:bdfb with SMTP id 8-20020a5d47a8000000b00217b5eabdfbmr22600956wrb.492.1655713924582;
        Mon, 20 Jun 2022 01:32:04 -0700 (PDT)
Received: from redhat.com ([2.52.146.221])
        by smtp.gmail.com with ESMTPSA id y12-20020adff6cc000000b0021126891b05sm12239212wrp.61.2022.06.20.01.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 01:32:04 -0700 (PDT)
Date: Mon, 20 Jun 2022 04:32:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
Message-ID: <20220620042610-mutt-send-email-mst@kernel.org>
References: <20220620081519.1494-1-jasowang@redhat.com>
 <20220620081519.1494-2-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220620081519.1494-2-jasowang@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I think you should CC the maintainer, Pankaj Gupta.

On Mon, Jun 20, 2022 at 04:15:19PM +0800, Jason Wang wrote:
> The NVDIMM region could be available before the virtio_device_ready()
> that is called by virtio_dev_probe(). This means the driver tries to
> use device before DRIVER_OK which violates the spec, fixing this by
> set device ready before the nvdimm_pmem_region_create().
> 
> Note that this means the virtio_pmem_host_ack() could be triggered
> before the creation of the nd region, this is safe since the
> virtio_pmem_host_ack() since pmem_lock has been initialized and we
> check if we've added any buffer before trying to proceed.
> 
> Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 48f8327d0431..173f2f5adaea 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	ndr_desc.provider_data = vdev;
>  	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>  	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> +	/*
> +	 * The NVDIMM region could be available before the
> +	 * virtio_device_ready() that is called by
> +	 * virtio_dev_probe(), so we set device ready here.
> +	 *

virtio_dev_probe is not to blame here, right?
I don't like copying its logic here as we won't remember to fix
it if we change virtio_dev_probe to e.g. not call virtio_device_ready.

is it nvdimm_pmem_region_create what makes it possible for
the region to become available?
Then "The NVDIMM region could become available immediately
after the call to nvdimm_pmem_region_create.
Tell device we are ready to handle this case."

> +	 * The callback - virtio_pmem_host_ack() is safe to be called
> +	 * before the nvdimm_pmem_region_create() since the pmem_lock
> +	 * has been initialized and legality of a used buffer is
> +	 * validated before moving forward.
> +	 */
> +	virtio_device_ready(vdev);
>  	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
>  	if (!nd_region) {
>  		dev_err(&vdev->dev, "failed to create nvdimm region\n");
> @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	}
>  	return 0;
>  out_nd:
> +	virtio_reset_device(vdev);


Does this fix cleanup too?

>  	nvdimm_bus_unregister(vpmem->nvdimm_bus);
>  out_vq:
>  	vdev->config->del_vqs(vdev);
> -- 
> 2.25.1

