Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B45972
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 20:36:46 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id a11so17244983ilf.2
        for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 13:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzJsApAxq85Ixdqa4IiCaIhW5uXDeCi7IiSc/QlUtuI=;
        b=WFaBhakSnGMNoe92VCjvpkNpGUdqaOysLgbDSJtv4tOzReEo6gSXLyMzCzXcIn8gpB
         KrASVsBiqhKMtkouGadC6te7AQSZ9e6cM0JusVWZ4I6r/gcX7G8+/6+ZiG2q6bQmQLSv
         U3sMd59VL+aEiynumerDtzSkBzaV344sbePQuvzL2tpGiqUvvcYm8OXSr8LJ36VYFncp
         RITTEyDowJogtKJgs3XdMuevR3s45woLjXTaQoA4SzYIGHLrLAAIdafQbnNoc6sDiIDH
         byPA5nUf0xW+7tcI7oNniX4+GUA43tko9BIcavqo/WkVDByaF9QhP7mvw7RaQJMuPY2A
         KQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzJsApAxq85Ixdqa4IiCaIhW5uXDeCi7IiSc/QlUtuI=;
        b=lIqtVVxsFoD2Zh4sKMwj4n+qelPMfO65DOse+F/wV+VrGG+aIkbKWOhh+p/xdyr/mk
         UAWYWxuhKfSFHaYyyhhZKJLFpINgRloma15GxS7EsJrk8qtpmFiIFr6r1t39Axka0xKu
         5xXEzIEieP82UFiBDly2zQ0B/QISA+hV8OnyjkW3JAwMQiAoWPkEBUWiI8B7qaQl8YZr
         e8VVWaZGf7WQbfwc5kyqo3ZoFQyMDO847crIaprEyM/mJG1n+Xem7cPKQCmlxMopN2gm
         h8W0UFvzeOhBmFPnC04yS6DCkU8H0UJfAvb8qVC56FMshKOOcxgl+NGkUrThA0vHA9SC
         y+bg==
X-Gm-Message-State: AOAM532Xz4kWo9/HlMWrcjQeUeyraiu+GxFWi0uDwmBDTcg528pnsO/T
	26qNXHaHYwPSHEFm/8l4gdJ9YtW31BsUbYzavNO+6tCR
X-Google-Smtp-Source: ABdhPJxuj2RJpytD3Jc0fTVW5TqYhhHc4i1Ew7eaHOFFMvyzKloyPejgli91al6MYBluBc56D7BDzTQbm+zcIPRR9qI=
X-Received: by 2002:a05:6e02:1947:: with SMTP id x7mr18741618ilu.85.1626727005227;
 Mon, 19 Jul 2021 13:36:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 19 Jul 2021 22:36:34 +0200
Message-ID: <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, 
	apais@microsoft.com, tyhicks@microsoft.com, jamorris@microsoft.com, 
	benhill@microsoft.com, sunilmut@microsoft.com, grahamwo@microsoft.com, 
	tstark@microsoft.com, "Michael S . Tsirkin" <mst@redhat.com>, 
	Pankaj Gupta <pankaj.gupta@ionos.com>
Content-Type: text/plain; charset="UTF-8"

> Update virtio-pmem to allow for the pmem region to be specified in either
> guest absolute terms or as a PCI BAR-relative address. This is required
> to support virtio-pmem in Hyper-V, since Hyper-V only allows PCI devices
> to operate on PCI memory ranges defined via BARs.
>
> Virtio-pmem will check for a shared memory window and use that if found,
> else it will fallback to using the guest absolute addresses in
> virtio_pmem_config. This was chosen over defining a new feature bit,
> since it's similar to how virtio-fs is configured.
>
> Signed-off-by: Taylor Stark <tstark@microsoft.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 21 +++++++++++++++++----
>  drivers/nvdimm/virtio_pmem.h |  3 +++
>  2 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 726c7354d465..43c1d835a449 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -37,6 +37,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>         struct virtio_pmem *vpmem;
>         struct resource res;
>         int err = 0;
> +       bool have_shm_region;
> +       struct virtio_shm_region pmem_region;
>
>         if (!vdev->config->get) {
>                 dev_err(&vdev->dev, "%s failure: config access disabled\n",
> @@ -58,10 +60,21 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>                 goto out_err;
>         }
>
> -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -                       start, &vpmem->start);
> -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -                       size, &vpmem->size);
> +       /* Retrieve the pmem device's address and size. It may have been supplied
> +        * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> +        */
> +       have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> +                                               VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);

Current implementation of Virtio pmem device in Qemu does not expose
it as PCI BAR.
So, can't test it. Just curious if device side implementation is also
tested for asynchronous
flush case?

Thanks,
Pankaj

> +
> +       if (have_shm_region) {
> +               vpmem->start = pmem_region.addr;
> +               vpmem->size = pmem_region.len;
> +       } else {
> +               virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +                               start, &vpmem->start);
> +               virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +                               size, &vpmem->size);
> +       }
>
>         res.start = vpmem->start;
>         res.end   = vpmem->start + vpmem->size - 1;
> diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> index 0dddefe594c4..62bb564e81cb 100644
> --- a/drivers/nvdimm/virtio_pmem.h
> +++ b/drivers/nvdimm/virtio_pmem.h
> @@ -50,6 +50,9 @@ struct virtio_pmem {
>         __u64 size;
>  };
>
> +/* For the id field in virtio_pci_shm_cap */
> +#define VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION 0
> +
>  void virtio_pmem_host_ack(struct virtqueue *vq);
>  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
>  #endif
> --
> 2.32.0
>
>
