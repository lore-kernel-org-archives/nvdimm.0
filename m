Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D149551D
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576146; cv=none; b=sjznkYxagLE5KhxZZO6LAwwhDeElck+kXe1bAaJTLAE69mP1Zsq4wIsEemrJ9LBxV4eyNNDMSaTZPghHe79jyIWqa5n6iz98tmnjLjOEjdAKJrlTp8e0QvU/5VWnRMJJMFIlz9FqrELGBn53PdBh6KWSUS4U/2C9ZK+PEhJpdbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576146; c=relaxed/simple;
	bh=yY8vdYfrcyLR9od9JeL4axrrxakrg2eLNX+2tZcvV5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p468w5kJrxfNl7SKcrVA8TdClrr+ZyKMkmI3XYqHnYAWrs84Gk6O2BC+AlPL5ZdvViv3sgXTmTmdPns7wqeiic9MWi5TUs3BNi+IE5h3PN+4mk/HR07dJTX0Z4tDEIe6Yb8TEEX+qSlX40HRTxloTwbtvE2YJQIpAIAjJktdJ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=d4z6zNJi; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="d4z6zNJi"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930c0f9c1b1so259153885a.1
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576141; x=1785180941; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJBiGb0Mu/jlRkqoocYqUCBCgZwlU5de7y2L/NJU7rM=;
        b=d4z6zNJiNyWyDbggtMDA90e2s0EmEJH6UPWjXvZZ8LC9YTh/7VxQJHjYCXTiKnB9so
         hiVWdPDGTXBL2uEeZ8SjYzLe/brzf3pVmWR7E59MJuo4j9HA3vLZvcrzx6L8DVSXWZOf
         78HKWCFSVcNHgfJeiLAgf6+bq+Ced7eFN3bIYkTxDi41Lbd1qvpOhMNxGmaInFqLHgXU
         e//ujQjsqa2hXg1w9RKCiao2QKRu6R81VIq15hofuy70cEnmbKsf5i+VuU9/87MGTjZ1
         XMF1i40s3mxc7OYGM6uaNoNoPTYO8RFLGbj0XAuscKqZG+0Xy0HALKquZefqwaqYOS5C
         Rwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576141; x=1785180941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJBiGb0Mu/jlRkqoocYqUCBCgZwlU5de7y2L/NJU7rM=;
        b=pLTcrKpba3JhDHNGNerJOOHBhVUnhUk7Que8V73ka3ThDjt4Te+Iru/MiJ9R4eX0mt
         GzlIXpoNb5wZbuooTRspw38sxswpO6t5V/K0JfDzF/uB8YvFfbXrVt5Cxky4ysnsWMlO
         Wb1Gl59KaHllxmlUhtRtY4VNX4W9pRZCBcYNbnk64cdJcG5GypgWB6fGZ+UP1459P9tY
         faEYwE3soj9HfBVYmoa7TRbd5rh0N9mJEQDjkNW1vXdT0yb6UmuRQszwT39Dtw488ZC6
         oJgxiI+qt9iNzNK8n5exmf3NWRYh6X1XB/6fs04agEwbp6cIjrOPIRLl+t6XHPnjTf88
         w5Lg==
X-Forwarded-Encrypted: i=1; AHgh+RrX3YzH9HuURpxjXuXQWSdbLcDNeRgzALyyZ4hcNYnqki22/Lch9rK1rHxemyR2lsh2vZRXPmo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwI6xKOZwM0150VFPtxyoF+Mbqlqvc+iVJw6eBSEIh3DyyamHV
	gItb2O8XiAFdVwcaGfxFkUfyLyXqSF5nYgOVt86l/L00K0trRafgt4tU3PLwEM4Si/k=
