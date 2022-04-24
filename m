Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123677A
	for <nvdimm@lists.linux.dev>; Sun, 24 Apr 2022 02:20:53 +0000 (UTC)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KmBCp4fXkz1JBJC;
	Sun, 24 Apr 2022 09:59:34 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 10:00:23 +0800
Subject: Re: [PATCH v13 3/7] pagemap,pmem: Introduce ->memory_failure()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>,
	<linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220419045045.1664996-4-ruansy.fnst@fujitsu.com>
 <f173f091-d5ca-b049-a8ed-6616032ca83e@huawei.com>
 <4a808b12-9215-9421-d114-951e70764778@fujitsu.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <cc219e5d-a400-776c-116b-21e5d1470045@huawei.com>
Date: Sun, 24 Apr 2022 10:00:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4a808b12-9215-9421-d114-951e70764778@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected

On 2022/4/22 15:06, Shiyang Ruan wrote:
> 
> 
...
>>
>> Thanks for your patch. There are two questions:
>>
>> 1.Is dax_lock_page + dax_unlock_page pair needed here?
> 
> They are moved into mf_generic_kill_procs() in Patch2.  Callback will implement its own dax lock/unlock method.  For example, for mf_dax_kill_procs() in Patch4, we implemented dax_lock_mapping_entry()/dax_unlock_mapping_entry() for it.
> 
>> 2.hwpoison_filter and SetPageHWPoison will be handled by the callback or they're just ignored deliberately?
> 
> SetPageHWPoison() will be handled by callback or by mf_generic_kill_procs().
> 
> hwpoison_filter() is moved into mf_generic_kill_procs() too.  The callback will make sure the page is correct, so it is ignored.

I see this when I read the other patches. Many thanks for clarifying!

> 
> 
> -- 
> Thanks,
> Ruan.
> 
>>
>> Thanks!
>>
>>>       rc = mf_generic_kill_procs(pfn, flags, pgmap);
>>>   out:
>>>       /* drop pgmap ref acquired in caller */
>>>
>>
> 
> 
> .

