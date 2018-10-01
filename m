Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 311B121159C98
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 14:25:53 -0700 (PDT)
Subject: [PATCH v2] libnvdimm, dimm: Maximize label transfer size
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 Oct 2018 14:14:01 -0700
Message-ID: <153842839852.2679462.16816747305002065908.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Use kvzalloc() to bypass the arbitrary PAGE_SIZE limit of label transfer
operations. Given the expense of calling into firmware, maximize the
amount of label data we transfer per call to be up to the total label
space if allowed by the firmware, or 256K whichever is smaller.

Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v2:
* clamp the max allocation size at 256K in case large label areas with
  unlimited transfer sizes appear in the future.

 drivers/nvdimm/dimm_devs.c       |   14 ++++++++------
 tools/testing/nvdimm/test/nfit.c |    2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 863cabc35215..3616e2e47788 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -111,8 +111,9 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 	if (!ndd->data)
 		return -ENOMEM;
 
-	max_cmd_size = min_t(u32, PAGE_SIZE, ndd->nsarea.max_xfer);
-	cmd = kzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
+	max_cmd_size = min_t(u32, ndd->nsarea.config_size, SZ_256K);
+	max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
+	cmd = kvzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -134,7 +135,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
 	}
 	dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
-	kfree(cmd);
+	kvfree(cmd);
 
 	return rc;
 }
@@ -157,9 +158,10 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 	if (offset + len > ndd->nsarea.config_size)
 		return -ENXIO;
 
-	max_cmd_size = min_t(u32, PAGE_SIZE, len);
+	max_cmd_size = min_t(u32, ndd->nsarea.config_size, SZ_256K);
 	max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
-	cmd = kzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
+	max_cmd_size = min_t(u32, max_cmd_size, len);
+	cmd = kvzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -183,7 +185,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 			break;
 		}
 	}
-	kfree(cmd);
+	kvfree(cmd);
 
 	return rc;
 }
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index cffc2c5a778d..caa58d8533f5 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -448,7 +448,7 @@ static int nfit_test_cmd_get_config_size(struct nd_cmd_get_config_size *nd_cmd,
 
 	nd_cmd->status = 0;
 	nd_cmd->config_size = LABEL_SIZE;
-	nd_cmd->max_xfer = SZ_4K;
+	nd_cmd->max_xfer = LABEL_SIZE;
 
 	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
