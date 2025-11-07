Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00718849C
	for <nvdimm@lists.linux.dev>; Mon, 10 Nov 2025 04:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762749312; cv=none; b=QLE5dBVND8cY7akTetW1+qjJPr6nFNqVynbosrnlyK4t63Oi28zMPMMuCswLK/3pLnE4n3ReW7c+uNeKEaI3io+8ZZQOwCCC4JWYzJLSOAUcUwB092TFN56rdayY8qUqfw3bHcsRCuBmZD/ghHgLyT8hbXOx8aeaAFe8+QfpqG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762749312; c=relaxed/simple;
	bh=OxbiXzogS18s9gWFpLOZC3SrNZNC2m487zexC//F/xc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=DFixxsIFYM3ST5+DTJrKlEdlVAbyXW375oRDqnxyGZsKB8iOr4BFz8OCjAgGRo0xyPbQ4yr0vmxo/sokfbVACz6dIXvXvGKzy0zT4uEX6b5RVs2m2j18yDyFP+XxZ/yPOpCPJ6LolUOiQD8sd0GbAtxv62mpaoHD78zalutH+P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aNzq5wCv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aNzq5wCv"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251110043502epoutp012385957a47ed9bccb9fab9407b0e9693~2iyatFJFi0742207422epoutp01y
	for <nvdimm@lists.linux.dev>; Mon, 10 Nov 2025 04:35:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251110043502epoutp012385957a47ed9bccb9fab9407b0e9693~2iyatFJFi0742207422epoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1762749302;
	bh=jS2+O+mkFBWGVcMnmL+fQCLQwIFScok/uQfxL5hNerg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aNzq5wCvGS9biQupwOu8y4oXzodh9756L4/sJND2vunYamilqmPThCcC8fhlo+h3p
	 a5SXeZXH9PPYjEOrgu1ketJXQJdgDDebaQvkXNZWfAXl17HeC+5KAZRx+LykjTPu0O
	 DWYX1J0z9P17j/tU99Terd3NlWVe17Y9BErTlHxQ=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251110043502epcas5p40c79ebcd4b283b5a56a400726bc74b2c~2iyaZp46P0233102331epcas5p4w;
	Mon, 10 Nov 2025 04:35:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4d4cK20DGQz6B9mD; Mon, 10 Nov
	2025 04:35:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251107124920epcas5p3cf861b7cd977a52f4aa576525f3a054e~1umI4nRmV1142611426epcas5p3K;
	Fri,  7 Nov 2025 12:49:20 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251107124916epsmtip2bceff1a0e2e8f903166d263b2ee43cad~1umFfRvxD0278102781epsmtip2M;
	Fri,  7 Nov 2025 12:49:16 +0000 (GMT)
Date: Fri, 7 Nov 2025 18:19:09 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 18/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <1296674576.21762749302024.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6e893bd1-467a-4e9a-91ca-536afa6e4767@intel.com>
X-CMS-MailID: 20251107124920epcas5p3cf861b7cd977a52f4aa576525f3a054e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_a59bf_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134209epcas5p1b7f861dbd8299ec874ae44cbf63ce87c
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134209epcas5p1b7f861dbd8299ec874ae44cbf63ce87c@epcas5p1.samsung.com>
	<20250917134116.1623730-19-s.neeraj@samsung.com>
	<147c4f1a-b8f6-4a99-8469-382b897f326d@intel.com>
	<1279309678.121759726504330.JavaMail.epsvc@epcpadp1new>
	<6e893bd1-467a-4e9a-91ca-536afa6e4767@intel.com>

