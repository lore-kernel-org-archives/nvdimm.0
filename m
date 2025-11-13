Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739B632F74B
	for <nvdimm@lists.linux.dev>; Thu, 13 Nov 2025 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763020207; cv=none; b=r9VmasD6axb5XXthggF53sfbD1PhmhWs8kXM5Ai5fijyroVsqRnt/XF62eo6HQ30ab6XMZEhlZb/meJlqC9x4hWXSBYqORyHr6wdJMg64rIOResQ2ZgMhSxOjndk5RxIPehkN2hVso0VsInVA3gm72lmtGqvGYEGpoJnw8gXB8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763020207; c=relaxed/simple;
	bh=Tivo3GFoS1phCSWYDeFF9DTpbwFBRvC/+ODFjHKNmMg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=GcZtS11llMso7h724jduriL8pkmAlln6vDVwsPNXHN1aI7JEl3c/QoQzzDP5Jk04R9S8/H+E/BGUfa6Q2Pt+MaQgSz4Jfo47cipxid5B1pMKwanMzCwq65BG8f4ybWn/WnU8XzNoBdI5t97I895qYlNPwseouSYw652uADFu55w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WO4ou/E7; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WO4ou/E7"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251113075003epoutp0107a833fb9ed76b17d37e145d2d75d6d7~3gYjBQtBB2267122671epoutp01i
	for <nvdimm@lists.linux.dev>; Thu, 13 Nov 2025 07:50:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251113075003epoutp0107a833fb9ed76b17d37e145d2d75d6d7~3gYjBQtBB2267122671epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763020203;
	bh=PrAqxrRuWP1UVQFq/hrOFrgLMn50SDu0myTwZAkgdZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WO4ou/E77rffoLa78AnZDACnmFJhzfBQy4ehPdp13sv/7/pFDdZhU0zGPs2HjgMNC
	 juHU2D5cmG9lDg21yK+lsymvvJ9hPkUjn3yblbmpHBuF+hqEUs8Ieo4DWAmyvBlbQY
	 7nvphZMHGVOJyn51CiKz2I244Rmm85GAtHjuqssE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251113075003epcas5p169a8bfdf20f110a1a12a42123b741e19~3gYitkL9g2606826068epcas5p1f;
	Thu, 13 Nov 2025 07:50:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4d6XVg0xcKz2SSKf; Thu, 13 Nov
	2025 07:50:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251113072918epcas5p3995164aced1a029b71ba5807705531f9~3gGbV46ey2448624486epcas5p3o;
	Thu, 13 Nov 2025 07:29:18 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251113072913epsmtip1b466bafcc451ab1ad11391ed310e73cd~3gGXHnJBP2873728737epsmtip16;
	Thu, 13 Nov 2025 07:29:13 +0000 (GMT)
Date: Thu, 13 Nov 2025 12:59:07 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 18/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <1931444790.41763020203119.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2aca7703-fae6-46bb-bef1-ee29e822b4c8@intel.com>
X-CMS-MailID: 20251113072918epcas5p3995164aced1a029b71ba5807705531f9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_bb9c1_"
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
	<1296674576.21762749302024.JavaMail.epsvc@epcpadp1new>
	<2aca7703-fae6-46bb-bef1-ee29e822b4c8@intel.com>

------xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_bb9c1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 12/11/25 08:40AM, Dave Jiang wrote:
>

<snip>

>> Keeping these functions in core/region.c (CONFIG_REGION)) and manually enabling CONFIG_LIBNVDIMM=y
>> will make it pass.
>>
>> Even if we can put these functions in core/region.c and forcefully make
>> libnvdimm (CONFIG_LIBNVDIMM) dependent using Kconfig. But I find it little improper as
>> this new dependency is not for all type of cxl devices (vmem and pmem) but only for cxl pmem
>> device region.
>>
>> Therefore I have seperated it out in core/pmem_region.c under Kconfig control
>> making libnvdimm forcefully enable if CONFIG_CXL_PMEM_REGION == y
>>
>> So, I believe this prep patch is required for this LSA 2.1 support.
>
>I think you misunderstood what I said. What I was trying to say is if possible to move all the diff changes of moving the existing code to a different place to a different patch. That way this patch is not full of those diff changes and make it easier to review.
>
>DJ

Hi Dave, Thanks for the clarification. Yes now I am able to get your point clear.

I should split this patch into two patches
1. First prep patch with no functionality change (Just code movement from core/region.c to newly core/pmem_region.c)
2. Second patch which calls the libnvdimm exported routines
	- region_label_update_show/store()
	- region_label_delete_store()

Regards,
Neeraj

------xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_bb9c1_
Content-Type: text/plain; charset="utf-8"


------xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_bb9c1_--

