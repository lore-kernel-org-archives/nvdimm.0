Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4620.austin.hp.com (g2t4620.austin.hp.com [15.73.212.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D07EE1A1FEB
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 12:37:56 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v8 08/10] nvdimm: command ioctl support
Date: Mon, 21 Mar 2016 13:37:08 -0600
Message-Id: <ab6f389579b1cac1be56983488a62086d7fc31bb.1458583367.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
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

Flags to indicate if object supports the full set of ND_IOCTL
commands (lack indicates just the pass thru.)

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit.h      | 1 +
 drivers/nvdimm/nd-core.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 10dd0d3..bf353fa 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -115,6 +115,7 @@ struct nfit_mem {
 	struct acpi_device *adev;
 	unsigned long dsm_mask;
 	const u8 *dsm_uuid;
+	int    cmd_ioctl;
 };
 
 struct acpi_nfit_desc {
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1d1500f..0933f66 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -38,6 +38,7 @@ struct nvdimm {
 	unsigned long flags;
 	void *provider_data;
 	unsigned long *dsm_mask;
+	int cmd_ioctl;
 	struct device dev;
 	atomic_t busy;
 	int id;
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
