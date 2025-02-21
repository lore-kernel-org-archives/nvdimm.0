Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5D01FFC60
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 08:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740125700; cv=none; b=X+3JWIfsIPGICgmuXz8o8NHKkUWuBsY7Y37EXFr4j6R3vWnX+Kbhi0YP1Gi0tqdKk+TH4441OGo+fJFxoZDl9gw7PCsFsgC5cR+XFnAc9KPqyl9BxkDrVBimn8Gqw5AVwVOUoODqNtQE6sluHA0EDrcHIq0fV+B6jkCkzg7biPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740125700; c=relaxed/simple;
	bh=aZvFVXJtQbwkBTrVIgiI1mzewIXSi85/1iciqx+9iIk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QIIOgwcWByzm4Us/7PqUp1edyyfKRIJqxZLtpVTlYHxX7agyn5YwliE5XViuiLa7NiP1Olzbb+gW6rgN/wWWRsD2o6ymXo9Qw16dbODcpuOjFDSTV3G3PbHaSP6xf6PjiseRTWtiX5vyzsdB1kGqcq9EMot+J4YmoWmF2Jk0fZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzjbC06Tjz4f3lCf
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1B0DB1A10EB
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 16:14:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl_8NbhnHF3eEQ--.3944S4;
	Fri, 21 Feb 2025 16:14:53 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	colyli@kernel.org,
	yukuai3@huawei.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	dlemoal@kernel.org,
	yanjun.zhu@linux.dev,
	kch@nvidia.com,
	hare@suse.de,
	zhengqixing@huawei.com,
	john.g.garry@oracle.com,
	geliang@kernel.org,
	xni@redhat.com,
	colyli@suse.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 00/12] badblocks: bugfix and cleanup for badblocks
Date: Fri, 21 Feb 2025 16:10:57 +0800
Message-Id: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl_8NbhnHF3eEQ--.3944S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1kGFW8uw1kXryxWF47XFb_yoW8Xr15pF
	nxK343Zr10grW7X3WkZw4UKr1F93WxGFWUK3y7Jas5WFyUAa4xJr1kXF10qryqqry3JrnF
	vF1YgFyUWFy8Cw7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU07PEDUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

During RAID feature implementation testing, we found several bugs
in badblocks.

This series contains bugfixes and cleanups for MD RAID badblocks
handling code.

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
  badblocks: return boolen from badblocks_set() and badblocks_clear()
  md: improve return types of badblocks handling functions
  badblocks: use sector_t instead of int to avoid truncation of
    badblocks length

 block/badblocks.c             | 317 +++++++++++++---------------------
 drivers/block/null_blk/main.c |  19 +-
 drivers/md/md.c               |  47 +++--
 drivers/md/md.h               |  14 +-
 drivers/md/raid1-10.c         |   2 +-
 drivers/md/raid1.c            |  10 +-
 drivers/md/raid10.c           |  14 +-
 drivers/nvdimm/badrange.c     |   2 +-
 drivers/nvdimm/nd.h           |   2 +-
 drivers/nvdimm/pfn_devs.c     |   7 +-
 drivers/nvdimm/pmem.c         |   2 +-
 include/linux/badblocks.h     |  10 +-
 12 files changed, 181 insertions(+), 265 deletions(-)

-- 
2.39.2

