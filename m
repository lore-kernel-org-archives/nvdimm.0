Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4618.austin.hp.com (g2t4618.austin.hp.com [15.73.212.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1A0E1A1F86
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:17:02 -0800 (PST)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v6 4/8] nvdimm: Add UUIDs
Date: Fri, 11 Mar 2016 14:16:28 -0700
Message-Id: <7bf521fc82a9a29c11906db569b06085ac5d90c0.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add UUID associated with HPE Type N NVDIMM.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index c75576b..10dd0d3 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -23,6 +23,8 @@
 
 #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
 #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
+#define UUID_NFIT_DIMM_N_HPE1 "9002c334-acf3-4c0e-9642-a235f0d53bc6"
+#define UUID_NFIT_DIMM_N_HPE2 "5008664B-B758-41A0-A03C-27C2F2D04F7E"
 #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED)
@@ -38,6 +40,8 @@ enum nfit_uuids {
 	NFIT_SPA_PCD,
 	NFIT_DEV_BUS,
 	NFIT_DEV_DIMM,
+	NFIT_DEV_DIMM_N_HPE1,
+	NFIT_DEV_DIMM_N_HPE2,
 	NFIT_UUID_MAX,
 };
 
@@ -110,6 +114,7 @@ struct nfit_mem {
 	struct list_head list;
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
+	const u8 *dsm_uuid;
 };
 
 struct acpi_nfit_desc {
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
