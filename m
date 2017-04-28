Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72AD521A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 14:34:56 -0700 (PDT)
Subject: [PATCH 2/3] virtio, rpmsg: switch to dynamic_hex_dump()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 14:29:04 -0700
Message-ID: <149341494418.35578.561981766577089185.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-acpi@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>
List-ID: <linux-nvdimm@lists.01.org>

Now that dynamic_hex_dump() has a fallback in the CONFIG_DYNAMIC_DEBUG=n
case we can kill the unnecessary ifdefs in the rpmsg driver.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 5e66e081027e..00d92b399ddd 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -599,10 +599,8 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 
 	dev_dbg(dev, "TX From 0x%x, To 0x%x, Len %d, Flags %d, Reserved %d\n",
 		msg->src, msg->dst, msg->len, msg->flags, msg->reserved);
-#if defined(CONFIG_DYNAMIC_DEBUG)
 	dynamic_hex_dump("rpmsg_virtio TX: ", DUMP_PREFIX_NONE, 16, 1,
 			 msg, sizeof(*msg) + msg->len, true);
-#endif
 
 	sg_init_one(&sg, msg, sizeof(*msg) + len);
 
@@ -687,10 +685,8 @@ static int rpmsg_recv_single(struct virtproc_info *vrp, struct device *dev,
 
 	dev_dbg(dev, "From: 0x%x, To: 0x%x, Len: %d, Flags: %d, Reserved: %d\n",
 		msg->src, msg->dst, msg->len, msg->flags, msg->reserved);
-#if defined(CONFIG_DYNAMIC_DEBUG)
 	dynamic_hex_dump("rpmsg_virtio RX: ", DUMP_PREFIX_NONE, 16, 1,
 			 msg, sizeof(*msg) + msg->len, true);
-#endif
 
 	/*
 	 * We currently use fixed-sized buffers, so trivially sanitize
@@ -801,10 +797,8 @@ static int rpmsg_ns_cb(struct rpmsg_device *rpdev, void *data, int len,
 	struct device *dev = &vrp->vdev->dev;
 	int ret;
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
 	dynamic_hex_dump("NS announcement: ", DUMP_PREFIX_NONE, 16, 1,
 			 data, len, true);
-#endif
 
 	if (len != sizeof(*msg)) {
 		dev_err(dev, "malformed ns msg (%d)\n", len);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
