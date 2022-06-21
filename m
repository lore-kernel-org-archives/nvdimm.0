Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A22ECF
	for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 12:44:35 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id t1so24257890ybd.2
        for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 05:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcIQibPfexODTHih8QSBH6gDtQvcAaxGd51zVH9OcUo=;
        b=KgSU952XDEzYOgGzLJuRcB2jL57X8I9BhfUVIO5VhrPs9F75iPJ7081mHZyPyZTOlF
         YnO88leCcq+sFBe3qZVWIlsqa+Etfoeq4eGEF0IUdgFErJv1av+XWKYt+icmX0J51Zt3
         NV6E8ERmb4n9vAfRhCeq5TrouUnvqzTpIVfmqs3j62FQ51j4geXj6xV4BCQWKjJJ3FbZ
         N693JSeYB/+nBkgq5qgV9saSK7F9C77VudfiC2uwd4T+Sj4Fs2IIAKksx1c01CLUqYHn
         57dlqvul3iVJKHktA0iPGLIYM3C4MbrNoU6YEk5FW24Y6eNHHElc3/iMDd4Vwx9/gomg
         NPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcIQibPfexODTHih8QSBH6gDtQvcAaxGd51zVH9OcUo=;
        b=PH4abELUwujqE0QExOlfaG3bAgEANSIl5N14dtRkNJ5k2/7TKZ1zrA3TlGSdxyoKiI
         pHYv7jQq+JXRsKAbUhI8xbg/uKi3mq4qPXwl9duDNfMy65bI300B0kdIlL2rmueWOSjy
         xzi11uMCgS6s2eSIiCHGyRSMhsUXPiBVNFy64LeT8eQnrr6q0d3bKW7bd9DEzE4m1pO3
         RFFSEYs1bW50NCY/OYU9Rk9h0Ohv/a8+1zULIC9CGMIQJKNrBQ9E/45ps2GzkSZqWZnE
         htbin7Oq7qeQdBZbEQ83MLYbu3vvzKWcSbhEk2BScotU5qM1jvRk0FeM4Xcn3wT1Ywbn
         wqzA==
X-Gm-Message-State: AJIora87nq+Sp71MJ63hZ0N52vP9jA6FgseV7rltUgUJd9jr11s7iNtj
	DqSDxH9VZpEdWsC6S95Oyq62RsyXBaAx2gjQlO87mPOe5Z8=
X-Google-Smtp-Source: AGRyM1tgrimmx1Lggm9Wy3BONj8iOo1DKd7piTYkFyTObxSmpVhb3yMpQ/NLTHF4iAVKCmHfNFh9shM9b7Q5/dZlfCM=
X-Received: by 2002:a05:6902:2ce:b0:64b:9bbd:34fa with SMTP id
 w14-20020a05690202ce00b0064b9bbd34famr30498366ybh.440.1655815474227; Tue, 21
 Jun 2022 05:44:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com>
In-Reply-To: <20220620081519.1494-1-jasowang@redhat.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 21 Jun 2022 14:44:23 +0200
Message-ID: <CAM9Jb+gKU3b0XSiXj-ePtynH49HNp+SZjEnRzhjHjhw=+uBB9Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio_pmem: initialize provider_data through nd_region_desc
To: Jason Wang <jasowang@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

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

Thank you for adding me.

The patch seems correct to me. Will test this as well.

Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>



Thanks,
Pankaj
