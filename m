Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AF11F5849
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 09:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740128467; cv=none; b=gj7Zo0mF7JKuZcTQ+0hCE6AXJpnXNlMJpY1wQ15SZaFBvT8U4rHwVMJqD64cN/T1Vu1+1SKCJI3rPiIJ0Dtpa+vjIUh4zdZjb/bfC6KWTqKPq6KeNg7nFncg/LhycPPToqxknHlucMo9dVx8hOQa72ixDGFauvU7sHh+2eBcDI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740128467; c=relaxed/simple;
	bh=V/WC878/m89s/Z5XeDingIqbZTQiDl+/BAF06rycO1E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cflQncG6kaCVjhv9bFOjNNL8fxEZl0oTJolbP3uPmHfxn0Fzelb6GzLwSbtavUgEkd9VszZBPVprK0mYtAa6XTSbvY+9eaN5YyxsPIY3KkrVYWpElenQ7oZ/5gFmOKM58bQ4F3F2xj1DzWUFdHkDDb/qFEgjTQU4R0UffXkacU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzkcX26nZz4f3jqM
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:00:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9F8711A058E
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:01:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH61_KQLhnK3ThEQ--.4447S3;
	Fri, 21 Feb 2025 17:01:00 +0800 (CST)
Subject: Re: [PATCH 00/12] badblocks: bugfix and cleanup for badblocks
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0ee2aa61-9190-53ce-1cbc-a8b40303187c@huaweicloud.com>
Date: Fri, 21 Feb 2025 17:00:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61_KQLhnK3ThEQ--.4447S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyfGw4rGFyrKFW5tr4UXFb_yoW8AFW3pr
	9xG343Ar18ury8Wa1DZw4jqryrCw1xJayUG3yUJ398WryUAa4xGr1kXa1rXFyqqry3JrnF
	qF1Yga45uFy5Cw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUIa0PDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/21 16:10, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> During RAID feature implementation testing, we found several bugs
> in badblocks.
> 
> This series contains bugfixes and cleanups for MD RAID badblocks
> handling code.

In addition, patch 1-8 is found while testing badblocks APIs, by mdraid
sysfs APIs, and it's applied and running in downstream kernels for a
long time.

Patch 9-12 is found recently by RAID new feature that is still in
development.

Thanks,
Kuai

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
>    badblocks: return boolen from badblocks_set() and badblocks_clear()
>    md: improve return types of badblocks handling functions
>    badblocks: use sector_t instead of int to avoid truncation of
>      badblocks length
> 
>   block/badblocks.c             | 317 +++++++++++++---------------------
>   drivers/block/null_blk/main.c |  19 +-
>   drivers/md/md.c               |  47 +++--
>   drivers/md/md.h               |  14 +-
>   drivers/md/raid1-10.c         |   2 +-
>   drivers/md/raid1.c            |  10 +-
>   drivers/md/raid10.c           |  14 +-
>   drivers/nvdimm/badrange.c     |   2 +-
>   drivers/nvdimm/nd.h           |   2 +-
>   drivers/nvdimm/pfn_devs.c     |   7 +-
>   drivers/nvdimm/pmem.c         |   2 +-
>   include/linux/badblocks.h     |  10 +-
>   12 files changed, 181 insertions(+), 265 deletions(-)
> 

