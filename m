Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D73C198C
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501749; cv=none; b=LnvFWd6mf54tmk2jKH8itaox6nMUataJZ6xORTI5Pk8HJdlrwSj0j3rx9yVr9Y5IhB7W2XbUkLk+VJlWC8tfbuyNMj2xWr20F04xBfFPtdYEjRxn2VpFwvPbRUr0qxR5NwS9e+y8GboYXdRrnL0wNin91KTu3H5BZLKChcfiNr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501749; c=relaxed/simple;
	bh=wef3s0+14TdvZHVDo/RiwclM0K18Q3W8MnDhLTAegJE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZorPxXMOFzknna/4VIDEMZ5ONUPlzujz02DctSUb1CP7GTu1H9N9IjiHYXVby9q+fGC96GqjKf2P1uBcNQKYtZ+xp7rZdeKKAG4rd7Xay6MLVDAiqsoKNyxNA6WDLEQc8AUREMtTkQP6YxpLD2Z98wGFZ7QslVTfq/igT9dja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWhd1BgvzJ467W;
	Fri, 16 Jan 2026 02:28:49 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id CF63040584;
	Fri, 16 Jan 2026 02:29:05 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:29:05 +0000
Date: Thu, 15 Jan 2026 18:29:03 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 17/17] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Message-ID: <20260115182903.00004a3a@huawei.com>
In-Reply-To: <20260109124437.4025893-18-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124534epcas5p47d59d746b77254f428735268d7731623@epcas5p4.samsung.com>
	<20260109124437.4025893-18-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:37 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
> cxl region based on region information parsed from LSA
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
