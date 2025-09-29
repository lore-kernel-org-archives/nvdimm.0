Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7166D27D776
	for <nvdimm@lists.linux.dev>; Mon, 29 Sep 2025 09:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136820; cv=none; b=WDMyOeFyWVaSa9KrjgYVV9rIa4MSs95qM7lTb6srraMmUeyn55lV653gPUgfADc+sJ2PI/wwOLmsjibvjzvvCbgosCr1nqPeBONgC+XpFA/LQs2fOLn7NJid0jW18BQktfzHfi7CFeIk9TQP2ycY7nmJgkbUk2k2XsiP0cGembc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136820; c=relaxed/simple;
	bh=CSPO/rbnfWRpJJoD3DKfcBWx25quvAkuTnOXVAVHEgY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uwnEWrQJeNjj4WCeSYP6u/yJnwmxt5fYA5lFJB0wtKdjMOS5CXH5hr7DVs3jt75uyNppa3if3Czrf7FvQrRBVgdkcT4IJZ/RsBZWwRtlLTFuCuuAXG8VTT6OfzwiRzbkLSYQUmJajDGhQUDRrGNeRysLX9WNbsL2eQ8ESHOktGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cZwKx5v3tz6L53B;
	Mon, 29 Sep 2025 17:06:45 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 30CE01402F4;
	Mon, 29 Sep 2025 17:06:56 +0800 (CST)
Received: from localhost (10.47.64.220) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Sep
 2025 10:06:55 +0100
Date: Mon, 29 Sep 2025 10:06:53 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <dan.j.williams@intel.com>,
	<s.neeraj@samsung.com>
Subject: Re: [PATCH v2 2/2] nvdimm: Clean up __nd_ioctl() and remove gotos
Message-ID: <20250929100653.000052c2@huawei.com>
In-Reply-To: <20250923174013.3319780-3-dave.jiang@intel.com>
References: <20250923174013.3319780-1-dave.jiang@intel.com>
	<20250923174013.3319780-3-dave.jiang@intel.com>
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

On Tue, 23 Sep 2025 10:40:13 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Utilize scoped based resource management to clean up the code and
> and remove gotos for the __nd_ioctl() function.
> 
> Change allocation of 'buf' to use kvzalloc() in order to use
> vmalloc() memory when needed and also zero out the allocated
> memory.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

LGTM
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

