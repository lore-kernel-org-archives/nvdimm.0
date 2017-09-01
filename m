Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87E0D20958BE8
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 17:37:01 -0700 (PDT)
Subject: [PATCH] libnvdimm: fix integer overflow static analysis warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 17:33:20 -0700
Message-ID: <150422600081.8459.2869511055414536668.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dan reports:
    The patch 62232e45f4a2: "libnvdimm: control (ioctl) messages for
    nvdimm_bus and nvdimm devices" from Jun 8, 2015, leads to the
    following static checker warning:

            drivers/nvdimm/bus.c:1018 __nd_ioctl()
            warn: integer overflows 'buf_len'

    From a casual review, this seems like it might be a real bug.  On
    the first iteration we load some data into in_env[].  On the second
    iteration we read a use controlled "in_size" from nd_cmd_in_size().
    It can go up to UINT_MAX - 1.  A high number means we will fill the
    whole in_env[] buffer.  But we potentially keep looping and adding
    more to in_len so now it can be any value.

    It simple enough to change, but it feels weird that we keep looping
    even though in_env is totally full.  Shouldn't we just return an
    error if we don't have space for desc->in_num.

We keep looping because the size of the total input is allowed to be
bigger than the 'envelope' which is a subset of the payload that tells
us how much data to expect. For safety explicitly check that buf_len
does not overflow which is what the checker flagged.

Cc: <stable@vger.kernel.org>
Fixes: 62232e45f4a2: "libnvdimm: control (ioctl) messages for nvdimm_bus..."
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a18c2914f4b6..66586ce23f1b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -911,19 +911,20 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		int read_only, unsigned int ioctl_cmd, unsigned long arg)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
-	size_t buf_len = 0, in_len = 0, out_len = 0;
 	static char out_env[ND_CMD_MAX_ENVELOPE];
 	static char in_env[ND_CMD_MAX_ENVELOPE];
 	const struct nd_cmd_desc *desc = NULL;
 	unsigned int cmd = _IOC_NR(ioctl_cmd);
-	unsigned int func = cmd;
-	void __user *p = (void __user *) arg;
 	struct device *dev = &nvdimm_bus->dev;
-	struct nd_cmd_pkg pkg;
+	void __user *p = (void __user *) arg;
 	const char *cmd_name, *dimm_name;
+	u32 in_len = 0, out_len = 0;
+	unsigned int func = cmd;
 	unsigned long cmd_mask;
-	void *buf;
+	struct nd_cmd_pkg pkg;
 	int rc, i, cmd_rc;
+	u64 buf_len = 0;
+	void *buf;
 
 	if (nvdimm) {
 		desc = nd_cmd_dimm_desc(cmd);
@@ -983,7 +984,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 
 	if (cmd == ND_CMD_CALL) {
 		func = pkg.nd_command;
-		dev_dbg(dev, "%s:%s, idx: %llu, in: %zu, out: %zu, len %zu\n",
+		dev_dbg(dev, "%s:%s, idx: %llu, in: %u, out: %u, len %llu\n",
 				__func__, dimm_name, pkg.nd_command,
 				in_len, out_len, buf_len);
 
@@ -1013,9 +1014,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		out_len += out_size;
 	}
 
-	buf_len = out_len + in_len;
+	buf_len = (u64) out_len + (u64) in_len;
 	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
-		dev_dbg(dev, "%s:%s cmd: %s buf_len: %zu > %d\n", __func__,
+		dev_dbg(dev, "%s:%s cmd: %s buf_len: %llu > %d\n", __func__,
 				dimm_name, cmd_name, buf_len,
 				ND_IOCTL_MAX_BUFLEN);
 		return -EINVAL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
