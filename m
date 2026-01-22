Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892C523ED75
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099173; cv=none; b=a3/OhkB3zI+s95ewVw+DgmHBumeJAlgAEMU0y72B9KL5XT426Vyi+sC9eSgZXNyl5xSuQZbW4yYjdIllgD1qoBx6Sg6P0eFyd3X5VJyr6s8vJpoRotjiA7TY/q+WHw2ud4rqujZNdZaSpsfmRPbb6g9I+rPrdsMGAogAhh4FrqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099173; c=relaxed/simple;
	bh=Yux+13WebJSh2CuLYkyVFAPCg7jEDaQF1QMBa/gn6mw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOVjED57u+NH5EP/ArSCMHQ/2AHVJp+sUv6eZt3nTjN46m2rI7FTzFIZlnsOd6tUp8b4G6Zluwlik+WFVWLfXXgQ2gQBs8YGXOjJH8YZjXaOjhAnEsdErmujJcMBoTAsx1+pxVAko0+pO9zlVna+isXkBLPWUpI/oc3QUkB5QZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dxmcz1cPBzHnGdN;
	Fri, 23 Jan 2026 00:25:23 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 3626740563;
	Fri, 23 Jan 2026 00:25:59 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 16:25:57 +0000
Date: Thu, 22 Jan 2026 16:25:56 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, "Peter Zijlstra"
	<peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>, Terry Bowman
	<terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Zhijian Li <lizhijian@fujitsu.com>, Borislav
 Petkov <bp@alien8.de>, Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v5 4/7] cxl/region: Add helper to check Soft Reserved
 containment by CXL regions
Message-ID: <20260122162556.0000184d@huawei.com>
In-Reply-To: <20260122045543.218194-5-Smita.KoralahalliChannabasappa@amd.com>
References: <20260122045543.218194-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260122045543.218194-5-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 22 Jan 2026 04:55:40 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> Add a helper to determine whether a given Soft Reserved memory range is
> fully contained within the committed CXL region.
> 
> This helper provides a primitive for policy decisions in subsequent
> patches such as co-ordination with dax_hmem to determine whether CXL has
> fully claimed ownership of Soft Reserved memory ranges.
> 
> No functional changes are introduced by this patch.

Given it's not used yet, I'd not have this line of description.
We tend to say things like that on refactor patches.

> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

