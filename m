Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03808226CF6
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769171851; cv=none; b=qaIITh8X2KkgFeB+c2j0BPXMl3OJu4l99mSqzQhQcn+3DxNS6esPQz+A0Z3WeWvvsgYU1aFJWoCH2PEbB8l0ZbqANDwOdIv/AOTfBGWZ12nDJ4qCYlXwO6I4r1IWVtVmHmAKuNSoXxwPLtjn/3Py4bBIGHha3QXjAC5VkM5jg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769171851; c=relaxed/simple;
	bh=LK7p3XtuzIC8VkarNSeFwttf5rhPN5CAIMSAY3l4Un4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eqnnCusyVU4JuxH+lkvb40s84vgqW/263AnrGnLyrLKO+z1ft5xSfVBF2C+Ps43zFOpn/3RGTi9sbHdARP0grkOP2MOHm1B2M09Rcc6Y3va34g8M0cW1c6s3apydJLzL0t+Szh3SRg9SKKj3Svnyus+Uiyp9EmpvH99nK+I7OyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dyHVw1hw8zJ46cw;
	Fri, 23 Jan 2026 20:36:56 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 9323540569;
	Fri, 23 Jan 2026 20:37:25 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 12:37:25 +0000
Date: Fri, 23 Jan 2026 12:37:23 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V6 11/18] cxl/region: Rename __create_region() to
 cxl_create_region()
Message-ID: <20260123123723.00004277@huawei.com>
In-Reply-To: <20260123113112.3488381-12-s.neeraj@samsung.com>
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113140epcas5p4bc7a864d4a717b96afcb863e3200b3a2@epcas5p4.samsung.com>
	<20260123113112.3488381-12-s.neeraj@samsung.com>
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

On Fri, 23 Jan 2026 17:01:05 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Currently __create_region() is a static routine used within region.c
> So to use it from another file rename it to cxl_create_region().
> 
> Later patch will create cxl region after fetching region information
> from LSA using cxl_create_region() along with two extra function
> parameters.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
