Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1E5223DDD
	for <nvdimm@lists.linux.dev>; Fri, 22 Aug 2025 02:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755831375; cv=none; b=V1oKeYWKFVyP+r82+M79fFjv8qMFev7LU5Cr++6kD4zd/TvqCadEkgweNIzAfR5zVRHQU4Ud6F+b/76dy6vh+APoS1j/qEjR+gHa6f+27oyPzPCdoAMOuVMag7HZPZ06ZyMPv+MXw29kSbZO5/ayIYDtyyrd0cMTQfMWEM8uDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755831375; c=relaxed/simple;
	bh=v1wAmUFk7VpL2pz/8tCAwLF8wqqysgQ7YtsCmHsH4FI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oo8SR/a/Ph9K9xVMndGqzHQvW7k6V1vunyaq19Wu+6NRecXpH7CSflwgWe1YM8RuL4VPihAtbpPM6RuUQy6fRKjWx6OrJ0VwmoLIcYZfr89bj2SqPT7nquSJkwIPMLfI/eyKLa6IeXNRbSH59x8cTnRzqtVA8dPiVGZUboQUlE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8Jyy853; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8Jyy853"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755831374; x=1787367374;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v1wAmUFk7VpL2pz/8tCAwLF8wqqysgQ7YtsCmHsH4FI=;
  b=R8Jyy853pOLiLdPiaGu+rXlOJYTOcYt1yIerLTFNPSFi+9xfJZKRo+9D
   WHSZTNxk5n8ytd5Y3+WaPJyQLwFC9Br7L+OgLV6SdUy2AODPxk+g8Mu6z
   CtCUjtqHxSoYs9hc/hVGMxT8A6JFqlvrllw13XulqhuToZ+t+kppKemig
   NRbbYr0yQR2IvQ8r8+dtOmeQNodjbBnSJrSoTo47iOvC0ePCUgNE4Pes3
   jrvyl11/Aasn9oWFhWgbvvRwCqmQq2xQ4keF50rTDTXwWqzuVZCVm7rQt
   UMza/F52Q/Qm/a5k4e+lrZ7i/Rz18Im9w03LKWnrPedm6AHf53R9jv6Bn
   A==;
X-CSE-ConnectionGUID: x1A9Bcn0QYS3LsUWV9pYtw==
X-CSE-MsgGUID: 8D8wLk3SQMmvd+S+lkQNfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="61943099"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="61943099"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 19:56:13 -0700
X-CSE-ConnectionGUID: MZpQ65/gS7Kt3lzxfF7PYg==
X-CSE-MsgGUID: wGOn5uDgT2KIa5SSdNNrSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168794998"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 19:56:13 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com,
	dave.jiang@intel.com
Cc: Marc Herbert <marc.herbert@linux.intel.com>
Subject: [ndctl PATCH] test/common: document magic number CXL_TEST_QOS_CLASS=42
Date: Fri, 22 Aug 2025 02:55:34 +0000
Message-ID: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marc Herbert <marc.herbert@linux.intel.com>

This magic number must match kernel code. Make that corresponding kernel
code much less time-consuming to find.

Additionally, that same one-line reference indirectly documents the
minimum kernel version required by the test(s) using this value (only
cxl-qos-class.sh at this time)

Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
---
 test/common | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/common b/test/common
index 2d076402ef7c..1ab62be6994f 100644
--- a/test/common
+++ b/test/common
@@ -155,4 +155,5 @@ check_dmesg()
 }
 
 # CXL COMMON
+# Test constant defined in kernel commit v6.8-rc2-9-g117132edc690
 CXL_TEST_QOS_CLASS=42
-- 
2.50.1

