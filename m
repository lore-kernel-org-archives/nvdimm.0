Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A7D4D2EE2
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576171; cv=none; b=HXUtSJFbQv5BNQND2EaJzLZ0/OATPg7RuDBErh8nngGjc+pBcDmKqWK0QumHNQ2SORBpMOw0/KIVxSQQjKYUcIaEJiXzkapG9nvJYX1PsUdA94cy//II1qizLj8XbJymJrGnd96YfO6SJMk1VgW7cQbC23sAAV/FXaBscBvw5I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576171; c=relaxed/simple;
	bh=17uSNxWNbNfWeu2defMnk2WRNed4MZXXsNWHp0EQmes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENN2AAfXR7VSpPFhxXpq7EmrQIjnbJNHi0E0uzwU/5ho141rud+uHvQCEYJ4CvPHMggM+QZN16W4GMhEOychsM67Xwe/qP0xUW/MDKbvjl4ZNNNSbGyy93Rseo22qjHdpSFZNGtYY42Q24wenhnBwoUI7gVBKnkgXWrv7YNyNTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=EuWvzJ+G; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="EuWvzJ+G"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92ed19f4d60so369355085a.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576166; x=1785180966; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
        b=EuWvzJ+GmyUzMtvrtts3l2Pelnb/f6IRT+U1klFTWirBOIutkNowEmVuPxgbuRUcLM
         lQYW+ymav1WYUF9TkQ70rN2ALSOECYdxhJrtBq+h4eQI85bC4CxMRXrYkf4fcIOXuVmf
         ZTZ4IXtInZw9LKCtHaAYmG+CjhilP6UBXtZc953Tw/i4FtAxpvsVQi+FL0CYqoWrHZ65
         Iq0RYEjUQ38O0soyYYU7uI999CVuke8QimyUxpVSdTnMldHbfuThIP0t+mpWUQwf/K6w
         JAQ0BC22/+g86u/2s8LTKjdh+xSAEyc3w1yDm0bE0uQ47oHlaR6hNCceBWEc+vrLdI8f
         fGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576166; x=1785180966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
        b=b5WYoaHpr+9abpHQpO7KXl/WBpBWj7kVLpYJmBqf2sc25QDlIOT3/iujUyNHaYVCBE
         v9Y0kyszEklNhFvjzFQKGs8uhWGP4EAAHdRw4FhmQzZWDLof/M6cxIeWxekz9bc5HjXU
         aJeb2E7WtaKWPUgwBKy9xdZ7ZCA3sgtSsfxSqiWkZHAPc1Bcs1LhJi9NpuAxSjRQ16Vd
         FLpW+9YeARJHyfqlLVnlS5DATzdh5rzt1PoxiL2UN0EA41cL7/UiTNH7c9cxBnaAbbxW
         MnaCepHh1YNUc8XlVFfV1c0DzcsLRQ5QWi/RBZB8svNQ3oLkrOuMd4c/UpWyD1xxTKXN
         hTPQ==
X-Forwarded-Encrypted: i=1; AHgh+RqnZGrNgxLPHAdp3oRJSMmUqB+c5ksl+uqmoqaH7pjSAVlYhkCP90mABkz+k+V1F1vjfMb9glM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/kiCs4zYavS8JwLTnbp3TVPwXnJ4chT81irSNuxf4WmsjNkRa
	HnEW6jihTR8lRmf6+s6d+V2oOW+sjzQ7huT9KNsKxX19JI6hZd0O+0ws38aCFXxK800=
X-Gm-Gg: AfdE7cn60HRsVFbCIzwFVu0V36LhtXp7DvU54PEfKcxeLn1L5mWPW5a2ikesBUFUy0D
	NojfoVvnpidufy91eeAY2l/OKvlDJnBx6SqppoNBXT7OtUUhvCzQjdM7/njE5RrAbYdcLHgkmw2
	hzNywpHVHZCY6qTc9xdiSJlUWytemmQ5fGn+HXu6W8S6VxpGOrXUUQX8gLPYhExNg0IoIfcIlMq
	WLv6viVUywPJo7ccRqgJbORO6DERfPupVo4ZalaOsM6PznuPGlVGwJ8u2DFYTDDBBkUDGRtBCT6
	6/lYqnhJXTlGYMBhi7ecq23T4HxGX7PJgpBOIzBtrQ8OxZsN0ovtPAHqEYLa5Pi1xG24OnvyMSE
	MSQqDyYZ18xRC7IpDvVbDUlBXzRJ4qBF4xjhl7tP3WkBjcz8RZHIVAmjfQfmRVqnW5TtqJ6vL1L
	7K64SpBq1a4mfqznDdEc7HahS1xmDD98Ijy3BwC0cMbzQgwepoAL+9ye9LmlZJTc0=
