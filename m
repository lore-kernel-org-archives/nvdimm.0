Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752B70
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 20:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627503441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wTOlYUXV1991ysqsQVTTRBs/M2N2Bgatu9whcUKn5SQ=;
	b=jCvp91L5D/GQ4ecSaIm1kIfvg0dHk769Bflkag6kB98ka0BSv5mw+JqXMnBnrtMlxVmqOF
	vKZGgKeto07mzMKejl8tQm53Rz8sjR/lMRMAmGjgPSlxYGUIgMCc/zSZ/p99Uc60jEm6ES
	n5p9tQbz5leVoQvfxg5iOob0KdXs6H0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-mhcsQpopPF2agJdQ5e0FHg-1; Wed, 28 Jul 2021 16:17:20 -0400
X-MC-Unique: mhcsQpopPF2agJdQ5e0FHg-1
Received: by mail-wm1-f71.google.com with SMTP id i3-20020a05600c3543b029021ecdaeeafaso419584wmq.7
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 13:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wTOlYUXV1991ysqsQVTTRBs/M2N2Bgatu9whcUKn5SQ=;
        b=llHUuB8Zou7jTynECnmLTRvifF1YKab74L6+kBGHx8DiTS6BTE0c4rT7hZ4Q/1h+YN
         9VQi4oU1g4h3++7Soam9UlenX2f5x7OKF7uEAG9mgDIQ5CzLC8e24473dq+KNi1WZYTn
         lmoyRhIW1Gh3rDypQE/bDqN+PJiQ6VfrkU65e4ZZiKbDhsj5ASVse+w+MiIiluzNc7QO
         Be7EzAcx0x79s4n8d4+lZKTuztXSlX0YOxHhrarCCX7hUbI6EinXy9kxPpmhNI1LBU5H
         my957RftAG2PyaHgVh0Q9tdaTuqpQO0DVOIMO8cf4yRGklj2eGE5RcWNBhQmGZCjGHji
         wWsw==
X-Gm-Message-State: AOAM532AlerpO42BI5RWURk+Xl4QNRvR2s+nw8CDUNFUEs5rDD8mcXoS
	Smi+jqus15ZK6UeHvLlhtl7LhGWCyJWU/gUy3QhJZf9y48TOtlBPHXdgkdAy8Jlsn9k73VgYB8G
	Ke2SUh+PLozlC7mFy
X-Received: by 2002:a1c:f203:: with SMTP id s3mr10636158wmc.138.1627503439159;
        Wed, 28 Jul 2021 13:17:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4laX2t23/QMPtmnKUWVnbHiRG9Z3USBKI5x2FQCZXJ4d/XfePp95Zz7/zDTpeOZKyxINrdw==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr10636132wmc.138.1627503438865;
        Wed, 28 Jul 2021 13:17:18 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id n8sm806164wrx.46.2021.07.28.13.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 13:17:18 -0700 (PDT)
To: Jia He <justin.he@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, nd@arm.com
References: <20210728082226.22161-1-justin.he@arm.com>
 <20210728082226.22161-2-justin.he@arm.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] device-dax: use fallback nid when numa_node is invalid
Message-ID: <fc31c6ab-d147-10c0-7678-d820bc8ec96e@redhat.com>
Date: Wed, 28 Jul 2021 22:17:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210728082226.22161-2-justin.he@arm.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 28.07.21 10:22, Jia He wrote:
> Previously, numa_off was set unconditionally in dummy_numa_init()
> even with a fake numa node. Then ACPI set node id as NUMA_NO_NODE(-1)
> after acpi_map_pxm_to_node() because it regards numa_off as turning
> off the numa node. Hence dev_dax->target_node is NUMA_NO_NODE on
> arm64 with fake numa.
> 
> Without this patch, pmem can't be probed as a RAM device on arm64 if
> SRAT table isn't present:
>    $ndctl create-namespace -fe namespace0.0 --mode=devdax --map=dev -s 1g -a 64K
>    kmem dax0.0: rejecting DAX region [mem 0x240400000-0x2bfffffff] with invalid node: -1
>    kmem: probe of dax0.0 failed with error -22
> 
> This fixes it by using fallback memory_add_physaddr_to_nid() as nid.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>   drivers/dax/kmem.c | 36 ++++++++++++++++++++----------------
>   1 file changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index ac231cc36359..749674909e51 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -46,20 +46,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   	struct dax_kmem_data *data;
>   	int rc = -ENOMEM;
>   	int i, mapped = 0;
> -	int numa_node;
> -
> -	/*
> -	 * Ensure good NUMA information for the persistent memory.
> -	 * Without this check, there is a risk that slow memory
> -	 * could be mixed in a node with faster memory, causing
> -	 * unavoidable performance issues.
> -	 */
> -	numa_node = dev_dax->target_node;
> -	if (numa_node < 0) {
> -		dev_warn(dev, "rejecting DAX region with invalid node: %d\n",
> -				numa_node);
> -		return -EINVAL;
> -	}
> +	int numa_node = dev_dax->target_node, new_node;
>   
>   	data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
>   	if (!data)
> @@ -104,6 +91,20 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   		 */
>   		res->flags = IORESOURCE_SYSTEM_RAM;
>   
> +		/*
> +		 * Ensure good NUMA information for the persistent memory.
> +		 * Without this check, there is a risk but not fatal that slow
> +		 * memory could be mixed in a node with faster memory, causing
> +		 * unavoidable performance issues. Furthermore, fallback node
> +		 * id can be used when numa_node is invalid.
> +		 */
> +		if (numa_node < 0) {
> +			new_node = memory_add_physaddr_to_nid(range.start);
> +			dev_info(dev, "changing nid from %d to %d for DAX region %pR\n",
> +				numa_node, new_node, res);
> +			numa_node = new_node;
> +		}
> +
>   		/*
>   		 * Ensure that future kexec'd kernels will not treat
>   		 * this as RAM automatically.
> @@ -141,6 +142,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>   	int i, success = 0;
>   	struct device *dev = &dev_dax->dev;
>   	struct dax_kmem_data *data = dev_get_drvdata(dev);
> +	int numa_node = dev_dax->target_node;
>   
>   	/*
>   	 * We have one shot for removing memory, if some memory blocks were not
> @@ -156,8 +158,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>   		if (rc)
>   			continue;
>   
> -		rc = remove_memory(dev_dax->target_node, range.start,
> -				range_len(&range));
> +		if (numa_node < 0)
> +			numa_node = memory_add_physaddr_to_nid(range.start);
> +
> +		rc = remove_memory(numa_node, range.start, range_len(&range));
>   		if (rc == 0) {
>   			release_resource(data->res[i]);
>   			kfree(data->res[i]);
> 

Note that this patch conflicts with:

https://lkml.kernel.org/r/20210723125210.29987-7-david@redhat.com

But nothing fundamental. Determining a single NID is similar to how I'm 
handling it for ACPI:

https://lkml.kernel.org/r/20210723125210.29987-6-david@redhat.com

-- 
Thanks,

David / dhildenb

