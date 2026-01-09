Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF4434BA28
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768145291; cv=none; b=h2Dh7tgbaUXR4Nzksyh2ABCGmMj3ZPy9fcEkpQFMlAEVPIhoMrEjkxpNukstV397hye3gbW/PXca+gtISQdjn1G4Oy8WHIJdc9ZGtdQMfov/f2+qxZGyChR7HyDeUODd1h56XAG1O6YfIqcT9FdsEO+OXKerfYT+n4etbM1aEsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768145291; c=relaxed/simple;
	bh=ywr0R2qffe7MOQbTCOqlWcYh3MdiGv8ZQwzuvzAbo08=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=k2AtSvZEv0/1T2w0k1XUa2+wtdQ7CoCvigXptxqusPqrd6JlUcLp7k5Pqio6v+LR63URbpoZw0tUT/MBby5U9nzheV3yqTjPyniuoFvC04Ocwxu9iWDihdW/86HNxCnxV1s5gJLinPd9/Lj5OCbRrFIjGwtQcmbX4z2qO7b1Jrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=I0Bql2Hr; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I0Bql2Hr"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260111152803epoutp034c7f67ef05a03b77e90908e0293e238c~JtsRhphFO3062930629epoutp03g
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260111152803epoutp034c7f67ef05a03b77e90908e0293e238c~JtsRhphFO3062930629epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768145283;
	bh=25S7bre1YtXjpMLZW3rLUrQvK/iPOgzJaV/AOb+jD2I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I0Bql2HrhcJ3ywNBQyyw6zcvLVbYwXBcqO7terrslwqt0OVGZvhIZZP/qtzpXH49o
	 Fose956fyJbxh6DG0EPbQneQYIsnXNb7eHAafHgFLUrqaFVvYitsRJbvEZ1p5ooeBN
	 hTGKm1z4ctybw4aSMy51LD4CnudJD3Y84EPUKKLE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260111152802epcas5p11a6b3575d15f22da52f68a7d0464f435~JtsRLUe5O1125111251epcas5p1y;
	Sun, 11 Jan 2026 15:28:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dpzst6Fx6z6B9m4; Sun, 11 Jan
	2026 15:28:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109121103epcas5p419e2e4f7c39aeefd6ceedc280d6280ad~JDts4mz6C1954919549epcas5p4y;
	Fri,  9 Jan 2026 12:11:03 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260109121101epsmtip2e3638b46f72b28bf7ad15a3b84e99909~JDtrZb_On2956029560epsmtip2a;
	Fri,  9 Jan 2026 12:11:01 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:40:55 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 10/17] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1296674576.21768145282877.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <48855612-3643-4d91-84aa-784cbc3fd593@intel.com>
X-CMS-MailID: 20260109121103epcas5p419e2e4f7c39aeefd6ceedc280d6280ad
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e580c_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251119075324epcas5p1b0a7149ede962491e6be2d72d33f77eb
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075324epcas5p1b0a7149ede962491e6be2d72d33f77eb@epcas5p1.samsung.com>
	<20251119075255.2637388-11-s.neeraj@samsung.com>
	<48855612-3643-4d91-84aa-784cbc3fd593@intel.com>

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e580c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/11/25 01:44PM, Dave Jiang wrote:
>
>
>On 11/19/25 12:52 AM, Neeraj Kumar wrote:
>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>> used to get called at last in cxl_endpoint_port_probe(), which requires
>> cxl_nvd presence.
>>
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
>> 4. As cxlmd->ops->probe() calls registered cxl_region_discovery(), so
>>    move devm_cxl_add_nvdimm() before cxlmd->ops->probe(). It gurantees
>
>s/gurantees/guarantees/

Fixed it in V5

>
>>    both the completion of endpoint probe and cxl_nvd presence before
>>    calling cxlmd->ops->probe().
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks Dave for RB tag


Regards,
Neeraj

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e580c_
Content-Type: text/plain; charset="utf-8"


------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e580c_--

