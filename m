Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337FA2836A0
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762367870; cv=none; b=NBHRY/rzRKQjPxTaRReshMcXQF+qarUI/wdEovvFl7unLO2BoOz8BfXRs31tKlhNPObn4tjCDg3rcskkJQNPRbRAgTXV4cK83oH4GMPx3C+I7/VNci/HY2osuEo3Vz3gw2A273jKsVFfvZefK5Hhaq8nQFIFWc3MdqjQlP1IGD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762367870; c=relaxed/simple;
	bh=R4bFuwzCbhJ+188XUh8XwprDMEtEHFoHtrsAsGVOyD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m4M7dKNnG8NBB7EXT2/Ni6U0DIl8XJYOk1ke0KoH/pPkV5DZx3yrvvqVGdEfDv2W75qRJVniv6C3LMjp6U0Yt6EcY5kYm3y9uupyx8Ar8pPM0D+BmoL5ZBamaM2vQId4X032LFWJyLo0I/cRwlIMd51CkXdG/7eOi9A2Qo/t79k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAzbRA0Q; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAzbRA0Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762367868; x=1793903868;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R4bFuwzCbhJ+188XUh8XwprDMEtEHFoHtrsAsGVOyD8=;
  b=aAzbRA0Q2uDurVH9NeNnjDWBPq9wy+hAj2j9oyBFR57CX9Azc4l0nd/+
   junL5Qvfyx7Lo6F+IUK+1v54RwKGO7v3g8/jigcZ4yIjvWx5MUT4k6YBa
   ewtsAJJ6V2GWBRXBefeLo43Mp7KCV4RZyR0+kRXpXRRtawTvCuT5DnssU
   7Am7+Alvpp4kyvzIZHVeHZLCsSEiixVzb828laveflyNpKjKzsQM4flWh
   C9NNsRcKi+Rz03YcaOa94U3FwZEA15edmKvKCfR3FN0eAp4lwvo2QZMAf
   RRYLatHymNcwIJBC0Pc8iQXN1xfiP8j2Dms6hni7BrdV4fBds0u1GY3Rf
   A==;
