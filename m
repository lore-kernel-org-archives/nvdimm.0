Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E21E1A83EE
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305025; cv=none; b=OQhWVycjSHbEik+nfM4ppkP5kzrsZrOuvA+j6ZmoKI+7lfT2QILj2r2CANS7kwbNQ4cuLTn/UT3faHHhn4L0OVDHMJY9Hu6SOx57Hz9VbClJzwiDTjTBRYl5D4SeScxRHATT09zm/+w53Gui+8MzBDqLhHU8l35R48QIuUoipOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305025; c=relaxed/simple;
	bh=2V/Pw+4z5X1zqGGkZxd5u8O91l9GwR8ruYbu0v/k7ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzmiOoMbiJ/sUL14CMGFuhQ1OKEIL894mYZEmSAcPaqknkL/t2rkptA3dfnS1bKbxZgYvyjk0PSz2cSefjLEcBlzX1rVlXaRcIx/8OLjyFfnJzBZJ61lEO1rAnV63IZzOyDRxncxXrU437FzI4y93M3//T1ZG0vLY8iKnYek0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i87c4Ido; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i87c4Ido"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305024; x=1772841024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2V/Pw+4z5X1zqGGkZxd5u8O91l9GwR8ruYbu0v/k7ys=;
  b=i87c4IdodgauVI3W/pToFFADNtJBtuL9wsG7CPx9RcB6+UWAl31Zc1xB
   rTkT3ic+LzM3KcbXUFOzdA8cewpDDoiOSXfYMsVF4nykO/d+untNL8Xrg
   wpx05s7RuEGhlBL4JJiFPYJslqHxcV/aYh86YlFam7F9jaVybV0F6N4yK
   pBN0FC3XyH22YETRqmpwLxly9UTQ0JLgHvQZ4gaFiekf/L1HPgcH37nvu
   9kyBdUBODfgoeCFmEZ9ieW8/UM0M0WbVBcGBnQfD4dsnmsPIomKq5J0/b
   kQ2iIzW3ef98DYlU6r73khGO245ziIXgOh82EKng/eBGKET6byRpjIlA1
   A==;
X-CSE-ConnectionGUID: 0IFI76J7THa8Vy4W5ZqVLQ==
X-CSE-MsgGUID: ZuWWYk9VQtil3EdcZQ9SUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="45150085"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="45150085"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:22 -0800
X-CSE-ConnectionGUID: rQfX55m7TUOSpAw/493t0w==
X-CSE-MsgGUID: EAvOFNRfRgWIxGmTJ7+47w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123358708"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.63])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:21 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 3/5] ndctl/dimm: do not increment a ULLONG_MAX slot value
Date: Thu,  6 Mar 2025 15:50:12 -0800
Message-ID: <04880bb53cbd400d9906ca2ac5042a9dc23b925f.1741304303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741304303.git.alison.schofield@intel.com>
References: <cover.1741304303.git.alison.schofield@intel.com>
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

Initialize slot to 0 and increment slot in the for loop header. That
keeps the comparison to a u32 as is and avoids overflow.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/dimm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 889b620355fc..aaa0abfa046c 100644
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
@@ -108,14 +108,13 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 		return NULL;
 
 	for (offset = nsindex_size * 2; offset < size;
-			offset += ndctl_dimm_sizeof_namespace_label(dimm)) {
+	     offset += ndctl_dimm_sizeof_namespace_label(dimm), slot++) {
 		ssize_t len = min_t(ssize_t,
 				ndctl_dimm_sizeof_namespace_label(dimm),
 				size - offset);
 		struct json_object *jobj;
 		char uuid[40];
 
-		slot++;
 		jlabel = json_object_new_object();
 		if (!jlabel)
 			break;
-- 
2.37.3

