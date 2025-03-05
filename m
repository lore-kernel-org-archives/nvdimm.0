Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF7D143736
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 01:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138198; cv=none; b=BYd7ZEvOm97+3kD/02yJk+WlSMsi+mrlBZFkeNqqUTYeY7+rYVnzsy5foo+e0YqHG9dsmW0XkUSoqSIku6eGHoARuJwzrHCFWJY/4mmzeE9yV0ewAkbIY1wOMHLBvmM2iyJXGIP4esibm6vhpQOCOMfuWV5hLb2H5NdfBQTUaZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138198; c=relaxed/simple;
	bh=Z82A1GypgMf51psxKEymQiZYIfSF+fYhtm8JSfxC4Mw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PMAECtrflcoeeT7vKWMu56dp8SsRbCM62y7xxTsK59mr4mA/krU/SaFj11hDT+cMYDhd6qI14KjXY2AzC8dCUUG7hhy2qbKhO6hgYZnWByeX79Xnj6I/a5tuXtKwVOK5uUE6oFioKPhZNNjq/bTlyyurNwzhy9YpgxX0QYuvFog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6w2L3ZZSz4f3kpQ
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 09:29:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 935691A1393
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 09:29:52 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHa18PqcdnevVKFg--.56374S3;
	Wed, 05 Mar 2025 09:29:52 +0800 (CST)
Subject: Re: [PATCH V2 12/12] badblocks: use sector_t instead of int to avoid
 truncation of badblocks length
To: Ira Weiny <ira.weiny@intel.com>,
 Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, dlemoal@kernel.org, kch@nvidia.com,
 yanjun.zhu@linux.dev, hare@suse.de, zhengqixing@huawei.com,
 colyli@kernel.org, geliang@kernel.org, xni@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
 <20250227075507.151331-13-zhengqixing@huaweicloud.com>
 <67c0844fe82af_b2959294d1@iweiny-mobl.notmuch>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6f2cafc4-7b18-7bce-94cc-b58a1707f630@huaweicloud.com>
Date: Wed, 5 Mar 2025 09:29:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <67c0844fe82af_b2959294d1@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa18PqcdnevVKFg--.56374S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYH7kC6x804xWl14x267AKxVW5JVWrJwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4
	kS14v26r4a6rW5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4l
	x2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrw
	CI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI
	42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
	80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbG2NtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/02/27 23:27, Ira Weiny Ð´µÀ:
> __add_badblock_range() in drivers/nvdimm/badrange.c limits the number of
> badblocks which can be set in each call to badblocks_set().
> 
> After this change can that algorithm be eliminated?  I'm not familiar with
> the badblocks code to know for certain.

This is another story, badblocks records are at most 512, and each
record is at most 512 sectors, so pass in INT_MAX will fail 100%.

Thanks,
Kuai

