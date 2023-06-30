Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E345716405
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688150053; x=1719686053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tVvPfhy1pq/F5VIaRT5AzqUsJQrfr238yG1EqHj9ZCg=;
  b=RskxWsuSlH/j/i0Z4sGUt/MgFTM22/zH8JNLT6tnLV1dc5K0Ead32lCs
   VdXtupd/Vyl6bQ/My6Qxs3MKW3tC8+QgpOIPPgL/QWfxsr2wuDzFwKe2o
   fYDzkgq5lp6DVJwmXJb08gXuUK1PPtcUI1sQQJi0d7aAY4NvMDt0bj24A
   wBcAnIjx/5b6Bg2Xo0PmQmmnmsQkdeVf1p+V3vIGbuzA1S946SgkPalI4
   Y1/Nb3mvtii2G4CdfvsY/r1Vso6JQ+rAx1ZPqid1TT+NQRqfX1DJWSjf9
   /us2dXnQpJ9KEyJYGHmP6q17kFjr/pG3Rzb+4SYbP84KP4OW7GuXq1wMD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365949936"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365949936"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717896431"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717896431"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 11:34:10 -0700
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
Subject: [PATCH v6 2/9] acpi/bus: Set driver_data to NULL every time .add() fails
Date: Fri, 30 Jun 2023 21:33:37 +0300
Message-ID: <20230630183344.891077-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630183344.891077-1-michal.wilczynski@intel.com>
References: <20230630183344.891077-1-michal.wilczynski@intel.com>
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
index 2d6f1f45d44e..c087fd6e8398 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1014,8 +1014,10 @@ static int acpi_device_probe(struct device *dev)
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