X-Gm-Gg: AfdE7ck9wfnKdjODxDCu3b00oK7nrQHJw9qk/p/rPpujKFmfDRuOFg9TGLUjjEusxiT
	xboOFOijNmai6JaYxaaiqDyeKIaxLNajoqlC9y3FodBelDuSZjuhl4wDOKUDcZ+4+pWLBK7r1UJ
	YQVnHUz2K2mMzdM1K0/Wx1n4Hh+9cDAlKE/s7uA3AR6IozJS6bh9BPvXTabn5YJtGrlCOcB8Kod
	EOfJh7pOUz4CVKMTyprMQI9XXGrqv2U32BG0XGq3DiNPKYeU3E1uihwVstcnTtWIHr0jGzRUdLZ
	2PtB+xdoR9Ox9KeHYrgQvvWzvCFA2DSHzLSL0iKiMnAk+8wDHh4HHUcG79uQY+lt2/ksKC9URZa
	2EiZzxiHrQTnFv2HTUklLAmGBvw6mXjc+alkldACmuhsmXZrQSWjlVJL5MMC7LZ8pYCLLpbnDvX
	btep3uEjS1rT9Tp5g8427OO6fimXscOwi9Mc5JCw26XSuYmj4bcBkRtbtOt0K0tnw=
X-Received: by 2002:a05:620a:370d:b0:930:ab28:945c with SMTP id af79cd13be357-930b41df2e2mr1633607185a.50.1784576140803;
        Mon, 20 Jul 2026 12:35:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:40 -0700 (PDT)
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
Subject: [PATCH v5 24/36] mm/mempolicy: add in-kernel MPOL_BIND interfaces for drivers/services
Date: Mon, 20 Jul 2026 15:34:18 -0400
Message-ID: <20260720193431.3841992-25-gourry@gourry.net>
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

Add and export interfaces to enable modules to build a mempolicy with
(MPOL_BIND | MPOL_F_PRIVATE) pinned to a private NUMA node, so the
drivers can stamp it onto VMAs they control (via vma->vm_policy).

  mpol_bind_node()    - acts the same as a userland mbind()
  mpol_private_bind() - bypasses the CAP_USER_NUMA check.

Export it to modules (private:kmem, bind:kvm).

Widen __mpol_put()'s module export to kmem so the driver can
release the policy.

Adjust mpol_set_nodemask to check for a pre-set MPOL_F_PRIVATE flag
to allow the mpol_private_bind() check to bypass the N_MEMORY filter.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/mempolicy.h |  14 ++++++
 mm/mempolicy.c            | 102 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2f..715951a5b03c1 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -7,6 +7,7 @@
 #define _LINUX_MEMPOLICY_H 1
 
 #include <linux/sched.h>
+#include <linux/err.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
@@ -128,6 +129,9 @@ void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    pgoff_t idx);
 
+struct mempolicy *mpol_private_bind(int nid);
+struct mempolicy *mpol_bind_node(int nid);
+
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 		unsigned long addr, pgoff_t *ilx);
@@ -226,6 +230,16 @@ mpol_shared_policy_lookup(struct shared_policy *sp, pgoff_t idx)
 	return NULL;
 }
 
