Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DBF168
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 20:06:02 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id r16so17116791ilt.11
        for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 13:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gxnjhusErhTK1CcC6mqMNjSlOpDG/ZOjUYObhN9uSM0=;
        b=r8XaCO/NaNKlVA/xaqdun4hZPvdNTpvrbCo2EcWTfeej0IMOVMh1foL2Z9fsd+HPvC
         UeeDMsJllqwDj7O6XHa6+7iAf7EbFpgT6gngpL7tIEhADNPVP8kP+pjM5kN/LSX91NW9
         ZGZdJ6+xoHd4X9PEscG8KfvF7/qJK0zCxSjaIrxIXT2wRnfB69sVH7x1OH+qR7lZcr/V
         TSupfye77nZT6n+3yZk6P3yKq2W4I3oXsBuelFqfyGVEKkkTHJuCswiSQ1Gz3Ozv8ipR
         fi3jGQmX2pizij2N+jCFuGIQbVt3mqM82DaHZfP7ZcbJKHZDZx15A9yVAFZ82FDXZeLd
         Lesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxnjhusErhTK1CcC6mqMNjSlOpDG/ZOjUYObhN9uSM0=;
        b=m1hVd/6BjE7lbFCGDCEtq3RGJuXMAad0SkvKuWu4YoSMBau1l1/k2O5qT+37VlUkqw
         JFE0pqDh3frq8QqSMEixS6CU7bIPg43XMJKt8M0TvmPN7XQ5cwzZLIOgXBYXZMEuqfYw
         2kTYKDIFLIvTT7Or4W/+nRDls8XD/AX0rf/ZkcojNwIDlEpwg96BnMhrZL7OCyRqweTP
         fzUHpf0WeKJBrOBuAY6Vgmie342TBDaliTpJ/bz2oFJJCAwqjvz7PfwukizIAZLy6gOr
         uLbgEqimproG9bEMTLjkzdtR1WWVvMWQQyGUtn8cXA0PpIceOXUCGwVjshAalYs15dWU
         xTGw==
X-Gm-Message-State: AOAM533idjtkHKaztX/v7k81nN/x75B1zdMQk6dWcvBefjDlqXMcUkMY
	xdx+w0zmRnzHUy9fwZlPou0qpTthjt0uQX/hK6k=
X-Google-Smtp-Source: ABdhPJwBkCsmX5bJpBJZaQ/6dmaVFF+hIdLIB32IIIxigEVhrqcTUejC/S3sL094xQ5G0bHUpqlIiJKi0Pv4eQfIDOM=
X-Received: by 2002:a05:6e02:1529:: with SMTP id i9mr17821821ilu.163.1626725161761;
 Mon, 19 Jul 2021 13:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223638.GA29649@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210715223638.GA29649@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 19 Jul 2021 22:05:50 +0200
Message-ID: <CAM9Jb+jwofZaeEThiDtUwrACCTXmQh8EJxsegpn8werQG8Bpcg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio-pmem: Set DRIVER_OK status prior to
 creating pmem region
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, 
	apais@microsoft.com, tyhicks@microsoft.com, jamorris@microsoft.com, 
	benhill@microsoft.com, sunilmut@microsoft.com, grahamwo@microsoft.com, 
	tstark@microsoft.com, "Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

+CC Michael

> Update virtio-pmem to call virtio_device_ready prior to creating the pmem
> region. Otherwise, the guest may try to access the pmem region prior to
> the DRIVER_OK status being set.
>
> In the case of Hyper-V, the backing pmem file isn't mapped to the guest
> until the DRIVER_OK status is set. Therefore, attempts to access the pmem
> region can cause the guest to crash. Hyper-V could map the file earlier,
> for example at VM creation, but we didn't want to pay the mapping cost if
> the device is never used. Additionally, it felt weird to allow the guest
> to access the region prior to the device fully coming online.
>
> Signed-off-by: Taylor Stark <tstark@microsoft.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 43c1d835a449..ea9e111f3ea1 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -91,6 +91,11 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>
>         dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
>
> +       /* Online the device prior to creating a pmem region, to ensure that
> +        * the region is never touched while the device is offline.
> +        */
> +       virtio_device_ready(vdev);
> +
>         ndr_desc.res = &res;
>         ndr_desc.numa_node = nid;
>         ndr_desc.flush = async_pmem_flush;
> @@ -105,6 +110,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>         nd_region->provider_data = dev_to_virtio(nd_region->dev.parent->parent);
>         return 0;
>  out_nd:
> +       vdev->config->reset(vdev);
>         nvdimm_bus_unregister(vpmem->nvdimm_bus);
>  out_vq:
>         vdev->config->del_vqs(vdev);
> --
> 2.32.0

Looks good to me, independent to the first patch.

Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
