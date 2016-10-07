Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 256071A1E3C
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:00 -0700 (PDT)
Subject: [PATCH 03/14] libnvdimm,
 namespace: refactor uuid_show() into a namespace_to_uuid() helper
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:38:57 -0700
Message-ID: <147585833727.22349.4151646734474522098.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The ability to translate a generic struct device pointer into a
namespace uuid is a useful utility as we go to unify the blk and pmem
label scanning paths.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 9f4188c78120..0e62f46755e7 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1032,22 +1032,27 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR(size, S_IRUGO, size_show, size_store);
 
-static ssize_t uuid_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static u8 *namespace_to_uuid(struct device *dev)
 {
-	u8 *uuid;
-
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
-		uuid = nspm->uuid;
+		return nspm->uuid;
 	} else if (is_namespace_blk(dev)) {
 		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
 
-		uuid = nsblk->uuid;
+		return nsblk->uuid;
 	} else
-		return -ENXIO;
+		return ERR_PTR(-ENXIO);
+}
+
+static ssize_t uuid_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u8 *uuid = namespace_to_uuid(dev);
 
+	if (IS_ERR(uuid))
+		return PTR_ERR(uuid);
 	if (uuid)
 		return sprintf(buf, "%pUb\n", uuid);
 	return sprintf(buf, "\n");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
