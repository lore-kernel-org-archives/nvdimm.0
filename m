Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213433BE628
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576093; cv=none; b=C1As2mAcdgcNBY8/KyY2YwzrgkqURdIXqke4Q4LOJbjXbSo9r6oSeLm2wcWqdQa4ElnlK/lx5BsuroRGB0TGrsrHk8GN9GaIWJKsRb58S1WLqo/h/Se/z89POEEIPhp2HN7E0ndbVQ6gwgbPAghgHDEuC4FZugSicv7ebaNleUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576093; c=relaxed/simple;
	bh=sgbJa0CPJs+QLhgKQUo4OkCi7bI12c55vc0O8fouI4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=basaQ9rjhdVXNOUhH0zrvLsWgND0DWPzRJp6uLJ6KG91YMyPNp7JmqB+n1v0oviQhxMK34GKW+vOVxAK9sP9BLa+oOawzX+VOO9hxApP1ELGl5EGHJ/MIRLmnfocYevohhE1X8vEbBUG8plmWno1jlfxNGErpRaneUkLO3hQ4B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=j2ej6ZO0; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="j2ej6ZO0"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9034b6b7674so86274396d6.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576089; x=1785180889; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M3kct1v+57CVZWjeLlS7sPI2XQHwAFOrYnO6UcPWFI4=;
        b=j2ej6ZO0Q17rmONtbeNOzn9zNp7y4/VMByEOc4TL5xQmZNm2cZSA50D3EbiXFf+l2z
         VBkNVN5FwywBV2RePT6ubF563DOBzAMhOCIlDNbzTpDraI6FiL/Xierm6ZHSBvAKHxk0
         I3U39KDO2+i4g6y1su6n5jbuIsGqPDTNMm1OzNPUlSax5fpCqIxLyk3KeqwTx1dunIJI
         s2NSAAVbhMmVNr9NEzLN+y7heGZ2lGxx8RJ/OQNj3/Fu4JNZC3Pc6VkKtRz+cmyq9TJ9
         lw7egdAJn0qgGnlr26sVNsEnj2QfkLbC0hQT36etKYPayoym1SxoUCOoaRrJpEo40Uz8
         ITPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576089; x=1785180889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M3kct1v+57CVZWjeLlS7sPI2XQHwAFOrYnO6UcPWFI4=;
        b=TOrlkTeWcRUVzd5roy6kxnYYIOZOS+vfxPvOEXS/OI9KljgGQB+QPI+B4n5OGHgcwT
         O2Sqnol7eX+HbG4fshh99xE1YPDVATI1K7YoxE2qtV6rOa0cr54p4bGCyhps1WW5Bdtj
         Fy5j0UFobHyk2Up76Y+rHH8FIwY/yo9LCrRfcIuUmiuYy1dsWjL2Tr34y7Mlo0wCvyxB
         REJa/r8O1bF7abhP+aUoSLKqnUlzSYucQL5gSeFgioOa/9sghCKni7bMKEjxSCTlj14c
         JKOOicf6/LxGug5CGee3sYW/biJLlZbfoigSqx1WlqTyak9ksaXFaPqTPXzRsPzNwdX6
         c8lQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr1olZdkwnpqnbxoHMnsx69/8JV878hNtplyEGcXSaeSFMdycSkRMRqQiEgf+oA83SihQ3gZXI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4qGl57k4i5yZv99IvbHem8lMwSmjRaupMAmn1DoYjKvrQlmm+
	SLqpWQmNXuD3ayNaneiAc2TpeSwRC5y0nW5Ul+yrCJjZB2EzwoBj2jJHXfeNnpBvZbs=
