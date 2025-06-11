Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D772223C8CD
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 08:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749631345; cv=none; b=FdUtogXRDODmM8WkLxkldYFvuVN5yh9P5KkMgb/IsaTPeWT3FKIke3CF7fqRT1XH5IiSUvL3Vi2zVEkjELPsOgqfkEh4sjcN4MCSAZ/WVTiyo5IwLiXHTjM9zhfMffauUh0oE77LsZ9/oavO0GVfyEZnhI8bP4beP0ZOC82u3Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749631345; c=relaxed/simple;
	bh=JN6/3wMG7bR+MMBVKMBJOzeMXrSF5nsAX5Hl6KT6O6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ezppVLqYaDJlS+7YhI41OQJeFtbXlkDobUqA4yreMsMJ4F6V7SDuM1zwFclAt71R8dMjgpDEx9rTokTyur2RTJoDuAPHrshgsvg06n3bSadS5XVvo+roeGsGBeB25nHCiTTYl0aBjtcn+CORDkyCD/RJgyycZkNYOiqx3sOrwWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eKABDA52; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eKABDA52"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250611084220euoutp01f9d86cd85f78403d666d681ea141374f~H8G8XLeKE0258902589euoutp01V
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 08:42:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250611084220euoutp01f9d86cd85f78403d666d681ea141374f~H8G8XLeKE0258902589euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1749631340;
	bh=8s5vFxR1V9KB58LvUJ18g2JnoUARTR5dGOv6Swwdcqg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=eKABDA52uJCgR/L3d9qNuIbaW4Rixx/M1DCjpGb8hTMXsvy8voYkLO21aqUZRDobq
	 J+x7a1RCq1JerI6pO/pYbEgKpIIZYHn6KZKaL8haxRIZjBaoKhN7xfCDeoNQLMHeTi
	 9P+MSw30GsrE7g6y2mqF6pPYqCixkkhR/9k7LjtY=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250611084219eucas1p1b1b445a9017d87f141561fa591847d7d~H8G78SWKX2272022720eucas1p1N;
	Wed, 11 Jun 2025 08:42:19 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250611084217eusmtip2665432f3fe30a8e815516687a8972357~H8G5lenbh2869928699eusmtip2v;
	Wed, 11 Jun 2025 08:42:17 +0000 (GMT)
Message-ID: <4e53d612-534c-46b5-9746-a4a9814d41c3@samsung.com>
Date: Wed, 11 Jun 2025 10:42:16 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and
 PFN_SG_LAST
To: David Hildenbrand <david@redhat.com>, Alistair Popple
	<apopple@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca,
	willy@infradead.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	jhubbard@nvidia.com, zhang.lyra@gmail.com, debug@rivosinc.com,
	bjorn@kernel.org, balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
	John@groves.net
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <52b746ae-82cc-428e-8e88-a05a6b738cd0@redhat.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250611084219eucas1p1b1b445a9017d87f141561fa591847d7d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e
X-EPHeader: CA
X-CMS-RootMailID: 20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e
References: <20250604032145.463934-1-apopple@nvidia.com>
	<CGME20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e@eucas1p1.samsung.com>
	<957c0d9d-2c37-4d5f-a8b8-8bf90cd0aedb@samsung.com>
	<hczxxu3txopjnucjrttpcqtkkfnzrqh6sr4v54dfmjbvf2zcfs@ocv6gqddyavn>
	<1daeaf4e-5477-40cb-bca0-e4cd5ad8a224@samsung.com>
	<52b746ae-82cc-428e-8e88-a05a6b738cd0@redhat.com>

