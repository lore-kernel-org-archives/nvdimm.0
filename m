Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675ED37BE72;
	Mon,  7 Sep 2026 15:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795787; cv=none; b=fKapFGRluqvTQL/WTZJY3FJgxhGFfqWcEYYewKidotx+A8b3LBSBWNAajpnVVt55JsYK3Uh6exTsvWDPPFwowfJbUBJrK0XS/2HCrtnLK5HP90cTG6D2BSpwg1y4A1Bp2QzSQki96ReO6Y4C/ZVZPQ7T1tA+JH/9VJTE/VTxIrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795787; c=relaxed/simple;
	bh=K6qPSlToR5uu/qcbqTpx7P+ULOjLAlFpeSd7M+VE3D8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aKtImlubIzU/mU8eNwBfFrT+75qf6EgRk8G2L25M8Uf2RkukTF6DN2zJuEvAG55e5xKHnlejAIqKviOBr6HkHnB1Nx5E+hQw/IHS8+kJC6601t9a5CagtCelbSr3JC7t/CZ9BCWHxAboq9HKoq5zemkcEUqjlbnQKDW9KMI59lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNLCa38H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNLCa38H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568C91F00A3A;
	Mon,  7 Sep 2026 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788795785;
	bh=TNjNLeGp14CZ7H0hPBAL/K95RBhlJSMOUysdZ+y0VyU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JNLCa38H/fWC6bxScgrTh1MFyJfj/qnvLfUXDf6lPj1RdiwyeB0sgAikXVYG740Zd
	 z3O6FtVNKPfeRwn8ShcsxfOs4hXpbGYrw1/XZLNHlV2q7URu2JCZ/LbeqluU7elGn7
	 Pw6f3AJvYiNxgaUpFu1Hrg34W1QUBdEGiLGo+vHhkSNe9MZRmX7xA1Yta5wadN9ab1
	 a86x33SLemC+3TUqgQ4OPNQ3iybjnTmTZargy4k+1LjX0wOip3ya28v/Hukzz5n8t2
	 KejDM9bFfdBQZt8YNOeYK7ajIc2RUTAX+O9mo0/mHjCm2Bh/7wfbjTEMs3XDvZ2OkF
	 vKr3Qd6AucawA==
Message-ID: <2cbf7f64-b2a1-4a7f-9887-8539525a3b6a@kernel.org>
Date: Mon, 7 Sep 2026 17:42:58 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903053535.17611-3-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/3/26 07:35, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> TestClearPageHWPoison() is now defined regardless of whether
> CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
> handling is unavailable.
> 
> The test_and_clear_pmem_poison() wrapper duplicates this configuration
> handling and has no other pmem-specific behavior.
> 
> Call TestClearPageHWPoison() directly and remove the redundant wrapper.
> This also removes the need to include page-flags.h from pmem.h.
> 
> No functional change is intended.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  drivers/nvdimm/pmem.c |  2 +-
>  drivers/nvdimm/pmem.h | 12 ------------
>  2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..5fb86595e8bd 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (TestClearPageHWPoison(page))
>  			clear_mce_nospec(pfn);
>  	}
>  }
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index a48509f90196..76870505dd79 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __NVDIMM_PMEM_H__
>  #define __NVDIMM_PMEM_H__
> -#include <linux/page-flags.h>
>  #include <linux/badblocks.h>
>  #include <linux/memremap.h>
>  #include <linux/types.h>
> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>  		unsigned long *pfn);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return TestClearPageHWPoison(page);
> -}
> -#else
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return false;
> -}
> -#endif
>  #endif /* __NVDIMM_PMEM_H__ */


With #1 squashed and the patch description updated accordingly:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David