X-CSE-ConnectionGUID: XISR8jLTS/u4HkN/pYTr6A==
X-CSE-MsgGUID: QLS/YDNGTZ6muwFlJOSFfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="82122111"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="82122111"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 10:37:48 -0800
X-CSE-ConnectionGUID: 0xdNeHl9RUeQBFiybfJjpg==
X-CSE-MsgGUID: XC/DnSzmQMyT3FXIJqvJ+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="191819128"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa005.fm.intel.com with ESMTP; 05 Nov 2025 10:37:46 -0800
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 5BB5296; Wed, 05 Nov 2025 19:37:45 +0100 (CET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ira Weiny <ira.weiny@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Date: Wed,  5 Nov 2025 19:37:43 +0100
Message-ID: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the snippets like the following

	if (...)
		return / goto / break / continue ...;
	else
		...

the 'else' is redundant. Get rid of it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/nvdimm/label.c | 60 ++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 04f4a049599a..b129f3a55a70 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -734,13 +734,13 @@ static enum nvdimm_claim_class guid_to_nvdimm_cclass(guid_t *guid)
 {
 	if (guid_equal(guid, &nvdimm_btt_guid))
 		return NVDIMM_CCLASS_BTT;
-	else if (guid_equal(guid, &nvdimm_btt2_guid))
+	if (guid_equal(guid, &nvdimm_btt2_guid))
 		return NVDIMM_CCLASS_BTT2;
-	else if (guid_equal(guid, &nvdimm_pfn_guid))
+	if (guid_equal(guid, &nvdimm_pfn_guid))
 		return NVDIMM_CCLASS_PFN;
-	else if (guid_equal(guid, &nvdimm_dax_guid))
+	if (guid_equal(guid, &nvdimm_dax_guid))
 		return NVDIMM_CCLASS_DAX;
-	else if (guid_equal(guid, &guid_null))
+	if (guid_equal(guid, &guid_null))
 		return NVDIMM_CCLASS_NONE;
 
 	return NVDIMM_CCLASS_UNKNOWN;
@@ -751,13 +751,13 @@ static enum nvdimm_claim_class uuid_to_nvdimm_cclass(uuid_t *uuid)
 {
 	if (uuid_equal(uuid, &nvdimm_btt_uuid))
 		return NVDIMM_CCLASS_BTT;
-	else if (uuid_equal(uuid, &nvdimm_btt2_uuid))
+	if (uuid_equal(uuid, &nvdimm_btt2_uuid))
 		return NVDIMM_CCLASS_BTT2;
-	else if (uuid_equal(uuid, &nvdimm_pfn_uuid))
+	if (uuid_equal(uuid, &nvdimm_pfn_uuid))
 		return NVDIMM_CCLASS_PFN;
-	else if (uuid_equal(uuid, &nvdimm_dax_uuid))
+	if (uuid_equal(uuid, &nvdimm_dax_uuid))
 		return NVDIMM_CCLASS_DAX;
-	else if (uuid_equal(uuid, &uuid_null))
+	if (uuid_equal(uuid, &uuid_null))
 		return NVDIMM_CCLASS_NONE;
 
 	return NVDIMM_CCLASS_UNKNOWN;
@@ -768,20 +768,20 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
 {
 	if (claim_class == NVDIMM_CCLASS_BTT)
 		return &nvdimm_btt_guid;
-	else if (claim_class == NVDIMM_CCLASS_BTT2)
+	if (claim_class == NVDIMM_CCLASS_BTT2)
 		return &nvdimm_btt2_guid;
-	else if (claim_class == NVDIMM_CCLASS_PFN)
+	if (claim_class == NVDIMM_CCLASS_PFN)
 		return &nvdimm_pfn_guid;
-	else if (claim_class == NVDIMM_CCLASS_DAX)
+	if (claim_class == NVDIMM_CCLASS_DAX)
 		return &nvdimm_dax_guid;
-	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
-		/*
-		 * If we're modifying a namespace for which we don't
-		 * know the claim_class, don't touch the existing guid.
-		 */
-		return target;
-	} else
+	if (claim_class == NVDIMM_CCLASS_NONE)
 		return &guid_null;
+
+	/*
+	 * If we're modifying a namespace for which we don't
+	 * know the claim_class, don't touch the existing guid.
+	 */
+	return target;
 }
 
 /* CXL labels store UUIDs instead of GUIDs for the same data */
@@ -790,20 +790,20 @@ static const uuid_t *to_abstraction_uuid(enum nvdimm_claim_class claim_class,
 {
 	if (claim_class == NVDIMM_CCLASS_BTT)
 		return &nvdimm_btt_uuid;
-	else if (claim_class == NVDIMM_CCLASS_BTT2)
+	if (claim_class == NVDIMM_CCLASS_BTT2)
 		return &nvdimm_btt2_uuid;
-	else if (claim_class == NVDIMM_CCLASS_PFN)
+	if (claim_class == NVDIMM_CCLASS_PFN)
 		return &nvdimm_pfn_uuid;
-	else if (claim_class == NVDIMM_CCLASS_DAX)
+	if (claim_class == NVDIMM_CCLASS_DAX)
 		return &nvdimm_dax_uuid;
-	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
-		/*
-		 * If we're modifying a namespace for which we don't
-		 * know the claim_class, don't touch the existing uuid.
-		 */
-		return target;
-	} else
+	if (claim_class == NVDIMM_CCLASS_NONE)
 		return &uuid_null;
+
+	/*
+	 * If we're modifying a namespace for which we don't
+	 * know the claim_class, don't touch the existing uuid.
+	 */
+	return target;
 }
 
 static void reap_victim(struct nd_mapping *nd_mapping,
@@ -990,9 +990,7 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 		mutex_unlock(&nd_mapping->lock);
 	}
 
-	if (ndd->ns_current == -1 || ndd->ns_next == -1)
-		/* pass */;
-	else
+	if (ndd->ns_current != -1 && ndd->ns_next != -1)
 		return max(num_labels, old_num_labels);
 
 	nsindex = to_namespace_index(ndd, 0);
-- 
2.50.1

