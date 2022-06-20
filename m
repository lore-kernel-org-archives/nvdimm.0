Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6127E7E6
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 08:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655714213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sSgfaujnD/2Dyu86VOOwiKh4ejtd9qtm+hMXE529rjU=;
	b=JsSVg03eJZCO5cldMxpEA+KosWGCtNk+lsDKKpTvBf1Z6maTMeL4Hg5Ipu3/zZCAPhuzh1
	OggZp86iUxewa8rzUvTOxIfdIv2dPC0gFIkjDoaAt23Og6e1Heckxa6USUaTetXbLLD4N4
	8cMSj0skM67qg1MrN1iWzZXnczNznpw=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-OqRmNjgCN8uJMNop1juyxg-1; Mon, 20 Jun 2022 04:36:52 -0400
X-MC-Unique: OqRmNjgCN8uJMNop1juyxg-1
Received: by mail-lj1-f198.google.com with SMTP id h23-20020a2e3a17000000b00255788e9a7fso1166880lja.10
        for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 01:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sSgfaujnD/2Dyu86VOOwiKh4ejtd9qtm+hMXE529rjU=;
        b=mPVvZVyTJranDJk7e6ddrOmwfhS1LBG6X0uFujbfxHeThtNTSUHhy513dtOzuoVTBK
         hzKWSbsSLLVSqbpsGWGyzdQlZIpNkDNyS3PuSreP8i33i8UJ275wj2ZbKEeQpqh1TONY
         rI4FC1WHLjOVpmeqzz6qFY/33tDzhJecU+fZx3R1YhnEqKmKg6QK4AnQbFRjcAztEWnV
         uwrc0cbcmW+wmPkO5iVNmrUwvn2Xw4Vs/dfAZJ6DkJic93FcHK5ON7quA7B+kuANukfp
         oS/GJva+IRijdxJbY6+Ga8NKBE4GZlV8JnmkO5GXc5EXa5rviAE9uIiEVESGKHgkfm9R
         CAYw==
X-Gm-Message-State: AJIora93eZ3zdcrs4h1Gwh/FevtPNQH7rqfwtZds1PBw9GC7MujPPkrX
	IjomAmImvmK89MhF1TL4QsoWv8KKp515n2eZtUiF/ATd8gCTABeGfTrx210srWzIKevKEXA7j+t
	udgqk1J8QE5aUiLuyASPlJH04WLpqIr1r
X-Received: by 2002:a05:6512:3130:b0:479:385f:e2ac with SMTP id p16-20020a056512313000b00479385fe2acmr12831860lfd.575.1655714210122;
        Mon, 20 Jun 2022 01:36:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t1Pp+/sgFgVD1xsb/DGXyTUHOhmhgFuV/qS35hRuGqepAXqYqLjNifXAGYUYKMcgwQaLtfVrFrCZfzTQTsbZI=
X-Received: by 2002:a05:6512:3130:b0:479:385f:e2ac with SMTP id
 p16-20020a056512313000b00479385fe2acmr12831841lfd.575.1655714209936; Mon, 20
 Jun 2022 01:36:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com>
In-Reply-To: <20220620081519.1494-1-jasowang@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 20 Jun 2022 16:36:38 +0800
Message-ID: <CACGkMEsXgQGCK860_But1UJz0TzSCJeBrpZz7OPU77mc4hrcdg@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio_pmem: initialize provider_data through nd_region_desc
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com, 
	"Jiang, Dave" <dave.jiang@intel.com>, ira.weiny@intel.com, nvdimm@lists.linux.dev, 
	mst <mst@redhat.com>, jasowang <jasowang@redhat.com>, pankaj.gupta.linux@gmail.com
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Adding Pankaj.

On Mon, Jun 20, 2022 at 4:15 PM Jason Wang <jasowang@redhat.com> wrote:
>
> We used to initialize the provider_data manually after
> nvdimm_pemm_region_create(). This seems to be racy if the flush is
> issued before the initialization of provider_data. Fixing this by
> initialize the provider_data through nd_region_desc to make sure the
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
>         ndr_desc.res = &res;
>         ndr_desc.numa_node = nid;
>         ndr_desc.flush = async_pmem_flush;
> +       ndr_desc.provider_data = vdev;
>         set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>         set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
>         nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
> @@ -89,7 +90,6 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>                 err = -ENXIO;
>                 goto out_nd;
>         }
> -       nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
>         return 0;
>  out_nd:
>         nvdimm_bus_unregister(vpmem->nvdimm_bus);
> --
> 2.25.1
>

