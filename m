Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5072E36A
	for <nvdimm@lists.linux.dev>; Tue, 30 Aug 2022 02:49:47 +0000 (UTC)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGsBJ557MzkWTJ;
	Tue, 30 Aug 2022 10:46:00 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 10:49:37 +0800
Subject: Re: [PATCH 3/4] mm/memory-failure: Fix detection of memory_failure()
 handlers
To: Dan Williams <dan.j.williams@intel.com>
CC: Shiyang Ruan <ruansy.fnst@fujitsu.com>, Christoph Hellwig <hch@lst.de>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Jane Chu <jane.chu@oracle.com>, Matthew Wilcox <willy@infradead.org>, Ritesh
 Harjani <riteshh@linux.ibm.com>, <nvdimm@lists.linux.dev>,
	<linux-xfs@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
	<djwong@kernel.org>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com>
 <166153428781.2758201.1990616683438224741.stgit@dwillia2-xfh.jf.intel.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f4f25c79-33b3-b1ae-3481-0328cbed199b@huawei.com>
Date: Tue, 30 Aug 2022 10:49:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <166153428781.2758201.1990616683438224741.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected

On 2022/8/27 1:18, Dan Williams wrote:
> Some pagemap types, like MEMORY_DEVICE_GENERIC (device-dax) do not even
> have pagemap ops which results in crash signatures like this:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000010
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 8000000205073067 P4D 8000000205073067 PUD 2062b3067 PMD 0
>   Oops: 0000 [#1] PREEMPT SMP PTI
>   CPU: 22 PID: 4535 Comm: device-dax Tainted: G           OE    N 6.0.0-rc2+ #59
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:memory_failure+0x667/0xba0
>  [..]
>   Call Trace:
>    <TASK>
>    ? _printk+0x58/0x73
>    do_madvise.part.0.cold+0xaf/0xc5
> 
> Check for ops before checking if the ops have a memory_failure()
> handler.
> 
> Fixes: 33a8f7f2b3a3 ("pagemap,pmem: introduce ->memory_failure()")
> Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Ritesh Harjani <riteshh@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

LGTM. Thanks for fixing this.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks,
Miaohe Lin


> ---
>  include/linux/memremap.h |    5 +++++
>  mm/memory-failure.c      |    2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 19010491a603..c3b4cc84877b 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -139,6 +139,11 @@ struct dev_pagemap {
>  	};
>  };
>  
> +static inline bool pgmap_has_memory_failure(struct dev_pagemap *pgmap)
> +{
> +	return pgmap->ops && pgmap->ops->memory_failure;
> +}
> +
>  static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
>  {
>  	if (pgmap->flags & PGMAP_ALTMAP_VALID)
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 14439806b5ef..8a4294afbfa0 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1928,7 +1928,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>  	 * Call driver's implementation to handle the memory failure, otherwise
>  	 * fall back to generic handler.
>  	 */
> -	if (pgmap->ops->memory_failure) {
> +	if (pgmap_has_memory_failure(pgmap)) {
>  		rc = pgmap->ops->memory_failure(pgmap, pfn, 1, flags);
>  		/*
>  		 * Fall back to generic handler too if operation is not
> 
> 
> .
> 

