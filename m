Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B0038945D
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770055007; cv=none; b=trWDW9kzBg3HtdsMuCpycNwWEGpPmFsNnrGU0xQlHstdSyocAACQv8iZavtSqQ5SGqC1bq8MX251YvbXDr6VtL/1yUDNiNs+sJkHvMxEctxSZ1fo3pGKJbQrB22BpKFe3LSjete+4AEOZVp2IzJgYgtn4wTmBkwd0a8rlIgC0lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770055007; c=relaxed/simple;
	bh=kpllcQBc6+1xmgTcYh1ly8WGdA8ygdor+StBrTsPzEI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJns4O9oJF//qN+E8sOdCx57cbGr3FnU6Lcq6nrWxHmVpz3QSKphQuVT5hdzc54oMV8HLmKThLAzZ7gEIaZ6s1IjRiZYDW4qPSR/GzHwE3OU+TnJyKrTGujw762Zr5p+F/Y36PYEOBphP2b1+FRbE+SPbE5g3CFw5r7X9Z+dplw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Z693ZqSzHnGh8;
	Tue,  3 Feb 2026 01:55:45 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 4CD2340569;
	Tue,  3 Feb 2026 01:56:43 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:56:42 +0000
Date: Mon, 2 Feb 2026 17:56:40 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 5/9] cxl/core/region: move pmem region driver logic into
 pmem_region
Message-ID: <20260202175640.00003ef5@huawei.com>
In-Reply-To: <20260129210442.3951412-6-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-6-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 29 Jan 2026 16:04:38 -0500
Gregory Price <gourry@gourry.net> wrote:

> Move the pmem region driver logic from region.c into pmem_region.c.

Needs to answer the question: Why?

> 
> No functional changes.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
Minor stuff inline.

> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> new file mode 100644
> index 000000000000..81b66e548bb5
> --- /dev/null
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -0,0 +1,191 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <cxlmem.h>
> +#include <cxl.h>
> +#include "core.h"
> +
> +static void cxl_pmem_region_release(struct device *dev)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	int i;
> +
> +	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
> +		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
> +
> +		put_device(&cxlmd->dev);
> +	}
> +
> +	kfree(cxlr_pmem);
> +}
> +
> +static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	NULL,
Maybe sneak in dropping that trailing comma whilst you are moving it.
> +};

> +/**
> + * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
> + * @cxlr: parent CXL region for this pmem region bridge device
> + *
> + * Return: 0 on success negative error code on failure.
> + */
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
...

> +	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
> +	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
> +
> +err:
> +	put_device(dev);
> +err_bridge:
> +	put_device(&cxl_nvb->dev);
> +	cxlr->cxl_nvb = NULL;
> +	return rc;
> +}
> +
> +
Bonus line...

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c


