Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4619.austin.hp.com (g2t4619.austin.hp.com [15.73.212.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 83DF61A1F2D
 for <linux-nvdimm@lists.01.org>; Wed, 27 Apr 2016 15:46:53 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v10 3/7] tools/testing/nvdimm: 'call_dsm' support
Date: Wed, 27 Apr 2016 16:46:15 -0600
Message-Id: <8bb6211c43860a8653955becd4f67e83c28ea351.1461793650.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1461793650.git.jerry.hoemann@hpe.com>
References: <cover.1461793650.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1461793650.git.jerry.hoemann@hpe.com>
References: <cover.1461793650.git.jerry.hoemann@hpe.com>
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

Enable nfit_test to use the generic 'call_dsm' envelope.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 1d3b8ce..6c89811 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -336,12 +336,21 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nfit_test *t = container_of(acpi_desc, typeof(*t), acpi_desc);
+	unsigned int func = cmd;
 	int i, rc = 0, __cmd_rc;
 
 	if (!cmd_rc)
 		cmd_rc = &__cmd_rc;
 	*cmd_rc = 0;
 
+	if (cmd == ND_CMD_CALL) {
+		struct nd_cmd_pkg *pkg = buf;
+
+		buf_len = pkg->nd_size_in + pkg->nd_size_out;
+		buf = (void *) pkg->nd_payload;
+		func = pkg->nd_command;
+	}
+
 	if (nvdimm) {
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 
@@ -356,7 +365,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		if (i >= ARRAY_SIZE(handle))
 			return -ENXIO;
 
-		switch (cmd) {
+		switch (func) {
 		case ND_CMD_GET_CONFIG_SIZE:
 			rc = nfit_test_cmd_get_config_size(buf, buf_len);
 			break;
@@ -377,7 +386,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		if (!nd_desc || !test_bit(cmd, &nd_desc->cmd_mask))
 			return -ENOTTY;
 
-		switch (cmd) {
+		switch (func) {
 		case ND_CMD_ARS_CAP:
 			rc = nfit_test_cmd_ars_cap(buf, buf_len);
 			break;
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
