Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 440B221A00ADA
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 09:55:13 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 1/7] libnvdimm: passthru functions clear to send
Date: Thu, 29 Jun 2017 10:56:26 -0600
Message-Id: <4454f90ea68f67a04546d92b22901c20b540e99e.1498754314.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1498754314.git.jerry.hoemann@hpe.com>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1498754314.git.jerry.hoemann@hpe.com>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
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
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Have dsm functions called via the pass thru mechanism also
be checked against clear to send.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/nvdimm/bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index e9361bf..e16427d 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -907,6 +907,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	static char in_env[ND_CMD_MAX_ENVELOPE];
 	const struct nd_cmd_desc *desc = NULL;
 	unsigned int cmd = _IOC_NR(ioctl_cmd);
+	unsigned int func = cmd;
 	void __user *p = (void __user *) arg;
 	struct device *dev = &nvdimm_bus->dev;
 	struct nd_cmd_pkg pkg;
@@ -972,6 +973,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	if (cmd == ND_CMD_CALL) {
+		func = pkg.nd_command;
 		dev_dbg(dev, "%s:%s, idx: %llu, in: %zu, out: %zu, len %zu\n",
 				__func__, dimm_name, pkg.nd_command,
 				in_len, out_len, buf_len);
@@ -1020,7 +1022,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	nvdimm_bus_lock(&nvdimm_bus->dev);
-	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, cmd, buf);
+	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
 	if (rc)
 		goto out_unlock;
 
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
