Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB062D541D
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749630218; cv=none; b=Sm2u1ekyZiw9fdjKpGYHNFGWBYkJVp60imZRjuvJbZ+/XDjQSBqymkVbnxreN5quqGzoANQ1/9DtW59CW0LTtX9xc11m502bcQrwJ/cWtVhvH14aofijTSB3mONfmuh2eIh0xIrV3OSAA0HVWE/0VFtKbOwIP+4jEfZOyqlkFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749630218; c=relaxed/simple;
	bh=N+1Zyr69TubqXEDAnwbvEj/99HAszavDxb96c48/dgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dwaLFD7IHc7htE/oTFPIOpoJF9TNHdvXut0dRKnHTDzg2aGaJb8jUllCQFBS3ntFku2xs3rmcruyKHnpSYn2AVKps0I6oV0xVP/eF2m8Sy64iqBOTculJGIzFmLmH0zqPbiL2dyLqBsho5qet1s6V68u/5y/0rotwyYQNfwDycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PR38tcxG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PR38tcxG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749630215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KGAJqXmjc8jwedunIap6ts3bHN4LjX3nvKHTfy1OSMc=;
	b=PR38tcxG0CpSGQEAgF6UctD/XgbtjOEEOlbbCXuSi+uyYPGKLPbvzYRpcEIG0G33nkgShc
	a288FXUiZSHdZKH6dZio/q+8fp5xTpJZdysM1fdTfb11gloNjKF91j+j1LhRCne1KaY9LA
	1bYsk6V5VQm9esm4Qq8Szo6cu8xv1cg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-6emJPMvQNn2YJJBIWXSzVQ-1; Wed, 11 Jun 2025 04:23:24 -0400
X-MC-Unique: 6emJPMvQNn2YJJBIWXSzVQ-1
X-Mimecast-MFC-AGG-ID: 6emJPMvQNn2YJJBIWXSzVQ_1749630203
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-607ecda10fcso2618292a12.1
        for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 01:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749630203; x=1750235003;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KGAJqXmjc8jwedunIap6ts3bHN4LjX3nvKHTfy1OSMc=;
        b=Kli0CYXrcvp288z/5uJCLfckSfmnsywcaYKWni4Yv3seo/OfxE1oNlpCtaAC4R1Pvy
         DNxhpOd+CvLbiUbgN7O2PzZuZkgKJ9sSWBDsL2nj2cfkVna/jySPgQipOeflIJlJj5Mb
         /lRKgA7uAqb7v93tC/s8YS3MHpp3AjZiyVhBwtic9bVktOtkqSKpc2hk4hQeM9+rq/+z
         0UP0ie2WWJf8UlLEas6CgQ6oErV6QaI6hZDYvNURDVSZdg8uwuCS94UnwB9mOwjSAk0Y
         iyAv/s4I2Ib926xPgzsybWQspNS6z5wDi0wrqberGQjM/rpGQMeMvmdRHLAkDicYLfeo
         Q0cA==
X-Forwarded-Encrypted: i=1; AJvYcCXiyTQoFfBQmepZJ5zRqGexm9VMFFpWAQtOsUfl50FwpELI8hptzj9CfAWcPebS6PGBgGs8X5c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yym1BVrup73JMzU8kFq5p7M0D1g26kQL3Bw4ugdIzT9Ll+57puf
	2yyyPKJwPnuxwfXXOoOok3+JysV44wBtZ2TSJsmaXYIwng6DZ/tsXefDYGEpsMfzenxsWK1kjlp
	5nRI3IRh89uPyNOW2pTi05wgAWqfkSq+ipXlSw86qewbZtHbo4jTMdu6YFg==
X-Gm-Gg: ASbGncuWkXozOdSuw2WQeyY57B+Erd7e+86iB9n83C76p6/3lXy2Vxon60sl9Sit51q
	ZZ6/IbDUIYnB1Fwt4GXlYzhpw5w6EGToAoZ2JriyoIS+0hgDxknHWqoVH8xLheyYG4/SuvMl3n7
	TY6OBSw/P34gn3LTm1CKD4Z5zrkvB2YZUpIJgYfSJL39Kqm6FoZgEJQYaGxdTM0KXRHqQUQl8Yy
	0fzFnscUJNCkYotEm1hWW72hs8ekB8jt5ljUgtDw9RyrTglSD1k9ikbGsOtDirl/DBlb9HSAVK1
	gqJUSwGM0nDdd1STXYt3LrDKtmsP9NsmWG0+dFLFhHQM
X-Received: by 2002:a05:6402:1941:b0:607:6619:1092 with SMTP id 4fb4d7f45d1cf-60846af42f2mr1953071a12.13.1749630202707;
        Wed, 11 Jun 2025 01:23:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMuPw8p1asPs6tLBDeVr1B8/KBQgjzliFlrJF7qnKZsYXTm7qlYtGdvn70FWDxJ38ed58fDQ==
X-Received: by 2002:a05:6402:1941:b0:607:6619:1092 with SMTP id 4fb4d7f45d1cf-60846af42f2mr1953043a12.13.1749630202282;
        Wed, 11 Jun 2025 01:23:22 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-607783dccbdsm7104469a12.54.2025.06.11.01.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 01:23:21 -0700 (PDT)
