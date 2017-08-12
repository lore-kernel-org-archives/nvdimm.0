Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C60FC21E2571D
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 22:16:30 -0700 (PDT)
Subject: [PATCH 2/3] libnvdimm, pfn,
 dax: show supported dax/pfn region alignments in sysfs
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 22:12:27 -0700
Message-ID: <150251474784.11236.9077158081550562491.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Oliver O'Halloran <oohall@gmail.com>

The alignment of a DAX and PFN regions dictates the page sizes that can
be used to map the region. Even if the hardware page sizes are known the
actual range of supported page sizes that can be used with DAX depends
on the kernel configuration. As a result it's best that the kernel
advertises the alignments that should be used with these region types.

This patch adds the 'supported_alignments' region attribute to expose
this information to userspace.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
[djbw: integrate with nd_size_select_show() rename and other fixups]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 2ae9a000b090..610dd17a17f6 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -111,6 +111,26 @@ static ssize_t align_show(struct device *dev,
 	return sprintf(buf, "%ld\n", nd_pfn->align);
 }
 
+static const unsigned long *nd_pfn_supported_alignments(void)
+{
+	/*
+	 * This needs to be a local variable because the *_SIZE macros
+	 * aren't always constants.
+	 */
+	static const unsigned long supported_alignments[] = {
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
+	return supported_alignments;
+}
+
 static ssize_t __align_store(struct nd_pfn *nd_pfn, const char *buf)
 {
 	unsigned long val;
@@ -260,6 +280,13 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t supported_alignments_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return nd_size_select_show(0, nd_pfn_supported_alignments(), buf);
+}
+static DEVICE_ATTR_RO(supported_alignments);
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
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
