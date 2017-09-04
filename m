Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.gtisc.gatech.edu (mx2.gtisc.gatech.edu [143.215.130.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CB1121E3EA72
 for <linux-nvdimm@lists.01.org>; Mon,  4 Sep 2017 08:32:14 -0700 (PDT)
From: Meng Xu <mengxu.gatech@gmail.com>
Subject: [PATCH] nvdimm: move the check on nd_reserved2 to the endpoint
Date: Mon,  4 Sep 2017 11:34:33 -0400
Message-Id: <1504539273-44522-1-git-send-email-mengxu.gatech@gmail.com>
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
To: dan.j.williams@intel.com, jerry.hoemann@hpe.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, meng.xu@gatech.edu, Meng Xu <mengxu.gatech@gmail.com>, sanidhya@gatech.edu
List-ID: <linux-nvdimm@lists.01.org>

This patch delays the check of nd_reserved2 to the actual endpoint
(acpi_nfit_ctl) that uses it, as a prevention of a potential
double-fetch bug.

Detailed discussion can be found at
https://marc.info/?l=linux-kernel&m=150421938113092&w=2

Signed-off-by: Meng Xu <mengxu.gatech@gmail.com>
---
 drivers/acpi/nfit/core.c | 4 ++++
 drivers/nvdimm/bus.c     | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 19182d0..694b1b1 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -228,6 +228,10 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd == ND_CMD_CALL) {
 		call_pkg = buf;
 		func = call_pkg->nd_command;
+
+		for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
+			if (call_pkg->nd_reserved2[i])
+				return -EINVAL;
 	}
 
 	if (nvdimm) {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 937fafa..0fb9adb 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -980,10 +980,6 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		dev_dbg(dev, "%s:%s, idx: %llu, in: %zu, out: %zu, len %zu\n",
 				__func__, dimm_name, pkg.nd_command,
 				in_len, out_len, buf_len);
-
-		for (i = 0; i < ARRAY_SIZE(pkg.nd_reserved2); i++)
-			if (pkg.nd_reserved2[i])
-				return -EINVAL;
 	}
 
 	/* process an output envelope */
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
