Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A913AC9
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 16:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686934261; x=1718470261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LJTbIfA0UENMk0xVXSZGWf0/1PqMliH9RFpRpZHd0Iw=;
  b=VXEPalELyco0bfzCN6f0LELcsocPbaYocLRzwUK//TsgNEZ2lB0rlaNa
   +d5U+jYsRUc3m+gf5HNJvlvRfvNrEn+SuexjrohHAs+OsJahEydO2/37I
   7onuIl4K9ppDSeP7WZlvY6h4sVQAwKjQ5RsOnv3dGRTJVkjdCtD23xjh7
   gIoPLrOK/rSapS6O6hy22I3RHg3GwUyGXUF8qgtKIB+USqDRWVklu6rQ+
   Zd4KRygY99KDUDjHAJKqitXnKe3p6NsbJzqk3EfvYznuluwXo1+GpZeIE
   I3xNyiIbY0YVQNifgzP+8EYOcj+9mrsZ6on6khSjq3uhq9CussNaYngC8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="422912973"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="422912973"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:51:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707154105"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707154105"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:50:57 -0700
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: linux-acpi@vger.kernel.org
Cc: rafael@kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	lenb@kernel.org,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rui.zhang@intel.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH v5 02/10] acpi/bus: Set driver_data to NULL every time .add() fails
Date: Fri, 16 Jun 2023 19:50:26 +0300
Message-ID: <20230616165034.3630141-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230616165034.3630141-1-michal.wilczynski@intel.com>
References: <20230616165034.3630141-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most drivers set driver_data during .add() callback, but usually
they don't set it back to NULL in case of a failure. Set driver_data to
NULL in acpi_device_probe() to avoid code duplication.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/acpi/bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 22468589c551..c1cb570c8d8c 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1017,8 +1017,10 @@ static int acpi_device_probe(struct device *dev)
 		return -ENOSYS;
 
 	ret = acpi_drv->ops.add(acpi_dev);
-	if (ret)
+	if (ret) {
+		acpi_dev->driver_data = NULL;
 		return ret;
+	}
 
 	pr_debug("Driver [%s] successfully bound to device [%s]\n",
 		 acpi_drv->name, acpi_dev->pnp.bus_id);
-- 
2.41.0

