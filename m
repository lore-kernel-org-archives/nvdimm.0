Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D754C2DE71B
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 18:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770056425; cv=none; b=Ooqrs88h/SY/6fng0BFR09BdgZa0/pZclnOn4LCs6JWgOYNt1/D1No9LpjftfpVdBeXpJwcZTlir1mKpJzc9vj16TrfFT9deOnlW/ZcQdCArsvaGD1zUmXWFUKAs1oQyaDqHFF9Dmp+l1tFuiRsID2k1PP3CxKLs4rj+bpi66Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770056425; c=relaxed/simple;
	bh=9evVPU/6Hj3hlrvPS13EoLvahvYf5Gmr1Wxrz+0ErGo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lR7aOe1xY33gDwgqX3mxJp23H1+MxU6ZNqruzL8orgo6IIcHavIY3s+2VH2YZWKDkZWDAMcmrYADFY6RWmXK2GyK2j6pMCQz1EHm5NEv6uBuBQ2BJDeRu0ZiS/FtoPtNqlqoBjsTfWo2mFQvfgqTkV7laqP5m1nSWmWis5WY2ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Zdb2s8dzJ46BB;
	Tue,  3 Feb 2026 02:19:31 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 80A7140565;
	Tue,  3 Feb 2026 02:20:17 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 18:20:16 +0000
Date: Mon, 2 Feb 2026 18:20:15 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <20260202182015.0000325b@huawei.com>
In-Reply-To: <20260129210442.3951412-9-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-9-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 29 Jan 2026 16:04:41 -0500
Gregory Price <gourry@gourry.net> wrote:

> In the current kmem driver binding process, the only way for users
> to define hotplug policy is via a build-time option, or by not
> onlining memory by default and setting each individual memory block
> online after hotplug occurs.  We can solve this with a configuration
> step between region-probe and dax-probe.
> 
> Add the infrastructure for a two-stage driver binding for kmem-mode
> dax regions. The cxl_dax_kmem_region driver probes cxl_sysram_region
> devices and creates cxl_dax_region with dax_driver=kmem.
> 
> This creates an interposition step where users can configure policy.
> 
> Device hierarchy:
>   region0 -> sysram_region0 -> dax_region0 -> dax0.0
> 
> The sysram_region device exposes a sysfs 'online_type' attribute
> that allows users to configure the memory online type before the
> underlying dax_region is created and memory is hotplugged.
> 
>   sysram_region0/online_type:
>       invalid:        not configured, blocks probe
>       offline:        memory will not be onlined automatically
>       online:         memory will be onlined in ZONE_NORMAL
>       online_movable: memory will be onlined in ZONE_MMOVABLE

ZONE_MOVABLE

> 
> The device initializes with online_type=invalid which prevents the
> cxl_dax_kmem_region driver from binding until the user explicitly
> configures a valid online_type.
> 
> This enables a two-step binding process:
>   echo region0 > cxl_sysram_region/bind
>   echo online_movable > sysram_region0/online_type
>   echo sysram_region0 > cxl_dax_kmem_region/bind
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
Trivial stuff. Will mull over this series as a whole...
My first instinctive reaction is positive - I'm just wondering
where additional drivers fit into this and whether it has the
right degree of flexibility.



> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 6200ca1cc2dd..8bef91dc726c 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3734,8 +3734,20 @@ int cxl_region_init(void)
>  	if (rc)
>  		goto err_dax;
>  
> +	rc = cxl_driver_register(&cxl_sysram_region_driver);

This smells like a loop over an array of drivers is becoming sensible.

> +	if (rc)
> +		goto err_sysram;
> +
> +	rc = cxl_driver_register(&cxl_dax_kmem_region_driver);
> +	if (rc)
> +		goto err_dax_kmem;
> +
>  	return 0;
>  
> +err_dax_kmem:
> +	cxl_driver_unregister(&cxl_sysram_region_driver);
> +err_sysram:
> +	cxl_driver_unregister(&cxl_devdax_region_driver);
>  err_dax:
>  	cxl_driver_unregister(&cxl_region_driver);
>  	return rc;
> @@ -3743,6 +3755,8 @@ int cxl_region_init(void)
>  
>  void cxl_region_exit(void)
>  {
> +	cxl_driver_unregister(&cxl_dax_kmem_region_driver);
> +	cxl_driver_unregister(&cxl_sysram_region_driver);
>  	cxl_driver_unregister(&cxl_devdax_region_driver);
>  	cxl_driver_unregister(&cxl_region_driver);
>  }
> diff --git a/drivers/cxl/core/sysram_region.c b/drivers/cxl/core/sysram_region.c
> new file mode 100644
> index 000000000000..5665db238d0f
> --- /dev/null
> +++ b/drivers/cxl/core/sysram_region.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2026 Meta Platforms, Inc. All rights reserved. */
> +/*
> + * CXL Sysram Region - Intermediate device for kmem hotplug configuration
> + *
> + * This provides an intermediate device between cxl_region and cxl_dax_region
> + * that allows users to configure memory hotplug parameters (like online_type)
> + * before the underlying dax_region is created and memory is hotplugged.
> + */
> +
> +#include <linux/memory_hotplug.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <cxlmem.h>
> +#include <cxl.h>
> +#include "core.h"

> +
> +static DEVICE_ATTR_RW(online_type);
> +
> +static struct attribute *cxl_sysram_region_attrs[] = {
> +	&dev_attr_online_type.attr,
> +	NULL,

As below.

> +};
> +
> +static const struct attribute_group cxl_sysram_region_attribute_group = {
> +	.attrs = cxl_sysram_region_attrs,
> +};
> +
> +static const struct attribute_group *cxl_sysram_region_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	&cxl_sysram_region_attribute_group,
> +	NULL,

Trivial, but don't want a comma on that NULL.

> +};

> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 674d5f870c70..1544c27e9c89 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -596,6 +596,25 @@ struct cxl_dax_region {
>  	enum dax_driver_type dax_driver;
>  };
>  
> +/**
> + * struct cxl_sysram_region - CXL RAM region for system memory hotplug
> + * @dev: device for this sysram_region
> + * @cxlr: parent cxl_region
> + * @hpa_range: Host physical address range for the region
> + * @online_type: Memory online type (MMOP_* 0-3, or -1 if not configured)

Ah. An there's our reason for an int.   Can we just add a MMOP enum value
for not configured yet and so let us use it as an enum?
Or have a separate bool for that and ignore the online_type until it's set.


> + *
> + * Intermediate device that allows configuration of memory hotplug
> + * parameters before the underlying dax_region is created. The device
> + * starts with online_type=-1 which prevents the cxl_dax_kmem_region
> + * driver from binding until the user explicitly sets online_type.
> + */
> +struct cxl_sysram_region {
> +	struct device dev;
> +	struct cxl_region *cxlr;
> +	struct range hpa_range;
> +	int online_type;
> +};


