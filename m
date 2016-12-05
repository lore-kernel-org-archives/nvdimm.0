Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD2A981FE6
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 13:28:37 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] nfit: Fix extended status translations for ACPI DSMs
Date: Mon,  5 Dec 2016 14:27:26 -0700
Message-Id: <1480973246-32078-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI DSMs can have an 'extended' status which can be non-zero to convey
additional information about the command. In the xlat_status routine,
where we translate the command statuses, we were returning an error for
a non-zero extended status, even if the primary status indicated success.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 71a7d07..d14f09b 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -169,7 +169,7 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
 	}
 
 	/* all other non-zero status results in an error */
-	if (status)
+	if (status & 0xffff)
 		return -EIO;
 	return 0;
 }
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
