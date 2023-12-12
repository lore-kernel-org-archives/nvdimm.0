Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28EA59175
	for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsoOBmDM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702375558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MaFI2nLzy2BuURLvmJJteNjl3+hrowavzBk9ysSya2U=;
	b=hsoOBmDMeBlktdsvUDrjIK+XwYW3+cDJvr9hxJBwsxroAG2YnnXwtwvJ9xcVnyOsuAxyFw
	f8NwOTfyWPHgm4i3o0neY+jUO31JPOq8pj64qCD85aZobLnzuvSXnPjs8k6qVmUR0l/P03
	dIukKiFlJKUahAuYmE8Ihur/yd3FT4s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-BYJPMvS9Piq_r6w12cwTIA-1; Tue, 12 Dec 2023 05:05:56 -0500
X-MC-Unique: BYJPMvS9Piq_r6w12cwTIA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-333501e22caso4519462f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 12 Dec 2023 02:05:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702375555; x=1702980355;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MaFI2nLzy2BuURLvmJJteNjl3+hrowavzBk9ysSya2U=;
        b=ag7fZNc7ugZfbdAn+IfpJGAIMqgS3c4+KGNHE234FVLQitpR99s7nTpfcqMqAgBuwW
         J6JtEF95bYTA6wnouBmDHluaN+fcXkp1Ddlaxp2ejmCt7skjyXxuiqcF3k6W/2U8xdsl
         XzPScSKuNs0STS5fyxmjKwfW8s+5+Md1dAKhCpr8jsewvCzfsZf0UzTVM5xARn5f+WDU
         srAWlwqs6lQYEr7zJAd/g4mD2UcVY57+J7lfwPEf3shQuZqN/UCGlPJNZhZgb+njnBJU
         fK1wbnLHOrD/biFPYShyGEcUfxEdHHIvvgHN2uSJ0YKLhOK9/fPoDjqA0+Iol9wmisfh
         /NDw==
X-Gm-Message-State: AOJu0YzNj8Jaj+chHQ40mjG2C5FWMS1Lqcy0XCzA51HKCqZu7OtU4o1n
	63mL1woKgdVWDcGAcWJKLcIKV2uyGUFwhKBtXWQzVnBBM8pdEzGghYbdnUW4HzMSoLGaeoKQ7HB
	hYq0Dy13XBsLcnzfq
X-Received: by 2002:a5d:620a:0:b0:333:3c28:767a with SMTP id y10-20020a5d620a000000b003333c28767amr2470366wru.46.1702375555449;
        Tue, 12 Dec 2023 02:05:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5Dy61sE9ZXZtGCeZ0WlhrlSS7Rh+IeqOz5YqaPlLVTMbyBr6u2EqtyUTB9ZcBSyRZqpupdw==
X-Received: by 2002:a5d:620a:0:b0:333:3c28:767a with SMTP id y10-20020a5d620a000000b003333c28767amr2470357wru.46.1702375554983;
        Tue, 12 Dec 2023 02:05:54 -0800 (PST)
Received: from ?IPV6:2003:cb:c74b:ca00:4ca2:ff2c:9092:f070? (p200300cbc74bca004ca2ff2c9092f070.dip0.t-ipconnect.de. [2003:cb:c74b:ca00:4ca2:ff2c:9092:f070])
        by smtp.gmail.com with ESMTPSA id e18-20020a056000121200b00333404e9935sm10381362wrx.54.2023.12.12.02.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 02:05:54 -0800 (PST)
Message-ID: <68582759-c74e-4bd8-b055-58eff81ef2e2@redhat.com>
Date: Tue, 12 Dec 2023 11:05:53 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] dax: add a sysfs knob to control memmap_on_memory
 behavior
To: Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
 Huang Ying <ying.huang@intel.com>, Li Zhijian <lizhijian@fujitsu.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
References: <20231211-vv-dax_abi-v3-0-acf6cc1bde9f@intel.com>
 <20231211-vv-dax_abi-v3-2-acf6cc1bde9f@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231211-vv-dax_abi-v3-2-acf6cc1bde9f@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.12.23 23:52, Vishal Verma wrote:
