Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582413191D3
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 06:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779950835; cv=none; b=uEkwuht6w692Q9/b+FbMWdHTAzcalVX4/FsAL2aj76XJ670zSVwkRDtDj2OcOyAlIzEDRNO7jbe995+b4xsSrXkGqK+wMAGnO6yVG9jKZlR8KnhycMdu9KeaRGtDnXnk5QX6EZFQkzrvH4aFipb7dm3gIHsmf94bD8rbVfqkuEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779950835; c=relaxed/simple;
	bh=prdtrxY4K6tpuyuEGT/BUZzB6ZtzGfmw31jIxmiUMc0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Tpk3ai72sXrLbJesSE2UzB9Et8PVP2llc+wDlj61tk7ekx47FZS+Gbo2/3QnwVLqG1EfOyuRx/Uocuic/z5JBPxhsFKdFnI2+hbzmHJcYtsQfdvobn9r27FfjegyRCy/sU1ovgJ4iP5ONSV8LgsqBbZNW4V7wmg7zUgJNIPkzgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=LDZwJR+X; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="LDZwJR+X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779950834; x=1811486834;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=prdtrxY4K6tpuyuEGT/BUZzB6ZtzGfmw31jIxmiUMc0=;
  b=LDZwJR+X8056i3qlcTcaX6O38jWoLYCQEEryJA1+Y7BUTFYS+DzaZIgm
   KT3IjKLq3CGysJJiO0OR48ehWXsmae6Se22t1ESS3GbYxs/Qucf6R1NSC
   lfB9uDa65fSRSd8zB/6CW6XIE+55dz5tzH6xeu7kTVeHd7r8jqmaxdtdJ
   hAtBFlWnIjfME3smgaB28W388X6/Ml7fobOujW7kjPyWUHZimsTxupouH
   Pht6E1T/Jc0ptfvdl5gYaqP6V2hdlL/XAw8enxuH8JnBibgtOGfCM+YI/
   DaEDKv2YzkMXV3YpLZaVm8eWkUFRhjDjnpcq84ox+GurqvfPChTetXtAK
   w==;
X-CSE-ConnectionGUID: cU58zM+bTyCIDDxFxkHKpw==
X-CSE-MsgGUID: PU+cydo7T3WVOaCRVW2q7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="242082765"
X-IronPort-AV: E=Sophos;i="6.24,173,1774278000"; 
   d="scan'208";a="242082765"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:46:04 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 32CDDADB6
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 06:46:03 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id D91F818461B5
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 06:46:02 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by az2uksmom2.o.css.fujitsu.com (Postfix) with ESMTPS id E6B7A1400132;
	Thu, 28 May 2026 06:46:01 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id 3E41260A0E;
	Thu, 28 May 2026 08:46:01 +0200 (CEST)
From: Tomasz Wolski <tomasz.wolski@fujitsu.com>
To: smita.koralahallichannabasappa@amd.com,
	alison.schofield@intel.com,
	dan.j.williams@intel.com
Cc: icheng@nvidia.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ardb@kernel.org,
	benjamin.cheatham@amd.com,
	dave.jiang@intel.com,
	jonathan.cameron@huawei.com,
	Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: [PATCH v3] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
Date: Thu, 28 May 2026 08:45:46 +0200
Message-Id: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

The dax_region resource conflict in alloc_dax_region() indicates a
serious configuration problem — two subsystems (e.g. dax_hmem and
dax_cxl) are attempting to register overlapping address ranges. This is
not a transient or debug-level condition; it represents a genuine
resource conflict that an administrator needs to be aware of.

Promote the log level from dev_dbg() to dev_err() so that the conflict
is visible by default without requiring dynamic debug to be enabled.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 68437c05e21d..cd963eeeef7b 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -672,7 +672,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 
 	rc = request_resource(&dax_regions, &dax_region->res);
 	if (rc) {
-		dev_dbg(parent, "dax_region resource conflict for %pR\n",
+		dev_err(parent, "dax_region resource conflict for %pR\n",
 			&dax_region->res);
 		goto err_res;
 	}
-- 
2.47.3

