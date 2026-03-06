Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C9837B3EC
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792588; cv=none; b=Hh+SGlJPkNbWD778MgJEGlDOdtFLHHcBGRVX6dcw8H8Go0Fll/Qhtas2xOEt7a1D3f5PCez6RFx+SfZDI+neeGvDWdKV0ZCBWhUwHnocvNgUME+iYVoex0L1W+HNPHk6fzk700HZkeaFWsVltKXu4bZNLHfdZhWAqWNBDbUetlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792588; c=relaxed/simple;
	bh=V2U4y78pnVdswONpocjUIQMSDnANqHWTkbe7TvA63rw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=gb9Q7Xrl/wHyBBWLKxnyhUXd9z9hVD91C+Zidege9W6lNr4yPknnv5CU6pgnVT0qrlnZ7QywxctA+RyIS1zgP9jpnVosRPv6bfU8UnenfbfXFit0tWtBKp4Eu0GPdSdRHDfEetZurInhC/Eijio02muE89MRDOxSD7Hly7MD+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lg24+BCr; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lg24+BCr"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260306102303epoutp03c22d9e4e1da39e584d30b0706506ae71~aOXZAoZNW2328223282epoutp03h
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 10:23:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260306102303epoutp03c22d9e4e1da39e584d30b0706506ae71~aOXZAoZNW2328223282epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772792583;
	bh=x6n4TB9SALV9vPu04bQI6+D9lMWrud9GB2IyZMDwa9k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lg24+BCrRRmoX1dm8ElOe37YSPr6prbUKN38GbDmbU7kMNS2mFwRHrFJoKitFwY1P
	 av7NBPJMljA62q96BjHjbjigKCItaHxvY+KXa95ik5bOcidIR5v+EGw9bB1wUn1k8U
	 HZr6/N7LTP6sXzQeDVZSxCZEdXjngXxBO/6cUfFM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260306102303epcas5p2477cd8981374ef7534f8ac88d8c74148~aOXYtz9hZ1186111861epcas5p25;
	Fri,  6 Mar 2026 10:23:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fS2Y30CMdz6B9m6; Fri,  6 Mar
	2026 10:23:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260306102207epcas5p1b799e7ce78ee07d71c3c638c3412d28a~aOWk_nmPI1322513225epcas5p1A;
	Fri,  6 Mar 2026 10:22:07 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260306102205epsmtip2d4819a6e14d38418e215918023d45973~aOWjjLT902731127311epsmtip2X;
	Fri,  6 Mar 2026 10:22:05 +0000 (GMT)
Date: Fri, 6 Mar 2026 15:52:00 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V6 10/18] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <158453976.61772792583024.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <1b67c345-1594-4221-b699-e26a00d17bfc@intel.com>
X-CMS-MailID: 20260306102207epcas5p1b799e7ce78ee07d71c3c638c3412d28a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73baa_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6@epcas5p4.samsung.com>
	<20260123113112.3488381-11-s.neeraj@samsung.com>
	<ff946a84-11bb-4956-beba-bf7bfbfecd7a@intel.com>
	<1b67c345-1594-4221-b699-e26a00d17bfc@intel.com>

------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73baa_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 27/01/26 04:45PM, Dave Jiang wrote:
>
>
>On 1/26/26 3:48 PM, Dave Jiang wrote:
>>
>>
>> On 1/23/26 4:31 AM, Neeraj Kumar wrote:
>>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>>> used to get called at last in cxl_endpoint_port_probe(), which requires
>>> cxl_nvd presence.
>>>
>>> For cxl region persistency, region creation happens during nvdimm_probe
>>> which need the completion of endpoint probe.
>>>
>>> In order to accommodate both cxl pmem region auto-assembly and cxl region
>>> persistency, refactored following
>>>
>>> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>>>    will be called only after successful completion of endpoint probe.
>>>
>>> 2. Create cxl_region_discovery() which performs pmem region
>>>    auto-assembly and remove cxl pmem region auto-assembly from
>>>    cxl_endpoint_port_probe()
>>>
>>> 3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
>>>    called during cxl_pci_probe() in context of cxl_mem_probe()
>>>
>>> 4. As cxlmd->attach->probe() calls registered cxl_region_discovery(), so
>>>    move devm_cxl_add_nvdimm() before cxlmd->attach->probe(). It guarantees
>>>    both the completion of endpoint probe and cxl_nvd presence before
>>>    calling cxlmd->attach->probe().
>>>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>>
>> Hi Neeraj,
>> Just FYI this is the patch that breaks the auto-region assemble in cxl_test.
>
>So it's missing this part in cxl_test. cxl_test auto region is now showing up. But now I'm hitting some lockdep issues.
>
>---
>diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>index cb87e8c0e63c..03af15edd988 100644
>--- a/tools/testing/cxl/test/mem.c
>+++ b/tools/testing/cxl/test/mem.c
>@@ -1686,6 +1686,7 @@ static void cxl_mock_test_feat_init(struct cxl_mockmem_data *mdata)
>
> static int cxl_mock_mem_probe(struct platform_device *pdev)
> {
>+       struct cxl_memdev_attach memdev_attach = { 0 };
>        struct device *dev = &pdev->dev;
>        struct cxl_memdev *cxlmd;
>        struct cxl_memdev_state *mds;
>@@ -1767,7 +1768,8 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>
>        cxl_mock_add_event_logs(&mdata->mes);
>
>-       cxlmd = devm_cxl_add_memdev(cxlds, NULL);
>+       memdev_attach.probe = cxl_region_discovery;
>+       cxlmd = devm_cxl_add_memdev(cxlds, &memdev_attach);
>        if (IS_ERR(cxlmd))
>                return PTR_ERR(cxlmd);
>
>---
>
>
>>
>> DJ

Hi Dave,

Yes using the above snippet auto region failure is getting fixed.
But still with above fix cxl-topology.sh is failing.

Actually we have a test case in cxl-topology.sh where we disable
mem device and check its availability after enabling it. And this
test case is failing in this case.

I am working on multi interleave support. I will test this with
next series and fix it accordingly.


Regards,
Neeraj

------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73baa_
Content-Type: text/plain; charset="utf-8"


------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73baa_--

