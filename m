Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 797552095D225
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 02:54:55 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id e199so4082739pfh.0
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 02:56:25 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] libnvdimm: show supported dax/pfn region alignments in sysfs
Date: Tue, 27 Jun 2017 19:56:12 +1000
Message-Id: <20170627095612.6328-1-oohall@gmail.com>
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

The alignment of a DAX and PFN regions dictates the page sizes that can
be used to map the region. Even if the hardware page sizes are known the
actual range of supported page sizes that can be used with DAX depends
on the kernel configuration. As a result its best that the kernel
advertises the alignments that should be used with these region types.

This patch adds the 'supported_alignments' region attribute to expose
this information to userspace.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 drivers/nvdimm/pfn_devs.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 2ae9a000b090..505d50ef9a91 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -260,6 +260,33 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t supported_alignments_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	/*
+	 * This needs to be a local variable because the *_SIZE macros
+	 * aren't always constants.
+	 */
+	unsigned long supported_alignments[] = {
+		PAGE_SIZE,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		HPAGE_PMD_SIZE,
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+		HPAGE_PUD_SIZE,
+#endif
+#endif
+		0,
+	};
+
+	return nd_sector_size_show(0, supported_alignments, buf);
+}
+DEVICE_ATTR_RO(supported_alignments);
+
+static struct attribute *nd_dax_attributes[] = {
+	&dev_attr_supported_alignments.attr,
+	NULL,
+};
+
 static struct attribute *nd_pfn_attributes[] = {
 	&dev_attr_mode.attr,
 	&dev_attr_namespace.attr,
@@ -267,6 +294,7 @@ static struct attribute *nd_pfn_attributes[] = {
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
+	&dev_attr_supported_alignments.attr,
 	NULL,
 };
 
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
