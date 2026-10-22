Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792698981;
	b=mvyqNYT6Ay0yewd+3+Eu9mOI15X+uNWAb6a+Iogh+hCrKJZE7UmqTytUAeUxcicfTvph
	 YlyaW4bW5dQsG4Gva1R90EultEOQwoeE2nTx4EWjR75uUHpKKV0schIVG22ICUDWesJCx
	 uGFZUWzSN84YpoReSpMQsdJTFh7yptgSMZs7gtD10x8HXBBPWv2IGOWrdM2Udc1APej1t
	 pUrFjgpqXmKqRXRQzETqccQwndc6KxMk9acu7sKFQQbzu0VnLNIhscOJVs2xYClY2esql
	 pvn+OGKLzxnRxwKD5+LtmfV7wLrTaGFg1bW+QK962972w1cDC2ozpS8BHG0ExgL5wVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698981;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f9YAkP4EChXw6CfYgFXeTIlroWld35HM4kuV8CGF/40=;
	b=j8wnItV7Ud7JE5eUXpex+DPQQseBNa9OeZb15f8nB69mtivwF62ZkpaeGchoziuuGfEO
	 Zlq2qhpgt1rNedIl/DKDtu7Je6UhSxc9W6b1D1/PHuN/xFPBV+HPNMw9sXfsSxPlbF4rk
	 Y9fLAgE2VuATzSQzxnYV40WyBi9m4moB1JVZSIl1vNQw0lSaW9EMsHsVPo3eIyr3dTEE0
	 Kw+L2Jp/BmniJigGohldLR967kr4x1WRicKNj/JIb0AEB5X48aEA75cNUQkLqG4BpLYNp
	 pGZeAASEjnDPTTb+zLWWx94GCHiNEhyLQEY0frN9MMjwphPww3kgD9e6UCXe/CQz+nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WECH6Opa;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FF3606A31E
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 19:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38FF3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WECH6Opa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792698981; x=1824234981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eKA/49eRBoRPVNpSgtmpfqWQM+GEt74BGoEDdw2pJzQ=;
  b=WECH6OpanFYHpe47jF91dnn+AqEmIhd7OBGX2s45iCs3edH9ysHsfXh5
   S279mkrr2PSVOCnWf7Kck5qw8JhvlRg0592mfe6QmUYfWVGCQfvyMybHG
   OUmY1nI3f5bilZDw4ItK0GVEoDQMfL4fM0oN1/S4i3CTMwPY5q6RjfZD7
   oIln+4VtI7Kzuwf2h1aUd6nC7459+DpJXmy2pYCCySN/l9VGehlx6iTfm
   wnvlhRK0kfn7vKFfhM0+CkQdrdRHtFYSJFfiKTSTZqsHsJiy+AWg7NkSI
   Dk5mtuXXqEziG0ZHPSCHehB7VjP+Ifr/WutXsT0mY2x/UWrD138WqpxYi
   Q==;
X-CSE-ConnectionGUID: l/qj5A49SuGFmPQiNsaWJg==
X-CSE-MsgGUID: bPiaPqi/Q+ataxn7KFgsiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1356741"
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="1356741"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 12:56:19 -0700
X-CSE-ConnectionGUID: G78wQavaQTKzgIvyaRzzQQ==
X-CSE-MsgGUID: Sjn9lfM+RNSQa9hm9HGEag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="3839600"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.215])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 12:56:19 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Gregory Price <gourry@gourry.net>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 4/4] test/daxctl-create.sh: count memory blocks across dax mappings
Date: Thu, 22 Oct 2026 12:56:13 -0700
Message-ID: <55162d83dfab6101fca10df09b6baacac1834b17.1792695259.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Existing tests use single-range devices and cannot detect incorrect memory
block accounting across discontiguous mappings. A two-range device exposed
this bug by reporting only one of its two blocks.

Create a device with two separated mappings and verify its memory block
count against the expected count from both mappings.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/daxctl-create.sh | 58 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/test/daxctl-create.sh b/test/daxctl-create.sh
index 954a112d0f18..c4fe369eac3a 100755
--- a/test/daxctl-create.sh
+++ b/test/daxctl-create.sh
@@ -7,6 +7,9 @@ rc=77
 
 trap 'cleanup $LINENO' ERR
 
+policy=/sys/devices/system/memory/auto_online_blocks
+saved_policy=
+
 modprobe -r cxl_test
 modprobe cxl_test
 $CXL list
@@ -14,6 +17,7 @@ $CXL list
 cleanup()
 {
 	printf "Error at line %d\n" "$1"
+	[[ $saved_policy ]] && echo "$saved_policy" > "$policy"
 	[[ $testdev ]] && reset_dax
 	exit $rc
 }
@@ -396,6 +400,59 @@ daxctl_test7()
 	test_pass
 }
 
+# Test 8: multi-range system-ram
+# Successfully counts every memory block of a device whose two ranges
+# have a gap between them. The memory is never onlined: cxl_test memory
+# is not backed by RAM.
+daxctl_test8()
+{
+	local daxdev_1 daxdev_2 daxdev path m start end n nmaps=0 total=0
+	local bs size
+
+	bs=$((0x$(cat /sys/devices/system/memory/block_size_bytes)))
+	size=$((available / 4))
+	if (( size < bs || size % bs )); then
+		echo "test8: skipped, region too small for $bs byte memory blocks"
+		return 0
+	fi
+
+	# a devdax device in the gap between the two ranges, it has no
+	# memory blocks to be miscounted
+	daxdev_1=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
+	daxdev_2=$("$DAXCTL" create-device -r "$region_id" -s $size | jq -er '.[].chardev')
+	test -n "$daxdev_2"
+	"$DAXCTL" disable-device "$daxdev_1" && "$DAXCTL" destroy-device "$daxdev_1"
+
+	daxdev=$("$DAXCTL" create-device -r "$region_id" -s $((size * 2)) | jq -er '.[].chardev')
+	test "$(daxctl_get_nr_mappings "$daxdev")" -eq 2
+
+	# memory blocks wholly inside each mapping
+	path=$(readlink -f /sys/bus/dax/devices/"$daxdev")
+	for m in "$path"/mapping[0-9]*; do
+		start=$(cat "$m"/start)
+		end=$(cat "$m"/end)
+		n=$(((end + 1) / bs - (start + bs - 1) / bs))
+		(( n > 0 ))
+		total=$((total + n))
+		nmaps=$((nmaps + 1))
+	done
+	test "$nmaps" -eq 2
+
+	saved_policy=$(cat "$policy")
+	echo offline > "$policy"
+	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
+	test "$("$DAXCTL" list -d "$daxdev" | jq -er '.[].total_memblocks')" -eq "$total"
+	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+	echo "$saved_policy" > "$policy"
+	saved_policy=
+
+	"$DAXCTL" disable-device -r "$region_id" all
+	"$DAXCTL" destroy-device -r "$region_id" all
+
+	clear_dev
+	test_pass
+}
+
 find_testdev
 rc=1
 setup_dev
@@ -407,6 +464,7 @@ daxctl_test4
 daxctl_test5
 daxctl_test6
 daxctl_test7
+daxctl_test8
 reset_dev
 modprobe -r cxl_test
 exit 0
-- 
2.37.3