X-Gm-Gg: AfdE7cnLez+eqiMgNBuR/n3Oj3V4ebZ42nKcErkU4Ry0JY3jdNcMTYSSSe6e4+8Vtek
	N1rK9am6f39Bd3XPvPn3eEBNZtbJr9/YQjjmVAK0PIHZWsYLdCrAbc17Ypn8d3jw48udML9MFH+
	B0EBUfb3g7kA6tgb1lafP/xWFSK1o5IZV4XR159/jrV/tv5odwBw9Ze6GO/QaS3COEM2TQkQ6ja
	6Gkj1YlUDk/ba4O0s1qEKblKamRiYcz7b91TN0dmZnh63IyvrK/u8dgLVrRJogxhgkr6YGqP35Q
	kDF6fwHL9Y2TWVUfXwUPhofEr9hRR2M5HHmcVq/hAvqmMsy9rAmRemjfyBX/0j7Alm63OybgcHI
	Rlv0ht/ESkhHUER9+R1i1l5MvXZgoPXNOhhDLLqMh+VPmHvt02nzfkIAmkUNO8siBj/H7mpwVLj
	2LaPrzd1rgmgA3K9DQBT4EiZdvcN5jVrEpoiY1D8PHHp2Tjhk7Tvcg0HIJsiv30f92MN8U3zgX/
	w==
X-Received: by 2002:a05:620a:690c:b0:930:9c0c:657 with SMTP id af79cd13be357-930b41e29c5mr1450539485a.60.1784576089026;
        Mon, 20 Jul 2026 12:34:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:48 -0700 (PDT)
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
Subject: [PATCH v5 04/36] numa: introduce N_MEMORY_PRIVATE
Date: Mon, 20 Jul 2026 15:33:58 -0400
Message-ID: <20260720193431.3841992-5-gourry@gourry.net>
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

Some devices want to hotplug their memory onto a node, but not have it
exposed as "general purpose".  The intent is to re-use portions of mm/
services for management without exposing it for general consumption.

N_MEMORY nodes are intended to contain general System RAM, so they
are unsuited for this purpose.

Create N_MEMORY_PRIVATE for memory nodes whose memory is not intended
for general consumption.

N_MEMORY and N_MEMORY_PRIVATE are mutually exclusive states.

This commit adds basic infrastructure for N_MEMORY_PRIVATE nodes:

  - struct node_private:
      Per-node container stored in NODE_DATA(nid) storing the owner.

  - folio/page_is_private_node():
       true if it resides on a private node

  - folio/page_is_private_managed():
      common predicate for checking private node or zone device
      Used to combine common filtering locations.

  - Registration API: node_private_register()/unregister()

  - sysfs attribute exposing N_MEMORY_PRIVATE node state.

  - fix node_state() and helpers to return false for N_MEMORY_PRIVATE
    when !CONFIG_NUMA (mutually exclusive w/ N_MEMORY)

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/stable/sysfs-devices-node |  10 ++
 drivers/base/node.c                         | 113 ++++++++++++++++++++
 include/linux/mmzone.h                      |  15 +++
 include/linux/node_private.h                |  82 ++++++++++++++
 include/linux/nodemask.h                    |   7 +-
 mm/internal.h                               |  12 +++
 6 files changed, 236 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/node_private.h

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 2d0e023f22a71..8a36fbc3d4028 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -29,6 +29,16 @@ Description:
 		Nodes that have regular or high memory.
 		Depends on CONFIG_HIGHMEM.
 
+What:		/sys/devices/system/node/has_private_memory
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have private (N_MEMORY_PRIVATE) memory: memory
+		hotplugged by a driver onto a CPU-less node and isolated from
+		the page allocator's normal and fallback zonelists.  A node is
+		listed here for as long as it holds private memory; it is never
+		listed in has_memory at the same time (the two states are
+		mutually exclusive).  See Documentation/mm/numa_private_nodes.rst.
+
 What:		/sys/devices/system/node/nodeX
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 3da91929ad4e3..94cd51f51b7e8 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -22,6 +22,7 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/memblock.h>
+#include <linux/node_private.h>
 
 static const struct bus_type node_subsys = {
 	.name = "node",
@@ -868,6 +869,116 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
 			   (void *)&nid, register_mem_block_under_node_hotplug);
 	return;
 }
