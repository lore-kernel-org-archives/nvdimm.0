Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDB78BE5
	for <nvdimm@lists.linux.dev>; Sun, 15 Dec 2024 02:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734231516; cv=none; b=P2SRAK+Qh/jw8FnFq9edQUTmaOO531H6F/D79jR2rTdH32PXdMVMqhkOceNMDgeXf6kd+9wgcZtpYIXgFg98/GRmF8cc5DWJyesg23PP38/hIpL7O8AWMxNzoyLpY+Vf9OVNFXNj9hULsPunrHroxlYBOBAsnMKg13PCmftgM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734231516; c=relaxed/simple;
	bh=2kDR2F9vKHIh6gm7iGCw+sZX6KqNubTsGoJ+dHRxaag=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MT45+D4hhbHJ+mjMrOFllSoLE6UW0AI2HZiG8u2T1wrrvmDd1s80tz3ULmZ+4ykfW28qSGK5SAMV21juAnrcBQMD9G/FjQepFMvVg/8l2PW0zqV7izKH5o5HDhtbHODGfgFatsh6Ti/1SlG6Iq7Jkpy+29mx4fUc6OJLEfrbqkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQTcI6/C; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQTcI6/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734231514; x=1765767514;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=2kDR2F9vKHIh6gm7iGCw+sZX6KqNubTsGoJ+dHRxaag=;
  b=cQTcI6/C845BNWTC2TD7w/FgtcXFtz6BQoqxs7kFM69fvHKKxtmnF9yo
   aFIQUtC9EDONeWWPRo9jICxLj4iwCh7LlEd3LdJcdvWamO6zKt6R+dYfV
   hY6XYljHEPisolaysURz57f5Z0U+omYp+lHy4wdKBl1i6bPGtPZuJibGJ
   fCFGIm3E9Uqggz6Lrj7hDvUcEgNJ33VlvqMR9kxuyEsftLUxbmJlLc6ow
   oxBB/Haet6unkAEmLNtJaw7rZAEgsOE3QH04nm2JVhG0nBcMnDw+ExVaK
   BuZemRDGQOcZ8G56x5f3BtH8usKVnoVKJpZtBB3WYcSUUrBL6gV9NhjEK
   Q==;
X-CSE-ConnectionGUID: dJqsC5i9QVKYqvWAgvqU0g==
X-CSE-MsgGUID: K8jI/VptQmaJfleGK+9B7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11286"; a="52166938"
X-IronPort-AV: E=Sophos;i="6.12,235,1728975600"; 
   d="scan'208";a="52166938"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:34 -0800
X-CSE-ConnectionGUID: 7YNHhoA+RLKyTMM7ySgHZA==
X-CSE-MsgGUID: b6IZyFoKRcKKsitReDdRLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="97309308"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.111.42])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 18:58:33 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Sat, 14 Dec 2024 20:58:28 -0600
Subject: [ndctl PATCH v4 1/9] ndctl/cxl-events: Don't fail test until event
 counts are reported
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241214-dcd-region2-v4-1-36550a97f8e2@intel.com>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
In-Reply-To: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Sushant1 Kumar <sushant1.kumar@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734231510; l=1494;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=2kDR2F9vKHIh6gm7iGCw+sZX6KqNubTsGoJ+dHRxaag=;
 b=wb8HxjQsB/wHATb4wKKaGox+Y7O4ht4Ig3/yZ7ougZYUDZo1OaOVD8WveV75dnUfTT119qk3l
 ccZot/Z/udmDkI1iPEXmIRUGQnGFq9/ergipHvJqsLCJInrOehV98N1
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

In testing DCD event modifications a failed cxl-event test lacked
details on the event counts.  This was because the greps were failing
the test rather than the check against the counts.

Suppress the grep failure and rely on event count checks for pass/fail
of the test.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
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
2.47.1

