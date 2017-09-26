Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FA6721F322B4
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 16:00:37 -0700 (PDT)
Subject: [PATCH 3/3] libnvdimm,
 pfn: make 'resource' attribute only readable by root
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 15:57:26 -0700
Message-ID: <150646664593.6588.2636887097527637750.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For the same reason that /proc/iomem returns 0's for non-root readers
and acpi tables are root-only, make the 'resource' attribute for pfn
devices only readable by root. Otherwise we disclose physical address
information.

Fixes: f6ed58c70d14 ("libnvdimm, pfn: 'resource'-address and 'size'...")
Cc: <stable@vger.kernel.org>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 9576c444f0ab..65cc171c721d 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -282,8 +282,16 @@ static struct attribute *nd_pfn_attributes[] = {
 	NULL,
 };
 
+static umode_t pfn_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	if (a == &dev_attr_resource.attr)
+		return 0400;
+	return a->mode;
+}
+
 struct attribute_group nd_pfn_attribute_group = {
 	.attrs = nd_pfn_attributes,
+	.is_visible = pfn_visible,
 };
 
 static const struct attribute_group *nd_pfn_attribute_groups[] = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
