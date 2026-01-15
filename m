Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0843C198D
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499994; cv=none; b=giAkXvfHedEluatnwfkwv+sf4qTEAFrSFdUnjjIAzZFs72n0/KG4MfOOncCvIybHqeA7u+qAzhn8L1tfOjsX6NI9n20TftAsmD2Z+l3wmjPTzeStSdJx/Oi4KNJu9Z1Nb2qTLmFeXhNBWsDMqeH3WJLmxXAuq9oXCuSeJLPkQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499994; c=relaxed/simple;
	bh=+hDLbP90AzI314WKsiiqsnOn1PwlDIrnSBmCv99Yugw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4SnYcox9DLF+vQYX0K1baA5WD+XOmRvLu+dybivwhPQBKzZ4MRoK8/nhDKHEH606racOciowf/ORNqfo6Bz95RCwoimGCoaWiIMM3kqtvV4GgmcOxDdPcWAEDn6wmO09245dHlgcF/CiVc9El+oDSI+FT9IibphfPJUQlVhUP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsW2m2lpnzHnGd0;
	Fri, 16 Jan 2026 01:59:28 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B173C40570;
	Fri, 16 Jan 2026 01:59:50 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 17:59:49 +0000
Date: Thu, 15 Jan 2026 17:59:48 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 06/17] nvdimm/label: Preserve region label during
 namespace creation
Message-ID: <20260115175948.00007597@huawei.com>
In-Reply-To: <20260109124437.4025893-7-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124518epcas5p26832d0b4ae4017cb3afbd613bf58eabd@epcas5p2.samsung.com>
	<20260109124437.4025893-7-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:26 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> During namespace creation we scan labels present in LSA using
> scan_labels(). Currently scan_labels() is only preserving
> namespace labels into label_ent list.
> 
> In this patch we also preserve region label into label_ent list
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
