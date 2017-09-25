Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A072B20945BC8
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 13:53:37 -0700 (PDT)
Subject: [PATCH] libnvdimm: introduce 'flags' attribute for DIMM 'lock' and
 'alias' status
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Sep 2017 13:50:24 -0700
Message-ID: <150637262477.11427.4877320960461490551.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Given that we now how have two mechanisms for a DIMM to indicate that it
is locked:

    * NVDIMM_FAMILY_INTEL 'get_config_size' _DSM command

    * ACPI 6.2 Label Storage Read / Write commands

...export the generic libnvdimm DIMM status in a new 'flags' attribute.

This attribute can also reflect the 'alias' state which indicates
whether the nvdimm core is enforcing labels for aliased-region-capacity
that the given dimm is an interleave-set member.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 5f1385b96b13..097794d9f786 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -331,6 +331,17 @@ static ssize_t commands_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(commands);
 
+static ssize_t flags_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	return sprintf(buf, "%s%s\n",
+			test_bit(NDD_ALIASING, &nvdimm->flags) ? "alias " : "",
+			test_bit(NDD_LOCKED, &nvdimm->flags) ? "lock " : "");
+}
+static DEVICE_ATTR_RO(flags);
+
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -372,6 +383,7 @@ static DEVICE_ATTR_RO(available_slots);
 
 static struct attribute *nvdimm_attributes[] = {
 	&dev_attr_state.attr,
+	&dev_attr_flags.attr,
 	&dev_attr_commands.attr,
 	&dev_attr_available_slots.attr,
 	NULL,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
