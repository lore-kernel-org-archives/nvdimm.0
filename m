Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79E737B3EC
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 10:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792701; cv=none; b=gnHDCPWx9f6tZ6ZvJz7H98z8StW++hwCl7CahP+biwX16U8sZPjKTZbDbpG+A0pFNkNiBC/cYSWN5fZNCU6qNdfdW7g5BMxZkKvzkmi5l7uQui3ZPMRSY4cYHdvRpec56wH8ggCWWVHV5Rp4sU+4fqPYXUC6Js24/iiha61aM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792701; c=relaxed/simple;
	bh=VwPDBc52y+ByONznQ17CVbyI/CYVHCtb7xpnbb3VR4U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=p+qYcA94bsS0cbAU6GMMb72wjVC0ev95b+4eMDoFIWLl2/sVjXabVG5bVYXSXnQKT+26iiTGf2W+b+kW0JZ6SJ8nChKZFHouWLFbCkHgSMFl0al4q5Nvsl7LRlXoleJwwQhw7tbWHi0rlMzE2Po3ZmoW6BCA3qIGrWNw3FjgC84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NoUPubwD; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NoUPubwD"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260306102456epoutp02646e37b2299fec83e47f5a7e2a378dff~aOZCg3wAw0871608716epoutp02L
	for <nvdimm@lists.linux.dev>; Fri,  6 Mar 2026 10:24:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260306102456epoutp02646e37b2299fec83e47f5a7e2a378dff~aOZCg3wAw0871608716epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772792696;
	bh=mkBvaLFfnKnjCBnDHYqAtzkGsBKFeIIQ9usUlK7H3kY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NoUPubwDCgZ59QwtmvHoLFnRNGQfkodocRt57Hqg9mwH1rXxjlbomdYunsGQH206h
	 e4a1zChy1INCN2vcB3NPRtwDEbzCoX65ZYK5ByNwoir+qtfAtu2gQw8RmiJLfGu1DU
	 Aj4541yPcK+E1YlnIwdyiyThjZsrLFIARaKD+7M0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260306102455epcas5p4790db72dd69e9cdf1ffac2731dd054d9~aOZBw1JUx1250412504epcas5p4u;
	Fri,  6 Mar 2026 10:24:55 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fS2bC1Cykz2SSKY; Fri,  6 Mar
	2026 10:24:55 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260306102454epcas5p4d2e1b37f366756d71853584d6c8246c7~aOZAdHMuU0525205252epcas5p4K;
	Fri,  6 Mar 2026 10:24:54 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260306102452epsmtip2518d8ac470e57ec2e1d49cd96838a2d3~aOY_wF1DG2865228652epsmtip2v;
	Fri,  6 Mar 2026 10:24:52 +0000 (GMT)
Date: Fri, 6 Mar 2026 15:54:44 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alejandro Lucero Palau <alucerop@amd.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V6 12/18] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <20260306102444.fkoqhyavd7cgorxy@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a560c14c-410c-4ea8-9076-deeb9ba28fee@amd.com>
X-CMS-MailID: 20260306102454epcas5p4d2e1b37f366756d71853584d6c8246c7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73bc8_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b@epcas5p4.samsung.com>
	<20260123113112.3488381-13-s.neeraj@samsung.com>
	<a560c14c-410c-4ea8-9076-deeb9ba28fee@amd.com>

------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73bc8_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 24/02/26 06:13PM, Alejandro Lucero Palau wrote:
>Hi Neeraj,
>
>
>I could get some free time for reviewing this series. Dan pointed out 
>to potential conflicts with my Type2 series, so I'm focused on those 
>patches modifying the cxl region creation and how it is being used.
>
>
>I do not know if you are aware of the Type2 work, although I dare to 
>say you are not since some of the functionality is duplicated ... and 
>in your case skipping some steps.
>

Hi Alejandro,

Thanks for your review.
Yes I have not looked at Type2 work in detail. I will have a look
and specially the conflicting part with my changes.

>
>Below my comments.
>
>
>On 1/23/26 11:31, Neeraj Kumar wrote:
>>devm_cxl_pmem_add_region() is used to create cxl region based on region
>>information scanned from LSA.
>>
>>devm_cxl_add_region() is used to just allocate cxlr and its fields are
>>filled later by userspace tool using device attributes (*_store()).
>>
>>Inspiration for devm_cxl_pmem_add_region() is taken from these device
>>attributes (_store*) calls. It allocates cxlr and fills information
>>parsed from LSA and calls device_add(&cxlr->dev) to initiate further
>>region creation porbes
>>
>>Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>>Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>>---
>>  drivers/cxl/core/region.c | 118 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 118 insertions(+)
>>
>>diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>>index 2e60e5e72551..e384eacc46ae 100644
>>--- a/drivers/cxl/core/region.c
>>+++ b/drivers/cxl/core/region.c
>>@@ -2621,6 +2621,121 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>>  	return ERR_PTR(rc);
>>  }
>>+static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
>>+{
>>+	int rc;
>>+
>>+	if (!size)
>>+		return -EINVAL;
>>+
>>+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>>+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
>>+		return rc;
>>+
>>+	return alloc_hpa(cxlr, size);
>>+}
>
>
>Type2 has a more elaborated function preceding the final hpa 
>allocation.  First of all, the root decoder needs to match the 
>endpoint type or to have support for it. Then interleave ways taken 
>into account. I know you are only supporting 1 way, what I guess makes 
>the initial support easier, but although some check for not supporting 
>> 1 is fine (I guess this takes a lot of work for matching at least 
>LSA labels and maybe something harder), the core code should support 
>that, mainly because there is ongoing work adding it. In my case I did 
>not need interleaving and it is unlikely other Type2 devices will need 
>it in the near future, but the support is there:
>
>https://lore.kernel.org/linux-cxl/20260201155438.2664640-1-alejandro.lucero-palau@amd.com/T/#m56bf70b58bb995082680bf363fd3f6d6f2b074d2
>
>
>>+
>>+static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
>>+{
>>+	if (!size)
>>+		return -EINVAL;
>>+
>>+	if (!IS_ALIGNED(size, SZ_256M))
>>+		return -EINVAL;
>>+
>>+	return cxl_dpa_alloc(cxled, size);
>>+}
>
>
>I'm not sure if the same applies here as you are passing an endpoint 
>decoder already, but FWIW:
>
>
>https://lore.kernel.org/linux-cxl/20260201155438.2664640-1-alejandro.lucero-palau@amd.com/T/#m38ff266e931fd9c932bc54d000b7ea72186493be
>
>
>I'm sending type2 individual patches for facilitating the integration, 
>and I'll focus next on these two referenced ones so you could use them 
>asap.
>
>
>Thank you,
>
>Alejandro

Actually I have created alloc_region_hpa() and alloc_region_dpa() taking
inspiration from device attributes (_store*) calls used to create cxl
region using cxl userspace tool.

I am adding the support of multi interleave, there these routines will
not be required as I would be re-using the existing auto region assembly infra.

Even though I will re-check any conflicts with Type2 changes.



Regards,
Neeraj





------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73bc8_
Content-Type: text/plain; charset="utf-8"


------S5vMiqbC9D9faF8YPw-GIekSHdZgzpYrwqcOSnq._zgadq5.=_73bc8_--
