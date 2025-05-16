Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC612376
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 04:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747370794; cv=none; b=Izzjy8eyXFqipxodUGBJhqOkkxxeR5lRFfIQfTws4yvlpkJ5F9IuDK5oI3COZRrt7FdWe6VLt5MU9VwFyJTCEH1NaGhUWbBfcJhiAo/uQoFpZt4jrTta99zuJc8hHPZNwiFmbYSLxMBaQoHPa9MDFOeXJuv9AdX+8elsINgL1/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747370794; c=relaxed/simple;
	bh=tRn91aYyJzDmRqA+FlUlAnKWG/TS7kv8UOHnFLfm01I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mWpRWckFkSUtMp+C+XtZ2j/0LayDZTWoCAAoM5WdPVlrIGwy2wWcyTp+zaQs3Er2Sa/B/Q6YDCcuzRWncp+QzYzItS6vogC3dvWauRurYxG//QAUL7hZFdtieSyEqFfXsLJkniE5KAxeoTvxc/UOSmLjMCH8ElBdULJuud/ppBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hHPylGod; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hHPylGod"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747370792; x=1778906792;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tRn91aYyJzDmRqA+FlUlAnKWG/TS7kv8UOHnFLfm01I=;
  b=hHPylGodjz2JfmQjROCtYcSAi1svNTXEfQrqdG53UCUkT10RH4trKwJY
   gI7sfkfZR0s/rXRxmpROb8mKJHl6K+KyOuWdwN0GzqcoI0s6fKiZjhhAZ
   j4yJEZlFpDgEeL0GHax8z2yN0qw95ihYwhocncWNkeo6TScm6OLBFbOWX
   w4sEJAr8Y5epz3pyMg8KUu12tBKNqRDSnU9b3XzE9QzPfBN88IX+Hvo0z
   nUd77k550z3uLRIMkfCHQSrh9DLwgOAmyC1pI8ScHMKghVOMhZQmlEFax
   oHhSN7gcIfmMO31ehRAWZPIonSFUFtlJnm9CavHntMSruF57Ugl+tayct
   Q==;
X-CSE-ConnectionGUID: qwxt9rdrQo6GM8JHeRVT2g==
X-CSE-MsgGUID: DmAhbrkQQqeyxBunD3vxTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="60355178"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="60355178"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 21:46:32 -0700
X-CSE-ConnectionGUID: MjKdnbVUTiS0ks70aMSSIg==
X-CSE-MsgGUID: uCamylTHSaKm6d9VyY4q1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="169643223"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.206])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 21:46:31 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	Marc Herbert <marc.herbert@linux.intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2] test/monitor.sh: replace sleep with polling after sync
Date: Thu, 15 May 2025 21:46:23 -0700
Message-ID: <20250516044628.1532939-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

monitor.sh runs for 50 seconds and spends 48 of those seconds sleeping
after sync. It sleeps for 3 seconds each time it restarts the monitor,
and 3 seconds before checking for expected log entries, a total of
16 naps.

Replace the sleeps with polling that waits for a max of 3 seconds but
does so in 30 0.1 second intervals. This leaves the current behavior
in place but offers a shorter run time for system configs capable of
a faster sync.

Again - I'd like to see some Tested-by's on this one because it wouldn't
be the first time my golden environment wasn't representative of all
environments where these tests are run. Thanks!

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v2:
- Poll for 3 seconds instead of removing sleep entirely (MarcH)
- Update commit msg & log
Link to v1: https://lore.kernel.org/nvdimm/20250514014133.1431846-1-alison.schofield@intel.com/

 test/monitor.sh | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index be8e24d6f3aa..61cad098d87c 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -21,12 +21,45 @@ trap 'err $LINENO' ERR
 
 check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
 
+wait_for_logfile_update()
+{
+	local file="$1"
+	local prev_size="$2"
+	local timeout=30
+	local i=0
+
+	# prev_size is always zero because start_monitor truncates it.
+	# Set and check against it anyway to future proof.
+	while [ $i -lt $timeout ]; do
+		local new_size=$(stat -c%s "$file" 2>/dev/null || echo 0)
+		if [ "$new_size" -gt "$prev_size" ]; then
+			return 0
+		fi
+		sleep 0.1
+		i=$((i+1))
+	done
+
+	echo "logfile not updated within 3 seconds"
+	err "$LINENO"
+}
+
 start_monitor()
 {
 	logfile=$(mktemp)
 	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
 	monitor_pid=$!
-	sync; sleep 3
+	sync
+	for i in {1..30}; do
+		if ps -p "$monitor_pid" > /dev/null; then
+			sleep 0.1
+			break
+		fi
+		sleep 0.1
+	done
+	if ! ps -p "$monitor_pid" > /dev/null; then
+		echo "monitor not ready within 3 seconds"
+		err "$LINENO"
+	fi
 	truncate --size 0 "$logfile" #remove startup log
 }
 
@@ -48,14 +81,18 @@ get_monitor_dimm()
 
 call_notify()
 {
+	local prev_size=$(stat -c%s "$logfile")
 	"$TEST_PATH"/smart-notify "$smart_supported_bus"
-	sync; sleep 3
+	sync
+	wait_for_logfile_update "$logfile" "$prev_size"
 }
 
 inject_smart()
 {
+	local prev_size=$(stat -c%s "$logfile")
 	$NDCTL inject-smart "$monitor_dimms" $1
-	sync; sleep 3
+	sync
+	wait_for_logfile_update "$logfile" "$prev_size"
 }
 
 check_result()
-- 
2.37.3