+
+static DEFINE_MUTEX(node_private_lock);
+
+/**
+ * node_private_register - Register a private node
+ * @nid: Node identifier
+ * @np: The node_private structure (driver-allocated, driver-owned)
+ *
+ * Register an owner for a private node. If an owner is already registered
+ * (different np), return -EBUSY.
+ *
+ * Re-registration with the same np is allowed.
+ *
+ * The caller owns the node_private memory and must ensure it remains valid
+ * until after node_private_unregister() returns.
+ *
+ * Returns 0 on success, negative errno on failure.
+ */
+int node_private_register(int nid, struct node_private *np)
+{
+	struct node_private *existing;
+	pg_data_t *pgdat;
+	int ret = 0;
+
+	if (!np || !node_possible(nid))
+		return -EINVAL;
+
+	mutex_lock(&node_private_lock);
+	mem_hotplug_begin();
+
+	/* N_MEMORY_PRIVATE and N_MEMORY are mutually exclusive */
+	if (node_state(nid, N_MEMORY)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	pgdat = NODE_DATA(nid);
+	existing = rcu_dereference_protected(pgdat->node_private,
+					     lockdep_is_held(&node_private_lock));
+
+	/* If it exists, restrict to single owner */
+	if (existing) {
+		if (existing != np)
+			ret = -EBUSY;
+		goto out;
+	}
+
+	rcu_assign_pointer(pgdat->node_private, np);
+out:
+	mem_hotplug_done();
+	mutex_unlock(&node_private_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(node_private_register);
+
+/**
+ * node_private_unregister - Unregister a private node
+ * @nid: Node identifier
+ *
+ * Unregister the driver from a private node.
+ *
+ * Only succeeds if all memory has been offlined (N_MEMORY_PRIVATE cleared).
+ *
+ * N_MEMORY_PRIVATE state is cleared by offline_pages() when the last
+ * memory is offlined, not by this function.
+ *
+ * After this returns, the node_private pointer is no longer visible and
+ * an RCU grace period has elapsed, so the driver may free its context.
+ *
+ * Return: 0 if unregistered, -EBUSY if N_MEMORY_PRIVATE is still set.
+ */
+int node_private_unregister(int nid)
+{
+	struct node_private *np;
+	pg_data_t *pgdat;
+
+	if (!node_possible(nid))
+		return 0;
+
+	mutex_lock(&node_private_lock);
+	mem_hotplug_begin();
+
+	pgdat = NODE_DATA(nid);
+	np = rcu_dereference_protected(pgdat->node_private,
+				       lockdep_is_held(&node_private_lock));
+	if (!np) {
+		mem_hotplug_done();
+		mutex_unlock(&node_private_lock);
+		return 0;
+	}
+
+	/*
+	 * Only unregister if N_MEMORY_PRIVATE is cleared (only occurs when
+	 * the last memory block is offlined in offline_pages())
+	 */
+	if (node_is_private(nid)) {
+		mem_hotplug_done();
+		mutex_unlock(&node_private_lock);
+		return -EBUSY;
+	}
+
+	rcu_assign_pointer(pgdat->node_private, NULL);
+
+	mem_hotplug_done();
+	mutex_unlock(&node_private_lock);
+
+	synchronize_rcu();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(node_private_unregister);
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 /**
@@ -966,6 +1077,7 @@ static struct node_attr node_state_attr[] = {
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+	[N_MEMORY_PRIVATE] = _NODE_ATTR(has_private_memory, N_MEMORY_PRIVATE),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
 					   N_GENERIC_INITIATOR),
@@ -979,6 +1091,7 @@ static struct attribute *node_state_attrs[] = {
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
 	&node_state_attr[N_MEMORY].attr.attr,
+	&node_state_attr[N_MEMORY_PRIVATE].attr.attr,
 	&node_state_attr[N_CPU].attr.attr,
 	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
 	NULL
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0507193b3ae34..9815e48c03b97 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -26,6 +26,8 @@
 #include <linux/sizes.h>
 #include <asm/page.h>
 
+struct node_private;
+
 /* Free memory management - zoned buddy allocator.  */
 #ifndef CONFIG_ARCH_FORCE_MAX_ORDER
 #define MAX_PAGE_ORDER 10
@@ -1596,12 +1598,25 @@ typedef struct pglist_data {
 	atomic_long_t		vm_stat[NR_VM_NODE_STAT_ITEMS];
 #ifdef CONFIG_NUMA
 	struct memory_tier __rcu *memtier;
+	struct node_private __rcu *node_private;
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
 } pg_data_t;
 
+#ifdef CONFIG_NUMA
+static inline bool pgdat_is_private(pg_data_t *pgdat)
+{
+	return !!pgdat->node_private;
+}
+#else
+static inline bool pgdat_is_private(pg_data_t *pgdat)
+{
+	return false;
+}
+#endif
+
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
 #define node_spanned_pages(nid)	(NODE_DATA(nid)->node_spanned_pages)
 
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
new file mode 100644
index 0000000000000..475496c84249f
--- /dev/null
+++ b/include/linux/node_private.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_NODE_PRIVATE_H
+#define _LINUX_NODE_PRIVATE_H
+
+#include <linux/mm.h>
+#include <linux/nodemask.h>
+
+struct page;
+
+/**
+ * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
+ *
+ * Allocated by the driver and passed to node_private_register().
+ * The driver owns the memory and must ensure it remains valid until after
+ * node_private_unregister() returns.
+ *
+ * @owner: Opaque driver identifier
+ * @caps: NODE_PRIVATE_CAP_* service opt-ins for the node (zero by default;
+ *	  individual capabilities are defined and consumed by later changes)
+ */
+struct node_private {
+	void *owner;
+	unsigned long caps;
+};
+
+#ifdef CONFIG_NUMA
+#include <linux/mmzone.h>
+
+static inline bool folio_is_private_node(struct folio *folio)
+{
+	return node_state(folio_nid(folio), N_MEMORY_PRIVATE);
+}
+
+static inline bool page_is_private_node(struct page *page)
+{
+	return node_state(page_to_nid(page), N_MEMORY_PRIVATE);
+}
+
+static inline bool node_is_private(int nid)
+{
+	return node_state(nid, N_MEMORY_PRIVATE);
+}
+
+#else /* !CONFIG_NUMA */
+
+static inline bool folio_is_private_node(struct folio *folio)
+{
+	return false;
+}
+
+static inline bool page_is_private_node(struct page *page)
+{
+	return false;
+}
+
+static inline bool node_is_private(int nid)
+{
+	return false;
+}
+
+#endif /* CONFIG_NUMA */
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
+
+int node_private_register(int nid, struct node_private *np);
+int node_private_unregister(int nid);
+
+#else /* !CONFIG_NUMA || !CONFIG_MEMORY_HOTPLUG */
+
+static inline int node_private_register(int nid, struct node_private *np)
+{
+	return -ENODEV;
+}
+
+static inline int node_private_unregister(int nid)
+{
+	return 0;
+}
+
+#endif /* CONFIG_NUMA && CONFIG_MEMORY_HOTPLUG */
+
+#endif /* _LINUX_NODE_PRIVATE_H */
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index b842aa5255464..ba3e6c570a112 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -391,6 +391,7 @@ enum node_states {
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
 	N_MEMORY,		/* The node has memory(regular, high, movable) */
+	N_MEMORY_PRIVATE,	/* The node's memory is private */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	NR_NODE_STATES
@@ -457,7 +458,7 @@ static __always_inline void node_set_offline(int nid)
 
 static __always_inline int node_state(int node, enum node_states state)
 {
-	return node == 0;
+	return node == 0 && state != N_MEMORY_PRIVATE;
 }
 
 static __always_inline void node_set_state(int node, enum node_states state)
@@ -470,11 +471,11 @@ static __always_inline void node_clear_state(int node, enum node_states state)
 
 static __always_inline int num_node_state(enum node_states state)
 {
-	return 1;
+	return state == N_MEMORY_PRIVATE ? 0 : 1;
 }
 
 #define for_each_node_state(node, __state) \
-	for ( (node) = 0; (node) == 0; (node) = 1)
+	for ((node) = 0; (node) == 0 && (__state) != N_MEMORY_PRIVATE; (node) = 1)
 
 #define first_online_node	0
 #define first_memory_node	0
diff --git a/mm/internal.h b/mm/internal.h
index 96d78a7778e88..cb9f4a8342e32 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
+#include <linux/node_private.h>
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
@@ -98,6 +99,17 @@ extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
 #endif
 
+/* folio_is_private_managed() - folio has special mm management rules */
+static inline bool folio_is_private_managed(struct folio *folio)
+{
+	return folio_is_zone_device(folio) || folio_is_private_node(folio);
+}
+
+static inline bool page_is_private_managed(struct page *page)
+{
+	return folio_is_private_managed(page_folio(page));
+}
+
 /*
  * Maintains state across a page table move. The operation assumes both source
  * and destination VMAs already exist and are specified by the user.
-- 
2.53.0-Meta

