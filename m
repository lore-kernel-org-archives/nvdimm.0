Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 253562095D215
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:50:32 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 4/7] acpi, nfit: Use bus_dsm_mask for passthru
Date: Tue, 20 Jun 2017 10:51:23 -0600
Message-Id: <d597b2ce2d394d9cae199d1b8209fbe66314c753.1497939166.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
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

Populate bus_dsm_mask and use it to filter dsm calls that user can
make through the pass thru interface.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/nfit/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index b46fca2..9d281a4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -253,6 +253,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		cmd_name = nvdimm_bus_cmd_name(cmd);
 		cmd_mask = nd_desc->cmd_mask;
 		dsm_mask = cmd_mask;
+		if (cmd == ND_CMD_CALL) dsm_mask = nd_desc->bus_dsm_mask;
 		desc = nd_cmd_bus_desc(cmd);
 		uuid = to_nfit_uuid(NFIT_DEV_BUS);
 		handle = adev->handle;
@@ -1624,6 +1625,9 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
 			set_bit(i, &nd_desc->cmd_mask);
 	set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
+	for (i = 0; i < ND_CMD_CALL; i++)
+		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &nd_desc->bus_dsm_mask);
 }
 
 static ssize_t range_index_show(struct device *dev,
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
