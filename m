Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F4225A3B
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 07:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643164; cv=none; b=V/WdI5u5qZgKnOwOq6+UpKDHDcBOMRc6hikCC03tLEZq+iGp6K+tqNkhf1bXUB3TdBAs1+BPsgjtij7IXtrs+nHKomaDC8bERaqRTuPObWDiKy2ymnjk51L9U682p5VlVojpTenAPnrTP5F99M2yX/KuIPvmT15QqCN701eNk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643164; c=relaxed/simple;
	bh=eIK6f1xdC/gmj/6eb8x2ZwnscNw6e+6hXWxyPHoFkGo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CzY8v7p19qrTVmm17eLUNS5vQnaPFDvyazEX4J162Zlf2xSc7QSdV2YtKxTo8gf7jnA0FRz3ozQL32Sp+f5uO3E1FavCzRGTzxT6A/TbYS0CPx0UqBn8xz7IvnRqI3s1dwNEweoWFRHdQygABASCNVj51sIcvYBiHVAwtqCnE5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z3NyN2DVhz4f3jYX
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:58:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2F71A1A06D7
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 15:59:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S4;
	Thu, 27 Feb 2025 15:59:13 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	dlemoal@kernel.org,
	kch@nvidia.com,
	yanjun.zhu@linux.dev,
	hare@suse.de,
	zhengqixing@huawei.com,
	colyli@kernel.org,
	geliang@kernel.org,
	xni@redhat.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V2 00/12] badblocks: bugfix and cleanup for badblocks
Date: Thu, 27 Feb 2025 15:54:55 +0800
Message-Id: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4UurWfZFWUWw45uw4Durg_yoW8CF1rpF
	nxK343Ar48ur47Xa4kZw4UZFyF9a1xJFWUG3y7J34kuFyUAas7Jr1vqF1Fqryqqry3JrnF
	qF1YgryUWry8Cw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a
	6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUIa0PDUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Hi,

during RAID feature implementation testing, we found several bugs
in badblocks.

This series contains bugfixes and cleanups for MD RAID badblocks
handling code.

V2:
        - patch 4: add a description of the issue
        - patch 5: add comment of parital setting
        - patch 6: add fix tag
        - patch 10: two code style modifications
        - patch 11: keep original functionality of rdev_clear_badblocks(),
          functionality was incorrectly modified in V1.
	- patch 1-10 and patch 12 are reviewed by Yu Kuai
	  <yukuai3@huawei.com>
	- patch 1, 3, 5, 6, 8, 9, 10, 12 are acked by Coly Li
	  <colyli@kernel.org>

Li Nan (8):
  badblocks: Fix error shitf ops
  badblocks: factor out a helper try_adjacent_combine
  badblocks: attempt to merge adjacent badblocks during
    ack_all_badblocks
  badblocks: return error directly when setting badblocks exceeds 512
  badblocks: return error if any badblock set fails
  badblocks: fix the using of MAX_BADBLOCKS
  badblocks: try can_merge_front before overlap_front
  badblocks: fix merge issue when new badblocks align with pre+1

Zheng Qixing (4):
  badblocks: fix missing bad blocks on retry in _badblocks_check()
  badblocks: return boolean from badblocks_set() and badblocks_clear()
  md: improve return types of badblocks handling functions
  badblocks: use sector_t instead of int to avoid truncation of
    badblocks length

 block/badblocks.c             | 322 +++++++++++++---------------------
 drivers/block/null_blk/main.c |  16 +-
 drivers/md/md.c               |  48 ++---
 drivers/md/md.h               |  14 +-
 drivers/md/raid1-10.c         |   2 +-
 drivers/md/raid1.c            |  10 +-
 drivers/md/raid10.c           |  14 +-
 drivers/nvdimm/badrange.c     |   2 +-
 drivers/nvdimm/nd.h           |   2 +-
 drivers/nvdimm/pfn_devs.c     |   7 +-
 drivers/nvdimm/pmem.c         |   2 +-
 include/linux/badblocks.h     |  10 +-
 12 files changed, 183 insertions(+), 266 deletions(-)

-- 
2.39.2

