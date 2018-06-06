Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B757A209884BC
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 09:45:17 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 4/4] libnvdimm: don't flush power-fail protected CPU caches
Date: Wed,  6 Jun 2018 10:45:15 -0600
Message-Id: <20180606164515.25677-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
References: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This commit:

5fdf8e5ba566 ("libnvdimm: re-enable deep flush for pmem devices via fsync()")

intended to make sure that deep flush was always available even on
platforms which support a power-fail protected CPU cache.  An unintended
side effect of this change was that we also lost the ability to skip
flushing CPU caches on those power-fail protected CPU cache.

Fix this by skipping the low level cache flushing in dax_flush() if we have
CPU caches which are power-fail protected.  The user can still override this
behavior by manually setting the write_cache state of a namespace.  See
libndctl's ndctl_namespace_write_cache_is_enabled(),
ndctl_namespace_enable_write_cache() and
ndctl_namespace_disable_write_cache() functions.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: 5fdf8e5ba566 ("libnvdimm: re-enable deep flush for pmem devices via fsync()")
---
 drivers/nvdimm/region_devs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index a612be6f019d..ec3543b83330 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1132,7 +1132,8 @@ EXPORT_SYMBOL_GPL(nvdimm_has_flush);
 
 int nvdimm_has_cache(struct nd_region *nd_region)
 {
-	return is_nd_pmem(&nd_region->dev);
+	return is_nd_pmem(&nd_region->dev) &&
+		!test_bit(ND_REGION_PERSIST_CACHE, &nd_region->flags);
 }
 EXPORT_SYMBOL_GPL(nvdimm_has_cache);
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
