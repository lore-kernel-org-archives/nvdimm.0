Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE9378
	for <nvdimm@lists.linux.dev>; Tue,  4 Apr 2023 04:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1680582858; i=@fujitsu.com;
	bh=Mqs9Av7h/o+dArURI0csKOUbQHg/tcabDiHBubWe4cM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=W8pmvVaq3cJ8LnklnICet2iHkK5dpGbcU8iEvTYoFeMRELNjIYhQojR57aCCR3dyG
	 ZHvRe6poU5+0eIq4IvBdPkVznEfI2ucFPhI+M6dzOkHgfr4D3x27Wz9ydGZXtPm/B5
	 hAcUtJ23b/Ulw9Hn+hYVkfDDLUli88diSti1c1t54tqA9S8V0lEcnl+XlAi1vFdAQs
	 EjIf0xFxTKBPjc/LD41LclCmLr6281/Xi8lMU2UNNmi55psAlvg5MJBqr20u59Vd74
	 Md99zhF+WeBl5+xzRXeqZ4Jbv8395mvj8IIkVDiiburOBdekVegcjyVZzNKJGbOmzz
	 6RWp9liuCGNew==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRWlGSWpSXmKPExsViZ8ORqLtvhXa
  KwcmvhhZz1q9hs5g+9QKjxeUnfBazpzczWezZe5LF4t6a/6wWu/7sYLdY+eMPq8XvH3PYHDg9
  Nq/Q8li85yWTx6ZVnWwemz5NYvc4MeM3i8eLzTMZPc4sOMLu8XmTXABHFGtmXlJ+RQJrxt3ms
  6wFp3kqTjzuZG5g/MrZxcjFISSwhVHixrWdjF2MnEDOciaJvv4EiMRWRom7x7cxgSR4Bewklp
  y9z9rFyMHBIqAisWGpHERYUOLkzCcsILaoQLLEsU1tbCC2sICfRP+Sk+wgNpuAjsSFBX9ZQWw
  RgUKJPUvfgdUzC1RINC76xwwyUkjAWeJatz1ImFPAReLtlxZmiBILicVvDrJD2PISzVtng8Ul
  BJQkLn69wwphA42ZfogJwlaTuHpuE/MERqFZSK6bhWTULCSjFjAyr2I0LU4tKkst0jXXSyrKT
  M8oyU3MzNFLrNJN1Est1S1PLS7RNdJLLC/WSy0u1iuuzE3OSdHLSy3ZxAiMu5Ri5Zk7GJf1/d
  U7xCjJwaQkyuuoqJ0ixJeUn1KZkVicEV9UmpNafIhRhoNDSYL32BKgnGBRanpqRVpmDjAFwKQ
  lOHiURHh9FgOleYsLEnOLM9MhUqcYdTnWNhzYyyzEkpeflyolzmuxHKhIAKQoozQPbgQsHV1i
  lJUS5mVkYGAQ4ilILcrNLEGVf8UozsGoJMxrMA9oCk9mXgncpldARzABHdEapQFyREkiQkqqg
  Sl3ssTRewEbOydZBtueWllg5TDL+QLXrhAZzkK3x55Cc/465WfE6Z8pvlqUnnp50hPzxhZbjy
  gFqUWBws8tBObNyDV5xulffMtH56/8TPs3xY+DDefNmdOdoXav52/7ilurZQObuX6/Ly/4Ozv
  sD+OcPrM1l8+UvP2mZ2URG7plRqCd15RojdsTRZW5CtgEJrbYuNXPORN36/2uxiUL1h6dvsvF
  fSb358aQ0Ii0n8X/fvzfpX7qXXxdsfiras6mmBmLHnCWnZHPdzv0Zt2q7afFz1/x/ruZPTcuf
  1Ht8+yuznqGO01nhZX0fskkqcefzj7SUZQoe/mW/IGGpuNnLRdKyyn07ry43CqmfpNoihJLcU
  aioRZzUXEiAO0Lqe3CAwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-20.tower-571.messagelabs.com!1680582846!427180!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 22136 invoked from network); 4 Apr 2023 04:34:06 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-20.tower-571.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 4 Apr 2023 04:34:06 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 75E7F1001BA;
	Tue,  4 Apr 2023 05:34:06 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 695CE1001A8;
	Tue,  4 Apr 2023 05:34:06 +0100 (BST)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Tue, 4 Apr 2023 05:34:02 +0100
Message-ID: <f7ae5c4f-b2c6-6b64-4b2a-a04bd1ad1aa6@fujitsu.com>
Date: Tue, 4 Apr 2023 12:33:56 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v11 0/2] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-xfs@vger.kernel.org>, <linux-mm@kvack.org>
CC: <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<akpm@linux-foundation.org>, <djwong@kernel.org>
References: <1679996506-2-1-git-send-email-ruansy.fnst@fujitsu.com>
In-Reply-To: <1679996506-2-1-git-send-email-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

Ping

在 2023/3/28 17:41, Shiyang Ruan 写道:
> This patchset is to add gracefully unbind support for pmem.
> Patch1 corrects the calculation of length and end of a given range.
> Patch2 introduces a new flag call MF_MEM_REMOVE, to let dax holder know
> it is a remove event.  With the help of notify_failure mechanism, we are
> able to shutdown the filesystem on the pmem gracefully.
> 
> Changes since v10:
>   Patch1:
>    1. correct the count calculation in xfs_failure_pgcnt().
>   Patch2:
>    2. drop the patch which introduces super_drop_pagecache().
>    3. in mf_dax_kill_procs(), don't SetPageHWPoison() and search for all
>        tasks while mf_flags has MF_MEM_PRE_REMOVE.
>    4. only do mf_dax_kill_procs() on dax mapping.
>    5. do invalidate_inode_pages2_range() for each file found during rmap,
>        to make sure the dax entry are disassociated before pmem is gone.
>        Otherwise, umount filesystem after unbind will cause crash because
>        the dax entries have to be disassociated but now the pmem is not
>        exist.
> 
>    For detail analysis of this change, please refer this link[1].
> 
> [1] https://lore.kernel.org/linux-xfs/b1d9fc03-1a71-a75f-f87b-5819991e4eb2@fujitsu.com/
> 
> Shiyang Ruan (2):
>    xfs: fix the calculation of length and end
>    mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
> 
>   drivers/dax/super.c         |  3 +-
>   fs/xfs/xfs_notify_failure.c | 66 +++++++++++++++++++++++++++++++------
>   include/linux/mm.h          |  1 +
>   mm/memory-failure.c         | 17 +++++++---
>   4 files changed, 72 insertions(+), 15 deletions(-)
> 
