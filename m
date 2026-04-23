Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F336DA0B;
	Thu, 23 Apr 2026 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963751; cv=none; b=kjOE8SjPIe8nqS8CClPaDRYRqWecZ13XyNsSuzklqVah5orGZR8WnM6DXpd8Z/uUmUF9mbGakUga8UYAdR6EDrv1NqhIUDYn9aKQuEv2YH8SU4RQLc/rXL4zMttjXmg0DeuaPWiz6JfylceXfHz+/UDvvNrutBO0Fu3GRGyf3n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963751; c=relaxed/simple;
	bh=PVLks3oRoegDPMuQnyktBwhAtpPXTB5aMp0SmMkse3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrTi8T07FWepbz6UQeqpZMr8ZnkMHxnbrNClluIli/xURlStbPk20j7X9+3laECeWgLFvKVKLtfpqrnSiIj3LJSTbH2+Alebxu8Vngs3XomyRdOOfnNd0hek72SpCh3rhOEv/vqTbPW0v2tV8tmgB9f1ccOqenE3C42wxXfASn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53354C2BCAF;
	Thu, 23 Apr 2026 17:02:31 +0000 (UTC)
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
Subject: [RFC PATCH 07/12] KVM: guest_memfd: Add setup of daxfd when binding gmem
Date: Thu, 23 Apr 2026 10:02:14 -0700
Message-ID: <20260423170219.281618-8-dave.jiang@intel.com>
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

A DAX fd comes from device dax char dev passed in from userspace. It's
not a fd that is created by the kernel unlike gmem fd.
kvm_guest_memfd_bind() seems to be the place to setup additional gmem
context for daxfd at this moment when it is passed in through the ioctl
to bind to gmem. Add a helper function to setup the necessary bits
when the fd is verified to be DAX.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/kvm/Kconfig      |  1 +
 drivers/dax/bus.c         |  3 +++
 drivers/dax/dax-private.h |  4 ++++
 include/linux/kvm_host.h  | 24 +++++++++++++++++++
 virt/kvm/Kconfig          |  4 ++++
 virt/kvm/guest_memfd.c    | 50 ++++++++++++++++++++++++++-------------
 6 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 278f08194ec8..bdcaff9c49e7 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM_X86
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
 	select KVM_GUEST_MEMFD if X86_64
+	select KVM_GUEST_DAXFD if X86_64
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ef447747876..759163722e4c 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1621,6 +1621,9 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	dev->parent = parent;
 	dev->type = &dev_dax_type;
 
+	xa_init(&dev_dax->gmem_file.bindings);
+	list_add(&dev_dax->gmem_file.entry, &inode->i_mapping->i_private_list);
+
 	rc = device_add(dev);
 	if (rc) {
 		kill_dev_dax(dev_dax);
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 425a515905e5..2b3c44cb0dbe 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/kvm_host.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -67,6 +68,8 @@ struct dev_dax_range {
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
+ *
+ * @gmem_file: guest mem file for this dev_dax. Must be first member
  * @region: parent region
  * @dax_dev: core dax functionality
  * @virt_addr: kva from memremap; used by fsdev_dax
@@ -83,6 +86,7 @@ struct dev_dax_range {
  * @ranges: range tuples of memory used
  */
 struct dev_dax {
+	struct gmem_file gmem_file;
 	struct dax_region *region;
 	struct dax_device *dax_dev;
 	void *virt_addr;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..9afce6d02d9e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -56,6 +56,7 @@
  */
 #define KVM_MEMSLOT_INVALID			(1UL << 16)
 #define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
+#define KVM_MEMSLOT_DAX_ONLY			(1UL << 18)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2515,6 +2516,14 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
 }
 
+static inline bool kvm_memslot_is_dax_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_DAXFD))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_DAX_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
@@ -2604,4 +2613,19 @@ static inline int kvm_enable_virtualization(void) { return 0; }
 static inline void kvm_disable_virtualization(void) { }
 #endif
 
+/*
+ * A guest_memfd instance can be associated multiple VMs, each with its own
+ * "view" of the underlying physical memory.
+ *
+ * The gmem's inode is effectively the raw underlying physical storage, and is
+ * used to track properties of the physical memory, while each gmem file is
+ * effectively a single VM's view of that storage, and is used to track assets
+ * specific to its associated VM, e.g. memslots=>gmem bindings.
+ */
+struct gmem_file {
+	struct kvm *kvm;
+	struct xarray bindings;
+	struct list_head entry;
+};
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 267c7369c765..7f0598af868b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -125,3 +125,7 @@ config HAVE_KVM_ARCH_GMEM_INVALIDATE
 config HAVE_KVM_ARCH_GMEM_POPULATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config KVM_GUEST_DAXFD
+	bool
+	depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..959f690c1d1d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,26 +7,12 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/dax.h>
 
 #include "kvm_mm.h"
 
 static struct vfsmount *kvm_gmem_mnt;
 
-/*
- * A guest_memfd instance can be associated multiple VMs, each with its own
- * "view" of the underlying physical memory.
- *
- * The gmem's inode is effectively the raw underlying physical storage, and is
- * used to track properties of the physical memory, while each gmem file is
- * effectively a single VM's view of that storage, and is used to track assets
- * specific to its associated VM, e.g. memslots=>gmem bindings.
- */
-struct gmem_file {
-	struct kvm *kvm;
-	struct xarray bindings;
-	struct list_head entry;
-};
-
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
@@ -644,6 +630,32 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
+/*
+ * DAX fd files are not initialized with gmem bits since it's passed in from
+ * user space and not created by the kernel (at least right now). So when
+ * the daxfd is being bound during kvm_gmem_bind(), the gmem bits needs to be
+ * initialized.
+ */
+static int kvm_daxfd_init(struct file *file, struct kvm_memory_slot *slot,
+			  struct kvm *kvm)
+{
+	struct gmem_file *f;
+	struct inode *inode;
+
+	if (!is_file_dax(file))
+		return -EINVAL;
+
+	inode = file_inode(file);
+	GMEM_I(inode)->flags |= GUEST_MEMFD_FLAG_MMAP;
+	slot->flags |= KVM_MEMSLOT_DAX_ONLY;
+
+	kvm_get_kvm(kvm);
+	f = file->private_data;
+	f->kvm = kvm;
+
+	return 0;
+}
+
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset)
 {
@@ -660,7 +672,13 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EBADF;
 
-	if (file->f_op != &kvm_gmem_fops)
+	if (is_file_dax(file)) {
+		r = kvm_daxfd_init(file, slot, kvm);
+		if (r)
+			goto err;
+	}
+
+	if (file->f_op != &kvm_gmem_fops && !is_file_dax(file))
 		goto err;
 
 	f = file->private_data;
-- 
2.53.0

