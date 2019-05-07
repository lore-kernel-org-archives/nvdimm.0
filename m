Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B3C521253307
 for <linux-nvdimm@lists.01.org>; Mon,  6 May 2019 22:36:02 -0700 (PDT)
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 04/81] acpi/nfit: Always dump _DSM output payload
Date: Tue,  7 May 2019 01:34:35 -0400
Message-Id: <20190507053554.30848-4-sashal@kernel.org>
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 351f339faa308c1c1461314a18c832239a841ca0 ]

The dynamic-debug statements for command payload output only get emitted
when the command is not ND_CMD_CALL. Move the output payload dumping
ahead of the early return path for ND_CMD_CALL.

Fixes: 31eca76ba2fc9 ("...whitelisted dimm command marshaling mechanism")
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 925dbc751322..8340c81b258b 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -542,6 +542,12 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		goto out;
 	}
 
+	dev_dbg(dev, "%s cmd: %s output length: %d\n", dimm_name,
+			cmd_name, out_obj->buffer.length);
+	print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4, 4,
+			out_obj->buffer.pointer,
+			min_t(u32, 128, out_obj->buffer.length), true);
+
 	if (call_pkg) {
 		call_pkg->nd_fw_size = out_obj->buffer.length;
 		memcpy(call_pkg->nd_payload + call_pkg->nd_size_in,
@@ -560,12 +566,6 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		return 0;
 	}
 
-	dev_dbg(dev, "%s cmd: %s output length: %d\n", dimm_name,
-			cmd_name, out_obj->buffer.length);
-	print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4, 4,
-			out_obj->buffer.pointer,
-			min_t(u32, 128, out_obj->buffer.length), true);
-
 	for (i = 0, offset = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,
 				(u32 *) out_obj->buffer.pointer,
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
