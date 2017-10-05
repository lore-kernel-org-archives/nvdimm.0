Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2210F20945BB8
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 02:52:37 -0700 (PDT)
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] libnvdimm, namespace: make a couple of functions static
Date: Thu,  5 Oct 2017 10:55:57 +0100
Message-Id: <20171005095557.29063-1-colin.king@canonical.com>
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

The functions create_namespace_pmem and create_namespace_blk are local
to the source and do not need to be in global scope, so make them static.

Cleans up sparse warnings:
symbol 'create_namespace_pmem' was not declared. Should it be static?
symbol 'create_namespace_blk' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nvdimm/namespace_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3e4d1e7998da..2029e70a24f4 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1875,7 +1875,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
  * @nspm: target namespace to create
  * @nd_label: target pmem namespace label to evaluate
  */
-struct device *create_namespace_pmem(struct nd_region *nd_region,
+static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		struct nd_namespace_index *nsindex,
 		struct nd_namespace_label *nd_label)
 {
@@ -2186,7 +2186,7 @@ static int add_namespace_resource(struct nd_region *nd_region,
 	return i;
 }
 
-struct device *create_namespace_blk(struct nd_region *nd_region,
+static struct device *create_namespace_blk(struct nd_region *nd_region,
 		struct nd_namespace_label *nd_label, int count)
 {
 
-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
