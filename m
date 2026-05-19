Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C332E03EA
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 10:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779185960; cv=none; b=rcezGfF+Y78WWeGlSU0FH/dcYWbgvRvG/7dUvFybQswWlSB6AXNQWbDKidrWZxCa/G1vrvaOSg+WHIRHPtoObubw4duv0y++iBKmzOsUMmTle1A6hrg7det7OQw2bVHZkKa/2VhFgEGaZMR4OVUsJ/1VA8RFTn361Tnu4KKjI8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779185960; c=relaxed/simple;
	bh=2nMw25pjO6lFmqT9ORMlFdHwuDJXpu902r+c+Vb1lIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=mKsTDTE27Iyxqef9Uu8cdD1WKU5P6uPvTQW/FxOaWysU0YrIB62V3F70kEx6TMGEyNZHzbOniK32goW+/Vs9ZlMWwsciH1tQQ78NhGo3X519XntRQLasIqFbpSZs11+LczVwL/2Itb5wQShwZ3tmRGxuvuv/P32WlG/osoreJ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=lS9psYwV; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="lS9psYwV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1779185959; x=1810721959;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2nMw25pjO6lFmqT9ORMlFdHwuDJXpu902r+c+Vb1lIQ=;
  b=lS9psYwVJEewmLmOIgxuceZ6H7NswRY1wh6jaGfZQduwrgGb3CqCmP2r
   N2v5SQQ0yEKse0klup7pqGfK7rSjKt33WBgwgiIEQpOnE4utWmD26DB/1
   yzA1kcNFhi1Phup1DhqXCqoQ3jQ2r1Jivh2JgqV9oevT1CBQkPyjbKkru
   7hTc+eb0TxA/natP38C7pKVj0l5x/aSksEfondxXLwT5+hLmiUdAzUO1b
   jrjvoX6sVcRYPXoGsIpctNcPrW6CQRscvXI9G5fgXvtTm3QFhBnd7xp1Q
   +uAf/2E+TFCGSVSHxxMQ9ecinQaUWB3rT6VVO7o3yRS4D6JRdulr2Ho/4
   w==;
X-CSE-ConnectionGUID: WPZTHngRSPyrac/Lpkb5kA==
X-CSE-MsgGUID: j+wJNX+nS7+JiExjCI0lXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="241108740"
X-IronPort-AV: E=Sophos;i="6.23,243,1770562800"; 
   d="scan'208";a="241108740"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 19:19:17 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 0A78E1C1C732
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 10:19:17 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (az2uksmom4.o.css.fujitsu.com [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id B620E182631A
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 10:19:16 +0000 (UTC)
Received: from dhcp-portal (unknown [10.172.107.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 4CB8A4066E3;
	Tue, 19 May 2026 10:19:15 +0000 (UTC)
Received: from isar2.ecs00.fujitsu.local (unknown [10.172.183.27])
	by dhcp-portal (Postfix) with ESMTP id E013460A9D;
	Tue, 19 May 2026 12:19:13 +0200 (CEST)
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
Subject: [PATCH v2] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
Date: Tue, 19 May 2026 12:18:32 +0200
Message-Id: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The dax_region resource conflict in alloc_dax_region() indicates a
serious configuration problem — two subsystems (e.g. dax_hmem and
dax_cxl) are attempting to register overlapping address ranges. This is
not a transient or debug-level condition; it represents a genuine
resource conflict that an administrator needs to be aware of.

Switch from request_resource() + dev_dbg() to
request_resource_conflict() + dev_err() so that the conflict is visible
by default and the colliding resource is identified in the message.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
---
 drivers/dax/bus.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 68437c05e21d..66413c6c2ba0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -637,7 +637,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		unsigned long flags)
 {
 	struct dax_region *dax_region;
-	int rc;
+	struct resource *conflict;
 
 	/*
 	 * The DAX core assumes that it can store its private data in
@@ -670,10 +670,11 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		.flags = IORESOURCE_MEM | flags,
 	};
 
-	rc = request_resource(&dax_regions, &dax_region->res);
-	if (rc) {
-		dev_dbg(parent, "dax_region resource conflict for %pR\n",
-			&dax_region->res);
+	conflict = request_resource_conflict(&dax_regions, &dax_region->res);
+	if (conflict) {
+		dev_err(parent,
+			"dax_region: can't claim %pR: address conflict with %s %pR\n",
+			&dax_region->res, conflict->name, conflict);
 		goto err_res;
 	}
 
-- 
2.47.3


