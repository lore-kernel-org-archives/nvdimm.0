Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09C8421951C94
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 02:16:05 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id g23so8067724pfj.1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 02:16:05 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] nvdimm: Export supported alignments via sysfs
Date: Thu, 27 Apr 2017 19:15:52 +1000
Message-Id: <20170427091552.17694-1-oohall@gmail.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Adds two new sysfs attributes for pfn (and dax) devices:
supported_alignements and default_alignment. These advertise to
userspace what alignments this kernel supports, and provides a nominal
default alignment to use.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
I'm not sure it makes sense to provide these for pfn devices. In the dax
case we have hard restrictions because of how fault handling works, but
I'm not convinced this makes sense for the pfn case since it's going to
be used with fs-dax.
---
 drivers/nvdimm/pfn_devs.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 6c033c9a2f06..5157e7d89f0b 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -260,6 +260,30 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t supported_alignments_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	/* Fun fact: These aren't always constants! */
+	unsigned long supported_alignments[] = {
+		PAGE_SIZE,
+		HPAGE_PMD_SIZE,
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+		HPAGE_PUD_SIZE,
+#endif
+		0,
+	};
+
+	return nd_sector_size_show(0, supported_alignments, buf);
+}
+DEVICE_ATTR_RO(supported_alignments);
+
+static ssize_t default_alignment_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%ld\n", HPAGE_PMD_SIZE);
+}
+DEVICE_ATTR_RO(default_alignment);
+
 static struct attribute *nd_pfn_attributes[] = {
 	&dev_attr_mode.attr,
 	&dev_attr_namespace.attr,
@@ -267,6 +291,8 @@ static struct attribute *nd_pfn_attributes[] = {
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
+	&dev_attr_supported_alignments.attr,
+	&dev_attr_default_alignment.attr,
 	NULL,
 };
 
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
