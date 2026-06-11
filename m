Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A46E361675
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781160464; cv=none; b=GVMXnpYLNyQfGruKL4chLfstfPuDl84AihcNiQ5JfG/M8ne12syynL9KXXzjs7gi96t03QADrOHhaIFSAYYUnYorghEsqx85SAnZH+aSOc0zX4VCyRaYHwWZwzO+c+veqWf20SdvSNvEe0/1ZbKqQA5BfBmNYWQm/omiXwBXel4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781160464; c=relaxed/simple;
	bh=qQjh1hPpEnkXFa73SRjJ9kqCtdzJ5Kh2Hsa46GK1zZk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UlV70iuIBEtnVX5LQnIxVGFG/FqpvxmNLDBly1inhLf4+Ibdllc/JQ2LlBWvKlbMTR9CxwAAjp0GlbXTaRXbZ58m10nAEKw28DtwJ6GIalf00yDtfWTJXy6TB0Qn47T6Hh4FuP7l1QCTICd0y8j2BetKdY3E5T+XOCpN6AsKADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbk745pz1dd8Y;
	Thu, 11 Jun 2026 14:21:38 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbh5hZnz1dd8Y;
	Thu, 11 Jun 2026 14:21:36 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 7FE3430004DB;
	Thu, 11 Jun 2026 14:20:11 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:31 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>
CC: <surenb@google.com>, <mjguzik@gmail.com>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <shakeel.butt@linux.dev>,
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux@armlinux.org.uk>, <dinguyen@kernel.org>,
	<schuster.simon@siemens-energy.com>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <djbw@kernel.org>, <willy@infradead.org>,
	<peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
	<namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH v2 0/4] mm: split the file's i_mmap tree for NUMA
Date: Thu, 11 Jun 2026 14:18:56 +0800
Message-ID: <20260611061915.2354307-1-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
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
patch 3 splits the i_mmap into sibling trees, each tree has separate lock,
and we can get better performance with this patch set in our NUMA server:
    we can get over 400% performance improvement.

I did not test the non-NUMA case, since I do not have such server.    
    
v1 --> v2:
	Not only split the immap tree, but also split the lock.
	v1 : https://lkml.org/lkml/2026/4/13/199

Huang Shijie (4):
  mm: use mapping_mapped to simplify the code
  mm: use get_i_mmap_root to access the file's i_mmap
  mm/fs: split the file's i_mmap tree
  docs/mm: update document for split i_mmap tree

 Documentation/mm/process_addrs.rst |  63 +++++++---
 arch/arm/mm/fault-armv.c           |   3 +-
 arch/arm/mm/flush.c                |   3 +-
 arch/nios2/mm/cacheflush.c         |   3 +-
 arch/parisc/kernel/cache.c         |   4 +-
 fs/Kconfig                         |   8 ++
 fs/dax.c                           |   3 +-
 fs/hugetlbfs/inode.c               |  30 +++--
 fs/inode.c                         |  75 +++++++++++-
 include/linux/fs.h                 | 179 ++++++++++++++++++++++++++++-
 include/linux/mm.h                 |  81 +++++++++++++
 include/linux/mm_types.h           |   3 +
 kernel/events/uprobes.c            |   3 +-
 mm/hugetlb.c                       |   7 +-
 mm/internal.h                      |   3 +-
 mm/khugepaged.c                    |   6 +-
 mm/memory-failure.c                |   8 +-
 mm/memory.c                        |   8 +-
 mm/mmap.c                          |  11 +-
 mm/nommu.c                         |  28 +++--
 mm/pagewalk.c                      |   4 +-
 mm/rmap.c                          |   2 +-
 mm/vma.c                           |  74 +++++++++---
 mm/vma_init.c                      |   3 +
 24 files changed, 534 insertions(+), 78 deletions(-)

-- 
2.53.0