> Add a sysfs knob for dax devices to control the memmap_on_memory setting
> if the dax device were to be hotplugged as system memory.
> 
> The default memmap_on_memory setting for dax devices originating via
> pmem or hmem is set to 'false' - i.e. no memmap_on_memory semantics, to
> preserve legacy behavior. For dax devices via CXL, the default is on.
> The sysfs control allows the administrator to override the above
> defaults if needed.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   drivers/dax/bus.c                       | 47 +++++++++++++++++++++++++++++++++
>   Documentation/ABI/testing/sysfs-bus-dax | 17 ++++++++++++
>   2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1ff1ab5fa105..2871e5188f0d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1270,6 +1270,52 @@ static ssize_t numa_node_show(struct device *dev,
>   }
>   static DEVICE_ATTR_RO(numa_node);
>   
> +static ssize_t memmap_on_memory_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +
> +	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
> +}
> +
> +static ssize_t memmap_on_memory_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t len)
> +{
> +	struct device_driver *drv = dev->driver;
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	struct dax_region *dax_region = dev_dax->region;
> +	struct dax_device_driver *dax_drv = to_dax_drv(drv);
> +	ssize_t rc;
> +	bool val;
> +
> +	rc = kstrtobool(buf, &val);
> +	if (rc)
> +		return rc;
> +
> +	if (dev_dax->memmap_on_memory == val)
> +		return len;
> +
> +	device_lock(dax_region->dev);
> +	if (!dax_region->dev->driver) {
> +		device_unlock(dax_region->dev);
> +		return -ENXIO;
> +	}
> +
> +	if (dax_drv->type == DAXDRV_KMEM_TYPE) {
> +		device_unlock(dax_region->dev);
> +		return -EBUSY;
> +	}
> +
> +	device_lock(dev);
> +	dev_dax->memmap_on_memory = val;
> +	device_unlock(dev);
> +
> +	device_unlock(dax_region->dev);
> +	return len;
> +}
> +static DEVICE_ATTR_RW(memmap_on_memory);
> +
>   static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>   {
>   	struct device *dev = container_of(kobj, struct device, kobj);
> @@ -1296,6 +1342,7 @@ static struct attribute *dev_dax_attributes[] = {
>   	&dev_attr_align.attr,
>   	&dev_attr_resource.attr,
>   	&dev_attr_numa_node.attr,
> +	&dev_attr_memmap_on_memory.attr,
>   	NULL,
>   };
>   
> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index a61a7b186017..b1fd8bf8a7de 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -149,3 +149,20 @@ KernelVersion:	v5.1
>   Contact:	nvdimm@lists.linux.dev
>   Description:
>   		(RO) The id attribute indicates the region id of a dax region.
> +
> +What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
> +Date:		October, 2023
> +KernelVersion:	v6.8
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Control the memmap_on_memory setting if the dax device
> +		were to be hotplugged as system memory. This determines whether
> +		the 'altmap' for the hotplugged memory will be placed on the
> +		device being hotplugged (memmap_on_memory=1) or if it will be
> +		placed on regular memory (memmap_on_memory=0). This attribute
> +		must be set before the device is handed over to the 'kmem'
> +		driver (i.e.  hotplugged into system-ram). Additionally, this
> +		depends on CONFIG_MHP_MEMMAP_ON_MEMORY, and a globally enabled
> +		memmap_on_memory parameter for memory_hotplug. This is
> +		typically set on the kernel command line -
> +		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> 

Thinking about it, I wonder if we could disallow setting that property 
to "true" if the current configuration does not allow it.

That is:

1) Removing the "size" parameter from mhp_supports_memmap_on_memory(), 
it doesn't make any sense anymore.

2) Exporting mhp_supports_memmap_on_memory() to modules.

3) When setting memmap_on_memory, check whether 
mhp_supports_memmap_on_memory() == true.

Then, the user really gets an error when trying to set it to "true".

-- 
Cheers,

David / dhildenb

