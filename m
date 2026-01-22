Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3313EA2A7
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769098618; cv=none; b=L72CujdD+Rnxs1/HrLVERU0ZAJUZ/V1XCBB/6LG9cwm2U/PZoE60pMgeIz1ykXpNgudY+kNXKF0M6cSxMLMEr6vD2gah+4aJpebmVKkCeTnzOsD6Nrox5aaXehJLOl5hF4kal0zpjOji3FdYDzjWMKanFLqmNyxY4biOsCDxuyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769098618; c=relaxed/simple;
	bh=XKkCajLL25icKDNtpCFBJmCpoEN/dxlJmGiEXPdER9Q=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMrIFYkpfAqkw2hjop/kyvhV89i3o3Tmevx8jXO0NG104U6qRGBjWe7TOQTl5e5ghPn/kkK6RhqQhssroBYlx37y9oprxhLg5poPcBJTm18kY6oqTHInb0VsYv+3YZp4QYg2HtSAgszlst7VQ7Eg7Ch6SUt+FZ9j/BYL9VkfeYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dxmQQ2QrwzJ467l;
	Fri, 23 Jan 2026 00:16:14 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 494EF4056B;
	Fri, 23 Jan 2026 00:16:42 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 16:16:41 +0000
Date: Thu, 22 Jan 2026 16:16:39 +0000
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
Subject: Re: [PATCH v5 1/7] dax/hmem: Request cxl_acpi and cxl_pci before
 walking Soft Reserved ranges
Message-ID: <20260122161639.00004dd3@huawei.com>
In-Reply-To: <20260122045543.218194-2-Smita.KoralahalliChannabasappa@amd.com>
References: <20260122045543.218194-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260122045543.218194-2-Smita.KoralahalliChannabasappa@amd.com>
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

On Thu, 22 Jan 2026 04:55:37 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> From: Dan Williams <dan.j.williams@intel.com>
> 
> Ensure cxl_acpi has published CXL Window resources before HMEM walks Soft
> Reserved ranges.
> 
> Replace MODULE_SOFTDEP("pre: cxl_acpi") with an explicit, synchronous
> request_module("cxl_acpi"). MODULE_SOFTDEP() only guarantees eventual
> loading, it does not enforce that the dependency has finished init
> before the current module runs. This can cause HMEM to start before
> cxl_acpi has populated the resource tree, breaking detection of overlaps
> between Soft Reserved and CXL Windows.
> 
> Also, request cxl_pci before HMEM walks Soft Reserved ranges. Unlike
> cxl_acpi, cxl_pci attach is asynchronous and creates dependent devices
> that trigger further module loads. Asynchronous probe flushing
> (wait_for_device_probe()) is added later in the series in a deferred
> context before HMEM makes ownership decisions for Soft Reserved ranges.
> 
> Add an additional explicit Kconfig ordering so that CXL_ACPI and CXL_PCI
> must be initialized before DEV_DAX_HMEM. This prevents HMEM from consuming
> Soft Reserved ranges before CXL drivers have had a chance to claim them.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
