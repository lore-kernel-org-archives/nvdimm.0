Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09CB37BE62
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792589; cv=none; b=cNyKW0RdBkU/2Zcd8T9hAWip7G8n822+ILg7uyPMKqJekccMqWeGAbovkMuxfsJAmq7qf3sHrGtFfGaGEFwSxiYh9X/znQLVCHNgsnsZiyhlYU1Rjlhn1NuaFk7dHF60BF3ihJNPN10J8ze/eb2Nplhw3auF/a0axp0Fsy8NYy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792589; c=relaxed/simple;
	bh=llKCHXdw7HaWtRkgToTXwvibYuBCCnUG18z8l59omFg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=D0p3ZCTkJDQ4OPoHrm3nuqeu4gYLqfcBb9Zngu3oaRoxIN28H8qFP7JDIHj/Ey1mJuaOOw+oJOW71qYUNe/x+MI0vNnHO8wA9Ye/YZbcxZb6Q6UEVpD6VHPGKU9/n54WsuZ3xbM7XvqNY8lNeIo0E0EjAFZc0SC6Vgp2q8EIoTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZgsLYEXt; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZgsLYEXt"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260306102303epoutp02cc11f582554d3239cff8ef28c5e92736~aOXY80-sz0509005090epoutp02F
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 10:23:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260306102303epoutp02cc11f582554d3239cff8ef28c5e92736~aOXY80-sz0509005090epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772792583;
	bh=zPFwpblfkVVYchR/5zAU82Z+Hg+HnHJvXX+N+JoETqc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZgsLYEXt9EtMObwF2D9huxVHC1YC/M757e6/DWAD6LRRtbk+47wTiGFeyNtKhu6l7
	 Pad5ekYrBvuuoP5nK8AoHhDoJxrtjqtY7wgPBsDW/WyXWM3z2vFckdcWK0oCMske9O
	 PgM6Zhg1b6v7cmC8hBk4v5azNxMKVEfO1UJYl5xE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260306102302epcas5p202b4142953e01d7cb9f57fad9e5d208f~aOXYjzMZp1476614766epcas5p2U;
	Fri,  6 Mar 2026 10:23:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fS2Y2671fz6B9m8; Fri,  6 Mar
	2026 10:23:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260306101951epcas5p29466c309320d35847315faa2b75d1a11~aOUmssgyi1646816468epcas5p2-;
	Fri,  6 Mar 2026 10:19:51 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260306101950epsmtip112cefdff155070621be11d6f488cc520~aOUlTKDpm1549215492epsmtip1r;
	Fri,  6 Mar 2026 10:19:50 +0000 (GMT)
Date: Fri, 6 Mar 2026 15:48:55 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V6 10/18] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1931444790.41772792582852.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6979522dc1916_1d331009@dwillia2-mobl4.notmuch>
X-CMS-MailID: 20260306101951epcas5p29466c309320d35847315faa2b75d1a11
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73b96_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6@epcas5p4.samsung.com>
	<20260123113112.3488381-11-s.neeraj@samsung.com>
	<6979522dc1916_1d331009@dwillia2-mobl4.notmuch>

------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73b96_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 27/01/26 04:02PM, dan.j.williams@intel.com wrote:
>Neeraj Kumar wrote:
>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>> used to get called at last in cxl_endpoint_port_probe(), which requires
>> cxl_nvd presence.
>
>What?

Hi Dan,

Auto-region assembly was added by a32320b71f085 [1] and during that time
devm_cxl_add_nvdimm() was called after devm_cxl_add_endpoint().

Later Li Ming found issue (kernel panic) in pmem region auto-assembly
and fixed it using 84ec985944ef3 [2]. During this fix devm_cxl_add_nvdimm()
sequence was changed and called before devm_cxl_add_endpoint()

In this patch-set I have tried to bring back the original sequence in order
to create pmem region (single interleave) based of parsed information from
LSA during nvdimm_probe()

[1] https://lore.kernel.org/r/167601999958.1924368.9366954455835735048.stgit@dwillia2-xfh.jf.intel.com
[2] https://lore.kernel.org/all/20240612064423.2567625-1-ming4.li@intel.com

>
>> For cxl region persistency, region creation happens during nvdimm_probe
>> which need the completion of endpoint probe.
>>
>> In order to accommodate both cxl pmem region auto-assembly and cxl region
>> persistency, refactored following
>>
>> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>>    will be called only after successful completion of endpoint probe.
>>
>> 2. Create cxl_region_discovery() which performs pmem region
>>    auto-assembly and remove cxl pmem region auto-assembly from
>>    cxl_endpoint_port_probe()
>>
>> 3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
>>    called during cxl_pci_probe() in context of cxl_mem_probe()
>>
>> 4. As cxlmd->attach->probe() calls registered cxl_region_discovery(), so
>>    move devm_cxl_add_nvdimm() before cxlmd->attach->probe(). It guarantees
>>    both the completion of endpoint probe and cxl_nvd presence before
>>    calling cxlmd->attach->probe().
>
>This does not make sense. The whole point of having
>devm_cxl_add_nvdimm() before devm_cxl_add_endpoint() is so that the
>typical region discovery path can consider pre-existing decoder settings
>*or* nvdimm labels in its assembly decisions.
>
>I would be surprised if this passes existing region assembly and
>ordering tests.

Actually using following change (as Dave has also checked) with the
current patch-set is making existing region assembly ordering test pass.
But still some other testcase in cxl_test cxl-topology.sh is failing.

---
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index cb87e8c0e63c..03af15edd988 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1686,6 +1686,7 @@ static void cxl_mock_test_feat_init(struct cxl_mockmem_data *mdata)

  static int cxl_mock_mem_probe(struct platform_device *pdev)
  {
+       struct cxl_memdev_attach memdev_attach = { 0 };
         struct device *dev = &pdev->dev;
         struct cxl_memdev *cxlmd;
         struct cxl_memdev_state *mds;
@@ -1767,7 +1768,8 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)

         cxl_mock_add_event_logs(&mdata->mes);

-       cxlmd = devm_cxl_add_memdev(cxlds, NULL);
+       memdev_attach.probe = cxl_region_discovery;
+       cxlmd = devm_cxl_add_memdev(cxlds, &memdev_attach);
         if (IS_ERR(cxlmd))
                 return PTR_ERR(cxlmd);

---

>
>This reads like "do not understand current ordering, change it for thin
>reasons".

Yes I got your concern that we should reuse the existing infra of region auto
assembly instead of doing this refactoring and creating new infra for region
creation based on information parsed from LSA.

Even the same is discussed in last CXL Collab Sync [1].

I will fix this refactoring along with multi interleave support using existing
auto region assembly infra in next series.

[1] https://pmem.io/ndctl/collab/#:~:text=LSA%202.1%20support,with%20first%20merge%3F


Regards,
Neeraj

------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73b96_
Content-Type: text/plain; charset="utf-8"


------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73b96_--

