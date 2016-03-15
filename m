Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4619.austin.hp.com (g2t4619.austin.hp.com [15.73.212.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94C541A1E91
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 14:32:41 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v7 5/7] libnvdimm: advertise 'call_dsm' support
Date: Tue, 15 Mar 2016 15:32:14 -0600
Message-Id: <5731be3c82134d47a485ca7def099030c29decd1.1458076114.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
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

Indicate to userspace that the generic 'dsm_call' capability is
available for the given control device.  Over time we want to deprecate
the per-dsm function ioctl commands and direct everything through the
generic envelope.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/nvdimm/core.c      | 3 +++
 drivers/nvdimm/dimm_devs.c | 8 +++++++-
 include/linux/libnvdimm.h  | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 79646d0..9b395e5 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -253,6 +253,9 @@ static ssize_t commands_show(struct device *dev,
 
 	for_each_set_bit(cmd, &nd_desc->dsm_mask, BITS_PER_LONG)
 		len += sprintf(buf + len, "%s ", nvdimm_bus_cmd_name(cmd));
+	if (nd_desc->call_dsm)
+		len += sprintf(buf + len, "%s ",
+				nvdimm_bus_cmd_name(ND_CMD_CALL));
 	len += sprintf(buf + len, "\n");
 	return len;
 }
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c56f882..89086d6 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -274,14 +274,20 @@ EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus_descriptor *nd_desc;
 	int cmd, len = 0;
 
-	if (!nvdimm->dsm_mask)
+	if (!nvdimm->dsm_mask || !nvdimm_bus)
 		return sprintf(buf, "\n");
 
 	for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
 		len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
+	nd_desc = nvdimm_bus->nd_desc;
+	if (nd_desc->call_dsm)
+		len += sprintf(buf + len, "%s ",
+				nvdimm_cmd_name(ND_CMD_CALL));
 	len += sprintf(buf + len, "\n");
 	return len;
 }
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index af31d1c..458db57 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -68,6 +68,7 @@ struct nd_mapping {
 
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
+	unsigned int call_dsm:1;
 	unsigned long dsm_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
