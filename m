Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031862;
	b=OJV5uKSD6prnAqDwKYRXzpwiLu9gF5cQvRUBHOnotvh5mzQ9Mn9X5uGDP57MMV00T8As
	 08K5kxTKlW3T8ezAYTfltrg934VP8Q44foSln8dJtwVFryTWFMmRyjQa+mZPrUtZyzbNZ
	 B1BthxHV4NRqIN5FBl3+vDgYQ9FLm7vtBEiNmQ3PQiexb5cypILZr5uFmVKJ2BujbDgi6
	 /gv63Zw7KtpE4PP0C8Cmf8ExmF9tEL4iVdoTfZPt331zazeXxZb6M80srEioZzcxecC4M
	 +pSagNWQwDhSr4svEKF55O7GghbwQ2qGYm7wy9hwmOP5Om18JFmlXzX4giOUMXamx/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031862;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5V9UwxxZ4kckRzYn76Rc4XXuNi2LlKGF/bbYQhhXomw=;
	b=ykB7vCtNAvsgAQo32f5s/UJUVLW8s2ou2y0QJAJ6pqiViXnDSqQlDfG1/sfe515yPmUJ
	 YbtSP+2E2y8m7m5h5dCAwgeGh76JnGz05v5fBlITr+kqDUswRwiH31wpdwpg1Vven30nF
	 gcEK2fYC/CqJaVJgHJTWgBqXHBzdU5UGZ8zdqmzw2/EubtWSZjurSt31xaWYb4KCFN+mp
	 oTTdpCFaVxM7z2woXCFkTClMiIxrTMZUexRFXU6yXsvhGpc/jQ+djaEkDGmErP5kMZwtl
	 KmSaMy+ck4+l2YE+ez2W8aCk+Pl73X7vMunTC9FSdPp4LCTVTp+wRXK7sOWEmmHPTsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AFfzC079;
	arc=none smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708DD606A31D
	for <nvdimm@lists.linux.dev>; Mon, 26 Oct 2026 16:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 708DD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=AFfzC079
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793031862; x=1824567862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=914L6Ehbzc010nX11Vf6AM1dCqaluy0uqbO7c7en+xI=;
  b=AFfzC0796fYO397em1yMEJtDOgVXK2QugQtVg37Q0YGrmS05wlFnLrI5
   obaYIWsZ4V1JBp52saXqRWQSqDqlA3bT0FGYm7UT4yE+gM2mKIlt7cFvZ
   gm8d0XxMWutLyohxzbaFvaSSMvCZmBGnhuY3blYBAEy+gaf1ZTZQvCrnZ
   ye+2E3gETMXdhNJH0MeA65xGmwXMkXeOAsxmvwJL6CE8JGUE7o+CFS0++
   RGR02QIxiVpF7NPZrpms9/ThJTc7X7atP9/5Y3UHuJJPwzbsRPxZ4y4cW
   TjRSsTMG9jiy4yP0QzLxSuIB1q/4oMXXI2efGeag4+l+SJ/JZZue4S2bo
   Q==;
X-CSE-ConnectionGUID: jjUGv+31SuGPGvj0ZT9JQA==
X-CSE-MsgGUID: yoFBeigcTVaV3ue65DCjDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1602002"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1602002"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 09:24:21 -0700
X-CSE-ConnectionGUID: atopQ1p9RUq0kj7YpG5vVw==
X-CSE-MsgGUID: GDKb+3zNQBGP+dGca93yYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="4316020"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.108.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 09:24:21 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2] test/cxl-region-sysfs.sh: test a repeat write of a region target
Date: Mon, 26 Oct 2026 09:24:15 -0700
Message-ID: <20261026162419.584201-1-alison.schofield@intel.com>
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

A CXL driver fix making its way upstream[1], makes a repeat write of an
endpoint decoder to the region targetN attribute that already holds it
succeed without changing the region. Without the fix, that write fails,
leaves the region half detached from the endpoint's ports, and a later
write can crash the kernel.

Add a test case to backstop that fix. Write target0 twice on a partially
populated region and check that the second write succeeds and leaves the
region's decoders attached.

[1] https://lore.kernel.org/linux-cxl/920d80735a449f93a1f17a8bca4c25e4b302cb42.1792989098.git.alison.schofield@intel.com/ 

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Changes since v1:
- Expect a repeat write to succeed, as the v2 kernel fix makes it a no-op


 test/cxl-region-sysfs.sh | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index db1a163efb30..cb5e6ba53e71 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -87,9 +87,19 @@ do
 						     select(.mode == \"pmem\") | .decoder")
 done
 
-# attach all endpoint decoders to the region
-pos=0
-for i in ${endpoint[@]}
+# a repeat write of an attached endpoint decoder must succeed and leave
+# every decoder between it and the root attached
+echo "${endpoint[0]}" > "/sys/bus/cxl/devices/$region/target0"
+nr_attached=$(cat /sys/bus/cxl/devices/decoder*/region | grep -cx "$region")
+if ! echo "${endpoint[0]}" > "/sys/bus/cxl/devices/$region/target0"; then
+	err "$LINENO: repeat write of ${endpoint[0]} to target0 failed"
+fi
+nr=$(cat /sys/bus/cxl/devices/decoder*/region | grep -cx "$region")
+[ "$nr" -ne "$nr_attached" ] && err "$LINENO: $nr of $nr_attached decoders still attached"
+
+# attach the remaining endpoint decoders to the region
+pos=1
+for i in ${endpoint[@]:1}
 do
 	echo $i > /sys/bus/cxl/devices/$region/target$pos
 	pos=$((pos+1))
-- 
2.37.3

