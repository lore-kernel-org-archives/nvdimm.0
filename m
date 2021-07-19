Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E794372
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 21:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626729430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kujiEKMy0thaS5CF5Qo02RWe4IiDsfJcC10rQmHEXBc=;
	b=KYBApTr5scRPsUUrnM4k23fgAsEWSHFXpaUlotkh+kglfzNK0ZKNsf64hVc1R13i2cVXZ1
	HVnVixR+gO1LC7Arq6EuTAOu7j3n87I0fayOcaDQiGPzzRUbeoUbPfTCPaOwjzJZ09YnEj
	ZvI2Vh3tFtN5aiggagkIjtpZTUhzeCI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-caqEcJ83MWWONOC72shmAw-1; Mon, 19 Jul 2021 17:17:07 -0400
X-MC-Unique: caqEcJ83MWWONOC72shmAw-1
Received: by mail-ed1-f70.google.com with SMTP id c21-20020aa7d6150000b02903ab03a06e86so9902141edr.14
        for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 14:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kujiEKMy0thaS5CF5Qo02RWe4IiDsfJcC10rQmHEXBc=;
        b=DnrCXuDbFDJuxv22XECcynRSdLDJu3Mte6VtPMv+qcrAE/7FgjI7eKoqLaB86bWcIa
         K3Q9rGEPwV4d7v+GPTunVy38JPanufPu4WyNql+Alfa16Exb4ptVx8zhzbwg6K13KKIT
         ypj2ftTTlQ2gl3rzIl3QwkEgs5vuKT08CnGkQPg5cQ5KLhP8njf23XGl96EzqztxkjHs
         IXU/9L83xy+5l1QI3q7MkOX5Hb52UYmcJFsEoKt29od765odEl9+Su59bW+IxiMpzRx3
         EHfLM8XFdcncQRSJtztqzK/MPHy91mkKcm1sIn6gm5SyVR4aaW/MIGvFs9ockmwxMa3x
         HWAA==
X-Gm-Message-State: AOAM531OFr7HBLbdCPVI7QkL0aPBYwKM8bUc8nZghcehAH0T1A4hv3m4
	eunA12Z6WXfbNOts85zIGXPLPGj9/8ykwZGncYGJkaFaxIR0wTq0uUjPcfNXgkbp4OjF0KPCQKK
	BTPW22m42TVPulYpd
X-Received: by 2002:a17:906:30d8:: with SMTP id b24mr28743764ejb.358.1626729426259;
        Mon, 19 Jul 2021 14:17:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJQOuk69N2sFzCoUDVPF4aaT8BJQky04/6I0ylfvTyOaGWbCPLANj6y6oZFFK0ToBrpsFkkA==
X-Received: by 2002:a17:906:30d8:: with SMTP id b24mr28743745ejb.358.1626729426068;
        Mon, 19 Jul 2021 14:17:06 -0700 (PDT)
Received: from redhat.com ([2.55.139.106])
        by smtp.gmail.com with ESMTPSA id jp26sm6402600ejb.28.2021.07.19.14.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 14:17:04 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:17:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	apais@microsoft.com, tyhicks@microsoft.com, jamorris@microsoft.com,
	benhill@microsoft.com, sunilmut@microsoft.com,
	grahamwo@microsoft.com, tstark@microsoft.com
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210719171533-mutt-send-email-mst@kernel.org>
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 15, 2021 at 03:35:05PM -0700, Taylor Stark wrote:
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

This needs to be added to the device spec too.
Can you send a spec patch please?
It's a subscriber-only list virtio-comment@lists.oasis-open.org


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
>  	struct virtio_pmem *vpmem;
>  	struct resource res;
>  	int err = 0;
> +	bool have_shm_region;
> +	struct virtio_shm_region pmem_region;
>  
>  	if (!vdev->config->get) {
>  		dev_err(&vdev->dev, "%s failure: config access disabled\n",
> @@ -58,10 +60,21 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  		goto out_err;
>  	}
>  
> -	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -			start, &vpmem->start);
> -	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -			size, &vpmem->size);
> +	/* Retrieve the pmem device's address and size. It may have been supplied
> +	 * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> +	 */
> +	have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> +						VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> +
> +	if (have_shm_region) {
> +		vpmem->start = pmem_region.addr;
> +		vpmem->size = pmem_region.len;
> +	} else {
> +		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +				start, &vpmem->start);
> +		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +				size, &vpmem->size);
> +	}
>  
>  	res.start = vpmem->start;
>  	res.end   = vpmem->start + vpmem->size - 1;
> diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> index 0dddefe594c4..62bb564e81cb 100644
> --- a/drivers/nvdimm/virtio_pmem.h
> +++ b/drivers/nvdimm/virtio_pmem.h
> @@ -50,6 +50,9 @@ struct virtio_pmem {
>  	__u64 size;
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