Message-ID: <52b746ae-82cc-428e-8e88-a05a6b738cd0@redhat.com>
Date: Wed, 11 Jun 2025 10:23:20 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and
 PFN_SG_LAST
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
 gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca,
 willy@infradead.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 jhubbard@nvidia.com, zhang.lyra@gmail.com, debug@rivosinc.com,
 bjorn@kernel.org, balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 John@groves.net
References: <20250604032145.463934-1-apopple@nvidia.com>
 <CGME20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e@eucas1p1.samsung.com>
 <957c0d9d-2c37-4d5f-a8b8-8bf90cd0aedb@samsung.com>
 <hczxxu3txopjnucjrttpcqtkkfnzrqh6sr4v54dfmjbvf2zcfs@ocv6gqddyavn>
 <1daeaf4e-5477-40cb-bca0-e4cd5ad8a224@samsung.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1daeaf4e-5477-40cb-bca0-e4cd5ad8a224@samsung.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IP4yd75iJKyHEPSTBdwsZIN36S_HEFDpkEnZAE1BkwQ_1749630203
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.06.25 10:03, Marek Szyprowski wrote:
> On 11.06.2025 04:38, Alistair Popple wrote:
>> On Tue, Jun 10, 2025 at 06:18:09PM +0200, Marek Szyprowski wrote:
>>> On 04.06.2025 05:21, Alistair Popple wrote:
>>>> The PFN_MAP flag is no longer used for anything, so remove it.
>>>> The PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been
>>>> used so also remove them. The last user of PFN_SPECIAL was removed
>>>> by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
>>>> support").
>>>>
>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Cc: gerald.schaefer@linux.ibm.com
>>>> Cc: dan.j.williams@intel.com
>>>> Cc: jgg@ziepe.ca
>>>> Cc: willy@infradead.org
>>>> Cc: david@redhat.com
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Cc: nvdimm@lists.linux.dev
>>>> Cc: jhubbard@nvidia.com
>>>> Cc: hch@lst.de
>>>> Cc: zhang.lyra@gmail.com
>>>> Cc: debug@rivosinc.com
>>>> Cc: bjorn@kernel.org
>>>> Cc: balbirs@nvidia.com
>>>> Cc: lorenzo.stoakes@oracle.com
>>>> Cc: John@Groves.net
>>>>
>>>> ---
>>>>
>>>> Splitting this off from the rest of my series[1] as a separate clean-up
>>>> for consideration for the v6.16 merge window as suggested by Christoph.
>>>>
>>>> [1] - https://lore.kernel.org/linux-mm/cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com/
>>>> ---
>>>>     include/linux/pfn_t.h             | 31 +++----------------------------
>>>>     mm/memory.c                       |  2 --
>>>>     tools/testing/nvdimm/test/iomap.c |  4 ----
>>>>     3 files changed, 3 insertions(+), 34 deletions(-)
>>> This patch landed in today's linux-next as commit 28be5676b4a3 ("mm:
>>> remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST"). In my tests
>>> I've noticed that it breaks operation of all RISC-V 64bit boards on my
>>> test farm (VisionFive2, BananaPiF3 as well as QEMU's Virt machine). I've
>>> isolated the changes responsible for this issue, see the inline comments
>>> in the patch below. Here is an example of the issues observed in the
>>> logs from those machines:
>> Thanks for the report. I'm really confused by this because this change should
>> just be removal of dead code - nothing sets any of the removed PFN_* flags
>> AFAICT.
>>
>> I don't have access to any RISC-V hardwdare but you say this reproduces under
>> qemu - what do you run on the system to cause the error? Is it just a simple
>> boot and load a module or are you running selftests or something else?
> 
> It fails a simple boot test. Here is a detailed instruction how to
> reproduce this issue with the random Debian rootfs image found on the
> internet (tested on Ubuntu 22.04, with next-20250610
> kernel source):

riscv is one of the archs where pte_mkdevmap() will *not* set the pte as special. (I
raised this recently in the original series, it's all a big mess)

So, before this change here, pfn_t_devmap() would have returned "false" if only
PFN_DEV was set, now it would return "true" if only PFN_DEV is set.

Consequently, in insert_pfn() we would have done a pte_mkspecial(), now we do a
pte_mkdevmap() -- again, which does not imply "special" on riscv.

riscv selects CONFIG_ARCH_HAS_PTE_SPECIAL, so if !pte_special(), it's considered as
normal.

Would the following fix your issue?


diff --git a/mm/memory.c b/mm/memory.c
index 8eba595056fe3..0e972c3493692 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -589,6 +589,10 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
  {
         unsigned long pfn = pte_pfn(pte);
  
+       /* TODO: remove this crap and set pte_special() instead. */
+       if (pte_devmap(pte))
+               return NULL;
+
         if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
                 if (likely(!pte_special(pte)))
                         goto check_pfn;
@@ -598,16 +602,6 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
                         return NULL;
                 if (is_zero_pfn(pfn))
                         return NULL;
-               if (pte_devmap(pte))
-               /*
-                * NOTE: New users of ZONE_DEVICE will not set pte_devmap()
-                * and will have refcounts incremented on their struct pages
-                * when they are inserted into PTEs, thus they are safe to
-                * return here. Legacy ZONE_DEVICE pages that set pte_devmap()
-                * do not have refcounts. Example of legacy ZONE_DEVICE is
-                * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
-                */
-                       return NULL;
  
                 print_bad_pte(vma, addr, pte, NULL);
                 return NULL;


But, I would have thought the later patches in Alistairs series would sort that out
(where we remove pte_devmap() ... )

-- 
Cheers,

David / dhildenb

