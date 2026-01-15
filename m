Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890C22D663D
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501157; cv=none; b=f/jrkHKLl90vAjohpQBh/g7tY9yEdeADaa+twV3udgKPdt0xfii2ckVYwkr2IBEaXaH9Np1ById6O6d2NgS8VWd582wbbPrh8383jXq/tIHY18Gt/4s0Jv7hYymf4a+uytXHNmN5eEv3x2qgl/7Zh8AXGIz0t6u3plcfDPQ1Ti8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501157; c=relaxed/simple;
	bh=vcyK4bdZjW9T32FXOmolJ/JwUbPZ65GSKQHR4NUPIg4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRm0GCCiSk4lTvwykODR42NaIEzf+TwgIwrH6ZVQwQgxWiYwGSuIGJzYLIoqjPNSaV3Xm3/R8coDVojmm/Kk9oOG0I5esJinW9VRz7gZUHb73e7qn8XPiFnp75AOq2syuqQ7LDh5WTBskWvJzUNtfhE15tTOyg3CATI2loIQsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWTD4g8gzJ468G;
	Fri, 16 Jan 2026 02:18:56 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4FDB140569;
	Fri, 16 Jan 2026 02:19:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:19:12 +0000
Date: Thu, 15 Jan 2026 18:19:11 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 14/17] cxl/pmem_region: Introduce
 CONFIG_CXL_PMEM_REGION for core/pmem_region.c
Message-ID: <20260115181911.000010c2@huawei.com>
In-Reply-To: <20260109124437.4025893-15-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124529epcas5p1d740589383c6428ce53b454f8ed42307@epcas5p1.samsung.com>
	<20260109124437.4025893-15-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:34 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> As pmem region label update/delete has hard dependency on libnvdimm.
> It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
> control. It handles the dependency by selecting CONFIG_LIBNVDIMM
> if not enabled.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


