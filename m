Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF80015DBAF
	for <nvdimm@lists.linux.dev>; Wed, 10 Apr 2024 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712756869; cv=none; b=DCJbbvBUeduuGxpSzWcwj4dNm9Z2QsIzshqAt5jcXW1OsIaLWjMkztDFUwvpNX0T2m6DPIxPO6CUf4gZyo8I53rYSl52EyrkL8DwbGpqOZTN8DIsZn1IAQdWNzVuP/vSDKQ8c/uQhXd96Q5RdGRueAwISNL1Gkprvgg38NKCw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712756869; c=relaxed/simple;
	bh=j2Y9ZtaZuCF7gr+nRNBTo6EH8eltCiyaAohfNaPDkEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nN4NY4Q2C5q0/i/eSdOosBtr4hE4CoGTgdfl3Mn4l6pRYC/bWST68sa6e0e31S5AdTxgrTltnjWIyofaEXKZ2Gfh8xjum7BLfFeTMH5P8gcul7alxnVUoBVdYwjQsfOBRsIVao8jg4Hc/7Fvtd84+sxKIGEk1ywGDgIxdMmYDRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00036u-Qx; Wed, 10 Apr 2024 15:47:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00BVNf-E2; Wed, 10 Apr 2024 15:47:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00HaeB-17;
	Wed, 10 Apr 2024 15:47:38 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Oliver O'Halloran <oohall@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: [PATCH 2/2] nvdimm/of_pmem: Convert to platform remove callback returning void
Date: Wed, 10 Apr 2024 15:47:34 +0200
Message-ID:  <8de0900f8c9f40648295fd9e2f445c85b2593d26.1712756722.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1800; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=j2Y9ZtaZuCF7gr+nRNBTo6EH8eltCiyaAohfNaPDkEY=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBmFph3/Au8pJrEm1CZuxOgA2q9kvUacBftb/bSB bRLxcWIZFaJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZhaYdwAKCRCPgPtYfRL+ TsqWB/0Yxw+A/8dlVCaeYAqZThmqNAarFCYLo8H7NCIeJ5IJd0Iw5EJ3J/Gc3uN7SAcWQ1yk2y6 afKbIeQDDZWmBsfJMEJtk9TZviD5/HltSvpENYvBclCX6AYJ6mlgbkeY7q4AT5bxAG1taJxrpX4 dYJ0sEQepZ3R82oKnlbssuHbp5PkYiDLFQunnYievu/8BCczzZGqIhlteyzNoSB6I/Y5VLIuZlo 6IbhbNDutmwReDOwH55P3Lyk13lUfaDWMjRtmikhXs3f+gyxwIZAHaTfSOZywhhoi7Jt8nE37D3 qWlhkp3ecCTiALIForKAkW0ZYi8fGdsBxG3e4qGKxXYxBUsW
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
 drivers/nvdimm/of_pmem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index d3fca0ab6290..10230a2f6619 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -84,14 +84,12 @@ static int of_pmem_region_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int of_pmem_region_remove(struct platform_device *pdev)
+static void of_pmem_region_remove(struct platform_device *pdev)
 {
 	struct of_pmem_private *priv = platform_get_drvdata(pdev);
 
 	nvdimm_bus_unregister(priv->bus);
 	kfree(priv);
-
-	return 0;
 }
 
 static const struct of_device_id of_pmem_region_match[] = {
@@ -102,7 +100,7 @@ static const struct of_device_id of_pmem_region_match[] = {
 
 static struct platform_driver of_pmem_region_driver = {
 	.probe = of_pmem_region_probe,
-	.remove = of_pmem_region_remove,
+	.remove_new = of_pmem_region_remove,
 	.driver = {
 		.name = "of_pmem",
 		.of_match_table = of_pmem_region_match,
-- 
2.43.0

