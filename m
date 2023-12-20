Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257CB13AF3
	for <nvdimm@lists.linux.dev>; Wed, 20 Dec 2023 07:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YiHqEol0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703055711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rd5YQ9r+q6yCXPyEf0CX/bG54ESKopDl5R8m4Jw2XKA=;
	b=YiHqEol0TUd4JV3oqv8DCInYCdcgTvH/58sIJHFRp25r8Oo7gjCGl4zcjUT5ctZDlIvYQH
	Sh28jbUq7sMrhLa8ZdJu2OxvPnC2yrMZJF170BmnZDFpT/ossRYJ3GWc9Hfg6IkWnz6VFM
	4v9utxPaGF4O8mUN7K8fdlIIihVqUI8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-nvxYe7cPO6iXCzUcTLTriw-1; Wed, 20 Dec 2023 02:01:49 -0500
X-MC-Unique: nvxYe7cPO6iXCzUcTLTriw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40d29d4ed7fso10364385e9.1
        for <nvdimm@lists.linux.dev>; Tue, 19 Dec 2023 23:01:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703055708; x=1703660508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rd5YQ9r+q6yCXPyEf0CX/bG54ESKopDl5R8m4Jw2XKA=;
        b=Z7dPBNMjjADmo0mnkfQqXvnW3N4nVte2DDZRhFedvW9ALz7oM6qfV2rN/L2mLaIz60
         MaXhDR1OdkKHVkCjRNkE/jHKih3kGhi71Ps5IMqZNPXHvluv64PzZ5RJ44zN8AAsf59g
         eGdGtzDPZO4dSWoLBOBf7PcYjIFEEbdVc9N+x+vV29g/27Z/yMotPH+F/FviGpQDe6S0
         40DgtoqmqK5lj93J5SzMTBg70y6gBiAmF3y75aRiM5JTRVufkDdGbLSYmu+JVjRem2PF
         Z4sj/1Fjtl8Bxo08y4bZqKwBRcZkU2uYYnYnOpra8pVMDwDYXEqgWRxBA7Nu3PbRIobX
         AvCg==
X-Gm-Message-State: AOJu0YwTTos23n2988az3x04MsRvm5m6PdcZ/H3iDtH6LXmQX0/+coJr
	OFhYEEyRoeyImAiWoeYoi8W7nLAMolpIQEHb/WX8M5T9CamM36lNoN1pGqGdBX4ULsbueQYilzT
	72TRFRv5TB2Y69IxQ
X-Received: by 2002:a05:600c:16d4:b0:40c:848:71bf with SMTP id l20-20020a05600c16d400b0040c084871bfmr9535306wmn.186.1703055708165;
        Tue, 19 Dec 2023 23:01:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZ1vB4EZFQLQdvC5TbQGze9IygzOlVUMt02E+45ULlDlpd0iQcsLeDos6Dyx2Se+helIaGdA==
X-Received: by 2002:a05:600c:16d4:b0:40c:848:71bf with SMTP id l20-20020a05600c16d400b0040c084871bfmr9535297wmn.186.1703055707788;
        Tue, 19 Dec 2023 23:01:47 -0800 (PST)
Received: from redhat.com ([2.52.148.230])
        by smtp.gmail.com with ESMTPSA id k17-20020adff291000000b003367bb8898dsm637039wro.66.2023.12.19.23.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 23:01:46 -0800 (PST)
Date: Wed, 20 Dec 2023 02:01:43 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Changyuan Lyu <changyuanl@google.com>
Cc: jasowang@redhat.com, dan.j.williams@intel.com, dave.jiang@intel.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	pankaj.gupta.linux@gmail.com, virtualization@lists.linux.dev,
	vishal.l.verma@intel.com, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH v2] virtio_pmem: support feature SHMEM_REGION
Message-ID: <20231220020100-mutt-send-email-mst@kernel.org>
References: <CACGkMEuEY5xJyf6H6RgqSuD0PeY9kynYywxzM2+3W6MPaav0Zw@mail.gmail.com>
 <20231220061301.228671-1-changyuanl@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231220061301.228671-1-changyuanl@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 19, 2023 at 10:13:00PM -0800, Changyuan Lyu wrote:
