Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B886B282F0C
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785462930; cv=none; b=RLQC81Ec3JikvKEpvLWyvqeOSVkvpLSAZpY08aFFsaylgBUoj698Hrl/kxh7QPStGi7pW3x1gxr6Wl4kPXba6d+ml81hoytZjTm6uYVNN7zOXRejH16XTOmdlbM1oLJyCFYT2D355zarXaNodWGuxoGTa+wvTZjVln8UMa0v4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785462930; c=relaxed/simple;
	bh=wrn75i3HjBG+ZjR6tteobOFM3TCS7fePQDhA5G4E5LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9jKDllEDGJlkdrnHW/B2RjtI9o8PAFDmcC9qzV/E8nFPrWdMi9RzjqexHqP2ctLn/e+YdLApskL91//SGYM5dAlnLjlSWb4BGadw0hY9x1hWa4SjQNvhClE5q4oWTGNw4YYBZ1SM4rjxfWVLegu/iJ86x5uetbi+MnjzYh0F0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqedfiEz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqedfiEz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785462928; x=1816998928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wrn75i3HjBG+ZjR6tteobOFM3TCS7fePQDhA5G4E5LI=;
  b=UqedfiEzArtVWpE6pqbFxxZbetg7Q4fvDQHdSKOifqxTzn7SFM0AZUqs
   +r+dgqYDsJHnROIZ8s8XZZ35UfT8fbEwZF13Xqrr9w4eJsG3lNAq2GnWq
   obQs9bWPtJ8p4gLNOChhkVlDnBll7FOzhFGqfbNfqcsS0g2IDixs/cb9m
   tS/fvvruK5nvYB2do8w4iTmvagpbJH5LcTHBBhHgdIP8P4SDK5jp09j3M
   zDZhg3Zc/mb9xDy/ZplQmUa9zMSKxmOVOlzsDD55uI2sjyVuX2r5BD+iH
   qwDXrJ8vsYtb0PvSwBnC5cJk20bokywraXaai4z+qP4EqTTaD6yrPPsN6
   Q==;
X-CSE-ConnectionGUID: n+D0Cxt3T9avgvbAQtoXKA==
X-CSE-MsgGUID: KNgc6V7rSAKbgmsnf6yQGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86281312"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="86281312"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 18:55:25 -0700
X-CSE-ConnectionGUID: xZ56Ub1oToOsotIie0zu3g==
X-CSE-MsgGUID: sfEOPhJzSAi15tLEYKkVeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="285056414"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.96])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 18:55:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/2] cxl/list: list locked zero-sized decoders
Date: Thu, 30 Jul 2026 18:55:20 -0700
Message-ID: <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'cxl list' hides zero-sized decoders unless --idle is given, assuming
they are unconfigured idle slots. That assumption does not hold for
locked HDM decoders, which may legitimately report size 0 while being
committed by firmware.

Do not suppress locked zero-sized decoders from the default listing.
Combined with the "locked" field in the decoder JSON, they are visible
and distinguishable from idle, unlocked slots that remain hidden
without --idle.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 5d634d3b2512..e6d45ac7b9e6 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -847,7 +847,8 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
 		if (!util_cxl_decoder_filter_by_region(decoder,
 						       p->region_filter))
 			goto walk_children;
-		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
+		if (!p->idle && cxl_decoder_get_size(decoder) == 0 &&
+		    !cxl_decoder_is_locked(decoder))
 			continue;
 		jdecoder = util_cxl_decoder_to_json(decoder, flags);
 		if (!decoder) {
-- 
2.37.3

