Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365E1C2323
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723819474; cv=none; b=sudFqOL2YReNInz/qBZsfv2Q0kitaxknjVB9fgDBdmdpTCoSsOjTm68v2s1r1Qq+CGhwhWgdJ9OlVHGmuVPfrQ0NmEA8FUN7yBzKQyDxCsy78BehEtv4ett+Pi4h+nNSZGcHMRjTtBFlToC4ptrg8MRTR308uC0KpYOwbla6ISY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723819474; c=relaxed/simple;
	bh=Zo1dZh5pzHpeeydz3y04EF5edS3G2yB/CM8mLx26TMA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J3E2KxnnGViQvuUa09jjG4TYMORcbwjHi8ds1s8BpVPgUeiYRl4np4x3+c/zI2ljDUCBo3U5s+jg1CpfQWJDhep0+6E+zyVBytcEnzJ+YB6ofxXnEJ/KyDzFbp/JwMG8CaF/7ZPOAM6s63VqyBBInnEAfzMImHSA+kClhIdZuec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PvGqtNqw; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PvGqtNqw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723819473; x=1755355473;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Zo1dZh5pzHpeeydz3y04EF5edS3G2yB/CM8mLx26TMA=;
  b=PvGqtNqwcHFnZOrYPz/M/ApEkEuiemacHtspaOaI7xpOeRg0PKIVFnBS
   2vQGOi0iS5pJVIC3h1H1wSpbA7ZdSW5wnvAwyzqLvIjrUu0dpvjyrkpzC
   AvKnYm6sQL258ke1dwnPmmXHFCw15D7GiQjUJOXOoyIbBHlrScxQiuczY
   0b7dLJKv/xS/Z9v4zw3OrB13dSRIrqNI+yGBNeQ/yEUv07kO9erqF+CIt
   ofSJwgI+JMM7q0/eAOanmpsR8kZ8YzF4ePjUTEWXxuHLCNfv4D0wCK35F
   F0xWJ4Ik0KEJl/ZYxb00FdQtjZ+7Ojv9hJe4Vo38GX7YgZtffcuaSh2nk
   A==;
X-CSE-ConnectionGUID: 9Pd0TK5qRiudRZDlaKbC7A==
X-CSE-MsgGUID: +cBsQcmHTDi7mcmUDqjDGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="32753048"
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="32753048"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 07:44:31 -0700
X-CSE-ConnectionGUID: A+k9k11cTg+775dN+jvcmQ==
X-CSE-MsgGUID: cU+2hgLVTZyWb0vy2IeXrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,152,1719903600"; 
   d="scan'208";a="64086946"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.125.111.52])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 07:44:30 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 16 Aug 2024 09:44:12 -0500
Subject: [PATCH v3 04/25] cxl/pci: Delay event buffer allocation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240816-dcd-type2-upstream-v3-4-7c9b96cba6d7@intel.com>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>, 
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1723819455; l=1342;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=Zo1dZh5pzHpeeydz3y04EF5edS3G2yB/CM8mLx26TMA=;
 b=lyHNdhhQchPEN4TCZSPERaIaafc1u1Lsn2DUD7pdFQA5VhnwgIqVo02pSl2kHckh8G0WbvonX
 e/oHe5Pwb1qDk21M9b7O1JOZRcv30gG8jtJJeE4CCENw0p8xI32ir6G
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

The event buffer does not need to be allocated if something has failed in
setting up event irq's.

In prep for adjusting event configuration for DCD events move the buffer
allocation to the end of the event configuration.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: keep tags for early simple patch]
[Davidlohr, Jonathan, djiang: move to beginning of series]
	[Dave feel free to pick this up if you like]
---
 drivers/cxl/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 4be35dc22202..3a60cd66263e 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -760,10 +760,6 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return 0;
 	}
 
-	rc = cxl_mem_alloc_event_buf(mds);
-	if (rc)
-		return rc;
-
 	rc = cxl_event_get_int_policy(mds, &policy);
 	if (rc)
 		return rc;
@@ -777,6 +773,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_mem_alloc_event_buf(mds);
+	if (rc)
+		return rc;
+
 	rc = cxl_event_irqsetup(mds);
 	if (rc)
 		return rc;

-- 
2.45.2