X-Received: by 2002:a05:620a:171f:b0:930:5a34:3882 with SMTP id af79cd13be357-930b482d3d6mr1498824485a.2.1784576165506;
        Mon, 20 Jul 2026 12:36:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:05 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 33/36] Documentation/mm: describe private (N_MEMORY_PRIVATE) memory nodes
Date: Mon, 20 Jul 2026 15:34:27 -0400
Message-ID: <20260720193431.3841992-34-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a design overview of private memory nodes:
  - the isolation model (structural zonelist exclusion)
  - ZONELIST_PRIVATE
  - driver provisioning API
  - capability opt-in model and its dependency rules
  - observability surfaces

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/mm/index.rst              |   1 +
 Documentation/mm/numa_private_nodes.rst | 160 ++++++++++++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/mm/numa_private_nodes.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c0..f60704df6104c 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -65,6 +65,7 @@ documentation, or deleted if it has served its purpose.
    mmu_notifier
    multigen_lru
    numa
+   numa_private_nodes
    overcommit-accounting
    page_migration
    page_frags
diff --git a/Documentation/mm/numa_private_nodes.rst b/Documentation/mm/numa_private_nodes.rst
new file mode 100644
index 0000000000000..3b27a2e24b086
--- /dev/null
+++ b/Documentation/mm/numa_private_nodes.rst
@@ -0,0 +1,160 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Private memory nodes
+====================
+
+A *private memory node* is a NUMA node whose memory is hotplugged by a driver
+and deliberately hidden from the kernel's normal memory management.  Such a
+node is marked ``N_MEMORY_PRIVATE`` instead of ``N_MEMORY``; the two states
+are mutually exclusive, so a private node is never considered by the page
+allocator's normal or fallback paths.
+
+The intent is to give a driver a block of NUMA-addressable memory that the rest
+of the kernel will not allocate from on its own, while still letting that memory
+be mapped into processes as ordinary, struct-page, LRU-managed folios -- and to
+let the driver re-enable individual mm services it is capable of allowing.
+
+Preconditions
+=============
+
+``N_MEMORY_PRIVATE`` and ``N_MEMORY`` are mutually exclusive, so the backing
+memory must come up on a node that has no DRAM of its own (otherwise the node
+would already be ``N_MEMORY``).
+
+In practice the memory is provided by a device driver or a DAX device whose
+target node has no other memory, and usually no CPUs.
+
+Isolation model
+===============
+
+Isolation is *opt-in by exclusion* and is **structural**: by default nothing in
+the kernel can place memory on a private node because the node is absent from the
+zonelists an ordinary allocation walks.
+
+Zonelist exclusion
+    The kernel page allocator depends on the ``FALLBACK`` and ``NOFALLBACK``
+    zonelists to allocate memory.  A normal ``N_MEMORY`` node's zones (except
+    ``ZONE_DEVICE``) appear in these lists and allow allocations to fall-back
+    to less preferable locations if the preferred location is pressured.
+
+    ``__GFP_THISNODE`` is used during normal operation to switch between
+    ``FALLBACK`` and ``NOFALLBACK``, where ``NOFALLBACK`` only contains the
+    zonelists of the preferred node.
+
+    ``N_MEMORY_PRIVATE`` nodes are **excluded** from both ``FALLBACK`` and
+    ``NOFALLBACK`` zonelists.  Instead they are added to ``ZONELIST_PRIVATE``,
+    which includes both ``N_MEMORY`` and ``N_MEMORY_PRIVATE`` nodes.  This is
+    the only zonelist that contains private-node zones, and so the only way
+    to acquire private node allocations is to explicitly request that zonelist.
+
+    Even an allocation carrying ``__GFP_THISNODE`` cannot access the node's
+    memory without also explicitly passing the private zonelist.  This prevents
+    incidental allocation of private memory by users of possible/online
+    nodelists.
+
+    When ``CONFIG_NUMA`` is disabled ``ZONELIST_PRIVATE`` aliases
+    ``ZONELIST_FALLBACK`` and is never selected.
+
+The user_numa path
+
+    ``MPOL_F_PRIVATE`` is an internal user_numa flag (never accepted from
+    userspace) marking that a mempolicy has a private node in its nodemask.
+
+    When ``CAP_USER_NUMA`` for a private node is set, user-sourced mempolicy
+    (``set_mempolicy(2)``) and migration (``move_pages(2)``) operations are
+    allowed to include that node in nodemasks and targets respectively.
+
+    ``mbind(MPOL_MF_MOVE)`` is both a mempolicy and a migration operation,
+    so placement and migration share the same capability.
+
+    The mempolicy component uses ``MPOL_F_PRIVATE`` at fault-time to select
+    ``ZONELIST_PRIVATE`` and makes the node's memory available for allocation.
+    It is otherwise an ordinary, relaxable mempolicy: an unsatisfiable request
+    (an unmovable allocation on a movable-only private node) simply falls back.
+
+
+cpuset interaction
+==================
+
+cpuset.mems does **not** partition private nodes.  cpuset neither grants nor
+denies access, and rebinding cpuset.mems nodemasks do not affect a private node's
+residency in any nodemask.
+
+Likewise, a private node's inclusion in a nodemask does not affect cpuset.mems'
+filtering of any ``N_MEMORY`` - they remain partitioned according to cpuset.
+
+
+Provisioning
+============
+
+A driver brings memory up as private with::
+
+  add_private_memory_driver_managed(nid, start, size, resource_name,
+                                    mhp_flags, online_type, np)
+
+which onlines the range and registers the driver-owned ``struct node_private``
+(``np``) describing the node, including its capability bitmap (see below).
+
+Only one driver/service may register a ``struct node_private``, which
+heavily implies a "one-node-per-device" design of the system.
+
+The node leaves ``N_MEMORY_PRIVATE`` only when the last range is offlined.
+
+.. kernel-doc:: mm/memory_hotplug.c
+   :identifiers: __add_memory_driver_managed
+
+.. kernel-doc:: drivers/base/node.c
+   :identifiers: node_private_register node_private_unregister
+
+Capabilities (per-service opt-ins)
+==================================
+
+Because the default is "no mm service touches the node", each service a driver
+wants back is requested explicitly through a capability bit in
+``np->caps``.  The mm side checks the matching ``node_allows_*()`` /
+``folio_allows_*()`` predicate before acting:
+
+.. list-table::
+   :header-rows: 1
+   :widths: 35 65
+
+   * - Capability
+     - Re-enables
+   * - ``NODE_PRIVATE_CAP_RECLAIM``
+     - reclaim of the node's folios, by the mm and by userspace
+       ``MADV_COLD`` / ``PAGEOUT`` / ``FREE`` (userland-driven reclaim)
+   * - ``NODE_PRIVATE_CAP_USER_NUMA``
+     - all userspace-directed placement and migration: ``mbind()`` /
+       ``set_mempolicy()`` / home node, and ``move_pages()`` /
+       ``migrate_pages()`` to/from the node
+   * - ``NODE_PRIVATE_CAP_HOTUNPLUG``
+     - hot-unplug via migration
+   * - ``NODE_PRIVATE_CAP_DEMOTION``
+     - reclaim-driven tiering demotion onto the node (the node joins the
+       demotion hierarchy)
+   * - ``NODE_PRIVATE_CAP_NUMA_BALANCING``
+     - access-based NUMA balancing scan/migration of the node's folios
+   * - ``NODE_PRIVATE_CAP_LTPIN``
+     - ``FOLL_LONGTERM`` GUP pins
+
+khugepaged never operates on private-node folios (like ZONE_DEVICE), and DAMON
+does not act on them; ``MADV_COLLAPSE`` is covered by ``CAP_USER_NUMA``.
+
+Dependencies between capabilities are enforced **once**, by
+``node_private_register()`` at hotplug, rather than by whatever sets the bits:
+
+* ``DEMOTION`` requires ``RECLAIM`` (a demotion target accumulates demoted
+  pages, so without reclaim as a safety valve it would just fill up).
+
+Capability flags are expected to be stable at runtime.
+
+Observability
+=============
+
+A private node is reported through:
+
+* ``/sys/devices/system/node/has_private_memory``
+* ``/proc/<pid>/numa_maps`` -- per-node residency includes private nodes
+* ``/proc/kcore`` -- private-node RAM appears in the kcore RAM map
+* memcg per-node statistics account private-node memory.
-- 
2.53.0-Meta

