Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED54618AEF
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 10:28:20 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="119220278"
X-IronPort-AV: E=Sophos;i="6.00,212,1681138800"; 
   d="scan'208";a="119220278"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:27:10 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 4A78DC3F94
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 19:27:07 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7DEB2D67D1
	for <nvdimm@lists.linux.dev>; Fri,  2 Jun 2023 19:27:06 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id A65F4E4AA6;
	Fri,  2 Jun 2023 19:27:05 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: kexec@lists.infradead.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	bhe@redhat.com,
	ruansy.fnst@fujitsu.com,
	y-goto@fujitsu.com,
	yangx.jy@fujitsu.com,
	Li Zhijian <lizhijian@fujitsu.com>,
	Eric Biederman <ebiederm@xmission.com>
Subject: [RFC PATCH v3 3/3] kernel/kexec_file: Mark pmem region with new flag PF_DEV
Date: Fri,  2 Jun 2023 18:26:52 +0800
Message-Id: <20230602102656.131654-4-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230602102656.131654-1-lizhijian@fujitsu.com>
References: <20230602102656.131654-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27666.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27666.006
X-TMASE-Result: 10--6.493600-10.000000
X-TMASE-MatchedRID: 9KRLfRi0EIdXk4HjwySOxx1kSRHxj+Z5W+HVwTKSJIbfghYDxv+lXYyt
	cTfY0Fk5Fcbst+g5Co4SHwgOjzzIf6GGOyqBK41vEXjPIvKd74BMkOX0UoduubgbJOZ434BsXMi
	+6Pt1uebPz9CYF+mMT7BRAkACNnr7lwV2iaAfSWcURSScn+QSXhhJCIHRlO51+gtHj7OwNO0kL2
	NLniq3NW48jxF4hJknuYLQT0SIw8Y4aBTofN3FK6vjRgCarhn/
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

For pmem, metadata is specific to the namespace rather than the entire
pmem region. Therefore, ranges that have not yet created a namespace or
are unusable due to alignment reasons will not be associated with metadata.

When an application attempts to access regions that do not have
corresponding metadata, it will encounter an access error. With this flag,
the dumping applications are able to know this access error, and then
take special actions correspondingly.

This is kexec_file_load() specific, for the traditional kexec_load(),
kexec-tools will have a similar change.

CC: Eric Biederman <ebiederm@xmission.com>
CC: Baoquan He <bhe@redhat.com>
CC: kexec@lists.infradead.org
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 kernel/kexec_file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f989f5f1933b..0d5b516b96ee 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -29,6 +29,8 @@
 #include <linux/vmalloc.h>
 #include "kexec_internal.h"
 
+#define PF_DEV (1 << 4)
+
 #ifdef CONFIG_KEXEC_SIG
 static bool sig_enforce = IS_ENABLED(CONFIG_KEXEC_SIG_FORCE);
 
@@ -1221,6 +1223,12 @@ int crash_exclude_mem_range(struct crash_mem *mem,
 	return 0;
 }
 
+static bool is_pmem_range(u64 start, u64 size)
+{
+	return REGION_INTERSECTS == region_intersects(start, size,
+			IORESOURCE_MEM, IORES_DESC_PERSISTENT_MEMORY);
+}
+
 int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 			  void **addr, unsigned long *sz)
 {
@@ -1302,6 +1310,8 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 
 		phdr->p_type = PT_LOAD;
 		phdr->p_flags = PF_R|PF_W|PF_X;
+		if (is_pmem_range(mstart, mend - mstart))
+			phdr->p_flags |= PF_DEV;
 		phdr->p_offset  = mstart;
 
 		phdr->p_paddr = mstart;
-- 
2.29.2

