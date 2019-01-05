Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
 by ml01.01.org (Postfix) with ESMTP id B5C98211A45AB
 for <linux-nvdimm@lists.01.org>; Sat,  5 Jan 2019 00:09:15 -0800 (PST)
From: Xiaochun Lee <lixiaochun.2888@163.com>
Subject: [PATCH] ACPI/nfit: delete the function to_acpi_nfit_desc
Date: Sat,  5 Jan 2019 16:08:38 +0800
Message-Id: <1546675718-31174-2-git-send-email-lixiaochun.2888@163.com>
In-Reply-To: <1546675718-31174-1-git-send-email-lixiaochun.2888@163.com>
References: <1546675718-31174-1-git-send-email-lixiaochun.2888@163.com>
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
To: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org, Xiaochun Lee <lixc17@lenovo.com>, zwisler@kernel.org, lenb@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Xiaochun Lee <lixc17@lenovo.com>

The function to_acpi_nfit_desc and function to_acpi_desc
do the same things,delete the function to_acpi_nfit_desc,
and keep the inline function to_acpi_desc.

Signed-off-by: Xiaochun Lee <lixc17@lenovo.com>
---
 drivers/acpi/nfit/core.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 011d3db..8f09410 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -78,12 +78,6 @@ const guid_t *to_nfit_uuid(enum nfit_uuids id)
 }
 EXPORT_SYMBOL(to_nfit_uuid);
 
-static struct acpi_nfit_desc *to_acpi_nfit_desc(
-		struct nvdimm_bus_descriptor *nd_desc)
-{
-	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
-}
-
 static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
@@ -419,7 +413,7 @@ static bool payload_dumpable(struct nvdimm *nvdimm, unsigned int func)
 int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
-	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	union acpi_object in_obj, in_buf, *out_obj;
 	const struct nd_cmd_desc *desc = NULL;
@@ -3367,7 +3361,7 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 
 static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 {
-	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct device *dev = acpi_desc->dev;
 
 	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
@@ -3384,7 +3378,7 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 static int __acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd)
 {
-	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 
 	if (nvdimm)
 		return 0;
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
