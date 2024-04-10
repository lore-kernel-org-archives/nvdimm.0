Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF84615E5B1
	for <nvdimm@lists.linux.dev>; Wed, 10 Apr 2024 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712756868; cv=none; b=X9FjxjEtSCMGTfBmw62IXFNu38IqSVsoxrt6nGtK39wcmtZdr95AlzsNnM6Oy26qaYCG7m/L3RgMWJH8oq4ZFWI6d5njMKKk2vhGRfnavkPfgWtWR0zNId70HLHprbjyOtJSfRhh2IgKw2K8S+OBdLPlvysiVEgV6NCJ8N0q9hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712756868; c=relaxed/simple;
	bh=qUfnlDnLPRGTX/8I0F2Z1wWIEgVqVIK7a1i9mccRtkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQRfl8txG3sxCWk3PZv1MztrKoAo7Y7vWf2wYTOz67yIGTIlFSkOWK5c7nMcr5VUt14qQxU1cVSQXzdgXjG3J2Akqq6/pBdm6pNV4JvkexG7eu6bkyfvnVFSnjkDt8PgVIpCgc2jqSpYASZsJilOBPwU4asajBtfOn3bLmQ4A3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00034T-O7; Wed, 10 Apr 2024 15:47:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00BVNc-7I; Wed, 10 Apr 2024 15:47:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00Hae7-0S;
	Wed, 10 Apr 2024 15:47:38 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: [PATCH 1/2] nvdimm/e820: Convert to platform remove callback returning void
Date: Wed, 10 Apr 2024 15:47:33 +0200
Message-ID:  <fcb5545d45cf31caee31e0c66ed3521ead12c9b4.1712756722.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
References: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1672; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=qUfnlDnLPRGTX/8I0F2Z1wWIEgVqVIK7a1i9mccRtkI=; b=owGbwMvMwMXY3/A7olbonx/jabUkhjSxGWWH0sP87ypabu5WKjhr+z/icGTKwa0/lt56d9Txn MCCoD3ynYzGLAyMXAyyYoos9o1rMq2q5CI71/67DDOIlQlkCgMXpwBMJG0C+28W7ZDEDfKvjpv8 /bZC6WSugL7TN3ujnpBzr6MXTwg/uY7ngl7OsxczPq10uDHl1Yc5DDaWcRUNB/36te9cMeu4r7U 2x65qameev6L7p833xaV1gxtv5V3It3zkMLejRKTMYIpoXeCr78Lznx4s3Ly4QkWncGpJq+/0zE 9HH73e7aZ3uKU77WFz7kPR+6GP2vS42XUqNu6Q8tCLnZ/uPr/Jt31J6/3rf471zXOQdF/85QrHj jMz+fUj29Rnp/C6LEwss5UTiolo7c1an5HJEbNe0dw2+Y6oREqv+txHGc+P3pDxM2p5EMXjYhy/ 8Kwec9cx+cdrmb8Eaa/96Bxq4VZR1iL49JDOwsjwti9LAQ==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/nvdimm/e820.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 4cd18be9d0e9..b84a1de7f23a 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -9,12 +9,11 @@
 #include <linux/module.h>
 #include <linux/numa.h>
 
-static int e820_pmem_remove(struct platform_device *pdev)
+static void e820_pmem_remove(struct platform_device *pdev)
 {
 	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
 
 	nvdimm_bus_unregister(nvdimm_bus);
-	return 0;
 }
 
 static int e820_register_one(struct resource *res, void *data)
@@ -60,7 +59,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
 
 static struct platform_driver e820_pmem_driver = {
 	.probe = e820_pmem_probe,
-	.remove = e820_pmem_remove,
+	.remove_new = e820_pmem_remove,
 	.driver = {
 		.name = "e820_pmem",
 	},
-- 
2.43.0

