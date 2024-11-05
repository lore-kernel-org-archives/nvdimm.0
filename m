Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255983BB48
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 02:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772667; cv=none; b=fcxRnBFCCIcz0MuW9wjlrq9AKtxXbDl85im0n+zZ6HYyQBvsep1+Rg57JBVODIV4hWt+8eDFpsaff2imkb7p9WsBXnAg/D/VIFx4q4Vlrg3eB+7jpm8p/YqmCWra3bE0UNvD3bF4DVzVVZZ9pnhCZpaTIxvNEflANnDlwjBXWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772667; c=relaxed/simple;
	bh=bnA5MH3Ut/o2XkdYerkFVpg3U06Fxf8NVmDS1qWQDyU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ppqxjsd/3AsOiS5CeET87+jwUpztHQd26ZLLexU4FphX+VZ7AXa8ZWoGurqHs22zaJSWa79dd6hAX5WKkBbJX6o20K/goaukWEXLaLrTIj6P9hR7zCdvZSWvfYHa8B20VrJ895aNWuYjc8QOI4pXLQ2ifJnQLTmJ15WECDTlvII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fzcTtB46; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fzcTtB46"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730772666; x=1762308666;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=bnA5MH3Ut/o2XkdYerkFVpg3U06Fxf8NVmDS1qWQDyU=;
  b=fzcTtB46FfBDMDzUg0t34JgsMcZo6vDYTvCPbnzAfAUypOShCLfPrhNe
   LLsq0qyx+BL+D9czFF6rCpE43h3Kn7/nX3mqo8a0iWoWp84A/BDXqJuug
   ipOjZ+JYYQ9x2kBgDoFfCRiM1Cq6UPgFs4CELfCPmFOhV73kBi/J48o4M
   dSoV0F541iZo58VwG4MNd0O4Dt1Qj7dTFOGcCQ61KNJQ84qpRunc30R5y
   qC8QoMqoQX8Lb4Wwv6H/TZsX+1ivwmY2SZbfHwnLbJHh4zKIIq/EXrufz
   3XnhYnjPipSpzOQ3BCeeDKJDsOgcguZR1eC4LHMTHClZM/nAqw08+iXq/
   g==;
X-CSE-ConnectionGUID: s/dCmWebRc2gz7j4buVrwg==
X-CSE-MsgGUID: X2bfYq1jQWuQBVsUEvmTuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30613068"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30613068"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:05 -0800
X-CSE-ConnectionGUID: uaA81OIZRRCPQWOJZ3T2bw==
X-CSE-MsgGUID: FOkCiQvIR4aMMCfd/9R56g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="107176444"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.226])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:04 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 04 Nov 2024 20:10:45 -0600
Subject: [ndctl PATCH v2 1/6] ndctl/cxl-events: Don't fail test until event
 counts are reported
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241104-dcd-region2-v2-1-be057b479eeb@intel.com>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730772649; l=1446;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=bnA5MH3Ut/o2XkdYerkFVpg3U06Fxf8NVmDS1qWQDyU=;
 b=azaIWGdTGXxd83oJiaG+D28KmWM0d7f8U6C35RhGPZ4sbF2O52DEj7Iy4Gh/HX1CLaUduaEpx
 j/m9uNy4LDWBIZ/7wjHXwltx//1EaB9Z9UkhPz0+YEft+ppdiDEMCIB
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

In testing DCD event modifications a failed cxl-event test lacked
details on the event counts.  This was because the greps were failing
the test rather than the check against the counts.

Suppress the grep failure and rely on event count checks for pass/fail
of the test.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 test/cxl-events.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index ff4f3fdff1d8f6fd80f093126a27bf14b52d167f..c216d6aa9148c938a649cb22656127b3df440039 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -71,10 +71,10 @@ echo 0 > /sys/kernel/tracing/tracing_on
 echo "TEST: Events seen"
 trace_out=$(cat /sys/kernel/tracing/trace)
 
-num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}")
-num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}")
-num_failure=$(grep -c "log=Failure" <<< "${trace_out}")
-num_info=$(grep -c "log=Informational" <<< "${trace_out}")
+num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}" || true)
+num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}" || true)
+num_failure=$(grep -c "log=Failure" <<< "${trace_out}" || true)
+num_info=$(grep -c "log=Informational" <<< "${trace_out}" || true)
 echo "     LOG     (Expected) : (Found)"
 echo "     overflow      ($num_overflow_expected) : $num_overflow"
 echo "     Fatal         ($num_fatal_expected) : $num_fatal"

-- 
2.47.0

