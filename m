Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F20781FF8
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 16:01:41 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2] nfit: Fix extended status translations for ACPI DSMs
Date: Mon,  5 Dec 2016 17:00:37 -0700
Message-Id: <1480982437-11567-1-git-send-email-vishal.l.verma@intel.com>
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

Return from each command's 'case' once we have verified both its status
and extend status are good.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 71a7d07..60acbb1 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -113,7 +113,7 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
 		flags = ND_ARS_PERSISTENT | ND_ARS_VOLATILE;
 		if ((status >> 16 & flags) == 0)
 			return -ENOTTY;
-		break;
+		return 0;
 	case ND_CMD_ARS_START:
 		/* ARS is in progress */
 		if ((status & 0xffff) == NFIT_ARS_START_BUSY)
@@ -122,7 +122,7 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
 		/* Command failed */
 		if (status & 0xffff)
 			return -EIO;
-		break;
+		return 0;
 	case ND_CMD_ARS_STATUS:
 		ars_status = buf;
 		/* Command failed */
@@ -154,7 +154,7 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
 		/* Unknown status */
 		if (status >> 16)
 			return -EIO;
-		break;
+		return 0;
 	case ND_CMD_CLEAR_ERROR:
 		clear_err = buf;
 		if (status & 0xffff)
@@ -163,7 +163,7 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
 			return -EIO;
 		if (clear_err->length > clear_err->cleared)
 			return clear_err->cleared;
-		break;
+		return 0;
 	default:
 		break;
 	}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
