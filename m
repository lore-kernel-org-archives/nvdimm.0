Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8A912261815F
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 15:49:10 -0700 (PDT)
Subject: [PATCH 1/5] libnvdimm, dimm: handle EACCES failures from label reads
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 15:39:14 -0700
Message-ID: <152339995442.16061.14476943382736126807.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The new support for the standard _LSR and _LSW methods neglected to also
update the nvdimm_init_config_data() and nvdimm_set_config_data() to
return the translated error code from failed commands. This precision is
necessary because the locked status that was previously returned on
ND_CMD_GET_CONFIG_SIZE commands is now returned on
ND_CMD_{GET,SET}_CONFIG_DATA commands.

If the kernel misses this indication it can inadvertently fall back to
label-less mode when it should otherwise avoid all access to locked
regions.

Cc: <stable@vger.kernel.org>
Fixes: 4b27db7e26cd ("acpi, nfit: add support for the _LSI, _LSR, and...")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e00d45522b80..8d348b22ba45 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -88,9 +88,9 @@ int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd)
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 {
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+	int rc = validate_dimm(ndd), cmd_rc = 0;
 	struct nd_cmd_get_config_data_hdr *cmd;
 	struct nvdimm_bus_descriptor *nd_desc;
-	int rc = validate_dimm(ndd);
 	u32 max_cmd_size, config_size;
 	size_t offset;
 
@@ -124,9 +124,11 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 		cmd->in_offset = offset;
 		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
 				ND_CMD_GET_CONFIG_DATA, cmd,
-				cmd->in_length + sizeof(*cmd), NULL);
-		if (rc || cmd->status) {
-			rc = -ENXIO;
+				cmd->in_length + sizeof(*cmd), &cmd_rc);
+		if (rc < 0)
+			break;
+		if (cmd_rc < 0) {
+			rc = cmd_rc;
 			break;
 		}
 		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
@@ -140,9 +142,9 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len)
 {
-	int rc = validate_dimm(ndd);
 	size_t max_cmd_size, buf_offset;
 	struct nd_cmd_set_config_hdr *cmd;
+	int rc = validate_dimm(ndd), cmd_rc = 0;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 
@@ -164,7 +166,6 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 	for (buf_offset = 0; len; len -= cmd->in_length,
 			buf_offset += cmd->in_length) {
 		size_t cmd_size;
-		u32 *status;
 
 		cmd->in_offset = offset + buf_offset;
 		cmd->in_length = min(max_cmd_size, len);
@@ -172,12 +173,13 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 
 		/* status is output in the last 4-bytes of the command buffer */
 		cmd_size = sizeof(*cmd) + cmd->in_length + sizeof(u32);
-		status = ((void *) cmd) + cmd_size - sizeof(u32);
 
 		rc = nd_desc->ndctl(nd_desc, to_nvdimm(ndd->dev),
-				ND_CMD_SET_CONFIG_DATA, cmd, cmd_size, NULL);
-		if (rc || *status) {
-			rc = rc ? rc : -ENXIO;
+				ND_CMD_SET_CONFIG_DATA, cmd, cmd_size, &cmd_rc);
+		if (rc < 0)
+			break;
+		if (cmd_rc < 0) {
+			rc = cmd_rc;
 			break;
 		}
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
