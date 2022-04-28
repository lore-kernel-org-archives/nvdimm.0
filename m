Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C5D136A
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 19:08:43 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 813AA1F37F
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 19:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1651172921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9H1G4eJL5KRj6HixvwdY1smhjo1SmkblwFHf9e/BsdI=;
	b=cBPNVvbSCKPPjxHViF2FDKlmx4HvLzS0muIAV1fMKI+Y0+BJ3GHDbJISRXend5ljTsPv/B
	BljVbJAdV1NpNlyWv3LSL+Wh0SQWmWt59TjinMmwB0Aj84gVT70GrkIPrT3Q4MyCOFkeJH
	4d9GIx1lhbEvCxp2wR0S+OHpiaLZ0Qg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1651172921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9H1G4eJL5KRj6HixvwdY1smhjo1SmkblwFHf9e/BsdI=;
	b=oBiqAo+l7QVgy4YLjV1B2hy+xVHcWBkB/asZb/jmGBdwVIfT+6BsX3VZ6+9RtT/p1ZeApM
	WmmvCyz5UEEFOBDw==
Received: from naga.suse.cz (unknown [10.100.224.114])
	by relay2.suse.de (Postfix) with ESMTP id 608A12C141;
	Thu, 28 Apr 2022 19:08:41 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH ndctl] test: monitor: Use in-tree configuration file
Date: Thu, 28 Apr 2022 21:08:31 +0200
Message-Id: <20220428190831.15251-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.36.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ndctl is not installed /etc/ndctl.conf.d does not exist and the
monitor fails to start. Use in-tree configuration for testing.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 test/monitor.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index e58c908..c5beb2c 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -13,6 +13,8 @@ smart_supported_bus=""
 
 . $(dirname $0)/common
 
+monitor_conf="$TEST_PATH/../ndctl"
+
 check_prereq "jq"
 
 trap 'err $LINENO' ERR
@@ -22,7 +24,7 @@ check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
 start_monitor()
 {
 	logfile=$(mktemp)
-	$NDCTL monitor -l $logfile $1 &
+	$NDCTL monitor -c "$monitor_conf" -l $logfile $1 &
 	monitor_pid=$!
 	sync; sleep 3
 	truncate --size 0 $logfile #remove startup log
-- 
2.36.0

