Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D9D381B05;
	Thu, 23 Apr 2026 17:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963756; cv=none; b=qzxCgljii4c7B6UJWecZzKAqVmhPaaS2FuwZVNBRlzlwFvO0pa6vhSUxlVAtj8T7uXmvi7HdBS5bqSZJC3KqmQQDkbBA4xTVZ6NkyzPHhmgYfIxBWCzIuWMrqrMeJsqoSmbFx3VGCTGWNBnUvlELBJtjxqeh6tXA+/zxu8h9DnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963756; c=relaxed/simple;
	bh=HYzvVExtWfJfN31F64rwitcl6O/I04M0IktAS+yPO3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvZkZQ8/TApgLiXu+6HOVj92fV9mceYXHOR8D9AdJVspawTTyd0gju178zcCyuQVwXeUTmwormTqBMpTJ0ojExT+EoRTyvzW17ZjBOMufFzdHwTb2Dw7LSWtHbR2ekdqxt1ISdZUH16L5lA0S5Ps/WBtjpnyohFa7falOYuLAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90961C2BCAF;
	Thu, 23 Apr 2026 17:02:35 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 10/12] kvm: Implement dax support for KVM faulting
Date: Thu, 23 Apr 2026 10:02:17 -0700
Message-ID: <20260423170219.281618-11-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for KVM faulting of daxfd through using dax_direct_access().
The function kvm_dax_get_pfn() is implemented to complete the daxfd
support for KVM faulting. A reference is taken on the page. There is no
need to call put_dev_pagemap() when put_page() happens as recent kernel
changes takes care of that within put_page() path.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c   | 48 +++++++++++++++++++++++++++++++++++-----
 drivers/dax/bus.c        |  1 +
 include/linux/dax.h      |  1 +
 include/linux/kvm_host.h |  8 +++++++
 virt/kvm/guest_memfd.c   | 42 +++++++++++++++++++++++++++++++++++
 5 files changed, 94 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..fe787f73b9a8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4588,16 +4588,52 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
+static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn - slot->base_gfn + slot->gmem.pgoff;
+}
+
+static kvm_pfn_t kvm_faultin_dax_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	kvm_pfn_t pfn;
+	pgoff_t index;
+	int rc;
+
+	if (!kvm_memslot_is_dax_only(fault->slot))
+		return KVM_PFN_ERR_FAULT;
+
+	index = kvm_gmem_get_index(fault->slot, fault->gfn);
+	rc = kvm_dax_get_pfn(fault->slot, index, &pfn, &fault->refcounted_page);
+	if (rc)
+		return KVM_PFN_ERR_FAULT;
+
+	return pfn;
+}
+
 static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
+	gfn_t gfn = fault->gfn;
 
-	if (fault->is_private || kvm_memslot_is_gmem_only(fault->slot))
+	if (fault->is_private || (kvm_memslot_is_gmem_only(fault->slot) &&
+	    !kvm_memslot_is_dax_only(fault->slot)))
 		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
 
+	if (kvm_memslot_is_dax_only(fault->slot)) {
+		gfn = kvm_gmem_get_index(fault->slot, fault->gfn);
+		fault->pfn = kvm_faultin_dax_pfn(vcpu, fault);
+		if (fault->pfn == KVM_PFN_ERR_FAULT) {
+			kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+			return RET_PF_INVALID;
+		}
+		fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+
+		return RET_PF_CONTINUE;
+	}
+
 	foll |= FOLL_NOWAIT;
-	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
+	fault->pfn = __kvm_faultin_pfn(fault->slot, gfn, foll,
 				       &fault->map_writable, &fault->refcounted_page);
 
 	/*
@@ -4610,9 +4646,9 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 		return RET_PF_CONTINUE;
 
 	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
-		if (kvm_find_async_pf_gfn(vcpu, fault->gfn)) {
-			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
+		trace_kvm_try_async_get_page(fault->addr, gfn);
+		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
+			trace_kvm_async_pf_repeated_fault(fault->addr, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return RET_PF_RETRY;
 		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
@@ -4627,7 +4663,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 */
 	foll |= FOLL_INTERRUPTIBLE;
 	foll &= ~FOLL_NOWAIT;
-	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
+	fault->pfn = __kvm_faultin_pfn(fault->slot, gfn, foll,
 				       &fault->map_writable, &fault->refcounted_page);
 
 	return RET_PF_CONTINUE;
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index a99db3739e45..2009f34614d8 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
 #include <linux/memremap.h>
 #include <linux/highmem.h>
+#include <linux/kvm_host.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
diff --git a/include/linux/dax.h b/include/linux/dax.h
index da1413c8a21f..41214b6d7897 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -5,6 +5,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/radix-tree.h>
+#include <linux/kvm_host.h>
 
 typedef unsigned long dax_entry_t;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9afce6d02d9e..ffd0381ba079 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2552,6 +2552,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order);
+int kvm_dax_get_pfn(struct kvm_memory_slot *slot, pgoff_t index, kvm_pfn_t *pfn,
+		    struct page **refcounted_page);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2561,6 +2563,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_dax_get_pfn(struct kvm_memory_slot *slot, gfn_t gfn,
+				  kvm_pfn_t *pfn)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 959f690c1d1d..4e7141fdb2b8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -840,6 +840,48 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
+int kvm_dax_get_pfn(struct kvm_memory_slot *slot, pgoff_t index, kvm_pfn_t *pfn,
+		    struct page **refcounted_page)
+{
+	struct dev_pagemap *pgmap;
+	struct dev_dax *dev_dax;
+	struct page *page;
+	void *kaddr;
+	long rc;
+	int id;
+
+	CLASS(gmem_get_file, file)(slot);
+	if (!file)
+		return -EFAULT;
+
+	dev_dax = file->private_data;
+	if (!dev_dax)
+		return -ENODEV;
+
+	id = dax_read_lock();
+	rc = dax_direct_access(dax_get_dev_dax(dev_dax), index, 1, DAX_ACCESS,
+			       &kaddr, (unsigned long *)pfn);
+	dax_read_unlock(id);
+	if (rc < 0)
+		return rc;
+
+	/* Verify that 'struct page' exists for this PFN */
+	pgmap = get_dev_pagemap(*pfn);
+	if (!pgmap)
+		return -ENODEV;
+
+	page = pfn_to_page(*pfn);
+	if (!try_get_page(page)) {
+		put_dev_pagemap(pgmap);
+		return -EFAULT;
+	}
+
+	*refcounted_page = page;
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_dax_get_pfn);
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
-- 
2.53.0

