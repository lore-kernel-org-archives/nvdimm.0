Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4621.austin.hp.com (g2t4621.austin.hp.com [15.73.212.80])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D3D41A1FD3
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 13:56:12 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v8 10/10] nvdimm: Add ioctl to return command mask.
Date: Mon, 21 Mar 2016 14:55:35 -0600
Message-Id: <78a0789b5d390c53e95018f8038b7df00cc326ba.1458583367.git.jerry.hoemann@hpe.com>
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

The pass thru calls return command mask.  Previously, bit zero
wasn't part of command mask, but as it is now, this left commands_show
displaying "unknown" for function zero.  Add an ioctl interface
to return command mask.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/nvdimm/bus.c       | 10 ++++++++--
 include/uapi/linux/ndctl.h |  9 +++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index dcfcd8e..a61f069 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -404,7 +404,10 @@ void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)
 }
 
 static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
-	[ND_CMD_IMPLEMENTED] = { },
+	[ND_CMD_IMPLEMENTED] = {
+		.out_num = 1,
+		.out_sizes = { 8, },
+	},
 	[ND_CMD_SMART] = {
 		.out_num = 2,
 		.out_sizes = { 4, 8, },
@@ -456,7 +459,10 @@ const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd)
 EXPORT_SYMBOL_GPL(nd_cmd_dimm_desc);
 
 static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
-	[ND_CMD_IMPLEMENTED] = { },
+	[ND_CMD_IMPLEMENTED] = {
+		.out_num = 1,
+		.out_sizes = { 1, },
+	},
 	[ND_CMD_ARS_CAP] = {
 		.in_num = 2,
 		.in_sizes = { 8, 8, },
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index c043cd1..cae7c34 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -20,6 +20,10 @@ struct nd_cmd_smart {
 	__u8 data[128];
 } __packed;
 
+struct nd_cmd_mask {
+	__u8 data[8];
+} __packed;
+
 struct nd_cmd_smart_threshold {
 	__u32 status;
 	__u8 data[8];
@@ -137,6 +141,7 @@ enum {
 static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 {
 	static const char * const names[] = {
+		[ND_CMD_IMPLEMENTED] = "cmd_mask",
 		[ND_CMD_ARS_CAP] = "ars_cap",
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
@@ -152,6 +157,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 static inline const char *nvdimm_cmd_name(unsigned cmd)
 {
 	static const char * const names[] = {
+		[ND_CMD_IMPLEMENTED] = "cmd_mask",
 		[ND_CMD_SMART] = "smart",
 		[ND_CMD_SMART_THRESHOLD] = "smart_thresh",
 		[ND_CMD_DIMM_FLAGS] = "flags",
@@ -171,6 +177,9 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 
 #define ND_IOCTL 'N'
 
+#define ND_IOCTL_CMD_MASK		_IOWR(ND_IOCTL, ND_CMD_IMPLEMENTED,\
+					struct nd_cmd_mask)
+
 #define ND_IOCTL_SMART			_IOWR(ND_IOCTL, ND_CMD_SMART,\
 					struct nd_cmd_smart)
 
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
