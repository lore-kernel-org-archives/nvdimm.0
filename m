Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8FD15ECFF
	for <nvdimm@lists.linux.dev>; Wed, 10 Apr 2024 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712756868; cv=none; b=VJj7RD5kNBRa+Ji7JS96cooklp0EuLdb10FpoXWb2MC+1sjg3NkhNpDM83RfgR52xiqEHjnahHBEQlFZXLj4+2RB3uqAfcUPWILDBBaS+1gmDsLs3tnDVVCjjUtXUVPG+ySCfVXOGB9bvHiNSiV9VE6s1o78YM56xYqKCCDw3Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712756868; c=relaxed/simple;
	bh=Jjz92nrAD2L+bQgrtdjeURKi9kfOa2WFKCqHcPIxkxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FGKEtdecjUEJvCnz4KwRXIFPZIe50QsMSBfgy/XXPo/wwGcpRAYXtYnxnaquut4TJHOcMH+YpFpvLenepQwY2rpXZL/GyJtgRfWykKm02UyW9JOl+s1z9YIzrPbIkzN7hrdm248/2lsTWN963mM42awkUM93Ft6Z0yOasbm1yp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00032O-OE; Wed, 10 Apr 2024 15:47:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIc-00BVNZ-1e; Wed, 10 Apr 2024 15:47:38 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <ukl@pengutronix.de>)
	id 1ruYIb-00Hae3-35;
	Wed, 10 Apr 2024 15:47:37 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Oliver O'Halloran <oohall@gmail.com>
Cc: nvdimm@lists.linux.dev,
	kernel@pengutronix.de
Subject: [PATCH 0/2] nvdimm: Convert to platform remove callback returning void
Date: Wed, 10 Apr 2024 15:47:32 +0200
Message-ID: <cover.1712756722.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=895; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=Jjz92nrAD2L+bQgrtdjeURKi9kfOa2WFKCqHcPIxkxM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBmFph0AQjbDTWUjQw0yVXuRyNdJWPOTRRUqoN1x WAJBHeD+XqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZhaYdAAKCRCPgPtYfRL+ TmSmB/oDu4crXv0OmqbqA7MqtUH8PP4M+KkmZ1zfYpz9SOgGJ008F9WM0KtuZLFGfIkKQ5TtarQ 12MldHflzSdtoHjr6kOi43zbJMes0UGOIm++/f6HSO7Ts52cLwAlHbNXo708P93SxCHw0owfXt/ mDoF+jE+tYybwj11G7gwP2vK9MyyEWOEWYhDWr6YXHO4vO6/jomTWBMwQn/8voJAAReOI+miNKs 20ELGqx/pSS1cPg2rMKIdLHa89UqS08hMuU9aNpwN0KQNtDaeDbzhxT6vUlTWJWwQAIjgfVgDkE c6zq/flhqUdplroRjNyYMta8Vk9YFl2MKBFIvhMLKtNuupet
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: nvdimm@lists.linux.dev

Hello,

this series converts all platform drivers below drivers/nvdimm/ to not
use struct platform_device::remove() any more. See commit 5c5a7680e67b
("platform: Provide a remove callback that returns no value") for an
extended explanation and the eventual goal.

All conversations are trivial, because the driver's .remove() callbacks
returned zero unconditionally.

There are no interdependencies between these patches, so they can be
applied independently if needed. This is merge window material.

Best regards
Uwe

Uwe Kleine-König (2):
  nvdimm/e820: Convert to platform remove callback returning void
  nvdimm/of_pmem: Convert to platform remove callback returning void

 drivers/nvdimm/e820.c    | 5 ++---
 drivers/nvdimm/of_pmem.c | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

base-commit: 6ebf211bb11dfc004a2ff73a9de5386fa309c430
-- 
2.43.0

