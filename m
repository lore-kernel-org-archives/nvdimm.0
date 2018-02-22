Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2482020954CBF
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 11:52:17 -0800 (PST)
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/5] edac: Add new memory type for non-volatile DIMMs
Date: Thu, 22 Feb 2018 11:58:08 -0800
Message-Id: <20180222195811.27237-3-tony.luck@intel.com>
In-Reply-To: <20180222195811.27237-1-tony.luck@intel.com>
References: <20180222195811.27237-1-tony.luck@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Borislav Petkov <bp@suse.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

There are now non-volatile versions of DIMMs. Add a new entry to
"enum mem_type" and a new string in edac_mem_types[].

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/edac_mc.c | 3 ++-
 include/linux/edac.h   | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 1f61b736e075..3bb82e511eca 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -214,7 +214,8 @@ const char * const edac_mem_types[] = {
 	[MEM_RDDR3]	= "Registered-DDR3",
 	[MEM_LRDDR3]	= "Load-Reduced-DDR3-RAM",
 	[MEM_DDR4]	= "Unbuffered-DDR4",
-	[MEM_RDDR4]	= "Registered-DDR4"
+	[MEM_RDDR4]	= "Registered-DDR4",
+	[MEM_NVDIMM]	= "Non-volatile-RAM",
 };
 EXPORT_SYMBOL_GPL(edac_mem_types);
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index cd75c173fd00..bffb97828ed6 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -186,6 +186,7 @@ static inline char *mc_event_error_type(const unsigned int err_type)
  * @MEM_RDDR4:		Registered DDR4 RAM
  *			This is a variant of the DDR4 memories.
  * @MEM_LRDDR4:		Load-Reduced DDR4 memory.
+ * @MEM_NVDIMM:		Non-volatile RAM
  */
 enum mem_type {
 	MEM_EMPTY = 0,
@@ -209,6 +210,7 @@ enum mem_type {
 	MEM_DDR4,
 	MEM_RDDR4,
 	MEM_LRDDR4,
+	MEM_NVDIMM,
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -231,6 +233,7 @@ enum mem_type {
 #define MEM_FLAG_DDR4           BIT(MEM_DDR4)
 #define MEM_FLAG_RDDR4          BIT(MEM_RDDR4)
 #define MEM_FLAG_LRDDR4         BIT(MEM_LRDDR4)
+#define MEM_FLAG_NVDIMM         BIT(MEM_NVDIMM)
 
 /**
  * enum edac-type - Error Detection and Correction capabilities and mode
-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