------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_a59bf_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 06/10/25 09:06AM, Dave Jiang wrote:
>
>
>On 9/29/25 6:57 AM, Neeraj Kumar wrote:
>> On 24/09/25 11:53AM, Dave Jiang wrote:
>>>
>>>
>>> On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>>>> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
>>>> Moved pmem_region related code from core/region.c to core/pmem_region.c
>>>> For region label update, need to create device attribute, which calls
>>>> nvdimm exported function thus making pmem_region dependent on libnvdimm.
>>>> Because of this dependency of pmem region on libnvdimm, segregated pmem
>>>> region related code from core/region.c
>>>
>>> We can minimize the churn in this patch by introduce the new core/pmem_region.c and related bits in the beginning instead of introduce new functions and then move them over from region.c.
>>
>> Hi Dave,
>>
>> As per LSA 2.1, during region creation we need to intract with nvdimmm
>> driver to write region label into LSA.
>> This dependency of libnvdimm is only for PMEM region, therefore I have
>> created a seperate file core/pmem_region.c and copied pmem related functions
>> present in core/region.c into core/pmem_region.c.
>> Because of this movemement of code we have churn introduced in this patch.
>> Can you please suggest optimized way to handle dependency on libnvdimm
>> with minimum code changes.
>
>Hmm....maybe relegate the introduction of core/pmem_region.c new file and only the moving of the existing bits into the new file to a patch. And then your patch will be rid of the delete/add bits of the old code? Would that work?
>
>DJ

Hi Dave,

As per LSA 2.1, during region creation we need to intract with nvdimmm
driver to write region label into LSA.

This dependency of libnvdimm is only for PMEM region, therefore I have
created a seperate file core/pmem_region.c and copied pmem related functions
present in core/region.c into core/pmem_region.c

I have moved following 7 pmem related functions from core/region.c to core/pmem_region.c
  - cxl_pmem_region_release()
  - cxl_pmem_region_alloc()
  - cxlr_release_nvdimm()
  - cxlr_pmem_unregister()
  - devm_cxl_add_pmem_region()
  - is_cxl_pmem_region()
  - to_cxl_pmem_region()

I have created region_label_update_show/store() and region_label_delete_store() which
internally calls following libnvdimm exported function
  - region_label_update_show/store()
  - region_label_delete_store()

I have added above attributes as following
    {{{
	static struct attribute *cxl_pmem_region_attrs[] = {
         	&dev_attr_region_label_update.attr,
         	&dev_attr_region_label_delete.attr,
         	NULL
	};
	static struct attribute_group cxl_pmem_region_group = {
	        .attrs = cxl_pmem_region_attrs,
	};
	static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
	        &cxl_base_attribute_group,
	        &cxl_pmem_region_group,      ------> New addition in this patch
	        NULL
	};
	const struct device_type cxl_pmem_region_type = {
	        .name = "cxl_pmem_region",
	        .release = cxl_pmem_region_release,
	        .groups = cxl_pmem_region_attribute_groups,
	};

	static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
	{
	        <snip>
	        dev = &cxlr_pmem->dev;
	        dev->parent = &cxlr->dev;
	        dev->bus = &cxl_bus_type;
	        dev->type = &cxl_pmem_region_type;
		<snip>
	}
    }}}

So I mean to say all above mentioned functions are inter-connected and dependent on libnvdimm
Keeping any of them in core/region.c to avoid churn, throws following linking error
    {{{
	ERROR: modpost: "nd_region_label_delete" [drivers/cxl/core/cxl_core.ko] undefined!
	ERROR: modpost: "nd_region_label_update" [drivers/cxl/core/cxl_core.ko] undefined!
	make[2]: *** [scripts/Makefile.modpost:147: Module.symvers] Error 1
    }}}

Keeping these functions in core/region.c (CONFIG_REGION)) and manually enabling CONFIG_LIBNVDIMM=y
will make it pass.

Even if we can put these functions in core/region.c and forcefully make
libnvdimm (CONFIG_LIBNVDIMM) dependent using Kconfig. But I find it little improper as
this new dependency is not for all type of cxl devices (vmem and pmem) but only for cxl pmem
device region.

Therefore I have seperated it out in core/pmem_region.c under Kconfig control
making libnvdimm forcefully enable if CONFIG_CXL_PMEM_REGION == y

So, I believe this prep patch is required for this LSA 2.1 support.


Regards,
Neeraj

------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_a59bf_
Content-Type: text/plain; charset="utf-8"


------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_a59bf_--

