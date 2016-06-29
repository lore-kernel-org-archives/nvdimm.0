Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id B94371A1E1B
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 16:01:38 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] acpi, nfit: print command names instead of numbers
Date: Wed, 29 Jun 2016 17:00:30 -0600
Message-Id: <1467241230-15054-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

For the debug prints in acpi_nfit_ctl(), all the prints except the input
buffer dump printed the command name. Make this also do the same for
better readability.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 2215fc8..d35e3be 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -247,8 +247,8 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	}
 
 	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
-				__func__, dimm_name, cmd, func,
+		dev_dbg(dev, "%s:%s cmd: %s: func: %d input length: %d\n",
+				__func__, dimm_name, cmd_name, func,
 				in_buf.buffer.length);
 		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
 			in_buf.buffer.pointer,
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
