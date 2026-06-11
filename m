Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27DE62367CF
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 06:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781158938; cv=none; b=stimCHMvhqFZekk4XITN2Xj8InnFiwwIkYCLVJ+FGZM9jV7P4gGsUu+2TLshNez9MFwb3Z1iBflq477Ztpqdpk0l3uNx1H9iySs+U4MGgnuaMvd0dIebmo0XTmuwt6cnbki8SFa/97ULLMRWsdI3wtdahB6VGpuNTqgHrdSJJMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781158938; c=relaxed/simple;
	bh=HpKx7iNOoNn/W9ykpZyJTUq/2x/av0MA7ffeHEjPGko=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CX51nNRKfe7JLE9p71ni6LwL3xlrtV6gyq8yQoC1LxF7N4diZSb4ciXEi0gLKhjD+AHENvc9bRY4e/oc6+GRY6tj0M633pvsH9z7M2pPhfQtPLfU6MUK8TMF4500jKOaNsFW20mprsl8XDzZf4YyrsiKJiT2OZuUJ20e2/mwWw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXc774mMz1dd8x;
	Thu, 11 Jun 2026 14:21:59 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXc66yN9z1dd8p;
	Thu, 11 Jun 2026 14:21:58 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id A4BFA30004DB;
	Thu, 11 Jun 2026 14:20:33 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:53 +0800
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
Subject: [PATCH v2 4/4] docs/mm: update document for split i_mmap tree
Date: Thu, 11 Jun 2026 14:19:00 +0800
Message-ID: <20260611061915.2354307-5-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

Document the i_mmap locking changes introduced by the following patches:
- Use mapping_mapped() to simplify the code
- Use get_i_mmap_root() to access the file's i_mmap
- Split the file's i_mmap tree (CONFIG_SPLIT_I_MMAP)

Add documentation for:
- CONFIG_SPLIT_I_MMAP split i_mmap tree architecture with per-tree locks
- New per-tree lock helpers: i_mmap_tree_lock_write/unlock_write
- New vm_area_struct.tree_idx field for sibling tree selection
- Updated i_mmap_lock_read/write semantics acquiring all per-tree locks
- Updated lock ordering notes for split tree configuration
- Updated page table freeing section for split tree scenario

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 Documentation/mm/process_addrs.rst | 63 +++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 14 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index 851680ead45f..4aed3100b249 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -60,6 +60,15 @@ Terminology
   :c:func:`!i_mmap_[try]lock_write` for file-backed memory. We refer to these
   locks as the reverse mapping locks, or 'rmap locks' for brevity.
 
+  When :c:macro:`!CONFIG_SPLIT_I_MMAP` is enabled, the file-backed i_mmap tree
+  is split into multiple sibling trees (one per NUMA node or a number based on
+  CPU count), each with its own :c:type:`!struct i_mmap_tree` containing a
+  red/black interval tree and a :c:type:`!struct rw_semaphore`. In this
+  configuration, :c:func:`!i_mmap_lock_read` and :c:func:`!i_mmap_lock_write`
+  acquire all per-tree locks, while VMA insert/remove operations use the
+  per-tree granularity :c:func:`!i_mmap_tree_lock_write` to lock only the
+  relevant sibling tree, significantly reducing lock contention.
+
 We discuss page table locks separately in the dedicated section below.
 
 The first thing **any** of these locks achieve is to **stabilise** the VMA
@@ -230,12 +239,16 @@ These are the core fields which describe the MM the VMA belongs to and its attri
                                                            Updated under mmap read lock by
                                                            :c:func:`!task_numa_work`.
    :c:member:`!vm_userfaultfd_ctx`   CONFIG_USERFAULTFD    Userfaultfd context wrapper object of    mmap write,
-                                                           type :c:type:`!vm_userfaultfd_ctx`,      VMA write.
-                                                           either of zero size if userfaultfd is
-                                                           disabled, or containing a pointer
-                                                           to an underlying
-                                                           :c:type:`!userfaultfd_ctx` object which
-                                                           describes userfaultfd metadata.
+                                                            type :c:type:`!vm_userfaultfd_ctx`,      VMA write.
+                                                            either of zero size if userfaultfd is
+                                                            disabled, or containing a pointer
+                                                            to an underlying
+                                                            :c:type:`!userfaultfd_ctx` object which
+                                                            describes userfaultfd metadata.
+   :c:member:`!tree_idx`             CONFIG_SPLIT_I_MMAP   The index of the sibling i_mmap tree     Written once on
+                                                            that this VMA belongs to, set at         initial map.
+                                                            VMA creation time based on the NUMA
+                                                            node or the smallest sibling tree.
    ================================= ===================== ======================================== ===============
 
 These fields are present or not depending on whether the relevant kernel
