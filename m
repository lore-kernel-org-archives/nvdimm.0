Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502C323BD
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 10:19:58 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="115116672"
X-IronPort-AV: E=Sophos;i="5.99,230,1677510000"; 
   d="scan'208";a="115116672"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 19:18:47 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id AD5B2D6478
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 19:18:45 +0900 (JST)
Received: from kws-ab1.gw.nic.fujitsu.com (kws-ab1.gw.nic.fujitsu.com [192.51.206.11])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id D73CDD55E5
	for <nvdimm@lists.linux.dev>; Thu, 27 Apr 2023 19:18:44 +0900 (JST)
Received: from FNSTPC.g08.fujitsu.local (unknown [10.167.226.45])
	by kws-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id 090451145FC8;
	Thu, 27 Apr 2023 19:18:42 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: x86@kernel.org,
	nvdimm@lists.linux.dev,
	kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	y-goto@fujitsu.com,
	yangx.jy@fujitsu.com,
	ruansy.fnst@fujitsu.com,
	Li Zhijian <lizhijian@fujitsu.com>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>
Subject: [RFC PATCH v2 1/3] crash: export dev memmap header to vmcoreinfo
Date: Thu, 27 Apr 2023 18:18:32 +0800
Message-Id: <20230427101838.12267-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230427101838.12267-1-lizhijian@fujitsu.com>
References: <20230427101838.12267-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27590.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27590.006
X-TMASE-Result: 10--8.579600-10.000000
X-TMASE-MatchedRID: NusNVSlhHE3o2ZWMy24DXxFbgtHjUWLyEDnDEqNPdupgPgeggVwCFnOw
	/jufb+urjx5X3FdI4UDmn3xyPJAJoh2P280ZiGmRFDuTLTe6zcPDCscXmnDN70ekR3VSvOYVfMZ
	9Z21cFRwZ+9qD5ZvwhynYQ5Puko8IFIetOq2+pVD/2ZGj3BST5dC1Z3HzBbIHEu7wSQdRGs93I3
	P+EY3BjRcfmI3+RkHYnagtny7ZPcQfE8yM4pjsDzXJPZYaymc4xEHRux+uk8h+ICquNi0WJMFcj
	FTxsO89PnFUB9od7fL1uFbUDrfyNiyqaup2Gcf5ftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Introduce a symbol and export it to vmcoreinfo. Dumping
applications such as makedumpfile, with this variable, they are able to
restore a linked list which contained the memmap region located in
device.

With this mechanism, nvdimm/pmem which allows placing memmap in device
is able to export the its memmap(page array) to kdump kernel via
vmcoreinfo.

CC: Baoquan He <bhe@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Dave Young <dyoung@redhat.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 include/linux/crash_core.h |  8 +++++
 kernel/crash_core.c        | 61 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index de62a722431e..05ec2777f4fd 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -84,4 +84,12 @@ int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
 int parse_crashkernel_low(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 
+#ifdef CONFIG_CRASH_CORE
+void devm_memmap_vmcore_delete(void *match);
+void devm_memmap_vmcore_update(void *match, u64 pfn, u64 npfn, bool dev);
+#else
+#define devm_memmap_vmcore_delete(match) do {} while (0)
+#define devm_memmap_vmcore_update(match, pfn, npfn, dev) do {} while (0)
+#endif
+
 #endif /* LINUX_CRASH_CORE_H */
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 755f5f08ab38..f28cbd98f28b 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -401,6 +401,61 @@ phys_addr_t __weak paddr_vmcoreinfo_note(void)
 }
 EXPORT_SYMBOL(paddr_vmcoreinfo_note);
 
+struct devm_memmap_vmcore {
+	struct list_head entry;
+	unsigned long start;
+	unsigned long end;
+	void *match;
+};
+
+static struct devm_memmap_vmcore devm_memmap_vmcore_head = {
+	.entry = LIST_HEAD_INIT(devm_memmap_vmcore_head.entry),
+};
+static DEFINE_MUTEX(devm_memmap_vmcore_mutex);
+
+static void devm_memmap_vmcore_add(void *match, u64 pfn, u64 npfn)
+{
+	struct devm_memmap_vmcore *metadata;
+
+	metadata = kzalloc(sizeof(*metadata), GFP_KERNEL);
+	if (!metadata) {
+		pr_err("No enough memory");
+		return;
+	}
+
+	metadata->start = pfn;
+	metadata->end = pfn + npfn;
+	metadata->match = match;
+
+	mutex_lock(&devm_memmap_vmcore_mutex);
+	list_add(&metadata->entry, &devm_memmap_vmcore_head.entry);
+	mutex_unlock(&devm_memmap_vmcore_mutex);
+}
+
+void devm_memmap_vmcore_delete(void *match)
+{
+	struct devm_memmap_vmcore *metadata;
+
+	mutex_lock(&devm_memmap_vmcore_mutex);
+	list_for_each_entry(metadata, &devm_memmap_vmcore_head.entry, entry) {
+		if (metadata->match == match) {
+			list_del(&metadata->entry);
+			kfree(metadata);
+			break;
+		}
+	}
+	mutex_unlock(&devm_memmap_vmcore_mutex);
+}
+EXPORT_SYMBOL_GPL(devm_memmap_vmcore_delete);
+
+void devm_memmap_vmcore_update(void *match, u64 start_pfn, u64 npfn, bool dev)
+{
+	devm_memmap_vmcore_delete(match);
+	if (dev)
+		devm_memmap_vmcore_add(match, start_pfn, npfn);
+}
+EXPORT_SYMBOL_GPL(devm_memmap_vmcore_update);
+
 static int __init crash_save_vmcoreinfo_init(void)
 {
 	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
@@ -436,6 +491,12 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
 #ifdef CONFIG_SPARSEMEM
+	VMCOREINFO_SYMBOL(devm_memmap_vmcore_head);
+	VMCOREINFO_STRUCT_SIZE(devm_memmap_vmcore);
+	VMCOREINFO_OFFSET(devm_memmap_vmcore, entry);
+	VMCOREINFO_OFFSET(devm_memmap_vmcore, start);
+	VMCOREINFO_OFFSET(devm_memmap_vmcore, end);
+
 	VMCOREINFO_SYMBOL_ARRAY(mem_section);
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
 	VMCOREINFO_STRUCT_SIZE(mem_section);
-- 
2.29.2

