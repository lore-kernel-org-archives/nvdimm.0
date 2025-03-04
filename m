Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528D073176
	for <nvdimm@lists.linux.dev>; Tue,  4 Mar 2025 00:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048645; cv=none; b=GGXN2XeNprUwKcgwj2Qtr2+wZ+m0VMAuiXrWIqN6YSmHn5xfZFg4q6D0aNkoq3NYUTP0PDKnhq1wfro0a3zUHFE9YDOz0EC7xDM8UAJ00kO7Tews8Y0PNGp6ZmDer4r9lgsgILhdlQ6Mchd3chh0Vz0RT1zsR+IzOqTS/t9Wl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048645; c=relaxed/simple;
	bh=pHe4G+oE8dVwZr8Tod68ruVXvcAns/sY/G7UWPRgZ2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivgonqY/lhHfXLWD1MN/LovSdWmsmONWs3N+LUOmOtuI6E1SKd4IS/w4BPqBiBg2EPl5IpT3wuLuQGHUSficJ5O1QWsHWViuINBuTtgm1aqG9YqN0lEfgD4IBgBqrkdgc6w8o3KLRClQUEdjygNdtP41z1wM7vkG/tC+RDw8Bz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=acIRut8X; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="acIRut8X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741048645; x=1772584645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pHe4G+oE8dVwZr8Tod68ruVXvcAns/sY/G7UWPRgZ2U=;
  b=acIRut8X7SI0dHW4bEzqUy+FgeR3aHhOezt2fKNnIet9Lcyc4Fs4QDjG
   j63VHvuXCsqG6H72HhL5gJ1bObB/hVlWThhei4/PrPpyFN7bXG5pUOqwq
   PwQBaHcOXSxVgg8g96vI4l9XKUfr/TqmhRU+zNUj73S3F45bdZfoMvQD5
   BglyGruFqpj1CWaljfWzEKob/JRGNxabjjHKKaZ6evGCMXKsjGcPuDmAe
   BrOL2KASSbjkMANvalhqvf7wzIOEJMerYN1AJ58ubsAx/glAYrrInunVl
   d74UceljXNTJmDUAo13kcIecxdAAX5PNElOrvSVczfAFfyO9pyJwKsp4g
   w==;
X-CSE-ConnectionGUID: 4nfNRx4oQoK/bePJjR0sDw==
X-CSE-MsgGUID: b/2EgaVBS8iWb266hEMShg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41975320"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41975320"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:22 -0800
X-CSE-ConnectionGUID: ciCiPPTcTROd6EnXMQ2e3Q==
X-CSE-MsgGUID: KG1avHpyRbqjdmTaaLRVIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141427148"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:21 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 3/5] ndctl/dimm: do not increment a ULLONG_MAX slot value
Date: Mon,  3 Mar 2025 16:37:09 -0800
Message-ID: <6f3f15b368b1d2708f93f00325e009747425cef0.1741047738.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741047738.git.alison.schofield@intel.com>
References: <cover.1741047738.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A coverity scan higlighted an overflow issue when the slot variable,
an unsigned integer that is initialized to -1, is incremented and
overflows.

Initialize slot to 0 and move the increment statement to after slot
is evaluated. That keeps the comparison to a u32 as is and avoids
overflow.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/dimm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 889b620355fc..c39c69bfa336 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -97,7 +97,7 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 	struct json_object *jlabel = NULL;
 	struct namespace_label nslabel;
 	unsigned int nsindex_size;
-	unsigned int slot = -1;
+	unsigned int slot = 0;
 	ssize_t offset;
 
 	if (!jarray)
@@ -115,7 +115,6 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 		struct json_object *jobj;
 		char uuid[40];
 
-		slot++;
 		jlabel = json_object_new_object();
 		if (!jlabel)
 			break;
@@ -127,8 +126,11 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 		if (len < 0)
 			break;
 
-		if (le32_to_cpu(nslabel.slot) != slot)
+		if (le32_to_cpu(nslabel.slot) != slot) {
+			slot++;
 			continue;
+		}
+		slot++;
 
 		uuid_unparse((void *) nslabel.uuid, uuid);
 		jobj = json_object_new_string(uuid);
-- 
2.37.3

