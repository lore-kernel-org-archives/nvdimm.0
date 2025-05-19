Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4C20E719
	for <nvdimm@lists.linux.dev>; Mon, 19 May 2025 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747682946; cv=none; b=doxDbsN6Sh40AbJMRh4OzGa9heljD4PD0wZwiQUWl2ssWY9dIVJAAV+jFrBJdXUuL87Yx8eRHFdssknbpJUF//lI+JjZ4GPmrK98yb8BlgtQUo3yZok84ccmIFh3mj3Su5LUmEFZLHTakB+e3LM5aA0r2DZ32lBdCUmZmBbZnSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747682946; c=relaxed/simple;
	bh=JUIXNfjoB4LSe4KPNAlyjg4xWcdtFtm/JV9Pn68kPFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VoIS23sBbIGgUZDvIowJJzAlmA8jneYhe7Vsxmt37II5tywuD+3Ky6GiNwBRRdgE+VQaO6BeLoNpMhNKDkEvcYAz4s/iyvso1iPhPJxYbUAqJBgyTS/6mlV5XDhrQ2Hv2bkDYfO4gVS9twsI3ljxdcnYNqI2M65U5shq+SDtKhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1F3J8lO; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1F3J8lO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747682944; x=1779218944;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JUIXNfjoB4LSe4KPNAlyjg4xWcdtFtm/JV9Pn68kPFs=;
  b=m1F3J8lOXe2I8RDYi+ZaFGk2qoJV4poTq5shCsCXydMFSxyg8FFtM5fI
   TkPA+FVEcDDQVYQJUgTl7r8hS4yUwCNBhkFAjOmm1EzoJHRul8129hJgm
   FVwzcsaS5mWKq/Aj+YwjcvTTj57tMpa1qYemNuVf8KgqtHRB7XYOsb3Dw
   VobcotWaZ/T+HNHEJshfTxtUx85SyVuC4Jx3xC4AUGgdd8ov+2TXthaNL
   FkauSYVXz5Ib9e/LMEMnj3tCYRvZcSj7nWAumlKJCZOfdQyxqf+jrUAgB
   q4ytVZEY0qZQayY38EduxmJDOxsfS35ZqLjDmU2Adoos4XdIcv/sSxiMs
   w==;
X-CSE-ConnectionGUID: 2TZ84nu0RHWk1FS6uHKU7Q==
X-CSE-MsgGUID: OPqNE3twTsKiox2oxq6hIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="67150898"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="67150898"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 12:29:02 -0700
X-CSE-ConnectionGUID: ejlzTKMyT7uA4GsCwjqXgg==
X-CSE-MsgGUID: 0nieJNnbTYuDUL6PJxvB1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="162758800"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.100])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 12:29:02 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	Marc Herbert <marc.herbert@linux.intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v3] test/monitor.sh: replace sleep with event driven wait
Date: Mon, 19 May 2025 12:28:56 -0700
Message-ID: <20250519192858.1611104-1-alison.schofield@intel.com>
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
and 3 seconds before checking for expected log entries.

Add a wait_for_logfile_update() helper that waits a max of 3 seconds
for an expected string to appear N times in the logfile using tail -F.

Add a "monitor ready" log message to the monitor executable and wait
for that message once after monitor start. Note that if no DIMM has an
event flag set, there will be no log entry at startup. Always look for
the "monitor ready" message.

Expand the check_result() function to handle both the sync and wait
that were previously duplicated in inject_smart() and call_notify().
It now waits for the expected N of new log entries.

Again, looking for Tested-by Tags. Thanks!

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes in v3:
- Add and use a helper that uses tail -F
- Add ready message to monitor.c
- Update commit msg and log
Link to v2: https://lore.kernel.org/nvdimm/20250516044628.1532939-1-alison.schofield@intel.com/

Changes in v2:
- Poll for 3 seconds instead of removing sleep entirely (MarcH)
- Update commit msg & log
Link to v1: https://lore.kernel.org/nvdimm/20250514014133.1431846-1-alison.schofield@intel.com/


 ndctl/monitor.c |  2 +-
 test/monitor.sh | 24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index bd8a74863476..925b37f4184b 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -658,7 +658,7 @@ int cmd_monitor(int argc, const char **argv, struct ndctl_ctx *ctx)
 			rc = -ENXIO;
 		goto out;
 	}
-
+	info(&monitor, "monitor ready\n");
 	rc = monitor_event(ctx, &mfa);
 out:
 	if (monitor.ctx.log_file)
diff --git a/test/monitor.sh b/test/monitor.sh
index be8e24d6f3aa..d0666392ab5b 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -21,12 +21,28 @@ trap 'err $LINENO' ERR
 
 check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
 
+wait_for_logfile_update()
+{
+	local expect_string="$1"
+	local expect_count="$2"
+
+	# Wait up to 3s for $expect_count occurrences of $expect_string
+	# tail -n +1 -F: starts watching the logfile from the first line
+
+	if ! timeout 3s tail -n +1 -F "$logfile" | grep -m "$expect_count" -q "$expect_string"; then
+		echo "logfile not updated in 3 secs"
+		err "$LINENO"
+	fi
+}
+
 start_monitor()
 {
 	logfile=$(mktemp)
 	$NDCTL monitor -c "$monitor_conf" -l "$logfile" $1 &
 	monitor_pid=$!
-	sync; sleep 3
+
+	sync
+	wait_for_logfile_update "monitor ready" 1
 	truncate --size 0 "$logfile" #remove startup log
 }
 
@@ -49,17 +65,19 @@ get_monitor_dimm()
 call_notify()
 {
 	"$TEST_PATH"/smart-notify "$smart_supported_bus"
-	sync; sleep 3
 }
 
 inject_smart()
 {
 	$NDCTL inject-smart "$monitor_dimms" $1
-	sync; sleep 3
 }
 
 check_result()
 {
+	sync
+	expect_count=$(wc -w <<< "$1")
+	wait_for_logfile_update "timestamp" "$expect_count"
+
 	jlog=$(cat "$logfile")
 	notify_dimms=$(jq ."dimm"."dev" <<<"$jlog" | sort | uniq | xargs)
 	[[ "$1" == "$notify_dimms" ]]
-- 
2.37.3

