Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6791509AB
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501093; cv=none; b=VHSsYh0AfUkDfH86Hajk/KMaf5NiMmwjyAK7r+L2jYl/OkQ0kMuw01moR49qu/D89+JHKB42WLnfWwwenbTesG4PWBbc3psd83m4UAaB2kRunSxukUyAuCaugSfRyf0me2yjdFaQTaJ+FZN4L9YTVPp+FJ/Pu7H922Fe/P48R2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501093; c=relaxed/simple;
	bh=mQm/J2aUPzeYOj+D0A/H+qDnR+eEdU5S3JQeMefsf+I=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHriDTi6MI294m5dhc2R3Unm0qqiCIdTi3YdGp/5jRObn2Q95Ow4GoHnoKEhIm+ZbWMmjm2QqkFIphPpgCLUX0fmNWVmntV2LwSlMhnlwosQw84dfOm4nZiE6vl2InnA+oRSDejeAlp+o9xsl6gzYAew76UG0zHTZEYCxpDDyOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWRv5xmvzHnGdW;
	Fri, 16 Jan 2026 02:17:47 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3129A4056A;
	Fri, 16 Jan 2026 02:18:10 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:18:09 +0000
Date: Thu, 15 Jan 2026 18:18:08 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 12/17] cxl/pmem: Preserve region information into
 nd_set
Message-ID: <20260115181808.000054e9@huawei.com>
In-Reply-To: <20260109124437.4025893-13-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124527epcas5p1bd7390304b8b6c99a75b0cf4e74b6c12@epcas5p1.samsung.com>
	<20260109124437.4025893-13-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri,  9 Jan 2026 18:14:32 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Save region information stored in cxlr to nd_set during
> cxl_pmem_region_probe in nd_set. This saved region information is being
> stored into LSA, which will be used for cxl region persistence
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
