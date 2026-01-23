Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFAD1F4CA9
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 12:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769171962; cv=none; b=BzS0z9yPRWyM4NIKh2P1wCPaRqe/TTQ3GKjf4p07L5U54fa1NcCmq5eCpDOmG3UrUZZZmDZpzu9qJ+cH041S8YLpZkrwC8eim8372GjgR9ullhdlbmJLfliDTUzWbKjNOcWqwjNd6uXejkcUiCG3InL/ih4i7bgVO9XXP5xbFB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769171962; c=relaxed/simple;
	bh=8WKa21WyH8aH/bMeJ0YR9E96wObmmr7POwfwLp8tfy0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuUEhYxRN2WAkRHc/MjuINYVZdz4MUP18tPkAe/Pm9inN3qs+tLih5KWUyG+U6ZJ36CQUuEK7CxmiSoiPBzSdZQzkJiL6Y44Gh0ydon5YlTVHCY3R6zcaLtvn4QnCPzX+St19/Usd+Uc27AcRQONaVMGH5E8YK5DeFm23zPopz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dyHXx57BvzHnH6P;
	Fri, 23 Jan 2026 20:38:41 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 5FD0840570;
	Fri, 23 Jan 2026 20:39:19 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 12:39:18 +0000
Date: Fri, 23 Jan 2026 12:39:17 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V6 12/18] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <20260123123917.00006d92@huawei.com>
In-Reply-To: <20260123113112.3488381-13-s.neeraj@samsung.com>
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b@epcas5p4.samsung.com>
	<20260123113112.3488381-13-s.neeraj@samsung.com>
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

On Fri, 23 Jan 2026 17:01:06 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> devm_cxl_pmem_add_region() is used to create cxl region based on region
> information scanned from LSA.
> 
> devm_cxl_add_region() is used to just allocate cxlr and its fields are
> filled later by userspace tool using device attributes (*_store()).
> 
> Inspiration for devm_cxl_pmem_add_region() is taken from these device
> attributes (_store*) calls. It allocates cxlr and fills information
> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
> region creation porbes
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
