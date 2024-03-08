Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEA554BCB
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709887926; cv=none; b=sfiq36qS1aTI9im4iFgdu+P6GVGtfHmRneTvJym8PI/7Z5IDK9sxYupfi/7hUImnywSKNGqWwlWn0Wr3SuI8QttszwMxpgUM/KCnA+A0Z1pZ2OaEDzfjRl9JobQO6J04imDiDLaIIH8WAopjpgkdDe3ivUrH/fgB1Tp9lMcD8zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709887926; c=relaxed/simple;
	bh=Z1uzOnQSrvfPw9hYybgCT2hw67VhTM9MMIGLHeGIaOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rWvWYox1msWHv0e/pb0STq52fyi+v+gisBT2wQU1rA+uTUsGOj4FKmIT6zQRDNB8Pu00sMVOSLW1STS9dQthzD5PCmSr4uAIW4X646FmD1Ln8vfOyseITJeD0r9uF5w92WRxy1gDslrR2B+A+ZSkb0Uv6VaYMo9g3MvSOgyBoU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1riVxI-00074J-52; Fri, 08 Mar 2024 09:51:52 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1riVxH-0056O1-BB; Fri, 08 Mar 2024 09:51:51 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1riVxH-00246T-0q;
	Fri, 08 Mar 2024 09:51:51 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: [PATCH] ndtest: Convert to platform remove callback returning void
Date: Fri,  8 Mar 2024 09:51:22 +0100
Message-ID:  <c04bfc941a9f5d249b049572c1ae122fe551ee5d.1709886922.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1779; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=Z1uzOnQSrvfPw9hYybgCT2hw67VhTM9MMIGLHeGIaOE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBl6tGPV1Iz+eM8xhS/r5aSHA2DD2lf8QtMr1tW0 iWCl4RydZGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZerRjwAKCRCPgPtYfRL+ TtlXB/0QaReitvAZK3PS92lOcxpcvPCsZ24yEa8NwWwne/cqVMhJsVyUtkrWLT3Fy/fpEAjjQgE Ct9aEXwItvThTpqkXlQKdDtChqbOc7VlGsX6rocWitx/eRmgXJMu/tKF2taI+lU0csqNPyPf/Ez EvIlSt4O8ahyYkbjtM5JbL/jIZ2ULGjp2W/vf9Wio2+QXHqleFF1s+OqlrbdpKz4OGddC3Qpi+R FXd0/aZIIDmz/6l1PUZpSWlcLZSOvqC0jH2cUaz0Sy3DE5Lj/x84rgCLimFehZiRnuk2Hk+priE +SPA2wTbciaUYBE3WRbCNP2AWwsXZUpbTf8MgNUqcpV/J1ZA
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
 tools/testing/nvdimm/test/ndtest.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index b8419f460368..2c6285aae852 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -830,12 +830,11 @@ static int ndtest_bus_register(struct ndtest_priv *p)
 	return 0;
 }
 
-static int ndtest_remove(struct platform_device *pdev)
+static void ndtest_remove(struct platform_device *pdev)
 {
 	struct ndtest_priv *p = to_ndtest_priv(&pdev->dev);
 
 	nvdimm_bus_unregister(p->bus);
-	return 0;
 }
 
 static int ndtest_probe(struct platform_device *pdev)
@@ -882,7 +881,7 @@ static const struct platform_device_id ndtest_id[] = {
 
 static struct platform_driver ndtest_driver = {
 	.probe = ndtest_probe,
-	.remove = ndtest_remove,
+	.remove_new = ndtest_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 	},

base-commit: 8ffc8b1bbd505e27e2c8439d326b6059c906c9dd
-- 
2.43.0

