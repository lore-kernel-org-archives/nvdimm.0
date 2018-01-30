Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02920223648B5
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jan 2018 09:41:35 -0800 (PST)
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] libnvdimm,
 namespace: remove redundant initialization of 'nd_mapping'
Date: Tue, 30 Jan 2018 17:47:07 +0000
Message-Id: <20180130174707.4921-1-colin.king@canonical.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer nd_mapping is being initialized to a value that is never read,
instead it is being updated to a new value in all the cases where it
is being read afterwards, hence the initialization is redundant and
can be removed.

Cleans up clang warning:
drivers/nvdimm/namespace_devs.c:2411:21: warning: Value stored to
'nd_mapping' during its initialization is never rea

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index bb3ba8cf24d4..658ada497be0 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2408,7 +2408,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 static struct device **create_namespaces(struct nd_region *nd_region)
 {
-	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nd_mapping *nd_mapping;
 	struct device **devs;
 	int i;
 
-- 
2.15.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
