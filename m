Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF77B211ACEBF
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 13:42:50 -0800 (PST)
Subject: [PATCH] device-dax: Auto-bind device after successful new_id
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Jan 2019 13:30:12 -0800
Message-ID: <154836541248.2998916.14581880959768387544.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The typical 'new_id' attribute behavior is to immediately attach a
device to its driver after a new device-id is added. Implement this
behavior for the dax bus.

Reported-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c620ad52d7e5..7053ab6419db 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -92,7 +92,10 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 	} else
 		/* dax_id already added */;
 	mutex_unlock(&dax_bus_lock);
-	return rc;
+
+	if (rc < 0)
+		return rc;
+	return driver_attach(drv);
 }
 
 static ssize_t new_id_store(struct device_driver *drv, const char *buf,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
