Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7251EFFAE
	for <nvdimm@lists.linux.dev>; Fri,  4 Apr 2025 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743774308; cv=none; b=aOCjp/d8YvexeY4mGoVP6KVV5414WfVls85dUe9SgQj9EjYizOkafNaovTYwmUsiMQjv0OvuJlLHBslsqhzwdN5RG49rleHuaNKUTGn8sS/Li8Yo7eQac+8HeSofNLzDj/hHwkPims+fvjXbuAz8zLxaoiBKsRujpOQ2WfIF6p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743774308; c=relaxed/simple;
	bh=hYzBcEMK2g7NFxBsAvkI946fDR+FoPc0bhqBZz/paf4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OFrcnAuUb8EXShzdnCMS3IRefyuqld/dqJ/iZiAummY21YskHN0aGy8Rkzrn6pMt+UK9OCd2k3QF3nWD1kYe0kak3tBOfj4TLDy6ZtvNGhuLY5his9B//vNRqwKp/sCL+5F91lmt6tsNBSfeRzkRvgtYWlkn+3mDfGJL2J6luT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZTfwP0BGBz67kSy;
	Fri,  4 Apr 2025 21:44:21 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 829FC14062A;
	Fri,  4 Apr 2025 21:45:03 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 4 Apr
 2025 15:45:03 +0200
Date: Fri, 4 Apr 2025 14:45:01 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <20250404144501.00003149@huawei.com>
In-Reply-To: <20250402015920.819077-1-gourry@gourry.net>
References: <20250402015920.819077-1-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue,  1 Apr 2025 21:59:20 -0400
Gregory Price <gourry@gourry.net> wrote:

> Device capacity intended for use as system ram should be aligned to the
> archite-defined memory block size or that capacity will be silently

archite?

> truncated and capacity stranded.
> 
> As hotplug dax memory becomes more prevelant, the memory block size
> alignment becomes more important for platform and device vendors to
> pay attention to - so this truncation should not be silent.
> 
> This issue is particularly relevant for CXL Dynamic Capacity devices,
> whose capacity may arrive in spec-aligned but block-misaligned chunks.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

One trivial comment inline otherwise seems reasonable to me.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  drivers/dax/kmem.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index e97d47f42ee2..32fe3215e11e 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -13,6 +13,7 @@
>  #include <linux/mman.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/string_helpers.h>
>  #include "dax-private.h"
>  #include "bus.h"
>  
> @@ -68,7 +69,7 @@ static void kmem_put_memory_types(void)
>  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  {
>  	struct device *dev = &dev_dax->dev;
> -	unsigned long total_len = 0;
> +	unsigned long total_len = 0, orig_len = 0;
>  	struct dax_kmem_data *data;
>  	struct memory_dev_type *mtype;
>  	int i, rc, mapped = 0;
> @@ -97,6 +98,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct range range;
>  
> +		orig_len += range_len(&dev_dax->ranges[i].range);
>  		rc = dax_kmem_range(dev_dax, i, &range);
>  		if (rc) {
>  			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
> @@ -109,6 +111,12 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	if (!total_len) {
>  		dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
>  		return -EINVAL;
> +	} else if (total_len != orig_len) {
> +		char buf[16];
> +
> +		string_get_size((orig_len - total_len), 1, STRING_UNITS_2,

Trivial but do those inner brackets really add anything?

> +				buf, sizeof(buf));
> +		dev_warn(dev, "DAX region truncated by %s due to alignment\n", buf);
>  	}
>  
>  	init_node_memory_type(numa_node, mtype);

