Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54E464E
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655714186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9G1eqOQSKk+SOcd3YxKoPPj8ae2p1cPYNbr/lm2a8U=;
	b=dclaVmKG3MfAwIw2DjInQnXzD3fboe9KKT8f7C+qpiKnufMKgBT1lgOB5JhZCloiG5u2Xu
	UKZGh35eOjpC12AiXWsCai+SDIx7hX8d/JFNXcrVsVRPqSPD5VHC/eVBGy6Qu7bxqXKN0E
	RETrCH/3hkMvOpEgORziSYgq9Zqbchg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-1nicBAinOs26LBENrUsUag-1; Mon, 20 Jun 2022 04:36:25 -0400
X-MC-Unique: 1nicBAinOs26LBENrUsUag-1
Received: by mail-ed1-f72.google.com with SMTP id f9-20020a056402354900b0042ded146259so8203665edd.20
        for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 01:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C9G1eqOQSKk+SOcd3YxKoPPj8ae2p1cPYNbr/lm2a8U=;
        b=DB7SvbBaIgsyYPGFcvI3IYxhTfG09Um6qg74CTZ33thA5TZr/5ucKditAUEAfAXDnC
         Gqh9HCe5yXuzZyzEHiFVRDARVoW5hc3D8/offaEG52ddAs/r9YWFEY+RaLtuIo0AiyiI
         hjptwWjtJNsGrnfRy7PWfDbkd5lTL6Z/0+nsyLvN8KrJvjqg36lNn1WI0WOm+2xV5J5a
         6eX51a9kJqF8Zgt7PiG51RO8GuR4UEdVCb8xaoixUX0H4E4Qu1+Jq4be4mU42Ypts+3R
         hlDOxJbPRlUc7c1DxgMDcypsi/rcVK9RwzuSN32Nl+IQQEh4kcuU3EEsAerlGFR7JsP/
         dgdA==
X-Gm-Message-State: AJIora+WPtq3OqjllOfA2hSByXg+518FCl3cGifeklkyZRkWMukfr2fF
	Q4PgSxUg/LbGczFD/thx5Np+wdTpAwk/scnQ8xMl5rv8OQhwQ19HJV2kLRlZQcIyzd84Snn7hbv
	/5yW73azeGcWnypMX
X-Received: by 2002:a05:6402:5189:b0:42d:fe60:a03a with SMTP id q9-20020a056402518900b0042dfe60a03amr28668946edd.390.1655714183337;
        Mon, 20 Jun 2022 01:36:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tCP8RTj+VWrm4S9u5UcSZuucdzBsM3zd1Sh6Lwk3bQ2kIZnOaj5xawq9lPWt//LfmliXgnvg==
X-Received: by 2002:a05:6402:5189:b0:42d:fe60:a03a with SMTP id q9-20020a056402518900b0042dfe60a03amr28668934edd.390.1655714183146;
        Mon, 20 Jun 2022 01:36:23 -0700 (PDT)
Received: from redhat.com ([2.52.146.221])
        by smtp.gmail.com with ESMTPSA id q23-20020a170906b29700b00708e906faecsm5521568ejz.124.2022.06.20.01.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 01:36:22 -0700 (PDT)
Date: Mon, 20 Jun 2022 04:36:19 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 1/2] virtio_pmem: initialize provider_data through
 nd_region_desc
Message-ID: <20220620043221-mutt-send-email-mst@kernel.org>
References: <20220620081519.1494-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220620081519.1494-1-jasowang@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 20, 2022 at 04:15:18PM +0800, Jason Wang wrote:
> We used to initialize the provider_data manually after

we used to -> we currently

> nvdimm_pemm_region_create(). This seems to be racy if the flush is

the flush -> flush

> issued before the initialization of provider_data. Fixing this by

Fixing -> Fix

> initialize

initialize -> initializing

> the provider_data through nd_region_desc to make sure the
> provider_data is ready after the pmem is created.
> 
> Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 995b6cdc67ed..48f8327d0431 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -81,6 +81,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	ndr_desc.res = &res;
>  	ndr_desc.numa_node = nid;
>  	ndr_desc.flush = async_pmem_flush;
> +	ndr_desc.provider_data = vdev;
>  	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>  	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
>  	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> @@ -89,7 +90,6 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  		err = -ENXIO;
>  		goto out_nd;
>  	}
> -	nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
>  	return 0;
>  out_nd:
>  	nvdimm_bus_unregister(vpmem->nvdimm_bus);
> -- 
> 2.25.1

