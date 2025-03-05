Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85F01465AD
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 01:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138921; cv=none; b=OATO0b+3dAy8hsVTkfBe8iqOJ/BJHHsh2LGu6zGLqwuTfX7qUjWtenxrk2CboVXkEy8F5tcf5bI+sqv6Sv28+/cT3w1qY2GdM+9qPEi/8RcCnqfHIw2zikHDGrMMoXuFoRKGltn4hK9WZr178930HCqHln3Jc36cegykXD00Vy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138921; c=relaxed/simple;
	bh=k89tu6JS/a/pyqtjF2M6CTjAuugZEOVu5TcSfnktE8c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gk7YZ+2kD3Cpb1T4duyq5Uw0wBNDDjwGXt+2UyCvPT3kaLHF5UBf29H66Gn2ibHPuw45P2POQhZ8TWDYHJaRBuTfmZupUlXtvWwjyR4fCS9lVdiEKfevzNtLtLAqdwKQiZBPgckcFHtPRAKoyWzTELMYdRxDzCCS2lu/1sFGAAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6wJF1BFgz4f3khX
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 09:41:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4326F1A06DC
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 09:41:55 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl_hq8dnsMVLFg--.55450S3;
	Wed, 05 Mar 2025 09:41:55 +0800 (CST)
Subject: Re: [PATCH V2 00/12] badblocks: bugfix and cleanup for badblocks
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, ira.weiny@intel.com, dlemoal@kernel.org,
 kch@nvidia.com, yanjun.zhu@linux.dev, hare@suse.de, zhengqixing@huawei.com,
 colyli@kernel.org, geliang@kernel.org, xni@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f30a7a37-7e2c-2c4c-ae55-a18ec7d6e98a@huaweicloud.com>
Date: Wed, 5 Mar 2025 09:41:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl_hq8dnsMVLFg--.55450S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1DKr4rXr4rXw4kXw4ktFb_yoW8uF4kpr
	nxt343Aw18ury7Wa1kZw4jvryFka1xJayUG3y7t348uryjva4xGr1kXa1rXFyjqry3JrnF
	qF1YgryY9FyrCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8Jr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU07PEDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Jens!

在 2025/02/27 15:54, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Hi,
> 
> during RAID feature implementation testing, we found several bugs
> in badblocks.
> 
> This series contains bugfixes and cleanups for MD RAID badblocks
> handling code.
> 
> V2:
>          - patch 4: add a description of the issue
>          - patch 5: add comment of parital setting
>          - patch 6: add fix tag
>          - patch 10: two code style modifications
>          - patch 11: keep original functionality of rdev_clear_badblocks(),
>            functionality was incorrectly modified in V1.
> 	- patch 1-10 and patch 12 are reviewed by Yu Kuai
> 	  <yukuai3@huawei.com>
> 	- patch 1, 3, 5, 6, 8, 9, 10, 12 are acked by Coly Li
> 	  <colyli@kernel.org>
> 
> Li Nan (8):
>    badblocks: Fix error shitf ops
>    badblocks: factor out a helper try_adjacent_combine
>    badblocks: attempt to merge adjacent badblocks during
>      ack_all_badblocks
>    badblocks: return error directly when setting badblocks exceeds 512
>    badblocks: return error if any badblock set fails
>    badblocks: fix the using of MAX_BADBLOCKS
>    badblocks: try can_merge_front before overlap_front
>    badblocks: fix merge issue when new badblocks align with pre+1
> 
> Zheng Qixing (4):
>    badblocks: fix missing bad blocks on retry in _badblocks_check()
>    badblocks: return boolean from badblocks_set() and badblocks_clear()
>    md: improve return types of badblocks handling functions
>    badblocks: use sector_t instead of int to avoid truncation of
>      badblocks length
> 

This set contains fixes that are found by testing mdraid, please
consider this set for the next merge window, or I can apply it to
md-6.15.

Thanks,
Kuai

>   block/badblocks.c             | 322 +++++++++++++---------------------
>   drivers/block/null_blk/main.c |  16 +-
>   drivers/md/md.c               |  48 ++---
>   drivers/md/md.h               |  14 +-
>   drivers/md/raid1-10.c         |   2 +-
>   drivers/md/raid1.c            |  10 +-
>   drivers/md/raid10.c           |  14 +-
>   drivers/nvdimm/badrange.c     |   2 +-
>   drivers/nvdimm/nd.h           |   2 +-
>   drivers/nvdimm/pfn_devs.c     |   7 +-
>   drivers/nvdimm/pmem.c         |   2 +-
>   include/linux/badblocks.h     |  10 +-
>   12 files changed, 183 insertions(+), 266 deletions(-)
> 

