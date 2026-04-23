Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7074A34887E;
	Thu, 23 Apr 2026 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963757; cv=none; b=TIdtQZA7BpCaIwktNCNvk+/qSpANXldcLzY1VJx1LNVA7CNia8KbwJnbpcjoiKGkM4E+klJSctCyzaWWJjTlWqh8+YpYqazM7mzKyJEnOGHpuJfkr4QWgtS6W2jr8SnLx/k4ogL5T0rudDaQdJTKMARSjzY8FZTsyQk8AVjMYRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963757; c=relaxed/simple;
	bh=rACiwKMD9EAG7r9aTlbl6V8nLJbbZBmPN5G2PoJzDbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC2aGHoXJDbY76vqKeKkrQyN/2/QBldcd9kUznBCwZzGMAR8+HrO+RZCk7Oclr/NTz16Q11mEQgxsw6qFSylgNBC7lfKPNsdrGLuU5RIScVt2+YQj7ylo2UfW5h/gejaeC08Y8P+2Jifvh+qGlOwCkhI5rjEg5TpZWRceNr/j3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A88C2BCAF;
	Thu, 23 Apr 2026 17:02:37 +0000 (UTC)
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
Subject: [RFC PATCH 11/12] kvm: Add daxfd support for supported flags
Date: Thu, 23 Apr 2026 10:02:18 -0700
Message-ID: <20260423170219.281618-12-dave.jiang@intel.com>
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

Add supported flags for daxfd similar to what memfd does.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 include/linux/kvm_host.h | 7 +++++++
 include/uapi/linux/kvm.h | 4 ++++
 virt/kvm/kvm_main.c      | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ffd0381ba079..1427ff41cfc9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -743,6 +743,13 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 }
 #endif
 
+#ifdef CONFIG_KVM_GUEST_DAXFD
+static inline u64 kvm_dax_get_supported_flags(struct kvm *kvm)
+{
+	return GUEST_MEMFD_FLAG_MMAP;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..2ae3e1cdcee5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_GUEST_DAXFD	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -974,6 +975,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
+#define KVM_CAP_GUEST_DAXFD 247
+#define KVM_CAP_GUEST_DAXFD_FLAGS 248
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1612,6 +1615,7 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_DAXFD_FLAG_MMAP		(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b5b69c97665..82d9fb65e149 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4952,6 +4952,12 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		return kvm_gmem_get_supported_flags(kvm);
+#endif
+#ifdef CONFIG_KVM_GUEST_DAXFD
+	case KVM_CAP_GUEST_DAXFD:
+		return 1;
+	case KVM_CAP_GUEST_DAXFD_FLAGS:
+		return kvm_dax_get_supported_flags(kvm);
 #endif
 	default:
 		break;
-- 
2.53.0

