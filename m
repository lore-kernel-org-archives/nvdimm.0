Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89031E22ED
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294936; cv=none; b=SGdfhCsjlrjLqucgpkyueSuUTCpSpODcuWyvhAwM0MdamgkPfDcPPjAiEp0fcQ5Otpgq1zh7H5kHyDwru9BIRDZomMRXyqDDh1mD8eUnVd5LjM4cQ1D7gE1iMjDbwOthx6KAdjqYyeHNlD/LYt6vGb8qPqdMkIjDTHIX01RWbuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294936; c=relaxed/simple;
	bh=++NFQYD9pKNnBhUiPl8q19h3ZzuSoCYcNY8ZXM5N+4E=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awF35tUU0vSErtAVP9qnjjX+kegVmoHu0eYoxftO1w2uRe7ub5EAKgD97Gy7M9gnVTjJ+jnUSJuPncb583O1Y5n40bin12Cbh3nFUjhdZ/BesIDVmI7DqJIl6Mjh4Un7rnbmAWA9iA2H9VusiLuoD05FvMNV/n929oVxY2V++VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xdnvj1hXnz6K5xw;
	Wed, 30 Oct 2024 21:26:25 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 4882F140B38;
	Wed, 30 Oct 2024 21:28:50 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Oct
 2024 14:28:49 +0100
Date: Wed, 30 Oct 2024 13:28:48 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 03/27] dax: Document struct dev_dax_range
Message-ID: <20241030132848.00001ac7@Huawei.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-3-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
	<20241029-dcd-type2-upstream-v5-3-8739cb67c374@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 29 Oct 2024 15:34:38 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> The device DAX structure is being enhanced to track additional DCD
> information.  Specifically the range tuple needs additional parameters.
> The current range tuple is not fully documented and is large enough to
> warrant its own definition.
> 
> Separate the struct dax_dev_range definition and document it prior to
> adding information for DC.
> 
> Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
