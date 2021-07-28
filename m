Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5833481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 08:22:43 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B2931FB;
	Wed, 28 Jul 2021 01:22:37 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D0A963F73D;
	Wed, 28 Jul 2021 01:22:34 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	nd@arm.com,
	Jia He <justin.he@arm.com>
Subject: [PATCH 0/1] fix pmem RAM device when nid is NUMA_NO_NODE
Date: Wed, 28 Jul 2021 16:22:25 +0800
Message-Id: <20210728082226.22161-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Background
==========
I once sent out the preparatory patches [1] but I dropped the last patch
of using fallback nid with memory_add_physaddr_to_nid() due to some
dependency.

After phys_addr_to_target_node() and memory_add_physaddr_to_nid() are
stable now, it's time to fix the original bug on arm64 now.

Compared with the last version [2], this version rebases the patch to
latest v5.14-rc3 (s/kmem_start/range.start)

Test
====
Tested on ThunderX2 host/qemu "-M virt" guest with a nvdimm device. The 
memblocks from the dax pmem device can be either hot-added or hot-removed
on arm64 guest. Also passed the compilation test on x86.

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2228771.html
[2] https://lkml.org/lkml/2020/7/8/1546

Jia He (1):
  device-dax: use fallback nid when numa_node is invalid

 drivers/dax/kmem.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

-- 
2.17.1

