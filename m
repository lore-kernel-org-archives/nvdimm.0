Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A170C246BAC
	for <nvdimm@lists.linux.dev>; Thu, 24 Jul 2025 22:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753395378; cv=none; b=s/dZwyyRYHfmwAuCVF9V0UT69Yplp8sSaRRubC6b/LEpkYGszDBcMi5GuXj9wI1ktNWI55DQ+FXMPhWW5CfS09CAUhTYrhDPu8IZ9YNcHEc17cNjUOePFqy+QhDtGkxirU+9xzX/MGY3LhTmz29pq2LMp8CPcP1Tjcc2oj5AqRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753395378; c=relaxed/simple;
	bh=VOsrWcJrCpJKt37WVVeZE3pPOc8UDCo9mApEEhIRFYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwLq5ttlD6f87TZC7tb0p3MRElbBduP3tyCo+enlU0GMNkxL2UngXGzKQjRiXlgHVynwhrglmsnAwogFMb80P3/BQGcial7OnVEm0rt+0f2MG/JBBol1TUFe+J2pqUyEtpU7rKDcyt7MktOhC77qLBfPlkIUTKyR47pBbNtoEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJzfCiJc; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJzfCiJc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753395376; x=1784931376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VOsrWcJrCpJKt37WVVeZE3pPOc8UDCo9mApEEhIRFYA=;
  b=gJzfCiJc/ndE+aoYplGDFb6+SGOxpDHGqZGr3CIXCh+XPtlA5tOBjoku
   ZM8HxVMFZjnfInbjaBp/a+e9irx+SZHfiHXxxAc2h+j428rnXbr30UUVC
   bwvt5oYAeytzDwfC3E8AqAU8qAujt2gnrkou4+uovRwe3DPQEjCQv0uc0
   9THwb8D7u1vxIPI9n1h6++3IRhahRdfO5u/vn4ntIxbwK4eImZTVXY6fK
   CjeVMCveRt/vzhx/9chVbsZN6VZixw5Q4fW2NOjxSiv9A394yyEfoOCNL
   EcMPKXYSU7XnSpB36wYId/wOlz+5M1/dNEsIEDfygdVPZBw260/ndNr2f
   w==;
X-CSE-ConnectionGUID: rPL0nCJVTdKFrThj3VVcWQ==
X-CSE-MsgGUID: 3IN4gZAZRBe/JcZ/lAmj6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="54941726"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="54941726"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:16:16 -0700
X-CSE-ConnectionGUID: 3Cte6RVxTNi4VVeMPQAhLA==
X-CSE-MsgGUID: 3UmnhAO8QU2eczd8AzfDHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="160504791"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:16:16 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH 3/3] test/common: stop relying on bash $SECONDS in check_dmesg()
Date: Thu, 24 Jul 2025 22:00:46 +0000
Message-ID: <20250724221323.365191-4-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250724221323.365191-1-marc.herbert@linux.intel.com>
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

Stop relying on the imprecise bash $SECONDS variable as a test start
timestamp when scanning the logs for issues.

$SECONDS was convenient because it came "for free" and did not require
any time_init(). But it was not fine-grained enough and its rounding
process is not even documented. Keep using $SECONDS in log messages
where it is easy to use and more user-friendly than bare timestamps, but
switch the critical journalctl scan to a new, absolute NDTEST_START
timestamp initialized when test/common is sourced. Use a SECONDS-based,
rough sanity check in time_init() to make sure test/common is always
sourced early.

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/common | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/test/common b/test/common
index 2d076402ef7c..0214c6aaed5f 100644
--- a/test/common
+++ b/test/common
@@ -15,6 +15,25 @@ err()
 	exit "$rc"
 }
 
+# Initialize the NDTEST_START timestamp used to scan the logs.
+# Insert an anchor/bookmark in the logs to quickly locate the start of any test.
+time_init()
+{
+	# Refuse to run if anything lasted for too long before this point
+	# because that would make NDTEST_START incorrect.
+	test "$SECONDS" -le 1 || err 'test/common must be included first!'
+
+	NDTEST_START=$(LC_TIME=C date '+%F %T.%3N')
+
+	# Log anchor, especially useful when running tests back to back
+	printf "<5>%s@%ds: sourcing test/common: NDTEST_START=%s\n" \
+		"$test_basename" "$SECONDS" "$NDTEST_START" > /dev/kmsg
+
+	# Default value, can be overridden by the environment
+	: "${NDTEST_LOG_DBG:=false}"
+}
+time_init
+
 # Global variables
 
 # NDCTL
@@ -147,11 +166,40 @@ json2var()
 # $1: line number where this is called
 check_dmesg()
 {
+	if "$NDTEST_LOG_DBG"; then
+		# Keep a record of which log lines we scanned
+		journalctl -q -b --since "$NDTEST_START" \
+			-o short-precise > journal-"$(basename "$0")".log
+	fi
+	# After enabling with `NDTEST_LOG_DBG=true meson test`, inspect with:
+	#    head -n 7 $(ls -1t build/journal-*.log | tac)
+	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
+
 	# validate no WARN or lockdep report during the run
-	sleep 1
-	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+	log=$(journalctl -r -k --since "$NDTEST_START")
 	grep -q "Call Trace" <<< "$log" && err "$1"
 	true
+
+	# Log anchor, especially useful when running tests back to back
+	printf "<5>%s@%ds: test/common: check_dmesg() OK\n" "$test_basename" "$SECONDS" > /dev/kmsg
+
+	if "$NDTEST_LOG_DBG"; then
+	    log_stress from_check_dmesg
+	fi
+}
+
+# While they should, many tests don't use check_dmesg(). So double down here. Also, this
+# runs later which is better.
+# Before enabling NDTEST_LOG_DBG=true, make sure no test started defining its own
+# EXIT trap.
+if "$NDTEST_LOG_DBG"; then
+    trap 'log_stress from_trap' EXIT
+fi
+
+log_stress()
+{
+	printf '<3>%s@%ds: NDTEST_LOG_DBG Call Trace; trying to break the next check_dmesg() %s\n' \
+		"$test_basename" "$SECONDS" "$1" > /dev/kmsg
 }
 
 # CXL COMMON
-- 
2.50.1

