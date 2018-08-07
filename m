Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x244.google.com (mail-qk0-x244.google.com
 [IPv6:2607:f8b0:400d:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67754210DBE87
 for <linux-nvdimm@lists.01.org>; Mon,  6 Aug 2018 23:15:46 -0700 (PDT)
Received: by mail-qk0-x244.google.com with SMTP id z74-v6so10639105qkb.10
 for <linux-nvdimm@lists.01.org>; Mon, 06 Aug 2018 23:15:46 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH] ACPI: nfit: adjust annotation for why return 0 if fail to
 find NFIT at startup
Date: Tue,  7 Aug 2018 02:15:31 -0400
Message-Id: <1533622531-3617-1-git-send-email-oceanhehy@gmail.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, rjw@rjwysocki.net, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

Add detail explanation why it's ok to return 0 if fail to find NFIT at
startup, refer to chapter 9.20.2 NVDIMM Root Device in ACPI 6.2 spec.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
v1: https://lists.01.org/pipermail/linux-nvdimm/2018-August/017311.html 
v2: Per Vishal's comments of v1, it turns out that it's right to keep 
"return 0" if NFIT not found at boot time. This v2 adjust annotation
to avoid misunderstanding of "return 0".

 drivers/acpi/nfit/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7c47900..1b982fe 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3353,7 +3353,13 @@ static int acpi_nfit_add(struct acpi_device *adev)
 
 	status = acpi_get_table(ACPI_SIG_NFIT, 0, &tbl);
 	if (ACPI_FAILURE(status)) {
-		/* This is ok, we could have an nvdimm hotplugged later */
+		/* The NVDIMM root device allows OS to trigger enumeration of
+		 * NVDIMMs through NFIT at boot time and re-enumeration at
+		 * root level via the _FIT method during runtime.
+		 * This is ok to return 0 here, we could have an nvdimm
+		 * hotplugged later and evaluate _FIT method which returns
+		 * data in the format of a series of NFIT Structures.
+		 */
 		dev_dbg(dev, "failed to find NFIT at startup\n");
 		return 0;
 	}
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
