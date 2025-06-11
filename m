Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDA12D8DBD
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 23:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749686006; cv=none; b=TS5Vwu72pe65HQ3CbVa6wfQIxWVfeJgwNdXQmGFP4Cn7oPEMjQDg+CpnyYRDbXEiYCcYNTAdJwtUAwbPNldOWf6cF8h/7SUAJLwZREKCaJydL/NGM3OPJ0ew4+zz26d2xmY4ZN5LgO43m7pKYFV7tm7SI7nHTE387s2cvjadAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749686006; c=relaxed/simple;
	bh=vOdBg1unCsUGX+Js9OBiWoh/r812m2v89hPz2Y8vNtY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=X/7G/XC5ilWxjwkKTKbiV8RL1bHNYLTCXlpeNsRsmuy4AU0rBHJfALa4pvg918zC9vvgmDLKzRfRRKNbCOwW8K3ZFRXwUwjlf0vhDAAcY0kZIdwcnVZedmLCWPQF8s4c2y7Q9e0bm/MzTJS4PFokNjVhm+hchaKE4veX/7CKAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXLyyo5k; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXLyyo5k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749686004; x=1781222004;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vOdBg1unCsUGX+Js9OBiWoh/r812m2v89hPz2Y8vNtY=;
  b=jXLyyo5kteudWjYcINBZo5P9UryHr6L0WTmJxTC39yRvtL/tcACRG4TY
   uCSAhO1lp4ijHyJ5d5f7ev0VlJdOwFgHHjoW4fZzxOeZ+IpzxqYBjZ+1X
   Oxpg2KW0QHaKq62tLR7VB2J6MppO7/Os1RKrpitWaUNmVNPfJbD03U0je
   fl1XEO/1/ptA5h7FD8qBKPNKvbLCBxCJLeWEEnqXEeqpdg31R3Z5bKhSO
   2sj2LROKyIsEvgSekiXyOroPd7W2BAWhulfzBLr1X38K4M3OzOgOXZd/O
   wD+9gJ7l3ypKoAtljZbDeh9V6w9h4ZQHqiaJ6zn6hCLp65JBiMJKnBy8i
   A==;
X-CSE-ConnectionGUID: zZh1oqHuS4iyhsjOuoNMEg==
X-CSE-MsgGUID: n3nd8WGFSkWH8anKlhoedg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="50955755"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="50955755"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 16:53:24 -0700
X-CSE-ConnectionGUID: +gbDAVCQR0eqeeEKq3fViA==
X-CSE-MsgGUID: hdvF3awUTxWI9wbqMsEbiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147243872"
Received: from unknown (HELO hyperion.jf.intel.com) ([10.243.61.29])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 16:53:24 -0700
From: marc.herbert@linux.intel.com
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	alison.schofield@intel.com,
	dan.j.williams@intel.com
Subject: [ndctl PATCH v3] test: fail on unexpected kernel error & warning, not just "Call Trace"
Date: Wed, 11 Jun 2025 23:44:19 +0000
Message-ID: <20250611235256.3866724-1-marc.herbert@linux.intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3 changes:

- One-line fix of kmsg_no_fail_on exclusion of the warning "Extended
  linear cache calculation failed". Fixes test failures since kernel
  commit de7fb30a5870 ("Add extended linear cache support for CXL").

v2 major changes:

- The old $SECONDS variable is dropped from journalctl. Which allows:
- ... dropping the very short-lived COOLDOWN proposed in version 1.
- A new, optional NDTEST_LOG_DBG code which allows "stress testing"
  the approach and proving that it is safe.

I tested and compared for many hours $SECONDS versus the NDTEST_START
approach that Alison submitted a few months ago and the conclusion is
very clear:
- $SECONDS does require a ~1.2 cool down between every test. As it was
  done in v1.
- NDTEST_START requires zero cool down.

So that is why I dropped $SECONDS and the cool down.


> Split them into a patchset for easier review and then I'll take a
> look. Thanks!

There are 3 logical changes in the main commit:

A1) Dropping $SECONDS, replaced with NDTEST_START

A2) The new NDTEST_LOG_DBG which was/is critical for:
   - proving that $SECONDS required a "cool down" (with version 1)
   - proving NDTEST_START does _not_ require any cool down, safe
     even without any.

B) The new, _harden_ journalctl check in check_dmesg() and its
   kmsg_fail_if_missing and kmsg_no_fail_on. The main feature!


- B) requires A1) because $SECONDS is too imprecise. With B) only, the
  tests fail.

- The A2) test code achieves nothing without B), it cannot prove
  anything without B).

- A1) and A2) are logically independent but their code are fairly
  intertwined and very painful to separate. Plus, B) would have to sit
  in the middle: A1->B->A2

Long story short:

- while they could be logically separate, these changes are tightly
coupled with each other.

- breaking down that (relatively small) commit is theoretically
possible but would be very labor intensive. I know because I just went
through a similar "git action"  to compare $SECONDS versus
NDTEST_START for COOLDOWN reasons and it was not fun at all.

