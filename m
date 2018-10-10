Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D91E721164C42
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:38:25 -0700 (PDT)
Subject: [nvdimm PATCH 1/6] libnvdimm, dimm: Maximize label transfer size
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 10 Oct 2018 16:38:24 -0700
Message-ID: <20181010233621.12228.61818.stgit@localhost.localdomain>
In-Reply-To: <20181010233428.12228.26106.stgit@localhost.localdomain>
References: <20181010233428.12228.26106.stgit@localhost.localdomain>
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
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org
Cc: alexander.h.duyck@linux.intel.com, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

Use kvzalloc() to bypass the arbitrary PAGE_SIZE limit of label transfer
operations. Given the expense of calling into firmware, maximize the
amount of label data we transfer per call to be up to the total label
space if allowed by the firmware.

Instead of limiting based on PAGE_SIZE we can instead simply limit the
maximum size based on either the config_size int he case of the get
operation, or the length of the write based on the set operation.

On a system with 24 NVDIMM modules each with a config_size of 128K and a
maximum transfer size of 64K - 4, this patch reduces the init time for the
label data from around 24 seconds down to between 4-5 seconds.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---

I think I only did a few minor tweaks on this so I thought I would leave
Dan as the author and just add my Signed-off-by.

 drivers/nvdimm/dimm_devs.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 863cabc35215..75ac78017b15 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -111,8 +111,8 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 	if (!ndd->data)
 		return -ENOMEM;
 
-	max_cmd_size = min_t(u32, PAGE_SIZE, ndd->nsarea.max_xfer);
-	cmd = kzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
+	max_cmd_size = min_t(u32, ndd->nsarea.config_size, ndd->nsarea.max_xfer);
+	cmd = kvzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -134,7 +134,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
 	}
 	dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
-	kfree(cmd);
+	kvfree(cmd);
 
 	return rc;
 }
@@ -157,9 +157,8 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 	if (offset + len > ndd->nsarea.config_size)
 		return -ENXIO;
 
-	max_cmd_size = min_t(u32, PAGE_SIZE, len);
-	max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
-	cmd = kzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
+	max_cmd_size = min_t(u32, len, ndd->nsarea.max_xfer);
+	cmd = kvzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
@@ -183,7 +182,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 			break;
 		}
 	}
-	kfree(cmd);
+	kvfree(cmd);
 
 	return rc;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
