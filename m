Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929733;
	b=XHPHXdkkHkKc0JgWdAVapSTCw5B20MqxiVdtGBR7d8RHvwMCM42gz+xIkV5nreRmwQZF
	 hD8UZN3E0/bi5TwNvw7/NL0OOPYKhE+bl3zHGxzwqXOKHg5IFXFAqiBqHuRIUcKbNbPlu
	 yL+RWoFyJlGkEY/QltLNrH++hv6HrOoAoKXqWE+Hj7iSJXHrwfdncHbFvaykvpEuhHM5n
	 R1lwR+Sgh5URU11hPa3L7KH002IUgHIaUZHLqab6YdRr9tfwcYdto2/CjcDyZoNDE4JZY
	 nz6FgpowkVVUsqgnst09Td4xpszIGXE5TtCXxnOmmWSiDjqKxMnmbt/0/4BLk2QC8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929733;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=6HKkt/FacbIRgfmiv6pvOv22szJaBY/Wpn7agVWQckc=;
	b=cGZ33JUy+d3QDqzFupRMzYpmKAjIWN6jJXkaQU24OPGowG0SXqb7jkl0Dm91qj3GsPil
	 2voKWNKqaTxYMVsaHJLz3PUO1qmFhBPfH9OxxzYUf3dUkWUVIl6+kBzKFtM/wGNGgydk9
	 3VnsQYMhthgHkroFdAkhj0ewqjPKZ519r+v/IjJ9ZdO4v5YdQ6yldeIlBYj+Uz1XIATe6
	 JnZykni14vaO44//c32FXWAZipmkXRJWkUzbeZUNRXfGVmxzgbdQw1KCo831wTgOcILhI
	 dhXx/nP4Pv0xdxtPZDH0GMYx0WfyOHT5haYS/ol48pBmHvejTs4NRZLTZOKMH0Rb2Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QFzWcYMC;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BCF606A31B
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 01:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5BCF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QFzWcYMC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793929731; x=1825465731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OT02+xGnkQCHTgGmDZCN1ZUDBuj+y0UDoxyjUiM303o=;
  b=QFzWcYMCrWsZeuWiK/mU2n1GHGCe6XUjldCBw2coyZYTi6kt/pAi/l2p
   E+mBZdSa0FcT8YRYzIAsiVO9h3j5lgBduUWRkIMqWEazoy5zJdrgLop7m
   qXNOVaUDtOkxLw0CFD6pxnvoLOz0JaKZRxmbmqEr5jZBxV0u5boH7+xpW
   hx90fU65O/hiYvKSVP8l3PSpV+bHsGVh7/VlGlbEODHOBs11kssJvH+el
   EDhA1xeEgR2GHNe70fDXWk/VCg4sCIeRHPCf6to2V2HBvpi19DmcghS97
   eHbbp1A7zimUIUfwUWS9IfNqFmqU8yqdNQXtXS7qzFNR8Gp4DelwzA2pQ
   w==;
X-CSE-ConnectionGUID: UbRKlQpjTcm7OX1jwO92Vg==
X-CSE-MsgGUID: orKF9/EHSeqMn8mu+aPVow==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2617809"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2617809"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 17:48:51 -0800
X-CSE-ConnectionGUID: JqvDJVPYRXWUi6Qm9iTOLg==
X-CSE-MsgGUID: EUMuEZzIQpOcY1gZbEgNrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="6992662"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.136])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 17:48:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH] test/cxl-destroy-region.sh: create RAM regions explicitly
Date: Thu,  5 Nov 2026 17:48:46 -0800
Message-ID: <20261106014848.938714-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
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

The test creates regions it expects to be RAM without passing a type.
create-region defaults to pmem when the root decoder supports both RAM
and PMEM, so the test fails when it picks such a decoder.

cxl_test has one such decoder. Whether the test picks it depends on the
memdev order, which changes when other CXL devices, such as QEMU-emulated
ones, are present.

Use the '-t ram' option so both checks create RAM regions regardless of
which decoder is selected.

This issue appeared while the CXL kernel patch[1] was being tested. It
changes the cxl_test created x1 volatile window to one that support both
RAM and PMEM.

[1] https://lore.kernel.org/linux-cxl/89e8d2cfde4f1054f37a4f48f2b206a7f05108f7.1793850480.git.alison.schofield@intel.com/


Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-destroy-region.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
index 5c3395e530b0..b07589fbbe39 100644
--- a/test/cxl-destroy-region.sh
+++ b/test/cxl-destroy-region.sh
@@ -60,7 +60,7 @@ check_destroy_ram()
 	mem=$1
 	decoder=$2
 
-	region="$("$CXL" create-region -d "$decoder" -m "$mem" | jq -r ".region")"
+	region="$("$CXL" create-region -t ram -d "$decoder" -m "$mem" | jq -r ".region")"
 	if [[ ! $region ]]; then
 		err "$LINENO"
 	fi
@@ -76,7 +76,7 @@ check_destroy_devdax()
 	mem=$1
 	decoder=$2
 
-	region="$("$CXL" create-region -d "$decoder" -m "$mem" | jq -r ".region")"
+	region="$("$CXL" create-region -t ram -d "$decoder" -m "$mem" | jq -r ".region")"
 	if [[ ! $region ]]; then
 		err "$LINENO"
 	fi
-- 
2.37.3

