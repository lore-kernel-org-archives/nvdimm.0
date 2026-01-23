Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1860A2741AB
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 12:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769172599; cv=none; b=M8do4/XzgutszdPt0DLmLGRK/aHhE3PDGwOmH2c577p6MSJ2bE7ZqLbF2qmEwEk7Wev9DRM3E0ItfD/94xNSEJ8ObJDIwWfZU360ugR7PnCe2tcrDYS7ScqEhFTEPXIDv6un2S2cNsQ56lphi9fSv0RYJbVL/WJROfIVYrkyBMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769172599; c=relaxed/simple;
	bh=yQ+r69jgqz6ryIBrbS+b/Z/i6dREkQsh5etFmNwoxm8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eIABHq9AdgkFGqJEXEAxt0Jp9Y0vcV0mQJ+3ITWP6agvDfpSYc+0Temc+2CK6RsP2Z4UVhDD9f0VbiPDgMII5H3I3nbyypYdCPKfBajrAi6zvf4+hg+9RrDcPiR3TvyDy4dsGsAU78SUnVJiC36QUv/uAuDWkcQQj+3RCUegT7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dyHn86nz4zHnH2m;
	Fri, 23 Jan 2026 20:49:16 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 93CCD40572;
	Fri, 23 Jan 2026 20:49:54 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 12:49:43 +0000
Date: Fri, 23 Jan 2026 12:49:41 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V6 17/18] cxl/pmem_region: Create pmem region using
 information parsed from LSA
Message-ID: <20260123124941.00007c37@huawei.com>
In-Reply-To: <20260123113112.3488381-18-s.neeraj@samsung.com>
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113149epcas5p1884531875d9676391e7ccc66a0f314d4@epcas5p1.samsung.com>
	<20260123113112.3488381-18-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Fri, 23 Jan 2026 17:01:11 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> create_pmem_region() creates CXL region based on region information
> parsed from the Label Storage Area (LSA). This routine requires cxl
> endpoint decoder and root decoder. Add cxl_find_root_decoder_by_port()
> and cxl_find_free_ep_decoder() to find the root decoder and a free
> endpoint decoder respectively.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
