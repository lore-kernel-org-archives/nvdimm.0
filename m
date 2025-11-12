Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FB92D662F
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975804; cv=none; b=e0tYgDA5Mswq0bwUssTxW50K7V60rjpHXEHGLez0G5ZyJzeRFtrYhA2GZ35jcGMCBJc+MbakUwalzwxrj5KYbk8qw9828W0jlT1pkwUUaf0BtO6AgDKYJ5tTcKlDMiZYFPABIox9SP0q2cG9+2EKo+OWp6AvIzd422wfq/2PeZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975804; c=relaxed/simple;
	bh=eHEbONvZIj37o0CRFSIwDW5/+99mEJwz4WMdReKTyos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTE4BFQtdxw5sntAzNLp2c9Hfq/UEjFJgm+9U5QV1EacTj2W9v6y4eXE0bPyiKZtb4nyiXKUSmfTmK1+5lnaHZtAbjIUyTLmenQcy8Q3dN17yNfPr+0PezDDs5tWP2jqle9NlSg1bviBw6XkwM6pWGFMfeOSv5sAt/iu8SZ64l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=dSGRnidV; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="dSGRnidV"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b28f983333so4549285a.3
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975800; x=1763580600; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJ3STVw+04anWCoqtoEILU8J9sgMLUtAldTEWscHkZw=;
        b=dSGRnidVU6WRYFHEGU3Z+tY692lRVksOi2C0azp9w11JIhI1oxK98PgDRj6TvNc+E8
         mKyTkVp9LDuSRJKhCDhpmIEMOPwQhgAjzcBcGf60NOL+1+/DzlcT9U/Wha80QF1jsljg
         XEF4V5+4tieiKfA88uceaXJSJ4dGcEP/JNr21O9Ko8n+kN6NG+0XB+wfmyQnLFlefeKp
         WvWKr8P7CfuZoBho/v4RlueIATzyYn/czQ1vlB9FVG2CanXY4WxufPog3gHVFe7T5bfg
         UJnfLtPoqYb6IOB8n0Q3T6t7kPMpPHNL8Vjq/7713DDRjD9NIBQBeycVkmbDNqX0TuTS
         Q9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975800; x=1763580600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QJ3STVw+04anWCoqtoEILU8J9sgMLUtAldTEWscHkZw=;
        b=mUID9L3QTrJKWnCYDbuOqTkb1YTkT9ZlSq524xX34t4q0I7t0m3fuBkhdeG5yRye+o
         0yUN8+QG+X6r6O8IQNH7E9SnH06N9z2f2xNQS3uQUbcWyD/dI7d682vKcw3dED1L2XjP
         yPAvTsOA+H9krG110lCCU3iw/z2jt4q4yz4dxVYDZBOSNhLB5iStrzlaub/edRflje1R
         cEXnMBZBHuZjOPvLW8FcM6MTmerABZxKyTodJXADKOeht2ypEiUhTI2SVPT8OEPxfO8k
         uezcJQ49Mczig199VJdJgK0t+V5zEpBbzGTRT28r9LfgEr1RoN1eGZ4vkwgmN1UY6EoP
         90HQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhkUwxcwcKpNXN4FUxr58CWT5u+SYMAYRRNJKEu1iWXtjYyP7eef09Vxpeq+UTpWf88oP4Yo8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUbxzUrMHORDw+qWIlGbP62ZqS5ZAJ05CwToXv4sD1QOH/GDp8
	AgdQJot1+p7OBel8+91ePG8GLnV4OJGgs8BsDeDAXsOhl6y17QyoKDeBLmlmv8frCYs=
