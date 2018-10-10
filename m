Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E3652116524A
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:39:21 -0700 (PDT)
Subject: [nvdimm PATCH 5/6] nvdimm: Split label init out from the logic for
 getting config data
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 10 Oct 2018 16:39:20 -0700
Message-ID: <20181010233911.12228.37721.stgit@localhost.localdomain>
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

This patch splits the initialization of the label data into two functions.
One for doing the init, and another for reading the actual configuration
data. The idea behind this is that by doing this we create a symmetry
between the getting and setting of config data in that we have a function
for both. In addition it will make it easier for us to identify the bits
that are related to init versus the pieces that are a wrapper for reading
data from the ACPI interface.

So for example by splitting things out like this it becomes much more
obvious that we were performing checks that weren't necessarily related to
the set/get operations such as relying on ndd->data being present when the
set and get ops should not care about a locally cached copy of the label
area.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/dimm.c      |    2 +-
 drivers/nvdimm/dimm_devs.c |   49 +++++++++++++++++---------------------------
 drivers/nvdimm/label.c     |   38 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/label.h     |    1 +
 drivers/nvdimm/nd.h        |    2 ++
 5 files changed, 61 insertions(+), 31 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 6c8fb7590838..07bf96948553 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -75,7 +75,7 @@ static int nvdimm_probe(struct device *dev)
 	 * DIMM capacity. We fail the dimm probe to prevent regions from
 	 * attempting to parse the label area.
 	 */
-	rc = nvdimm_init_config_data(ndd);
+	rc = nd_label_data_init(ndd);
 	if (rc == -EACCES)
 		nvdimm_set_locked(dev);
 	if (rc)
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 75ac78017b15..6c3de2317390 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -85,55 +85,47 @@ int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd)
 	return cmd_rc;
 }
 
-int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
+int nvdimm_get_config_data(struct nvdimm_drvdata *ndd, void *buf,
+			   size_t offset, size_t len)
 {
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 	int rc = validate_dimm(ndd), cmd_rc = 0;
 	struct nd_cmd_get_config_data_hdr *cmd;
-	struct nvdimm_bus_descriptor *nd_desc;
-	u32 max_cmd_size, config_size;
-	size_t offset;
+	size_t max_cmd_size, buf_offset;
 
 	if (rc)
 		return rc;
 
-	if (ndd->data)
-		return 0;
-
-	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0
-			|| ndd->nsarea.config_size < ND_LABEL_MIN_SIZE) {
-		dev_dbg(ndd->dev, "failed to init config data area: (%d:%d)\n",
-				ndd->nsarea.max_xfer, ndd->nsarea.config_size);
+	if (offset + len > ndd->nsarea.config_size)
 		return -ENXIO;
-	}
 
-	ndd->data = kvmalloc(ndd->nsarea.config_size, GFP_KERNEL);
-	if (!ndd->data)
-		return -ENOMEM;
-
-	max_cmd_size = min_t(u32, ndd->nsarea.config_size, ndd->nsarea.max_xfer);
+	max_cmd_size = min_t(u32, len, ndd->nsarea.max_xfer);
 	cmd = kvzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
-	nd_desc = nvdimm_bus->nd_desc;
-	for (config_size = ndd->nsarea.config_size, offset = 0;
-			config_size; config_size -= cmd->in_length,
-			offset += cmd->in_length) {
-		cmd->in_length = min(config_size, max_cmd_size);
-		cmd->in_offset = offset;
+	for (buf_offset = 0; len;
+	     len -= cmd->in_length, buf_offset += cmd->in_length) {
+		size_t cmd_size;
+
+		cmd->in_offset = offset + buf_offset;
+		cmd->in_length = min(max_cmd_size, len);
+
+		cmd_size = sizeof(*cmd) + cmd->in_length;
+
 		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
-				ND_CMD_GET_CONFIG_DATA, cmd,
-				cmd->in_length + sizeof(*cmd), &cmd_rc);
+				ND_CMD_GET_CONFIG_DATA, cmd, cmd_size, &cmd_rc);
 		if (rc < 0)
 			break;
 		if (cmd_rc < 0) {
 			rc = cmd_rc;
 			break;
 		}
-		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
+
+		/* out_buf should be valid, copy it into our output buffer */
+		memcpy(buf + buf_offset, cmd->out_buf, cmd->in_length);
 	}
-	dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
 	kvfree(cmd);
 
 	return rc;
@@ -151,9 +143,6 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 	if (rc)
 		return rc;
 
-	if (!ndd->data)
-		return -ENXIO;
-
 	if (offset + len > ndd->nsarea.config_size)
 		return -ENXIO;
 
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 43bad0d5bdb6..563f24af01b5 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -417,6 +417,44 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 	return 0;
 }
 
+int nd_label_data_init(struct nvdimm_drvdata *ndd)
+{
+	size_t config_size, read_size;
+	int rc = 0;
+
+	if (ndd->data)
+		return 0;
+
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0) {
+		dev_dbg(ndd->dev, "failed to init config data area: (%u:%u)\n",
+			ndd->nsarea.max_xfer, ndd->nsarea.config_size);
+		return -ENXIO;
+	}
+
+	/*
+	 * We need to determine the maximum index area as this is the section
+	 * we must read and validate before we can start processing labels.
+	 *
+	 * If the area is too small to contain the two indexes and 2 labels
+	 * then we abort.
+	 *
+	 * Start at a label size of 128 as this should result in the largest
+	 * possible namespace index size.
+	 */
+	ndd->nslabel_size = 128;
+	read_size = sizeof_namespace_index(ndd) * 2;
+	if (!read_size)
+		return -ENXIO;
+
+	/* Allocate config data */
+	config_size = ndd->nsarea.config_size;
+	ndd->data = kvzalloc(config_size, GFP_KERNEL);
+	if (!ndd->data)
+		return -ENOMEM;
+
+	return nvdimm_get_config_data(ndd, ndd->data, 0, config_size);
+}
+
 int nd_label_active_count(struct nvdimm_drvdata *ndd)
 {
 	struct nd_namespace_index *nsindex;
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 18bbe183b3a9..685afb3de0fe 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -141,6 +141,7 @@ static inline int nd_label_next_nsindex(int index)
 int nd_label_validate(struct nvdimm_drvdata *ndd);
 void nd_label_copy(struct nvdimm_drvdata *ndd, struct nd_namespace_index *dst,
 		struct nd_namespace_index *src);
+int nd_label_data_init(struct nvdimm_drvdata *ndd);
 size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
 int nd_label_active_count(struct nvdimm_drvdata *ndd);
 struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 98317e7ce5b5..e79cc8e5c114 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -241,6 +241,8 @@ ssize_t nd_size_select_store(struct device *dev, const char *buf,
 int nvdimm_check_config_data(struct device *dev);
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
+int nvdimm_get_config_data(struct nvdimm_drvdata *ndd, void *buf,
+			   size_t offset, size_t len);
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len);
 long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
