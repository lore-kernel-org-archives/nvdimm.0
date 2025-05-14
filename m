Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C7D12C499
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747186911; cv=none; b=H+GTXmCBWDaeojsgNl7/+IRD3C2+LmU3nQXVWK330rk2tQ9ljgcCVmtJ5yDwCANl6XwzCGJWFJDOYi65h57MtOJ2eTtGJafRPBYmLy+S3mj9fo8PEZC1jRX/x8sfomlGkTvJxaX23z9zgQky8jeamFff4uWVZX9RSma3X95XCt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747186911; c=relaxed/simple;
	bh=L6ry45Fu6VLaBJtp4Wsgffl5dv81worZTn75s40MVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uPS0pfAAchzqFMEx51nFxPYtEBLOIUwy1WZ6z3CJRwVzuMnpOCyVlMh2p3dJyxkzp+Y1zRxcwx6SSYXnzvpEQGfGrM0+XK3Ry+2WcU18X3KMrjH46yppYiJZjVHaxSYrnRlKqGOzvEAKHsaEofmIBjDgkYUqfTK/xz7glyJko/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lvgeLFpu; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lvgeLFpu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747186910; x=1778722910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L6ry45Fu6VLaBJtp4Wsgffl5dv81worZTn75s40MVN4=;
  b=lvgeLFpuBysjJzhEDX4rNuDDud/guRAuH0dGZsXxLJXDE+PUz/0T/MHF
   PbIn0RlI8YZotFVqDR/9U4gBOhAOJ8+7Zq5kU7zGFB0buNdfVWPuxDurp
   KG+a4KQ573u9aSmP0V2EplHCRndpNmu91bxJ5p5Ide2AJ4lwblI4HicGQ
   Yz5U0QqQ6g34tU1U9/CG+QE19uuebxlacL0qE/QrY0ksswKphyeXknWrl
   dAo7wfTfE5aBKN6IaaDnplt90nvOcg38VBoEdNkp53Vd355Ub4dfrbVaE
   tXG4HbJGQJIFUXYh+FDoozb8UMCNPBxtSZnvqOEyAkJNGJ6EfhICFlj01
   w==;
X-CSE-ConnectionGUID: leSEEpnmQzOpbGLQvdikGQ==
X-CSE-MsgGUID: e/MhEkymRKKcbonv/N3sXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="52874059"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="52874059"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 18:41:45 -0700
X-CSE-ConnectionGUID: Jso1xneAQ+a69Y04qZaE4A==
X-CSE-MsgGUID: bsRUX2+dStySYPnNVcxzDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142830080"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.167])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 18:41:44 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] test/monitor.sh: remove useless sleeps
Date: Tue, 13 May 2025 18:41:30 -0700
Message-ID: <20250514014133.1431846-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping.
Removing the sleeps entirely has no effect on the test in this users
environment. It passes and produces the same test log.

Experiments replacing sleeps with polling for monitor ready and log file
updates proved that both are always available following the sync so there
is no need to replace the sleeps with a more precise or reliable polling
method. Simply remove the sleeps. Run time is now < 3s.

I'd especially like to get Tested-by tags on this one to confirm that my
environment isn't special and that this succeeds elsewhere.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/monitor.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index be8e24d6f3aa..88e253e5df00 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -26,7 +26,7 @@ start_monitor()
 	logfile=$(mktemp)
 	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
 	monitor_pid=$!
-	sync; sleep 3
+	sync
 	truncate --size 0 "$logfile" #remove startup log
 }
 
@@ -49,13 +49,13 @@ get_monitor_dimm()
 call_notify()
 {
 	"$TEST_PATH"/smart-notify "$smart_supported_bus"
-	sync; sleep 3
+	sync
 }
 
 inject_smart()
 {
 	$NDCTL inject-smart "$monitor_dimms" $1
-	sync; sleep 3
+	sync
 }
 
 check_result()
-- 
2.37.3

