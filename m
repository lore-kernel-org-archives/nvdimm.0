Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41101A3166
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 00:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781137173; cv=none; b=XhtQE8eUhsizLtX8qoNHq4kGikRp1Rffu14+gxjCTVRaNkwXTktd+MeORnWhGtqZnEPGAtgYH7VsmYw84YeMGBUYJETBdtLfQD38eJNvsdqMmGXHuIIBqQrx4vVKUItDG7bEwYTSuBD6MSNhnFKLmAEiR0OS+KDtbQ/C9/gZQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781137173; c=relaxed/simple;
	bh=DH6dugzs3ehSD4MRH2PCC1byzEHK65hv0gCFpARWDnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKeDChQ1R9iQIlpd0KdPA42FCW0p/zjycvlmrd3N9hdKdGA0Hd5SBL0rrenKR4XoZS9hHQrj51Bi8sYKyaLpwzgBFd6Y2sRin347i2yuadIXMxd/U9nL+BEs2i+dLf5Gqo24yhbRC9ZqQgSnQ2+ip27y4SFh4deBm+oU9ClpYrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzihZEb9; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzihZEb9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781137172; x=1812673172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DH6dugzs3ehSD4MRH2PCC1byzEHK65hv0gCFpARWDnk=;
  b=UzihZEb9ID+HZbHyvgDpuVQFFiX3ipxFiGV00fxVXIvulmmmJnFNgtQ1
   rCVFRCfctMGlSDsq88UIORYp5t8A4qgUIORnPgBazX8dH7sK4ascVAXmS
   5OBTe7j3bSEGA1db4XUG6J9RX1MUvgV+oZfmqpEXyyZMr+xfAbwQke7SY
   4TLs46MI/xKbozcBjDMGmDscmjFUxolNR8h1dr0NEmPbBNXgKItr2nhxp
   7nMpJ5wclIt7isBds0pNDNVB6XUd267qpCaWFq0R4o8r5wtAkXKx8gveJ
   Xeuz17tSJYDfRI3LHWnAK8N21NtCFUYRW4wtR4XQofcN3mK7GCJHkTuCT
   Q==;
X-CSE-ConnectionGUID: 54MdvoBxTPWzeBEosp/B5w==
X-CSE-MsgGUID: h7pzDRdYQXeP70amFwPJ0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82054172"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="82054172"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 17:19:30 -0700
X-CSE-ConnectionGUID: faHe5xMCQnCgxptVhJiLJg==
X-CSE-MsgGUID: ae/fApmeTzKA0P7rVwmQVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="242181829"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.46])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 17:19:30 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 3/3] test/cxl-create-region.sh: add passthrough >16K granularity test case
Date: Wed, 10 Jun 2026 17:19:21 -0700
Message-ID: <b7a3c495100ca0ca85c980770a254fcf9b307ae6.1781136221.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1781136221.git.alison.schofield@intel.com>
References: <cover.1781136221.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CXL driver region configuration use to reject valid topologies
containing passthrough decoders beneath a wide parent interleave.
A recent kernel patch fixed that issue and extended cxl-test with
a topology that exercises it.

Add a create-and-destroy region case spanning the two host bridges
beneath the new 2-way 16K root decoder to verify that such
configurations are accepted.

The test case is quietly skipped if the new cxl/test topology is
not found, which also means the kernel fix is not yet present.

Assisted-by: Claude:Opus-4-8
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-create-region.sh | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/test/cxl-create-region.sh b/test/cxl-create-region.sh
index 5941e18f338d..c24e477c4f5c 100644
--- a/test/cxl-create-region.sh
+++ b/test/cxl-create-region.sh
@@ -170,10 +170,12 @@ setup_x1()
 
 setup_x2()
 {
-	# Find an x2 decoder
+	# Find an x2 decoder. Pin to the 256 granularity root to avoid
+	# the 16K root used by the passthrough granularity test.
 	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
 		select(.pmem_capable == true) |
 		select(.nr_targets == 2) |
+		select(.interleave_granularity == 256) |
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
@@ -184,10 +186,12 @@ setup_x2()
 
 setup_x4()
 {
-	# find an x2 decoder
+	# find an x2 decoder. Pin to the 256 granularity root to avoid
+	# the 16K root used by the passthrough granularity test.
 	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
 		select(.pmem_capable == true) |
 		select(.nr_targets == 2) |
+		select(.interleave_granularity == 256) |
 		.decoder")
 
 	# Find a memdev for each host-bridge interleave position
@@ -198,6 +202,23 @@ setup_x4()
 	memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 
+setup_passthru_gran()
+{
+	# Find the 2-way 16K root. A region spanning both host bridges
+	# places one endpoint under each. The intermediate switch decoders
+	# are passthrough decoders with 32K granularity.
+	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
+		select(.pmem_capable == true) |
+		select(.nr_targets == 2) |
+		select(.interleave_granularity == 16384) |
+		.decoder")
+
+	# Find a memdev for each host-bridge interleave position
+	mem0=$(find_memdev "$decoder" 0 0)
+	mem1=$(find_memdev "$decoder" 1 0)
+	memdevs="$mem0 $mem1"
+}
+
 setup_x3()
 {
 	# find an x3 decoder
@@ -252,6 +273,11 @@ setup_x3
 if [[ $decoder ]]; then
 	create_and_destroy_region
 fi
+# 16K root may not be available in cxl/test topo yet
+setup_passthru_gran
+if [[ $decoder ]]; then
+	create_and_destroy_region
+fi
 
 check_dmesg "$LINENO"
 
-- 
2.37.3