X-Gm-Gg: ASbGnct1LS/+VTWRxVbK84WJCd79Y8uUBTNkqOedoP/4jme0xyyQa0GEuPPwoTC5Y2Q
	ryb8zT1GiwOPAJQ4YEO5zUIm3pPXKdLeEZHpScbw1wIYtow9G+zWyvvOJuGBgad4/7hEwOGMcK3
	cnU1jA/g31d80CAs5O9fsmqIm3lbCa4YXOdMi/d1sh1oat4DOmJp+To7sXE2jmGuA9BApMQdjZ5
	pHhNtJRoBNBlGhEcojMyUl8DGsrWRs0jsTh+jQWP+zXIY3We1EJsCLsCQNnT05piRDQdFwSHo0s
	wTxOu7hSbB8G6PW5hS/+CXp0E8aTNV02LEBzGjMyx1S5js57/vEGPEyCKfj5hWWo/wJSkhT9AN4
	B6E5uxvAy6X5MIOArjQ/NZXk4+TJUFcvjL6DavOhIlDYvEFEK/Y58yeweTSwrTSfCxK9NZPwyMU
	cacItRdHuwWSNI8df4AIg1AD9DhLJkOsDm/Pnmcp4X0ETed0/x4+EM/E5cqXhvvZTZ
X-Google-Smtp-Source: AGHT+IFpnJx+AzJWivjhYu5iwBOCku4YiBEji1yF3XFF/JbCkfgSDAdwWhiHUxXnRZSwthPc0nD5rw==
X-Received: by 2002:a05:620a:40c1:b0:8b1:ac18:acc9 with SMTP id af79cd13be357-8b29b77ad4bmr554239985a.32.1762975799847;
        Wed, 12 Nov 2025 11:29:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:59 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 04/11] memory-tiers: Introduce SysRAM and Specific Purpose Memory Nodes
Date: Wed, 12 Nov 2025 14:29:20 -0500
Message-ID: <20251112192936.2574429-5-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create Memory Node "types" (SysRAM and Specific Purpose) which can be
set at memory hotplug time.

SysRAM nodes present at __init time are added to the mt_sysram_nodelist
and memory hotplug will decide whether hotplugged nodes will be placed
in mt_sysram_nodelist or mt_spm_nodelist.

SPM nodes are not included in demotion targets.

Setting a node type is permanent and cannot be switched once set, this
prevents type-change race conditions on the global mt_sysram_nodelist.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h | 47 +++++++++++++++++++++++++
 mm/memory-tiers.c            | 66 ++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..59443cbfaec3 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -35,10 +35,44 @@ struct memory_dev_type {
 
 struct access_coordinate;
 
+enum {
+	MT_NODE_TYPE_SYSRAM,
+	MT_NODE_TYPE_SPM
+};
+
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
 extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
+extern nodemask_t mt_sysram_nodelist;
+extern nodemask_t mt_spm_nodelist;
+static inline nodemask_t *mt_sysram_nodemask(void)
+{
+	if (nodes_empty(mt_sysram_nodelist))
+		return NULL;
+	return &mt_sysram_nodelist;
+}
+static inline void mt_nodemask_sysram_mask(nodemask_t *dst, nodemask_t *mask)
+{
+	/* If the sysram filter isn't available, this allows all */
+	if (nodes_empty(mt_sysram_nodelist)) {
+		nodes_or(*dst, *mask, NODE_MASK_NONE);
+		return;
+	}
+	nodes_and(*dst, *mask, mt_sysram_nodelist);
+}
+static inline bool mt_node_is_sysram(int nid)
+{
+	/* if sysram filter isn't setup, this allows all */
+	return nodes_empty(mt_sysram_nodelist) ||
+	       node_isset(nid, mt_sysram_nodelist);
+}
+static inline bool mt_node_allowed(int nid, gfp_t gfp_mask)
+{
+	if (gfp_mask & __GFP_SPM_NODE)
+		return true;
+	return mt_node_is_sysram(nid);
+}
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
@@ -73,11 +107,19 @@ static inline bool node_is_toptier(int node)
 }
 #endif
 
+int mt_set_node_type(int node, int type);
+
 #else
 
 #define numa_demotion_enabled	false
 #define default_dram_type	NULL
 #define default_dram_nodes	NODE_MASK_NONE
+#define mt_sysram_nodelist	NODE_MASK_NONE
+#define mt_spm_nodelist		NODE_MASK_NONE
+static inline nodemask_t *mt_sysram_nodemask(void) { return NULL; }
+static inline void mt_nodemask_sysram_mask(nodemask_t *dst, nodemask_t *mask) {}
+static inline bool mt_node_is_sysram(int nid) { return true; }
+static inline bool mt_node_allowed(int nid, gfp_t gfp_mask) { return true; }
 /*
  * CONFIG_NUMA implementation returns non NULL error.
  */
