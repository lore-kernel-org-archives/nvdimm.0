Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E812374
	for <nvdimm@lists.linux.dev>; Tue, 30 Aug 2022 06:17:48 +0000 (UTC)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MGxrb3cJSzHnVd;
	Tue, 30 Aug 2022 14:15:59 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 14:17:44 +0800
Subject: Re: [PATCH 4/4] mm/memory-failure: Fall back to vma_address() when
 ->notify_failure() fails
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
 <166153429427.2758201.14605968329933175594.stgit@dwillia2-xfh.jf.intel.com>
 <76fb4464-73eb-256c-60e0-a0c3dc152e78@huawei.com>
 <630d8a902231b_259e5b29490@dwillia2-xfh.jf.intel.com.notmuch>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <abe4b976-e2b2-57e6-9cd5-596129d11a95@huawei.com>
Date: Tue, 30 Aug 2022 14:17:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <630d8a902231b_259e5b29490@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected

On 2022/8/30 11:57, Dan Williams wrote:
> Miaohe Lin wrote:
>> On 2022/8/27 1:18, Dan Williams wrote:
>>> In the case where a filesystem is polled to take over the memory failure
>>> and receives -EOPNOTSUPP it indicates that page->index and page->mapping
>>> are valid for reverse mapping the failure address. Introduce
>>> FSDAX_INVALID_PGOFF to distinguish when add_to_kill() is being called
>>> from mf_dax_kill_procs() by a filesytem vs the typical memory_failure()
>>> path.
>>
>> Thanks for fixing.
>> I'm sorry but I can't find the bug report email. 
> 
> Report is here:
> 
> https://lore.kernel.org/all/63069db388d43_1b3229426@dwillia2-xfh.jf.intel.com.notmuch/
> 
>> Do you mean mf_dax_kill_procs() can pass an invalid pgoff to the
>> add_to_kill()? 
> 
> No, the problem is that ->notify_failure() returns -EOPNOTSUPP so
> memory_failure_dev_pagemap() falls back to mf_generic_kill_procs().
> However, mf_generic_kill_procs() end up passing '0' for fsdax_pgoff from
> collect_procs_file() to add_to_kill(). A '0' for fsdax_pgoff results in
> vma_pgoff_address() returning -EFAULT which causes the VM_BUG_ON() in
> dev_pagemap_mapping_shift().

Many thanks for your explanation.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks,
Miaohe Lin

