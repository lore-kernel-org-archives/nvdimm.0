Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7731E3DCF
	for <nvdimm@lists.linux.dev>; Mon, 29 Sep 2025 09:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136725; cv=none; b=P12hXz4duF0YVyJCbkvBbmEN36jQX3Sf8N7Sx/5V1Kmu/Tzfvzr5f/9ZjtDv7VNKsUDf89J2sEBptcqsjGv3zEmrLPOtTgLWXK7bCE0lmoJqDZBYdgNnEHPtK/+i9NYjcEJA2hMRBz5U3sofEx9ckxObUE4gYvomOX8qy+7bSs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136725; c=relaxed/simple;
	bh=KASToVAm/GIBg3WnkabuJZsUgvpbP1SGSeY7J1mfeTE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PSa0iI3/CKp5/V+Z3qc7AEDoPvILSVYjdTzxtBH+rWgX9QWfZhmCpdOjyQoEFPU6TlX2cTedCAwJlMw5eXr7rLwpU4hTMvzLP3kpLwuOPNA5wuDppINY5sjn6btPNvyVJEkLGOo9k1KxXseqYha7E6wqup9QUwnH52hVXZOsvW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cZwFl6x47z6L53K;
	Mon, 29 Sep 2025 17:03:07 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F351D1402F4;
	Mon, 29 Sep 2025 17:05:14 +0800 (CST)
Received: from localhost (10.47.64.220) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Sep
 2025 10:05:04 +0100
Date: Mon, 29 Sep 2025 10:05:01 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <dan.j.williams@intel.com>,
	<s.neeraj@samsung.com>
Subject: Re: [PATCH v2 1/2] nvdimm: Introduce guard() for nvdimm_bus_lock
Message-ID: <20250929100501.00004bc6@huawei.com>
In-Reply-To: <20250923174013.3319780-2-dave.jiang@intel.com>
References: <20250923174013.3319780-1-dave.jiang@intel.com>
	<20250923174013.3319780-2-dave.jiang@intel.com>
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
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 23 Sep 2025 10:40:12 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Converting nvdimm_bus_lock/unlock to guard() to clean up usage
> of gotos for error handling and avoid future mistakes of missed
> unlock on error paths.
> 
> Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Nice.

I still wince a little the places where sharing a dev_dbg()
leads to more complex code flow that we'd otherwise have, but that
is probably not worth the effort of cleaning up further.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
> v2:
> - Moved cleanup of __nd_ioctl() cleanup to a different patch. (Dan)
> - Various minor fixes and cleanups. (Jonathan)
> ---
>  drivers/nvdimm/badrange.c       |   3 +-
>  drivers/nvdimm/btt_devs.c       |  24 +++----
>  drivers/nvdimm/bus.c            |   6 +-
>  drivers/nvdimm/claim.c          |   7 +-
>  drivers/nvdimm/core.c           |  17 +++--
>  drivers/nvdimm/dax_devs.c       |  12 ++--
>  drivers/nvdimm/dimm.c           |   5 +-
>  drivers/nvdimm/dimm_devs.c      |  48 +++++--------
>  drivers/nvdimm/namespace_devs.c | 117 +++++++++++++++----------------
>  drivers/nvdimm/nd.h             |   3 +
>  drivers/nvdimm/pfn_devs.c       |  61 +++++++----------
>  drivers/nvdimm/region.c         |  14 ++--
>  drivers/nvdimm/region_devs.c    | 118 ++++++++++++++------------------
>  drivers/nvdimm/security.c       |  10 +--
>  14 files changed, 194 insertions(+), 251 deletions(-)

