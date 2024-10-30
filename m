Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEF11CF7B1
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 21:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730325310; cv=none; b=dsP8r9tALqRSyivs9qWF+cMeLF+xi11Hs8BQhUk2NktKRfynOgsZycnF2lAZf18Rav0mitmchBvyEn5oe0G+290DnKvFIkLG07HeX6Yex8L1CUJrAtahF5J6FVSDkVIrJYq+hwnwhuZOJCHjfqpxAAKt5YuNfFLu3KjH+hFfVqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730325310; c=relaxed/simple;
	bh=bnA5MH3Ut/o2XkdYerkFVpg3U06Fxf8NVmDS1qWQDyU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bpVqcbJqWeBXz6Kba9puYY+OeLX17fBkJjCH1dMYvlzxtAb+JpMbk94AFxbJmbL75MOHVETad7M7A0x+ogGC2+U3ft2hFOc/lWjb+wwoL7uecg5XukIyfsWQyxXL7vK7zUH8qGAp6tErwULEgLtmV0p35elU4O/iEXOlA4ZhgGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mQJfZvCT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQJfZvCT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730325308; x=1761861308;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=bnA5MH3Ut/o2XkdYerkFVpg3U06Fxf8NVmDS1qWQDyU=;
  b=mQJfZvCTsCMii/vpZgh9iLCFQ/dxQCIoba8Yij+LTmCXJFlfFx7DWP0L
   koNDPWpf4akDQPOL4v6VM1yezsFDQOMt9Gec44UtnNSaoKfdD+8Iyb7lm
   cz51tfXkRDQl66xkZF1WwWw69teHGKM6TeAcJ/Z1QDnFFescpJSfeeu+G
   fEdGgiK7mMsHQ9uT7CjT0C2Mj80TEcr/I5EizOWLBpDE1HR4aowH3EWwJ
   6M9BZtsjtKFQYE0pMC98aRCAC38hmhIAULjTontyTqEXmo0R9aSj7zETe
   +kmt5z6alrAoOAgT6IdUtR7I1AU0qaHtVKPq6mOTEpTixRzKVkW168vsQ
   g==;
X-CSE-ConnectionGUID: n39eXuqNQ1WRjRn31lPrrw==
X-CSE-MsgGUID: S55+OW1AQHeQ751QaWnuHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="40620516"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="40620516"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:07 -0700
X-CSE-ConnectionGUID: HtVLIGyhTBOeFp4sGGTRyQ==
X-CSE-MsgGUID: anaIG9rLS/yLhYlVpvRwUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="119899958"
Received: from msatwood-mobl.amr.corp.intel.com (HELO localhost) ([10.125.108.161])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:06 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Wed, 30 Oct 2024 16:54:44 -0500
Subject: [ndctl PATCH 1/6] ndctl/cxl-events: Don't fail test until event
 counts are reported
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241030-dcd-region2-v1-1-04600ba2b48e@intel.com>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
In-Reply-To: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730325302; l=1446;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=bnA5MH3Ut/o2XkdYerkFVpg3U06Fxf8NVmDS1qWQDyU=;
 b=2LHLcye7C1q/k2ff3Tle0TanynHZFAlrIrZb1/odOlKFg9NhciiCGZwU3KfuxfpD1n7zCEAt3
 HfeF81rrCzfCuMYo971bKWs0+tSsYBFlETLEUwEFcGyHdtLRKFFzVnZ
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

In testing DCD event modifications a failed cxl-event test lacked
details on the event counts.  This was because the greps were failing
the test rather than the check against the counts.

Suppress the grep failure and rely on event count checks for pass/fail
of the test.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 test/cxl-events.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index ff4f3fdff1d8f6fd80f093126a27bf14b52d167f..c216d6aa9148c938a649cb22656127b3df440039 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -71,10 +71,10 @@ echo 0 > /sys/kernel/tracing/tracing_on
 echo "TEST: Events seen"
 trace_out=$(cat /sys/kernel/tracing/trace)
 
-num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}")
-num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}")
-num_failure=$(grep -c "log=Failure" <<< "${trace_out}")
-num_info=$(grep -c "log=Informational" <<< "${trace_out}")
+num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}" || true)
+num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}" || true)
+num_failure=$(grep -c "log=Failure" <<< "${trace_out}" || true)
+num_info=$(grep -c "log=Informational" <<< "${trace_out}" || true)
 echo "     LOG     (Expected) : (Found)"
 echo "     overflow      ($num_overflow_expected) : $num_overflow"
 echo "     Fatal         ($num_fatal_expected) : $num_fatal"

-- 
2.47.0

