Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A52313E38
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 06:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776062279; cv=none; b=MqKbhlXeN9JAqHNT+RBoOId2jyGBvj1aX3w1mvGsmopWALDCQw+sM9i2/wzfodfgX1a+YMU+0PF3CGeSbXzYZdcmrr8phZm/pkCi30vU7Jtchyh4hShwLCtw+b0lEstdWB0cRYttxz8XkLb1HkL4TwFMppV6d5zd228yMe2VDeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776062279; c=relaxed/simple;
	bh=oB93Jo0Hird487YH6LLEBixEFdTrDVpgeLLVzfgz3m4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S5QFBy/pGZNF2apE8BWPA9EUq0XanLEaRpYlK+j80g2n/v2FNae6e+za7EMDiGTyvh9Ye6pnXmHMyYB4fhi0obAmDgFtfW4csZhmSN7JbTzWsdYsEOvdBNHhYZnJWI9yatJMtdqj4OzKIsyEbOx12KI9mx24klCX1xYkC5ThPio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvHNX68Ypz1YQpmD;
	Mon, 13 Apr 2026 14:21:16 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fvHNW0JZ7z1YQpmD;
	Mon, 13 Apr 2026 14:21:15 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id F402830004D3;
	Mon, 13 Apr 2026 14:19:21 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 13 Apr
 2026 14:21:13 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Date: Mon, 13 Apr 2026 14:20:39 +0800
Message-ID: <20260413062042.804-1-huangsj@hygon.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)

  In NUMA, there are maybe many NUMA nodes and many CPUs.
For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
In the UnixBench tests, there is a test "execl" which tests
the execve system call.

  When we test our server with "./Run -c 384 execl",
the test result is not good enough. The i_mmap locks contended heavily on
"libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
over 6000 VMAs, all the VMAs can be in different NUMA mode.
The insert/remove operations do not run quickly enough.

patch 1 & patch 2 are try to hide the direct access of i_mmap.
patch 3 splits the i_mmap into sibling trees, and we can get better 
performance with this patch set:
    we can get 77% performance improvement(10 times average)


Huang Shijie (3):
  mm: use mapping_mapped to simplify the code
  mm: use get_i_mmap_root to access the file's i_mmap
  mm: split the file's i_mmap tree for NUMA

 arch/arm/mm/fault-armv.c   |  3 ++-
 arch/arm/mm/flush.c        |  3 ++-
 arch/nios2/mm/cacheflush.c |  3 ++-
 arch/parisc/kernel/cache.c |  4 ++-
 fs/dax.c                   |  3 ++-
 fs/hugetlbfs/inode.c       | 10 +++----
 fs/inode.c                 | 55 +++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h         | 40 +++++++++++++++++++++++++++
 include/linux/mm.h         | 33 +++++++++++++++++++++++
 include/linux/mm_types.h   |  1 +
 kernel/events/uprobes.c    |  3 ++-
 mm/hugetlb.c               |  7 +++--
 mm/khugepaged.c            |  6 +++--
 mm/memory-failure.c        |  8 +++---
 mm/memory.c                |  8 +++---
 mm/mmap.c                  |  3 ++-
 mm/nommu.c                 | 11 +++++---
 mm/pagewalk.c              |  2 +-
 mm/rmap.c                  |  2 +-
 mm/vma.c                   | 36 +++++++++++++++++++------
 mm/vma_init.c              |  1 +
 21 files changed, 204 insertions(+), 38 deletions(-)

-- 
2.43.0


