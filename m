Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545A83BED46
	for <nvdimm@lists.linux.dev>; Mon,  9 Mar 2026 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067073; cv=none; b=asIZaUk/5WWZdfyyBFB8psjaBsUdfU8OOT9vaRHZzOFhJRI0Rk5yI3LTv1mCF3F7matPudNgwDjoAgA0AtKfobPrq2F/JDUOM72lvzqQIXWErAem2P/GaPNmFu+sjQzVAnWa9jr/kuxl8PNQxVE7+UfALODmAdlLKExcEjHn5o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067073; c=relaxed/simple;
	bh=9zZLfNMC2c49UfYD8f5c65mEQnz14cRh4NmSK0J6fBA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AHNXlVwj3o002DigoqVyXABTuwHCmMXvCRG/+KnmDRR8L8mxNHR3QYyLJLenbvgCto13UeLLOowDBKJxNfLyM8BDbk3+iJ2HanlQyiPhp8v1ypHBsJNb75YXce40lRui2kItqJVoidfwyWuEe2ToV17X7Ohhl3KuduuLIYaCcIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fV02n5Nt0zJ46F6;
	Mon,  9 Mar 2026 22:37:05 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id C860840086;
	Mon,  9 Mar 2026 22:37:48 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 9 Mar
 2026 14:37:47 +0000
Date: Mon, 9 Mar 2026 14:37:46 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, "Peter Zijlstra"
	<peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>, Terry Bowman
	<terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Zhijian Li <lizhijian@fujitsu.com>, Borislav
 Petkov <bp@alien8.de>, Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v6 5/9] dax: Track all dax_region allocations under a
 global resource tree
Message-ID: <20260309143746.000047ee@huawei.com>
In-Reply-To: <20260210064501.157591-6-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260210064501.157591-6-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 10 Feb 2026 06:44:57 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> Introduce a global "DAX Regions" resource root and register each
> dax_region->res under it via request_resource(). Release the resource on
> dax_region teardown.
> 
> By enforcing a single global namespace for dax_region allocations, this
> ensures only one of dax_hmem or dax_cxl can successfully register a
> dax_region for a given range.
> 
> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

One question inline about the locking.

Is intent to serialize beyond this new resource tree?  If it's just
the resource tree the write_lock(&resource_lock); in the request
and release_resource() should be sufficient.  

> ---
>  drivers/dax/bus.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index fde29e0ad68b..5f387feb95f0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -10,6 +10,7 @@
>  #include "dax-private.h"
>  #include "bus.h"
>  
> +static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");
>  static DEFINE_MUTEX(dax_bus_lock);
>  
>  /*
> @@ -625,6 +626,8 @@ static void dax_region_unregister(void *region)
>  {
>  	struct dax_region *dax_region = region;
>  
> +	scoped_guard(rwsem_write, &dax_region_rwsem)
> +		release_resource(&dax_region->res);

Do we need the locking? resource stuff all runs under the global
resource_lock so if aim is just to serialize adds and removes that should
be enough. Maybe there is a justification in that being an internal
implementation detail.



>  	sysfs_remove_groups(&dax_region->dev->kobj,
>  			dax_region_attribute_groups);
>  	dax_region_put(dax_region);
> @@ -635,6 +638,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		unsigned long flags)
>  {
>  	struct dax_region *dax_region;
> +	int rc;
>  
>  	/*
>  	 * The DAX core assumes that it can store its private data in
> @@ -667,14 +671,27 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		.flags = IORESOURCE_MEM | flags,
>  	};
>  
> -	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> -		kfree(dax_region);
> -		return NULL;
> +	scoped_guard(rwsem_write, &dax_region_rwsem)
> +		rc = request_resource(&dax_regions, &dax_region->res);
> +	if (rc) {
> +		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +			&dax_region->res);
> +		goto err_res;
>  	}
>  
> +	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups))
> +		goto err_sysfs;
> +
>  	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
>  		return NULL;
>  	return dax_region;
> +
> +err_sysfs:
> +	scoped_guard(rwsem_write, &dax_region_rwsem)
> +		release_resource(&dax_region->res);
> +err_res:
> +	kfree(dax_region);
> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(alloc_dax_region);
>  

