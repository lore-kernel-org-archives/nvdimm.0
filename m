Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F3DB665
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 01:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652412; cv=none; b=t1Sc1c5t71H8vqttxk9yqcHiripc6PLr/dxnrFJmKt8WjCdhflQSumocawEkdKw8o5kvZBjhZKrwve1IjiAywvGcjcsdKUWtlHrOCW7eFtGUm05Ez9fq5jrlXU2/KmR9cTK+JmYH21GAR2MT+ygc1/sx2Ex9xBYBTAb6xfWniLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652412; c=relaxed/simple;
	bh=uHb/xFkDx29gBnroHLk9azdfXlhPcC5UcIj5Dj0LQCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UXJccaBZ0XpJUhxQA7q2oHiHjT9m0kdbtUci/tJczuFM/d5485fRwPDuR6WstSOjoJpJjbRPf460QgIkz9kGzTnGHu9b7mqW3zx6cLVnBkWVZG7y5ZY6QAJR+Dh7SYyEGkjuJUrePSwuxejwZvz9/Nlfvd+O9RackW4GLRwfigc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LBBtz3QI; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LBBtz3QI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708652411; x=1740188411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uHb/xFkDx29gBnroHLk9azdfXlhPcC5UcIj5Dj0LQCU=;
  b=LBBtz3QIzv1C74FPBWmBeRP+AIFgyq7cUxaPAqW/v64GnlS5JiNWYzP3
   P8XgFV5ppHbxKSJnd8AcaKfYN/2zQLYtBp0S9GGWmn8hTQWG4pQQA8s8M
   hCTQOoxKA6lZ5kdJZmemyHkYbOGu2ZO3VcF/JLOxq5QU0MGH67y7rTzQs
   B1Vcs0zoA01+hC4xqBsa9w56cYYopj3WwiZt1O2RlW5UczDecAjfObnVz
   qyAHdxBJVNALINu0XDKGcrhvq26wkTqOBOMxBQyqt/lWBPY6vTkZ3TIBp
   SCVQoOFN5uSHNFacZbOa5zBYG2qZGFDwD53hPctq9ceFi85jy5NrQXjX3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="3097991"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="3097991"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10482408"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:09 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 3/3] cxl/test: add 3-way HB interleave testcase to cxl-xor-region.sh
Date: Thu, 22 Feb 2024 17:40:05 -0800
Message-Id: <256021e0e136965ebe92e3900bbe93aab014e28e.1708650921.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1708650921.git.alison.schofield@intel.com>
References: <cover.1708650921.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

cxl-xor-region.sh includes test cases for 1 & 2 way host bridge
interleaves. Add a new test case to exercise the modulo math
function the CXL driver uses to find positions in a 3-way host
bridge interleave.

Skip this test case, don't fail, if the new 3-way XOR decoder
is not present in cxl/test.

Add the missing check_dmesg helper before exiting this test.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-xor-region.sh | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index e536f0256202..b9e1d79212d3 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -87,11 +87,44 @@ setup_x4()
 	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
+setup_x3()
+{
+	# find an x3 decoder
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 3) |
+		.decoder")
+
+	if [[ ! $decoder ]]; then
+		echo "no x3 decoder found, skipping xor-x3 test"
+		return
+	fi
+
+	# Find a memdev for each host-bridge interleave position
+	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 0) | .target")
+	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 1) | .target")
+	port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
+		.targets | .[] | select(.position == 2) | .target")
+	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
+	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
+	mem2=$($CXL list -M -p "$port_dev2" | jq -r ".[0].memdev")
+	memdevs="$mem0 $mem1 $mem2"
+}
+
 setup_x1
 create_and_destroy_region
 setup_x2
 create_and_destroy_region
 setup_x4
 create_and_destroy_region
+# x3 decoder may not be available in cxl/test topo yet
+setup_x3
+if [[ $decoder ]]; then
+	create_and_destroy_region
+fi
+
+check_dmesg "$LINENO"
 
 modprobe -r cxl_test
-- 
2.37.3

