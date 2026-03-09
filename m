Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF95DDA9
	for <nvdimm@lists.linux.dev>; Mon,  9 Mar 2026 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773066707; cv=none; b=m3fhieL+RQCZ9yGIwKfRVoX593DDLJfbPVGMTEJulKq464GGtcEZuVpsaTHiyQjl7qfLLHxhpy+JQT3NfU91qI2d8RQUZf00G4hAG1Ucb1LnjyyiEomweMnUs0ev4cC4gLvHoAYSgaH6zFK+daakfe6gWeYejlci18KgjFtq6q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773066707; c=relaxed/simple;
	bh=A2xnDBZ/7H4/KWMz+g2KWxqXjH1hw8+EU0vRLJ6iDyQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLf4J/RTL/icANvGIkmNZzsnX3a0iKuw1lB+wOJdy7Tj8DlmeUS9fiH4wh4I0kH9yojtsWdkNWudm4xsDMjfwfrqpkLgR03xs3f28A0xN8jtRw2bwvVu18PtTUuiZYGwvbwXfZ98dRJOBp8eqLR297sI9KVPRqV7bK419Jtl6NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fTzwT3G2NzHnH4q;
	Mon,  9 Mar 2026 22:31:37 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 5478B4056B;
	Mon,  9 Mar 2026 22:31:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 9 Mar
 2026 14:31:39 +0000
Date: Mon, 9 Mar 2026 14:31:38 +0000
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
Subject: Re: [PATCH v6 4/9] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
Message-ID: <20260309143138.000004c1@huawei.com>
In-Reply-To: <20260210064501.157591-5-Smita.KoralahalliChannabasappa@amd.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260210064501.157591-5-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 10 Feb 2026 06:44:56 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> From: Dan Williams <dan.j.williams@intel.com>
> 
> Move hmem/ earlier in the dax Makefile so that hmem_init() runs before
> dax_cxl.
> 
> In addition, defer registration of the dax_cxl driver to a workqueue
> instead of using module_cxl_driver(). This ensures that dax_hmem has
> an opportunity to initialize and register its deferred callback and make
> ownership decisions before dax_cxl begins probing and claiming Soft
> Reserved ranges.
> 
> Mark the dax_cxl driver as PROBE_PREFER_ASYNCHRONOUS so its probe runs
> out of line from other synchronous probing avoiding ordering
> dependencies while coordinating ownership decisions with dax_hmem.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Bit of a hack but I don't have a better idea.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