On 11.06.2025 10:23, David Hildenbrand wrote:
> On 11.06.25 10:03, Marek Szyprowski wrote:
>> On 11.06.2025 04:38, Alistair Popple wrote:
>>> On Tue, Jun 10, 2025 at 06:18:09PM +0200, Marek Szyprowski wrote:
>>>> On 04.06.2025 05:21, Alistair Popple wrote:
>>>>> The PFN_MAP flag is no longer used for anything, so remove it.
>>>>> The PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been
>>>>> used so also remove them. The last user of PFN_SPECIAL was removed
>>>>> by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
>>>>> support").
>>>>>
>>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Cc: gerald.schaefer@linux.ibm.com
>>>>> Cc: dan.j.williams@intel.com
>>>>> Cc: jgg@ziepe.ca
>>>>> Cc: willy@infradead.org
>>>>> Cc: david@redhat.com
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Cc: nvdimm@lists.linux.dev
>>>>> Cc: jhubbard@nvidia.com
>>>>> Cc: hch@lst.de
>>>>> Cc: zhang.lyra@gmail.com
>>>>> Cc: debug@rivosinc.com
>>>>> Cc: bjorn@kernel.org
>>>>> Cc: balbirs@nvidia.com
>>>>> Cc: lorenzo.stoakes@oracle.com
>>>>> Cc: John@Groves.net
>>>>>
>>>>> ---
>>>>>
>>>>> Splitting this off from the rest of my series[1] as a separate 
>>>>> clean-up
>>>>> for consideration for the v6.16 merge window as suggested by 
>>>>> Christoph.
>>>>>
>>>>> [1] - 
>>>>> https://lore.kernel.org/linux-mm/cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com/
>>>>> ---
>>>>>     include/linux/pfn_t.h             | 31 
>>>>> +++----------------------------
>>>>>     mm/memory.c                       |  2 --
>>>>>     tools/testing/nvdimm/test/iomap.c |  4 ----
>>>>>     3 files changed, 3 insertions(+), 34 deletions(-)
>>>> This patch landed in today's linux-next as commit 28be5676b4a3 ("mm:
>>>> remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST"). In my 
>>>> tests
>>>> I've noticed that it breaks operation of all RISC-V 64bit boards on my
>>>> test farm (VisionFive2, BananaPiF3 as well as QEMU's Virt machine). 
>>>> I've
>>>> isolated the changes responsible for this issue, see the inline 
>>>> comments
>>>> in the patch below. Here is an example of the issues observed in the
>>>> logs from those machines:
>>> Thanks for the report. I'm really confused by this because this 
>>> change should
>>> just be removal of dead code - nothing sets any of the removed PFN_* 
>>> flags
>>> AFAICT.
>>>
>>> I don't have access to any RISC-V hardwdare but you say this 
>>> reproduces under
>>> qemu - what do you run on the system to cause the error? Is it just 
>>> a simple
>>> boot and load a module or are you running selftests or something else?
>>
>> It fails a simple boot test. Here is a detailed instruction how to
>> reproduce this issue with the random Debian rootfs image found on the
>> internet (tested on Ubuntu 22.04, with next-20250610
>> kernel source):
>
> riscv is one of the archs where pte_mkdevmap() will *not* set the pte 
> as special. (I
> raised this recently in the original series, it's all a big mess)
>
> So, before this change here, pfn_t_devmap() would have returned 
> "false" if only
> PFN_DEV was set, now it would return "true" if only PFN_DEV is set.
>
> Consequently, in insert_pfn() we would have done a pte_mkspecial(), 
> now we do a
> pte_mkdevmap() -- again, which does not imply "special" on riscv.
>
> riscv selects CONFIG_ARCH_HAS_PTE_SPECIAL, so if !pte_special(), it's 
> considered as
> normal.
>
> Would the following fix your issue?
>
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 8eba595056fe3..0e972c3493692 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -589,6 +589,10 @@ struct page *vm_normal_page(struct vm_area_struct 
> *vma, unsigned long addr,
>  {
>         unsigned long pfn = pte_pfn(pte);
>
> +       /* TODO: remove this crap and set pte_special() instead. */
> +       if (pte_devmap(pte))
> +               return NULL;
> +
>         if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>                 if (likely(!pte_special(pte)))
>                         goto check_pfn;
> @@ -598,16 +602,6 @@ struct page *vm_normal_page(struct vm_area_struct 
> *vma, unsigned long addr,
>                         return NULL;
>                 if (is_zero_pfn(pfn))
>                         return NULL;
> -               if (pte_devmap(pte))
> -               /*
> -                * NOTE: New users of ZONE_DEVICE will not set 
> pte_devmap()
> -                * and will have refcounts incremented on their struct 
> pages
> -                * when they are inserted into PTEs, thus they are 
> safe to
> -                * return here. Legacy ZONE_DEVICE pages that set 
> pte_devmap()
> -                * do not have refcounts. Example of legacy 
> ZONE_DEVICE is
> -                * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs 
> drivers.
> -                */
> -                       return NULL;
>
>                 print_bad_pte(vma, addr, pte, NULL);
>                 return NULL;
>
>
> But, I would have thought the later patches in Alistairs series would 
> sort that out
> (where we remove pte_devmap() ... )
>
The above change fixes the issues observed on RISCV boards.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

