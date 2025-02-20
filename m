Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A011BC58;
	Thu, 20 Feb 2025 00:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740012351; cv=none; b=DELAIfZmczcJVeb4EbQY2RU+l2HofHsOT1lBNyZ0uCERa/4eEI20dJcZO7VO21idsdHdbUUspCkIvuJbtUTEMZ3iThIlNLkeWxaZ5qM53tOoZlFdpmEuG+xNJMZSlFmYwTnHIE9XULIAbV2A4wgSH60z92YZJWwavL7f4jnJEV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740012351; c=relaxed/simple;
	bh=gSlNT9EIRqppT0Ey09HJuTR9gFcLPJ+PyiTlRGk8mv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa4n1kLIWU/J9YSts82gbuwVoxegkeZ0+yChreG1qKBnG39YSLY2lEc28BE5fOdanP+YWxU4gqkyGZCzn4irxT01VZhpIJ6hPbg3rL4NGy193t9RZXDNx4SetYt0zSA96lWfQiy/lullVwKrkiy6GPuT+Osr/OFgdMdbR0z3470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=LOtdws3f; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="LOtdws3f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=C+cWGTYiyExyDFnUCLSnpZSaEm/uWUEqZQvglCyI99w=; b=LOtdws3fzV8jL4UH
	tqOUB+tGg0U9quEoQFJN3XVTY6qyaF++4te9XOnW7x4OZHuiNcUhnDI11M7yssyckHWi4/+Jx0dPQ
	hHkfelV6I5ihjXhT6eofsqDSA/nNuRFmWmuXtrY98Gk04xTD85aN0PFHFDNEfRzoKS66Lwtv8niuG
	adrD8HqKvYhT21xdzYVBnpX87LJS+vdP08Jr5nn2o4Kn1nlTlQRjI00231ZPYM84hRU8yHufYPboq
	bnsVCHg0tLB2SByiTbEuoeblMxyaJQJelOhP+eczSEPWAGTJXdMZ/DFM2sJF5/60GitUCSbLyP7HF
	8O3DSI2zsHHuueWN7w==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tkuhB-00H2o0-18;
	Thu, 20 Feb 2025 00:45:41 +0000
From: linux@treblig.org
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/2] libnvdimm: Remove unused nd_attach_ndns
Date: Thu, 20 Feb 2025 00:45:38 +0000
Message-ID: <20250220004538.84585-3-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250220004538.84585-1-linux@treblig.org>
References: <20250220004538.84585-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

nd_attach_ndns() hasn't been used since 2017's
commit 452bae0aede7 ("libnvdimm: fix nvdimm_bus_lock() vs device_lock()
ordering")

Remove it.

Note the __ version is still used and has been left.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/nvdimm/claim.c   | 11 -----------
 drivers/nvdimm/nd-core.h |  2 --
 2 files changed, 13 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 9e84ab411564..51614651d2e7 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -56,17 +56,6 @@ bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
 	return true;
 }
 
-bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
-		struct nd_namespace_common **_ndns)
-{
-	bool claimed;
-
-	nvdimm_bus_lock(&attach->dev);
-	claimed = __nd_attach_ndns(dev, attach, _ndns);
-	nvdimm_bus_unlock(&attach->dev);
-	return claimed;
-}
-
 static bool is_idle(struct device *dev, struct nd_namespace_common *ndns)
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 2b37b7fc4fef..bfc6bfeb6e24 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -134,8 +134,6 @@ void get_ndd(struct nvdimm_drvdata *ndd);
 resource_size_t __nvdimm_namespace_capacity(struct nd_namespace_common *ndns);
 void nd_detach_ndns(struct device *dev, struct nd_namespace_common **_ndns);
 void __nd_detach_ndns(struct device *dev, struct nd_namespace_common **_ndns);
-bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
-		struct nd_namespace_common **_ndns);
 bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
 		struct nd_namespace_common **_ndns);
 ssize_t nd_namespace_store(struct device *dev,
-- 
2.48.1