> On Tue, Dec 19, 2023 at 7:57 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, Dec 19, 2023 at 3:19 PM Changyuan Lyu <changyuanl@google.com> wrote:
> > >
> > > +/* shmid of the shared memory region corresponding to the pmem */
> > > +#define VIRTIO_PMEM_SHMCAP_ID 0
> >
> > NIT: not a native speaker, but any reason for "CAP" here? Would it be
> > better to use SHMMEM_REGION_ID?
> 
> I was following the name VIRTIO_FS_SHMCAP_ID_CACHE in
> include/uapi/linux/virtio_fs.h, where I guess "CAP" was referring to
> the shared memory capability when the device is on PCI bus. I agree
> SHMMEM_REGION_ID is a better name.
> 
> On Tue, Dec 19, 2023 at 3:19 PM Changyuan Lyu <changyuanl@google.com> wrote:
> >
> > +		if (!have_shm) {
> > +			dev_err(&vdev->dev, "failed to get shared memory region %d\n",
> > +					VIRTIO_PMEM_SHMCAP_ID);
> > +			return -EINVAL;
> > +		}
> 
> I realized that it needs to jump to tag out_vq to clean up vqs
> instead of simply returnning an error.
> 
> Thanks for reviewing the patch!
> 
> ---8<---
> 
> As per virtio spec 1.2 section 5.19.5.2, if the feature
> VIRTIO_PMEM_F_SHMEM_REGION has been negotiated, the driver MUST query
> shared memory ID 0 for the physical address ranges.

This is not a great description. Please describe what the patch does.

> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> 
> ---
> V2:
>   * renamed VIRTIO_PMEM_SHMCAP_ID to VIRTIO_PMEM_SHMEM_REGION_ID
>   * fixed the error handling when region 0 does not exist
> ---
>  drivers/nvdimm/virtio_pmem.c     | 30 ++++++++++++++++++++++++++----
>  include/uapi/linux/virtio_pmem.h |  8 ++++++++
>  2 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index a92eb172f0e7..8e447c7558cb 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -35,6 +35,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	struct nd_region *nd_region;
>  	struct virtio_pmem *vpmem;
>  	struct resource res;
> +	struct virtio_shm_region shm_reg;
> +	bool have_shm;
>  	int err = 0;
>  
>  	if (!vdev->config->get) {
> @@ -57,10 +59,24 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  		goto out_err;
>  	}
>  
> -	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -			start, &vpmem->start);
> -	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> -			size, &vpmem->size);
> +	if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION)) {
> +		have_shm = virtio_get_shm_region(vdev, &shm_reg,
> +				(u8)VIRTIO_PMEM_SHMEM_REGION_ID);
> +		if (!have_shm) {
> +			dev_err(&vdev->dev, "failed to get shared memory region %d\n",
> +					VIRTIO_PMEM_SHMEM_REGION_ID);
> +			err = -ENXIO;
> +			goto out_vq;
> +		}
> +		vpmem->start = shm_reg.addr;
> +		vpmem->size = shm_reg.len;
> +	} else {
> +		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +				start, &vpmem->start);
> +		virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> +				size, &vpmem->size);
> +	}
> +
>  
>  	res.start = vpmem->start;
>  	res.end   = vpmem->start + vpmem->size - 1;
> @@ -122,7 +138,13 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
>  	virtio_reset_device(vdev);
>  }
>  
> +static unsigned int features[] = {
> +	VIRTIO_PMEM_F_SHMEM_REGION,
> +};
> +
>  static struct virtio_driver virtio_pmem_driver = {
> +	.feature_table		= features,
> +	.feature_table_size	= ARRAY_SIZE(features),
>  	.driver.name		= KBUILD_MODNAME,
>  	.driver.owner		= THIS_MODULE,
>  	.id_table		= id_table,
> diff --git a/include/uapi/linux/virtio_pmem.h b/include/uapi/linux/virtio_pmem.h
> index d676b3620383..c5e49b6e58b1 100644
> --- a/include/uapi/linux/virtio_pmem.h
> +++ b/include/uapi/linux/virtio_pmem.h
> @@ -14,6 +14,14 @@
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
>  
> +/* Feature bits */
> +#define VIRTIO_PMEM_F_SHMEM_REGION 0	/* guest physical address range will be
> +					 * indicated as shared memory region 0
> +					 */
> +
> +/* shmid of the shared memory region corresponding to the pmem */
> +#define VIRTIO_PMEM_SHMEM_REGION_ID 0
> +
>  struct virtio_pmem_config {
>  	__le64 start;
>  	__le64 size;
> -- 
> 2.43.0.472.g3155946c3a-goog

