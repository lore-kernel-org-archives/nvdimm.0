Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27F93CBE72
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773930957; cv=none; b=jfzG8TMfjmDYrT9PAzJ2A6PMpHgkzXCaWw4d+c/DaDiuoPfVCPai6/y2GB82CrKUZT2oS5znWDyjpMSiBgvfcpRkftuFmIv4gIQqffg8oiBLdga2KGJnahzM4q6RG1W7g7jsgX5AxNhV6uWLNbhlrahGgeoK2t3pB+bq3voJFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773930957; c=relaxed/simple;
	bh=kCFcyI/VQpnscCbjgeBI5ADhG7SSHRdxxGKfbAtuAsA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hoQ7yrC20fg6Cq8tXLs8ltgOl1B7zYG+DxUOosQKI//4i9nBVRMXNzfKIzToenv/rjFtkooP3q/r69Da0RNvGocnty3wF7494h5+nLs2WyLw449rjmCdmb8rzL+hyDCvGo4ShEyg+NJS0oze0rYPVf/gxnbTGhG2ZdqY1c8gqRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc7Wd15CCzJ46Zg;
	Thu, 19 Mar 2026 22:34:53 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id A01A140569;
	Thu, 19 Mar 2026 22:35:52 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 14:35:51 +0000
Date: Thu, 19 Mar 2026 14:35:49 +0000
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
Subject: Re: [PATCH v7 7/7] dax/hmem: Reintroduce Soft Reserved ranges back
 into the iomem tree
Message-ID: <20260319143549.00005394@huawei.com>
In-Reply-To: <20260319011500.241426-8-Smita.KoralahalliChannabasappa@amd.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260319011500.241426-8-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 19 Mar 2026 01:15:00 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> Reworked from a patch by Alison Schofield <alison.schofield@intel.com>
> 
> Reintroduce Soft Reserved range into the iomem_resource tree for HMEM
> to consume.
> 
> This restores visibility in /proc/iomem for ranges actively in use, while
> avoiding the early-boot conflicts that occurred when Soft Reserved was
> published into iomem before CXL window and region discovery.
> 
> Link: https://lore.kernel.org/linux-cxl/29312c0765224ae76862d59a17748c8188fb95f1.1692638817.git.alison.schofield@intel.com/
> Co-developed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Co-developed-by: Zhijian Li <lizhijian@fujitsu.com>
> Signed-off-by: Zhijian Li <lizhijian@fujitsu.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
One minor update needed as kmalloc_obj() has shown up in meantime.

Thanks

Jonathan
> ---
>  drivers/dax/hmem/hmem.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 8c574123bd3b..15e462589b92 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -72,6 +72,34 @@ void dax_hmem_flush_work(void)
>  }
>  EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
>  
> +static void remove_soft_reserved(void *r)
> +{
> +	remove_resource(r);
> +	kfree(r);
> +}
> +
> +static int add_soft_reserve_into_iomem(struct device *host,
> +				       const struct resource *res)
> +{
> +	int rc;
> +
> +	struct resource *soft __free(kfree) =
> +		kmalloc(sizeof(*res), GFP_KERNEL);

Update to

	struct resource *soft __free(kfree) = kmalloc_obj(*soft);

Got added in 7.0 with lots of call sites updated via scripting.

Not sure why this had sizeof(*res) rather than sizeof(*soft).
Same type but should have been soft!  If nothing else that would
probably have broken the scripts looking for where we should
be using kmalloc_obj().


	
> +	if (!soft)
> +		return -ENOMEM;
> +
> +	*soft = DEFINE_RES_NAMED_DESC(res->start, (res->end - res->start + 1),
> +				      "Soft Reserved", IORESOURCE_MEM,
> +				      IORES_DESC_SOFT_RESERVED);
> +
> +	rc = insert_resource(&iomem_resource, soft);
> +	if (rc)
> +		return rc;
> +
> +	return devm_add_action_or_reset(host, remove_soft_reserved,
> +					no_free_ptr(soft));
> +}
> +
>  static int hmem_register_device(struct device *host, int target_nid,
>  				const struct resource *res)
>  {
> @@ -94,7 +122,9 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	if (rc != REGION_INTERSECTS)
>  		return 0;
>  
> -	/* TODO: Add Soft-Reserved memory back to iomem */
> +	rc = add_soft_reserve_into_iomem(host, res);
> +	if (rc)
> +		return rc;
>  
>  	id = memregion_alloc(GFP_KERNEL);
>  	if (id < 0) {

