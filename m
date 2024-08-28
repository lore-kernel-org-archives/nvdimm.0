Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ABD1ABEC7
	for <nvdimm@lists.linux.dev>; Wed, 28 Aug 2024 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724873425; cv=none; b=N7fG1+J3NKCF41ABXdRxjQQuMUU77Tr3WObsXRDQpO5MJmeIvickoj3VedVDvc/2w12tCSq82gMXbck6wJJpSuer8aE+bwuw/SVrguJ2IbEhdKExSNJK9P5HAHkT/zXk9ghuGk5vGV+PCTA7XIUPaVFz8B4uuylHS9tRnil2rmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724873425; c=relaxed/simple;
	bh=jeX0Fofx9zzQfBkH13GF4C1KtpUV2i3fVSqDonKRQFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fDreU03aN9bKYVQWT+2PZcHdv39BftazAkGWmo0cCmMR8ZC+PYXoOIYwa0EWyG+fhNZ4H7EFwfLZmQ2ClZRGXA//s+kyiKwIcqs/gxeyr7/ZSx2pe8ukVD0+RMr3gbBxBfYtHR1lALEEKC3RkTdDfMnL/9RHnvM+4kZMJCerwkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hctVlIrc; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hctVlIrc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724873424; x=1756409424;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jeX0Fofx9zzQfBkH13GF4C1KtpUV2i3fVSqDonKRQFA=;
  b=hctVlIrcA4mu6iEuixEy4RuTUTLt0jKPPkYVks7zd5hKBP83zZkDNOIv
   o4zze+OAfhQi81z7ZTwWD+CS1IMxgu+tC89RBA5/+4xQ8upzwYHPR9ger
   nWtMpz5yUew6NeGQmhgbEN6zvRUGIM5S+d6R+N/zYS/Y2mz6iz9roi2G2
   IYvUlAOJQK9GAKn5MNWLe2QXpdsi8UDiZ/pX7r62EgTEPGHei7EJa3cvh
   Y3d1hC0PLeTFHzREnRJnaz1CTbIdYYObptv2FcBWU+bIr7VTMFnZOKqv3
   v9BOoaw4opcGVF9p/lUpnC0gA9wk7JrLVcUc1EK8FtQqqZED7ly8/+RG5
   A==;
X-CSE-ConnectionGUID: kQ9jLOR9S+mJnIv5k5AwTg==
X-CSE-MsgGUID: /TzAbdxXQtylIwATl2xQrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="40934763"
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="40934763"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 12:26:26 -0700
X-CSE-ConnectionGUID: MkLNDxipSVun/8wbPyGyXA==
X-CSE-MsgGUID: kzV787/cRUqFAhcXxfUqww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="86524961"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.98])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 12:26:25 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH] test/rescan-partitions.sh: refine search for created partition
Date: Wed, 28 Aug 2024 12:26:17 -0700
Message-ID: <20240828192620.302092-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Unit test rescan-partitions.sh can fail because the grep test looking
for the expected partition is overly broad and can match multiple
pmem devices.

/root/ndctl/build/meson-logs/testlog.txt reports this failure:
test/rescan-partitions.sh: failed at line 50

An example of an improper grep is:
'pmem10 pmem12 pmem1p1' when only 'pmem1p1' was expected

Replace the faulty grep with a query of the lsblk JSON output that
examines the children of this blockdev only and matches on size.

This type of pesky issue is probably arising as the unit tests are
being run in more complex environments and may also be due to other
unit tests not properly cleaning up after themselves. No matter the
cause this change makes this test more robust and that's a good thing!

Reported-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/rescan-partitions.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
index 51bbd731fb55..ccb542cb2f68 100755
--- a/test/rescan-partitions.sh
+++ b/test/rescan-partitions.sh
@@ -24,6 +24,7 @@ check_min_kver "4.16" || do_skip "may not contain fixes for partition rescanning
 
 check_prereq "parted"
 check_prereq "blockdev"
+check_prereq "jq"
 
 test_mode()
 {
@@ -46,7 +47,10 @@ test_mode()
 	sleep 1
 	blockdev --rereadpt /dev/$blockdev
 	sleep 1
-	partdev="$(grep -Eo "${blockdev}.+" /proc/partitions)"
+	partdev=$(lsblk -J -o NAME,SIZE /dev/$blockdev |
+		jq -r '.blockdevices[] | .children[] |
+		select(.size == "9M") | .name')
+
 	test -b /dev/$partdev
 
 	# cycle the namespace, and verify the partition is read
-- 
2.37.3