@@ -247,12 +260,18 @@ configuration option is set.
    Field                               Description                               Write lock
    =================================== ========================================= ============================
    :c:member:`!shared.rb`              A red/black tree node used, if the        mmap write, VMA write,
-                                       mapping is file-backed, to place the VMA  i_mmap write.
-                                       in the
-                                       :c:member:`!struct address_space->i_mmap`
-                                       red/black interval tree.
+                                        mapping is file-backed, to place the VMA  i_mmap write (or per-tree
+                                        in the                                    i_mmap write when
+                                        :c:member:`!struct address_space->i_mmap` :c:macro:`!CONFIG_SPLIT_I_MMAP`
+                                        red/black interval tree (or one of the    is set).
+                                        sibling trees when
+                                        :c:macro:`!CONFIG_SPLIT_I_MMAP`
+                                        is enabled).
    :c:member:`!shared.rb_subtree_last` Metadata used for management of the       mmap write, VMA write,
-                                       interval tree if the VMA is file-backed.  i_mmap write.
+                                        interval tree if the VMA is file-backed.  i_mmap write (or per-tree
+                                                                                  i_mmap write when
+                                                                                  :c:macro:`!CONFIG_SPLIT_I_MMAP`
+                                                                                  is set).
    :c:member:`!anon_vma_chain`         List of pointers to both forked/CoW’d     mmap read, anon_vma write.
                                        :c:type:`!anon_vma` objects and
                                        :c:member:`!vma->anon_vma` if it is
@@ -490,6 +509,16 @@ There is also a file-system specific lock ordering comment located at the top of
 Please check the current state of these comments which may have changed since
 the time of writing of this document.
 
+.. note:: When :c:macro:`!CONFIG_SPLIT_I_MMAP` is enabled, the single
+   ``mapping->i_mmap_rwsem`` is replaced by an array of per-tree locks
+   ``mapping->i_mmap[i]->rwsem``. The lock ordering positions of
+   ``mapping->i_mmap_rwsem`` above apply to each per-tree lock
+   equivalently. VMA insert/remove operations acquire only the relevant
+   per-tree lock via :c:func:`!i_mmap_tree_lock_write`, while operations
+   that require all trees to be locked (such as
+   :c:func:`!unmap_mapping_range`) acquire all per-tree locks via
+   :c:func:`!i_mmap_lock_write` or :c:func:`!i_mmap_lock_read`.
+
 ------------------------------
 Locking Implementation Details
 ------------------------------
@@ -704,11 +733,15 @@ traversed or referenced by concurrent tasks.
 
 It is insufficient to simply hold an mmap write lock and VMA lock (which will
 prevent racing faults, and rmap operations), as a file-backed mapping can be
-truncated under the :c:struct:`!struct address_space->i_mmap_rwsem` alone.
+truncated under the :c:struct:`!struct address_space->i_mmap_rwsem` alone
+(or, when :c:macro:`!CONFIG_SPLIT_I_MMAP` is enabled, under all per-tree
+``mapping->i_mmap[i]->rwsem`` locks acquired via
+:c:func:`!i_mmap_lock_write`).
 
 As a result, no VMA which can be accessed via the reverse mapping (either
 through the :c:struct:`!struct anon_vma->rb_root` or the :c:member:`!struct
-address_space->i_mmap` interval trees) can have its page tables torn down.
+address_space->i_mmap` interval trees, or the sibling trees when
+:c:macro:`!CONFIG_SPLIT_I_MMAP` is enabled) can have its page tables torn down.
 
 The operation is typically performed via :c:func:`!free_pgtables`, which assumes
 either the mmap write lock has been taken (as specified by its
@@ -729,7 +762,9 @@ cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_cle
 .. note:: It is possible for leaf page tables to be torn down independent of
           the page tables above it as is done by
           :c:func:`!retract_page_tables`, which is performed under the i_mmap
-          read lock, PMD, and PTE page table locks, without this level of care.
+          read lock (or all per-tree ``mapping->i_mmap[i]->rwsem`` locks in
+          read mode when :c:macro:`!CONFIG_SPLIT_I_MMAP` is enabled), PMD, and
+          PTE page table locks, without this level of care.
 
 Page table moving
 ^^^^^^^^^^^^^^^^^
-- 
2.53.0


