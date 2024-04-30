Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D4181B8D
	for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714499086; cv=none; b=cIhf+pqV30WFFBRosjPiBvoqV51BR4gd88VXd+gqdy/VI8a/bcWKrzkHtLT0qz6vNPTsiRNCDwSGX8ENBCfIJaZ7TdJ8RFckp2LzZcux4BP0UUhkqaOjHTTwcaxRQ76V/OSEvZk00D1vwtp1+FZx56gOM1HVryMHo/7axZicc6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714499086; c=relaxed/simple;
	bh=NhTlptPmEedEHUiT46vqy1jTU5giIPfdgp2TteFj/UU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HjrAfEb5F18yGvLEKcDfp0x+qIqxvi6M5SOgZ8FOKKcH6uCW+GyFD3PgsibyQTKF6ZnS5kz/5EHhawRx9rnbj/jbLFfOlLuQGYdt40OJEWtviDOvXH5WOJJrv+2oxs5ssM3pftYTlx34q4Y7WcF5255YNKuamUcFcVvmHUkKSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lnWXKisR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lnWXKisR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714499085; x=1746035085;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=NhTlptPmEedEHUiT46vqy1jTU5giIPfdgp2TteFj/UU=;
  b=lnWXKisRIcBvAlB3v9wMQnpzQGED+kKrSGx4LSHfJP/m+KAgAixuk+0Q
   +Velcw+/J7cB9rBuGyAEDYU1G/poTLQ6swh6NmoOL+zopLlUNmZo2rf7k
   /cC5glZePSuMFYziSRNfXW0wuuEN+oo2UH/WHSWkhenoxj9OTJPQp4TzG
   +m80RZRIBQrEFUJNBrVN3laq7BrbGOhRMetENgyxj0lpvUZu4sXriyS9u
   v7RgeDxl7nvtdaco/b9G63Rjpd9Sf7nyH6ocNmwE6LTeoiCviifHj6k0h
   txLpFH8mAREcA7bJLts/AobUVcH/JB5rmLU3CTrdxjqdp66qx2b4qKEcs
   A==;
X-CSE-ConnectionGUID: SQpWfahJRN6PevcZFP0EQQ==
X-CSE-MsgGUID: DQPJq94rR6KCxJHVCDY0VA==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="27669838"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="27669838"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 10:44:42 -0700
X-CSE-ConnectionGUID: MTZbRtiIT46p1EZt8gC0Xw==
X-CSE-MsgGUID: PtnL8bTtQJuz5mXOFvW8pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26534780"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.82.45])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 10:44:42 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 30 Apr 2024 11:44:25 -0600
Subject: [PATCH v3 3/4] dax/bus.c: Don't use down_write_killable for
 non-user processes
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240430-vv-dax_abi_fixes-v3-3-e3dcd755774c@intel.com>
References: <20240430-vv-dax_abi_fixes-v3-0-e3dcd755774c@intel.com>
In-Reply-To: <20240430-vv-dax_abi_fixes-v3-0-e3dcd755774c@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=1045;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=NhTlptPmEedEHUiT46vqy1jTU5giIPfdgp2TteFj/UU=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGmGehxcG/a8TGZ7GGendtTw8nyFaR2CS4KDrHMureQTe
 8XOJx7RUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgIl4tTEy/F+18KzNXK/pAbHM
 YZzhbhWfskIF/QLXnjxRPZ95RabIdob/yWsvbDY4MY9zwd3/egXFfE36dhuc1cQ9lx8WVVhUH3i
 FGwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Change an instance of down_write_killable() to a simple down_write() where
there is no user process that might want to interrupt the operation.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e2c7354ce328..0011a6e6a8f2 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1540,12 +1540,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dev_dax *dev_dax;
-	int rc;
-
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return ERR_PTR(rc);
 
+	down_write(&dax_region_rwsem);
 	dev_dax = __devm_create_dev_dax(data);
 	up_write(&dax_region_rwsem);
 

-- 
2.44.0

