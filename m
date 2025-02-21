Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792E333EA
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 09:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129175; cv=none; b=pG/qIFx/3J4NF+3rYrzfRn7nWjKjdqwvminCKgNmgOwqMT46zPc5Fra6D+7WFUavnOERGv7b47m1XTOyF7OXsmYXfRvMPGbBrpro6pkq/N5+dLR8s1y6G1FZlHiAz28nYqigw29mNUnLpTpBC84l8WwdcuVka3alTfqVHfwqSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129175; c=relaxed/simple;
	bh=qBNDGok0ZLX8c5yCRbGm5cdISBhSDit295ASxo2LD70=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=W8R/OWgy3WIdw65pC0ABQu4EbiJ7mAbOmBIYJjyeMR94P2TR/NBBp7Efp8d6AAywhOkxoqvkQ2dwPbl/r0CThOgcMX++LxXuiSG6cUZ2O2EX4S4xEkhmn6vkeOtZvmf970f/ckLrlEgp8+j42ssMxwhVP1Kp9/armRnjXgehpaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yzkt96d6gz4f3jqP
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:12:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 485671A06DD
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 17:12:50 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXul6PQ7hnsz_iEQ--.4076S3;
	Fri, 21 Feb 2025 17:12:50 +0800 (CST)
Subject: Re: [PATCH 03/12] badblocks: attempt to merge adjacent badblocks
 during ack_all_badblocks
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
 <20250221081109.734170-4-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <95d0bd33-6142-5b89-bf29-317137db9882@huaweicloud.com>
Date: Fri, 21 Feb 2025 17:12:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221081109.734170-4-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXul6PQ7hnsz_iEQ--.4076S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFyDZw4kXF4xWrWUWr1kGrg_yoWkCFc_Z3
	92yFyxJr95AF1fCr1Syr18Jr4SgFn8Cr4xGryUJF1rZ3W7tFZ7JwsYyFn8Wrs8GFyDuwnx
	Ar95Xr1a9ryIvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbaAYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJr
	UvcSsGvfC2KfnxnUUI43ZEXa7IU07PEDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/21 16:11, Zheng Qixing Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> If ack and unack badblocks are adjacent, they will not be merged and will
> remain as two separate badblocks. Even after the bad blocks are written
> to disk and both become ack, they will still remain as two independent
> bad blocks. This is not ideal as it wastes the limited space for
> badblocks. Therefore, during ack_all_badblocks(), attempt to merge
> badblocks if they are adjacent.
> 
> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   block/badblocks.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/block/badblocks.c b/block/badblocks.c
> index f069c93e986d..ad8652fbe1c8 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -1491,6 +1491,11 @@ void ack_all_badblocks(struct badblocks *bb)
>   				p[i] = BB_MAKE(start, len, 1);
>   			}
>   		}
> +
> +		for (i = 0; i < bb->count ; i++)
> +			while (try_adjacent_combine(bb, i))
> +				;
> +
>   		bb->unacked_exist = 0;
>   	}
>   	write_sequnlock_irq(&bb->lock);
> 

