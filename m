Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa4.dell-outbound.iphmx.com (esa4.dell-outbound.iphmx.com
 [68.232.149.214])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 998FD2034CF96
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 13:37:41 -0700 (PDT)
From: Lijun Pan <Lijun.Pan@dell.com>
Subject: [PATCH] acpi/nfit: export read_only attribute of dimms
Date: Mon, 30 Oct 2017 15:41:27 -0500
Message-Id: <20171030204127.4779-1-Lijun.Pan@dell.com>
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
To: linux-nvdimm@lists.01.org
Cc: Lijun Pan <Lijun.Pan@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

Though flags attribute provides enough information about
the dimm, it is nice to export the read_only attribute if
bit3 of NVDIMM state flag is set.
If error is injected by BIOS, bit3 and bit1 are both set.
If DIMM is set to read-only by BIOS, bit3 is set.
Hence bit3 is good enough to tell whether the dimm is in
read-only mode or not.

Signed-off-by: Lijun Pan <Lijun.Pan@dell.com>
---
 drivers/acpi/nfit/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ebe0857ac346..f96e65aa29dd 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1480,6 +1480,16 @@ static ssize_t flags_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(flags);
 
+static ssize_t read_only_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u16 flags = to_nfit_memdev(dev)->flags;
+
+	return sprintf(buf, "%d\n",
+		flags & ACPI_NFIT_MEM_NOT_ARMED ? 1 : 0);
+}
+static DEVICE_ATTR_RO(read_only);
+
 static ssize_t id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1512,6 +1522,7 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_format1.attr,
 	&dev_attr_serial.attr,
 	&dev_attr_flags.attr,
+	&dev_attr_read_only.attr,
 	&dev_attr_id.attr,
 	&dev_attr_family.attr,
 	&dev_attr_dsm_mask.attr,
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
