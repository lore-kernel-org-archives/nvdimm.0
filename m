Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C94273D6D
	for <nvdimm@lists.linux.dev>; Sat, 11 Apr 2026 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775870043; cv=none; b=fE2eojRKkjqiQXKAyokzd4x1G9TFWN5d0rXI4U0huIZUbZOdIdCR/SerXfQLv9WTsHdAu1cxk2szvviirbp7FgGA+MZT0RKtLEHYqdTLVbCtOIVYx5RWE8EI2aTyM9tBeXhy2gyyVMCw2alww2n0/9FYj3ffHx3c+h7gIx30AZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775870043; c=relaxed/simple;
	bh=Prt7EBHgmHveLZtcjqu7hk2a++d3Ai0nA1qmLG5r6jw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qqkUAJgwybf2M/T4A8veVr75tZBRrAY8Y6JIuMrB76SsyLJv0S1RqIeHJdQaFbHw6rKDpB3j4ykPOEXZWHOfJFK5UgbwP0K7uXnOS5dpX2pDi9BktoyrDk+h5JgoQtxVSWva7HfnlkxkcHL2+qlJdyfCsVpo9MJKdWy8dssL1Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YceEMR2u; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YceEMR2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775870042; x=1807406042;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Prt7EBHgmHveLZtcjqu7hk2a++d3Ai0nA1qmLG5r6jw=;
  b=YceEMR2uG4qtxR4EAqbqd+WdDqIQ3H8D9wsR60sZ0O7wO8i+MoKCK2wA
   b0xm12N+BwIdHnk0sKYMoSogfRgb0SXBGO7shqdCsvyObqash9ycSMiJh
   DXHjxMqR+UcbiqCtlNVtXKWjPSa2CjCk0oDXXMGEOXrcjmxs8POrr9aMQ
   MB3an/8Py+qWUsb2gjS5WnUlu4uSuiIpL+SqPt1kkqNF0B1FH5ucSSx5s
   wA2zeVNCgKxvbxNGvpSQrt5r+IAOztNQq+RnwKwO8TlqYNJ2JDOiYZS/c
   djKT2GrZs8KoqxrYZ0/ZJsm3Zbgt6tpEnAnLb+9TzJXVWlVPZffCxQE0q
   w==;
X-CSE-ConnectionGUID: AANYREMSSOOfY0AY3nXF2g==
X-CSE-MsgGUID: Pb2XXTQKQyCsXBWl3ertkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="88337731"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="88337731"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 18:14:02 -0700
X-CSE-ConnectionGUID: E2gegKDuSZq6oBV7fy2E4g==
X-CSE-MsgGUID: fVjBgSf7Sw+XklDO1cv0Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="267226848"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.123])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 18:14:01 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH] cxl/list: apply bus and port filters to anonymous memdevs
Date: Fri, 10 Apr 2026 18:13:56 -0700
Message-ID: <20260411011358.3133190-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Anonymous memdevs are disabled memdevs that do not nest in the
topology output and are reported separately in the "anon memdevs"
array.

A user reports that cxl list -M -i with a port filter may return
anonymous memdevs that are not part of the selected port. In this
case, QEMU-defined disabled memdevs were returned in a query of a
cxl_test bus port.

The issue has two parts. First, util_cxl_memdev_filter_by_port() does 
not properly constrain bus-filtered queries. It treats the bus name
as a port identifier, allowing memdevs from other buses to match.

Second, cxl_filter_walk() collects anonymous memdevs in a global
pre-pass without applying decoder, bus, or port filters, so disabled
memdevs outside the requested scope are included.

Update util_cxl_memdev_filter_by_port() to limit the search to the
selected bus and match ports only within that bus. Apply decoder and
bus/port filtering to anonymous memdevs so they follow the same rules
as other memdev listings.

Found with CXL unit test cxl-topology.sh

Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/filter.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 8c7dc6e31701..5d634d3b2512 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -615,12 +615,12 @@ util_cxl_memdev_filter_by_port(struct cxl_memdev *memdev, const char *bus_ident,
 		struct cxl_port *port, *top;
 
 		port = cxl_bus_get_port(bus);
-		if (util_cxl_bus_filter(bus, bus_ident))
-			if (__memdev_filter_by_port(memdev, port,
-						    cxl_bus_get_devname(bus)))
-				return memdev;
+
+		if (!util_cxl_bus_filter(bus, bus_ident))
+			continue;
 		if (__memdev_filter_by_port(memdev, port, port_ident))
-				return memdev;
+			return memdev;
+
 		top = port;
 		cxl_port_foreach_all(top, port)
 			if (__memdev_filter_by_port(memdev, port, port_ident))
@@ -1125,6 +1125,12 @@ struct json_object *cxl_filter_walk(struct cxl_ctx *ctx,
 		if (!util_cxl_memdev_filter(memdev, p->memdev_filter,
 					    p->serial_filter))
 			continue;
+		if (!util_cxl_memdev_filter_by_decoder(memdev,
+						       p->decoder_filter))
+			continue;
+		if (!util_cxl_memdev_filter_by_port(memdev, p->bus_filter,
+						    p->port_filter))
+			continue;
 		if (cxl_memdev_is_enabled(memdev))
 			continue;
 		if (!p->idle)
-- 
2.37.3

