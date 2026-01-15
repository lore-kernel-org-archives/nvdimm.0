Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26CF2D73B4
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500229; cv=none; b=YO8evGhGZffrfdtrEF/JSsaKMlAzqEwUpDzMz/gYip7t1k/ruXrwzqw1j2ZILpBh8eDXGrPDIP1IOJAyYl8cFnTBMOShdRnw1k6Q6vS4keK476aTgL+9j4yyf4I+nqDD7+zzmfTvxBW44AKn6fypaDJ9jJTqnzY4YTW302Qgr0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500229; c=relaxed/simple;
	bh=KqrVLid3vJppCVjGiciBl6PGQazPg4vFyDfN7gmWdUc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKoTdJN+JWq/MgyaxIdLbB7yyIcmUppr7GC1PsLMEAwPewlXCpEOBzxoI8ztcthd1NSIfYSxBTi7T+7cOTfcC+xpoPVcViXv+EeB+tpdLoRJt2cYIv1NrXmT3yaGkQPne3V1MaySX5WxFSLOEJxK0afSoNg/JJ4pqOh2OAeAmy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsW7P3GGdzJ467W;
	Fri, 16 Jan 2026 02:03:29 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1ADF540570;
	Fri, 16 Jan 2026 02:03:46 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:03:45 +0000
Date: Thu, 15 Jan 2026 18:03:44 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 09/17] nvdimm/label: Export routine to fetch region
 information
Message-ID: <20260115180344.0000188c@huawei.com>
In-Reply-To: <20260109124437.4025893-10-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3@epcas5p2.samsung.com>
	<20260109124437.4025893-10-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:29 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> CXL region information preserved from the LSA needs to be exported for
> use by the CXL driver for CXL region re-creation.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