@@ -151,5 +193,10 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+int mt_set_node_type(int node, int type)
+{
+	return 0;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0ea5c13f10a2..dd6cfaa4c667 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -44,7 +44,15 @@ static LIST_HEAD(memory_tiers);
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
-nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
+
+/* default_dram_nodes is the list of nodes with both CPUs and RAM */
+nodemask_t default_dram_nodes = NODE_MASK_NONE;
+
+/* mt_sysram_nodelist is the list of nodes with SysramRAM */
+nodemask_t mt_sysram_nodelist = NODE_MASK_NONE;
+
+/* mt_spm_nodelist is the list of nodes with Specific Purpose Memory */
+nodemask_t mt_spm_nodelist = NODE_MASK_NONE;
 
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
@@ -427,6 +435,14 @@ static void establish_demotion_targets(void)
 	disable_all_demotion_targets();
 
 	for_each_node_state(node, N_MEMORY) {
+		/*
+		 * If this is not a sysram node, direct-demotion is not allowed
+		 * and must be managed by special logic that understands the
+		 * memory features of that particular node.
+		 */
+		if (!node_isset(node, mt_sysram_nodelist))
+			continue;
+
 		best_distance = -1;
 		nd = &node_demotion[node];
 
@@ -457,7 +473,8 @@ static void establish_demotion_targets(void)
 				break;
 
 			distance = node_distance(node, target);
-			if (distance == best_distance || best_distance == -1) {
+			if ((distance == best_distance || best_distance == -1) &&
+			    node_isset(target, mt_sysram_nodelist)) {
 				best_distance = distance;
 				node_set(target, nd->preferred);
 			} else {
@@ -689,6 +706,48 @@ void mt_put_memory_types(struct list_head *memory_types)
 }
 EXPORT_SYMBOL_GPL(mt_put_memory_types);
 
+/**
+ * mt_set_node_type() - Set a NUMA Node's Memory type.
+ * @node: The node type to set
+ * @type: The type to set
+ *
+ * This is a one-way setting, once a type is assigned it cannot be cleared
+ * without resetting the system.  This is to avoid race conditions associated
+ * with moving nodes from one type to another during memory hotplug.
+ *
+ * Once a node is added as a SysRAM node, it will be used by default in
+ * the page allocator as a valid target when the calling does not provide
+ * a node or nodemask.  This is safe as the page allocator iterates through
+ * zones and uses this nodemask to filter zones - if a node is present but
+ * has no zones the node is ignored.
+ *
+ * Return: 0 if the node type is set successfully (or it's already set)
+ *         -EBUSY if the node has a different type already
+ *         -ENODEV if the type is invalid
+ */
+int mt_set_node_type(int node, int type)
+{
+	int err;
+
+	mutex_lock(&memory_tier_lock);
+	if (type == MT_NODE_TYPE_SYSRAM)
+		err = node_isset(node, mt_spm_nodelist) ? -EBUSY : 0;
+	else if (type == MT_NODE_TYPE_SPM)
+		err = node_isset(node, mt_sysram_nodelist) ? -EBUSY : 0;
+	if (err)
+		goto out;
+
+	if (type == MT_NODE_TYPE_SYSRAM)
+		node_set(node, mt_sysram_nodelist);
+	else if (type == MT_NODE_TYPE_SPM)
+		node_set(node, mt_spm_nodelist);
+	else
+		err = -ENODEV;
+out:
+	mutex_unlock(&memory_tier_lock);
+	return err;
+}
+
 /*
  * This is invoked via `late_initcall()` to initialize memory tiers for
  * memory nodes, both with and without CPUs. After the initialization of
@@ -922,6 +981,9 @@ static int __init memory_tier_init(void)
 	nodes_and(default_dram_nodes, node_states[N_MEMORY],
 		  node_states[N_CPU]);
 
+	/* Record all nodes with non-hotplugged memory as default SYSRAM nodes */
+	mt_sysram_nodelist = node_states[N_MEMORY];
+
 	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
 }
-- 
2.51.1

