Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [85.220.165.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34AA28EF
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 10:05:30 +0000 (UTC)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1p52A4-0001w9-7g; Tue, 13 Dec 2022 11:05:20 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1p52A1-004Du3-1f; Tue, 13 Dec 2022 11:05:17 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1p52A1-004jVp-6E; Tue, 13 Dec 2022 11:05:17 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: [PATCH] tools/testing/nvdimm: Drop empty platform remove function
Date: Tue, 13 Dec 2022 11:05:12 +0100
Message-Id: <20221213100512.599548-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1021; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=lJ1jO01Pz6EnnQEAf5N7Smj3q627YxyYACi+S6cZUvc=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjmE5Vi8HR4usdB1/z6dEhhJl/4RBdyiSYdSy0pDEv hDpFd26JATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY5hOVQAKCRDB/BR4rcrsCfDKB/ 93428/NItSBzSYPzcSNykSMNm5DWDuuVMURYpmvxou2cDR2ftuHbS9ZS1WFYI6dddZ3TrPXArC7Nh7 YSidffV3f7x03YyBWrAvKKsLsFOpQQQY3xEhXF+uDvChvYZmLfgi4PzgK0Baxcs8H+0EBkL2eCewJ7 q70h4UY9tlpg9WraSXYozPJQaQBYT/Q4VvyPyxQ1qKVIZ4+BNLpU/re3MuNg0+iSSLC6KJ3j3T46DQ EUfRmKR2ZGLQ4WW66k0uho7MuNCLAB9cjSjLcdIv5kTHfKLvsS4SAuC5Awo2EjfJJjMz5CffU7/rkm L9OWXqyi29ksGjoH1wgYXirj6Ar7pO
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev

A remove callback just returning 0 is equivalent to no remove callback
at all. So drop the useless function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 tools/testing/nvdimm/test/nfit.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c75abb497a1a..207c19f831aa 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -3240,11 +3240,6 @@ static int nfit_test_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int nfit_test_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static void nfit_test_release(struct device *dev)
 {
 	struct nfit_test *nfit_test = to_nfit_test(dev);
@@ -3259,7 +3254,6 @@ static const struct platform_device_id nfit_test_id[] = {
 
 static struct platform_driver nfit_test_driver = {
 	.probe = nfit_test_probe,
-	.remove = nfit_test_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 	},
-- 
2.38.1

