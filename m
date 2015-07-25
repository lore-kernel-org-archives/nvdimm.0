Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 10/25] x86: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:38:53 -0400
Message-ID: <20150725023853.8664.23118.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in
arch/x86/ to memremap.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/efi.h      |    3 ++-
 arch/x86/kernel/crash_dump_64.c |    6 +++---
 arch/x86/kernel/kdebugfs.c      |    8 ++++----
 arch/x86/kernel/ksysfs.c        |   28 ++++++++++++++--------------
 arch/x86/mm/ioremap.c           |   10 ++++------
 5 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 155162ea0e00..755272a8c45f 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -54,7 +54,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 	kernel_fpu_end();						\
 })
 
-#define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, type, attr)				\
+	memremap(addr, size, MEMREMAP_CACHE)
 
 #else /* !CONFIG_X86_32 */
 
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index afa64adb75ee..b87ca059e5fc 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -31,19 +31,19 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = memremap(pfn << PAGE_SHIFT, PAGE_SIZE, MEMREMAP_CACHE);
 	if (!vaddr)
 		return -ENOMEM;
 
 	if (userbuf) {
 		if (copy_to_user(buf, vaddr + offset, csize)) {
-			iounmap(vaddr);
+			memunmap(vaddr);
 			return -EFAULT;
 		}
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
 	set_iounmap_nonlazy();
-	iounmap(vaddr);
+	memunmap(vaddr);
 	return csize;
 }
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index dc1404bf8e4b..a2248482c14b 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -49,7 +49,7 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
 	pa = node->paddr + sizeof(struct setup_data) + pos;
 	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
 	if (PageHighMem(pg)) {
-		p = ioremap_cache(pa, count);
+		p = memremap(pa, count, MEMREMAP_CACHE);
 		if (!p)
 			return -ENXIO;
 	} else
@@ -58,7 +58,7 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
 	remain = copy_to_user(user_buf, p, count);
 
 	if (PageHighMem(pg))
-		iounmap(p);
+		memunmap(p);
 
 	if (remain)
 		return -EFAULT;
@@ -128,7 +128,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 
 		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
 		if (PageHighMem(pg)) {
-			data = ioremap_cache(pa_data, sizeof(*data));
+			data = memremap(pa_data, sizeof(*data), MEMREMAP_CACHE);
 			if (!data) {
 				kfree(node);
 				error = -ENXIO;
@@ -144,7 +144,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		pa_data = data->next;
 
 		if (PageHighMem(pg))
-			iounmap(data);
+			memunmap(data);
 		if (error)
 			goto err_dir;
 		no++;
diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
index c2bedaea11f7..d2670bb75a08 100644
--- a/arch/x86/kernel/ksysfs.c
+++ b/arch/x86/kernel/ksysfs.c
@@ -16,8 +16,8 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/setup.h>
 
 static ssize_t version_show(struct kobject *kobj,
@@ -79,12 +79,12 @@ static int get_setup_data_paddr(int nr, u64 *paddr)
 			*paddr = pa_data;
 			return 0;
 		}
-		data = ioremap_cache(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_CACHE);
 		if (!data)
 			return -ENOMEM;
 
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 		i++;
 	}
 	return -EINVAL;
@@ -97,17 +97,17 @@ static int __init get_setup_data_size(int nr, size_t *size)
 	u64 pa_data = boot_params.hdr.setup_data;
 
 	while (pa_data) {
-		data = ioremap_cache(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_CACHE);
 		if (!data)
 			return -ENOMEM;
 		if (nr == i) {
 			*size = data->len;
-			iounmap(data);
+			memunmap(data);
 			return 0;
 		}
 
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 		i++;
 	}
 	return -EINVAL;
@@ -127,12 +127,12 @@ static ssize_t type_show(struct kobject *kobj,
 	ret = get_setup_data_paddr(nr, &paddr);
 	if (ret)
 		return ret;
-	data = ioremap_cache(paddr, sizeof(*data));
+	data = memremap(paddr, sizeof(*data), MEMREMAP_CACHE);
 	if (!data)
 		return -ENOMEM;
 
 	ret = sprintf(buf, "0x%x\n", data->type);
-	iounmap(data);
+	memunmap(data);
 	return ret;
 }
 
@@ -154,7 +154,7 @@ static ssize_t setup_data_data_read(struct file *fp,
 	ret = get_setup_data_paddr(nr, &paddr);
 	if (ret)
 		return ret;
-	data = ioremap_cache(paddr, sizeof(*data));
+	data = memremap(paddr, sizeof(*data), MEMREMAP_CACHE);
 	if (!data)
 		return -ENOMEM;
 
@@ -170,15 +170,15 @@ static ssize_t setup_data_data_read(struct file *fp,
 		goto out;
 
 	ret = count;
-	p = ioremap_cache(paddr + sizeof(*data), data->len);
+	p = memremap(paddr + sizeof(*data), data->len, MEMREMAP_CACHE);
 	if (!p) {
 		ret = -ENOMEM;
 		goto out;
 	}
 	memcpy(buf, p + off, count);
-	iounmap(p);
+	memunmap(p);
 out:
-	iounmap(data);
+	memunmap(data);
 	return ret;
 }
 
@@ -250,13 +250,13 @@ static int __init get_setup_data_total_num(u64 pa_data, int *nr)
 	*nr = 0;
 	while (pa_data) {
 		*nr += 1;
-		data = ioremap_cache(pa_data, sizeof(*data));
+		data = memremap(pa_data, sizeof(*data), MEMREMAP_CACHE);
 		if (!data) {
 			ret = -ENOMEM;
 			goto out;
 		}
 		pa_data = data->next;
-		iounmap(data);
+		memunmap(data);
 	}
 
 out:
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12b1eaeab6b9..6f759c7c2ab7 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -403,12 +403,10 @@ void *xlate_dev_mem_ptr(phys_addr_t phys)
 	if (page_is_ram(start >> PAGE_SHIFT))
 		return __va(phys);
 
-	vaddr = ioremap_cache(start, PAGE_SIZE);
-	/* Only add the offset on success and return NULL if the ioremap() failed: */
+	vaddr = memremap(start, PAGE_SIZE, MEMREMAP_CACHE);
 	if (vaddr)
-		vaddr += offset;
-
-	return vaddr;
+		return vaddr + offset;
+	return NULL;
 }
 
 void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
@@ -416,7 +414,7 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 	if (page_is_ram(phys >> PAGE_SHIFT))
 		return;
 
-	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
+	memunmap((void *)((unsigned long)addr & PAGE_MASK));
 }
 
 static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;

