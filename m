Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E950CA2D
	for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 12:34:16 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id i7so6543316ybe.11
        for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 05:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z32Z2/oXcfK7gDhGzfrQvxGDPEH+xTcEf++T8i1DLI8=;
        b=hqDAiplueObLbFgItubNMIMW13GFdNvQCGo5oWCOGSNWvTLLVKu9KnJDCF7h1SFnpU
         lVGKTgK88k6txzOJsRk4Ir8pUoGqzXxnlHGgqPQisIgsSF/v38AWrk3L0XlBJhs60Gni
         Xp029Bx6v0aItTzlm2obQfTcIwMDLEoZXiTUDxWQlKS/A6N0844wdNxR602l3pwFJAB/
         CUUh0O5twwjAJXoTnTNyIbjYSmzBT0gklxc9qBmq+Avok4+n7F/M0zz5X4iNIZAQhiqi
         c4rAsAGoe0zLGhyr2blay4o+QG12xaKiAWUuoeJt8/1PzMFX7zepxo7Y0FsnxzHlVwFS
         rOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z32Z2/oXcfK7gDhGzfrQvxGDPEH+xTcEf++T8i1DLI8=;
        b=o1zaaG/2k58274clJ1o+/iMagPGlIkLmUhrorlNK5nxeWWpglrsfOv9JRRF81vx0+X
         LbNqFA1coFI8LGEOj9w/IXXY0vlkd6jJ59Q9HvRycAd/oNU7j7sgcUqwj3jRLuwpFA44
         1uTlz47jYzdrq27m59h9OBJdRBKRw4VweSHJvsNqoai8uVEjhveLVVQgVlUYAkwRm6os
         DzVNgIDRDHB5FEKa+c5JYvUqgarMcDYOYUxXk/bez4KFUkzaY/083gS04mr7UAl5MqRJ
         sROTmTwEViRg5uxhR5sWFoxWmJFmTibnJnjVaiPx5A7NYszkN28Pw3F9GG6j+K7/f9PG
         eZzg==
X-Gm-Message-State: AJIora8g9/LaZ1UZrvy28s+UrdIDW/vsVYbQUhslj2ANCOwJH9miH7fG
	aLkCNNs5nXQ+irOYfN3OMAThgG8Ze2BXoI5Eczg=
X-Google-Smtp-Source: AGRyM1tBFIEYBDxGLzaDvVTXuHe5ZYHZOgc6ukFSLHfEfsXufc0R2byw7I1e3UpHfdQtHjLb2QuKF+0UskplAwmseNI=
X-Received: by 2002:a25:6a46:0:b0:669:1da2:ba1d with SMTP id
 f67-20020a256a46000000b006691da2ba1dmr9699838ybc.163.1655814855831; Tue, 21
 Jun 2022 05:34:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220620081519.1494-1-jasowang@redhat.com> <20220620081519.1494-2-jasowang@redhat.com>
In-Reply-To: <20220620081519.1494-2-jasowang@redhat.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 21 Jun 2022 14:34:04 +0200
Message-ID: <CAM9Jb+jvbr757EbY+kvKF9Y5yyyfYmtYe=+kY5vg-Mm6wT4rCQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio_pmem: set device ready in probe()
To: Jason Wang <jasowang@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

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
>         ndr_desc.provider_data = vdev;
>         set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>         set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> +       /*
> +        * The NVDIMM region could be available before the
> +        * virtio_device_ready() that is called by
> +        * virtio_dev_probe(), so we set device ready here.
> +        *
> +        * The callback - virtio_pmem_host_ack() is safe to be called
> +        * before the nvdimm_pmem_region_create() since the pmem_lock
> +        * has been initialized and legality of a used buffer is
> +        * validated before moving forward.
> +        */
> +       virtio_device_ready(vdev);
>         nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
>         if (!nd_region) {
>                 dev_err(&vdev->dev, "failed to create nvdimm region\n");
> @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>         }
>         return 0;
>  out_nd:
> +       virtio_reset_device(vdev);
>         nvdimm_bus_unregister(vpmem->nvdimm_bus);
>  out_vq:
>         vdev->config->del_vqs(vdev);

IIRC Similar fix was submitted by msft in the past while proposing support for
PCI BAR with virtio pmem and I tested it. Feel free to add.

Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
