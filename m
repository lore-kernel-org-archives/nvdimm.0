Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3912420DF7
	for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 04:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600652; cv=none; b=fm96lopESJT5+QlnoUSWwluKP8itu6GJUgbI+vOC4bcnfywWZ0xjy4J3HuqBRgZ6bPMzTsRFPT+w/UVBIrIHdzXqZ2+D6Dsb2gUTNHMvfnURLL/iJvGDIMLM0isgrmiGICWkUuqiQsuqttC1ncTF5I8TWjKfIDeRPNghVcHPGwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600652; c=relaxed/simple;
	bh=NZWk238xAHDeY9JH8FrITbsIR8ggf5Jdl6N+d/iwPSo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qa60stEUOJlMh3U/on7WVi0urASzRyl4oaBeyPkeqekvJxQUpW543JyVw8/tw6Bah4aoKASM9lslS0v/80CRz+9gz8vaWzo5oabSVc15Xgo/9yxnouGX6iYzE7bH157A8QZ/xCthdeFZ6RIj4FQ7soG2WlNnpPyl45ZPA1GF0eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=moDlite7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="moDlite7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711600651; x=1743136651;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NZWk238xAHDeY9JH8FrITbsIR8ggf5Jdl6N+d/iwPSo=;
  b=moDlite7ME9N7DTX+QV/4Yd9Q4jMJkM3jkgRcr8szfIxfbtPdx6dIzJD
   5Dtze1qyR3WsBTsV5c5G+dMIOvqfx2RfwfqCcwpsDOv4EjM+8J7zcjQFE
   xs2Kj8QPX9kqS15DHxhihF36iu4eOuQkHCUb97/ulqj5uJlUVEUTK/Chd
   J4Xz3EVZh76PIWsylYjHQ7ol3zbUQAvGcrpE70uYClZubFvSLT0j+aips
   w1r6Jg3hlyNCa1EWqsw59z2b5FOo0bByeyMzuTCYJ+y0Mc11I6yHGPvld
   l7iWrEhTrF635B8XlBtVQA0QiZyVhBLo7lMge31kUqYkuUsZUMVyYrhKi
   w==;
X-CSE-ConnectionGUID: D9XVI+HQQZuvVVfWb96shw==
X-CSE-MsgGUID: rwd8sgTWSbuGJ1dhED1dYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6672691"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6672691"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 21:37:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="47506111"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 21:37:31 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: Add test case for region info to cxl-events.sh
Date: Wed, 27 Mar 2024 21:37:26 -0700
Message-Id: <20240328043727.2186722-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Events cxl_general_media and cxl_dram both report DPAs that may
be mapped in a region. If the DPA is mapped, the trace event will
include the HPA translation, region name and region uuid in the
trace event.

Add a test case that triggers these events with DPAs that map
into a region. Verify the region is included in the trace event.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-events.sh | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index fe702bf98ad4..ff4f3fdff1d8 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -23,6 +23,26 @@ modprobe cxl_test
 rc=1
 
 dev_path="/sys/bus/platform/devices"
+trace_path="/sys/kernel/tracing"
+
+test_region_info()
+{
+	# Trigger a memdev in the cxl_test autodiscovered region
+	region=$($CXL list  -R | jq -r ".[] | .region")
+	memdev=$($CXL list -r "$region" --targets |
+		jq -r '.[].mappings' |
+		jq -r '.[0].memdev')
+	host=$($CXL list -m "$memdev" | jq -r '.[].host')
+
+	echo 1 > "$dev_path"/"$host"/event_trigger
+
+	if ! grep "cxl_general_media.*$region" "$trace_path"/trace; then
+		err "$LINENO"
+	fi
+	if ! grep "cxl_dram.*$region" "$trace_path"/trace; then
+		err "$LINENO"
+	fi
+}
 
 test_cxl_events()
 {
@@ -74,6 +94,10 @@ if [ "$num_info" -ne $num_info_expected ]; then
 	err "$LINENO"
 fi
 
+echo 1 > /sys/kernel/tracing/tracing_on
+test_region_info
+echo 0 > /sys/kernel/tracing/tracing_on
+
 check_dmesg "$LINENO"
 
 modprobe -r cxl_test
-- 
2.37.3

