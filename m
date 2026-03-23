Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9A3BED27
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289026; cv=none; b=EZGwq71/7P+o43BIQlF7yaoCAQDY3GbqPDEz+jFkddaokMYJXHyE8ldgBgZM1DKd9Mh1ZOdJ6bn+Kt4oQlBFbH3syos8TgpKVNKZqZskElGGadX8krRk4UIY2eqPqUFSTPz/mWNa75ikCOw0Hkov4K92QinpclaTWz0tK3JcLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289026; c=relaxed/simple;
	bh=+nCfv8QsmLNwAtl/7UmCupQ+zNAYkVPw/oedoEK48mo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARl02CZRJ6EIan0vwrAgAraUgfp92mri/oA3GPIPXc2S5K/J+euRU9HXTjqBEEuvKh3q/ixcvXFe3j/EM0P6r2NYYc1NPJl8WraIwA99O12SECtzdnsWkS4et8c3q5uX0GEqoG7naJTnQ+lK1qGp3ioL90FSKjMtM/a9Vnw9HDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ffgy612bCzHnGjB;
	Tue, 24 Mar 2026 02:03:10 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id E110A40086;
	Tue, 24 Mar 2026 02:03:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Mar
 2026 18:03:40 +0000
Date: Mon, 23 Mar 2026 18:03:39 +0000
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
Subject: Re: [PATCH v8 8/9] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
Message-ID: <20260323180339.0000518e@huawei.com>
In-Reply-To: <20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Sun, 22 Mar 2026 19:53:41 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> The current probe time ownership check for Soft Reserved memory based
> solely on CXL window intersection is insufficient. dax_hmem probing is not
> always guaranteed to run after CXL enumeration and region assembly, which
> can lead to incorrect ownership decisions before the CXL stack has
> finished publishing windows and assembling committed regions.
> 
> Introduce deferred ownership handling for Soft Reserved ranges that
> intersect CXL windows. When such a range is encountered during the
> initial dax_hmem probe, schedule deferred work to wait for the CXL stack
> to complete enumeration and region assembly before deciding ownership.
> 
> Once the deferred work runs, evaluate each Soft Reserved range
> individually: if a CXL region fully contains the range, skip it and let
> dax_cxl bind. Otherwise, register it with dax_hmem. This per-range
> ownership model avoids the need for CXL region teardown and
> alloc_dax_region() resource exclusion prevents double claiming.
> 
> Introduce a boolean flag dax_hmem_initial_probe to live inside device.c
> so it survives module reload. Ensure dax_cxl defers driver registration
> until dax_hmem has completed ownership resolution. dax_cxl calls
> dax_hmem_flush_work() before cxl_driver_register(), which both waits for
> the deferred work to complete and creates a module symbol dependency that
> forces dax_hmem.ko to load before dax_cxl.
> 
> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