+static inline struct mempolicy *mpol_private_bind(int nid)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline struct mempolicy *mpol_bind_node(int nid)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 				unsigned long addr, int order, pgoff_t *ilx)
 {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e83c2c7a94c1d..a3ffb09897489 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -406,7 +406,7 @@ static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 static int mpol_set_nodemask(struct mempolicy *pol,
 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
 {
-	int ret;
+	int ret, nid;
 
 	/*
 	 * Default (pol==NULL) resp. local memory policies are not a
@@ -432,6 +432,18 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	else
 		pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
 
+	/*
+	 * Private nodes are not in cpuset.mems, so they're always stripped.
+	 * Driver-allocated policies will already have MPOL_F_PRIVATE set,
+	 * if that's the case, add back in the requested set of private nodes.
+	 */
+	for_each_node_mask(nid, *nodes) {
+		if (!node_is_private(nid))
+			continue;
+		if (pol->flags & MPOL_F_PRIVATE)
+			node_set(nid, nsc->mask2);
+	}
+
 	/* If any private nodes left in the nodemask - add the private flag */
 	if (nodes_intersects(nsc->mask2, node_states[N_MEMORY_PRIVATE]))
 		pol->flags |= MPOL_F_PRIVATE;
@@ -501,7 +513,7 @@ void __mpol_put(struct mempolicy *pol)
 	 */
 	kfree_rcu(pol, rcu);
 }
-EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
+EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm,kmem");
 
 static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 {
@@ -1126,6 +1138,92 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 	return ret;
 }
 
+/*
+ * Build a refcounted MPOL_BIND policy targeting the single node @nid,
+ * contextualised to the caller's cpuset like a userspace mbind().
+ *
+ * @flags is MPOL_F_PRIVATE for the an explicit in-kernel user, letting
+ * a private node be bound without checking CAP_USER_NUMA.  Otherwise,
+ * CAP_USER_NUMA is enforced.
+ *
+ * The caller owns the reference and frees it with mpol_put().
+ */
+static struct mempolicy *__mpol_bind_node(int nid, unsigned short flags)
+{
+	struct mempolicy *pol;
+	nodemask_t nodes;
+	int err;
+
+	NODEMASK_SCRATCH(scratch);
+
+	if (!scratch)
+		return ERR_PTR(-ENOMEM);
+
+	nodes_clear(nodes);
+	node_set(nid, nodes);
+
+	pol = mpol_new(MPOL_BIND, flags, &nodes);
+	if (IS_ERR(pol)) {
+		NODEMASK_SCRATCH_FREE(scratch);
+		return pol;
+	}
+
+	err = mpol_set_nodemask(pol, &nodes, scratch);
+	NODEMASK_SCRATCH_FREE(scratch);
+	if (err) {
+		mpol_put(pol);
+		return ERR_PTR(err);
+	}
+	return pol;
+}
+
+/**
+ * mpol_private_bind - build an MPOL_BIND policy pinned to a private node
+ * @nid: an N_MEMORY_PRIVATE node
+ *
+ * Returns a refcounted mempolicy that binds allocations to @nid with the
+ * private-placement intent (MPOL_F_PRIVATE).  This binds to @nid regardless
+ * of the node's CAP_USER_NUMA, providing a privileged way for node-owners
+ * to bind driver/service owned VMAs to the node.
+ *
+ * Like any MPOL_BIND it is relaxable: an unsatisfiable request falls back
+ * rather than failing.
+ *
+ * Must be called while @nid is N_MEMORY_PRIVATE.
+ *
+ * The caller owns the reference and frees it with mpol_put().
+ *
+ * Return: the policy, or an ERR_PTR on failure.
+ */
+struct mempolicy *mpol_private_bind(int nid)
+{
+	if (!node_is_private(nid))
+		return ERR_PTR(-EINVAL);
+	return __mpol_bind_node(nid, MPOL_F_PRIVATE);
+}
+EXPORT_SYMBOL_FOR_MODULES(mpol_private_bind, "kmem");
+
+/**
+ * mpol_bind_node - build an MPOL_BIND policy targeting @nid for in-kernel use
+ * @nid: the node to bind to
+ *
+ * Returns a refcounted MPOL_BIND policy that places allocations on @nid,
+ * contextualised to the caller's cpuset exactly like a userspace mbind().
+ *
+ * This interface should be used by services implenting mempolicy support with
+ * user-provided node bindings. N_MEMORY_PRIVATE node bindings are honored if
+ * the node has CAP_USER_NUMA, otherwise return -EINVAL.
+ *
+ * The caller owns the reference and frees it with mpol_put().
+ *
+ * Return: the policy, or an ERR_PTR on failure.
+ */
+struct mempolicy *mpol_bind_node(int nid)
+{
+	return __mpol_bind_node(nid, 0);
+}
+EXPORT_SYMBOL_FOR_MODULES(mpol_bind_node, "kvm");
+
 /*
  * Return nodemask for policy for get_mempolicy() query
  *
-- 
2.53.0-Meta

