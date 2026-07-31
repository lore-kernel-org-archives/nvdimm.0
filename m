Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077E82C21DD
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785462927; cv=none; b=rGu/z85H+Ipn584joVBLxJ24fPgT9j7PFF5jyxtJC+ao66x6tIq/MUZNiAjvqBqCb8ivTRo3u2xAYVnZIpzmXCNbww4q+/2aWTpMumjGRWQrzRhigzBfa4SomXPr3L5r2oNo8gf0thmDVTpkg1mNSXTNPBS5nRZrP6ReVkKPBaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785462927; c=relaxed/simple;
	bh=6rCdkoCWeQibhG4ETux/WpZHusagDty2olaCdQBuLyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AY3vbPIhPqnJXRdz/2OLJ89tsSFFtRugs9FwWFcIEfKAKUvNJWHRHU9fEc/xUY+B8cjRmkq47pWFY8pX+kFTdJV7tXUI4nkOhs3KxJYVOQOrOWrSOTHuRvGMMTned2s6T2n0r+EJxyM67oIgH28inELY99THHYdExtQHWZg3WS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CiUYKsL8; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CiUYKsL8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785462925; x=1816998925;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6rCdkoCWeQibhG4ETux/WpZHusagDty2olaCdQBuLyk=;
  b=CiUYKsL86PcIDR0pXqs9tAbV/dliC4POwZpmgvwIXOofA0KI9gdaX+JG
   7uOxYjEVnGWVjvGb4/dNemEFxVZX18Fi1uGu7KPDXKPv/AuB7QIeKaQlu
   TpHgttClZcjCs2KOUdj+00uRwgSPN7TDgKIJEsTR8y0pzogGxYj1zLqbb
   k6nbZhG9g12mb9q7PijT/eyqv3MULwMdQYWz8XCVvdzpccGNLetR+21qD
   pK9az8NjNNvME08Kfqn72ccb3mlGMZTSRBt9jwvCZmy3d+/9hCX+V03Ji
   bX2liUPxa4O0WnXi7fx55s2vozSofORca/5pjS304G3UpLE5TVfFkGYHk
   Q==;
X-CSE-ConnectionGUID: 2HqFOZv3Q6GUXWwRCwCjPA==
X-CSE-MsgGUID: wUHrko16SeybXHQ7pnpDsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86281308"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="86281308"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 18:55:24 -0700
X-CSE-ConnectionGUID: kVm9zFQGTO6u02UI253BFg==
X-CSE-MsgGUID: VxIqO8nLSAaj/h1cQv24/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="285056408"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.96])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 18:55:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 1/2] cxl/list: emit decoder locked status
Date: Thu, 30 Jul 2026 18:55:19 -0700
Message-ID: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A committed zero-sized HDM decoder reports size 0, so 'cxl list'
renders it identically to an ordinary unconfigured decoder ("state":
"disabled"). The locked attribute that distinguishes firmware-committed
decoders is not included in the JSON output.

The library already reads the decoder's locked attribute and exports
cxl_decoder_is_locked(); it was simply never emitted. Add a "locked"
field to the decoder JSON, following the emit-only-when-true idiom used
by the capability flags so existing output is unchanged for the common
unlocked case.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/json.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index a92548828582..2214f7027d91 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -870,6 +870,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 			json_object_object_add(jdecoder, "state", jobj);
 	}
 
+	if (cxl_decoder_is_locked(decoder)) {
+		jobj = json_object_new_boolean(true);
+		if (jobj)
+			json_object_object_add(jdecoder, "locked", jobj);
+	}
+
 	if (cxl_port_is_endpoint(port)) {
 		enum cxl_decoder_mode mode = cxl_decoder_get_mode(decoder);
 
-- 
2.37.3

