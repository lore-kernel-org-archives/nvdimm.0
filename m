Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B2A221F17
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985735; cv=none; b=ZesB/vaBSNzXpXRqn3bL+xOp/jf7VA4xRbOyrydr24s7T5H/9L91BEJ5tPJj/0eMrpDPkPPIn6RCFSDeeojLfkNXg9z1F5FKiE9YWfB5Rosgywrypk2TY6BCPeinX53CP3MOIzO6nslIwdbC5D3AAHypC1cJHlYbFzZ5kGMOKME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985735; c=relaxed/simple;
	bh=ukDC9tBwbT2KmSHyymhYerj4bb7+O4BXdsZpWcrllDo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8MnlhzEidxyehCk1sqZEIVNqU4tUXNsjET6VcRU/PE4qkVTJqQJ0vulNzW+XJ35SYLB7TXFpRKXaaFKuruVtJu5W3t3ER5CZMpckqyc/GG18ETYVe6AL8oTF7NSgKkOfUBvrxmlxxSHiD+gYN3p3K/+PNmcGKwEBQZrSiXCoMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWdCT6GnCzJ46BF;
	Wed, 17 Dec 2025 23:35:01 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C3DC40565;
	Wed, 17 Dec 2025 23:35:31 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 15:35:30 +0000
Date: Wed, 17 Dec 2025 15:35:29 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 13/17] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <20251217153529.00002c2b@huawei.com>
In-Reply-To: <20251119075255.2637388-14-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075332epcas5p2d173f0373aa1ccdfcd4d75c68d5d09fd@epcas5p2.samsung.com>
	<20251119075255.2637388-14-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Wed, 19 Nov 2025 13:22:51 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> For region label update, need to create device attribute, which calls
> nvdimm exported routine thus making pmem_region dependent on libnvdimm.
> Because of this dependency of pmem region on libnvdimm, segregate pmem
> region related code from core/region.c to core/pmem_region.c
> 
> This patch has no functionality change. Its just code movement from
> core/region.c to core/pmem_region.c
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Minor stuff below.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


>  #define SET_CXL_REGION_ATTR(x)
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> new file mode 100644
> index 000000000000..b45e60f04ff4
> --- /dev/null
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -0,0 +1,202 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2020 Intel Corporation. */
> +#include <linux/device.h>
> +#include <linux/memregion.h>
> +#include <cxlmem.h>
> +#include <cxl.h>
> +#include "core.h"
> +
> +/**
> + * DOC: cxl pmem region
> + *
> + * The core CXL PMEM region infrastructure supports persistent memory
> + * region creation using LIBNVDIMM subsystem. It has dependency on
> + * LIBNVDIMM, pmem region need updation of cxl region information into

Perhaps reword as:

pmem region needs to update the cxl region information in the LSA.

> + * LSA. LIBNVDIMM dependency is only for pmem region, it is therefore
> + * need this separate file.

This seems like an explanation for the patch. Not sure we need it
in the final code.  Anyone who considers changing this will rapidly
spot that in the build files.

...

> +static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	NULL,

Whilst here, perhaps drop that trailing , there shouldn't be one on a terminating
entry like this.

> +};

