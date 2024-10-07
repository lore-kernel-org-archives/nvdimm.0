Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD72B1DF26C
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343039; cv=none; b=d4vwG8dh6GJte8jOQjwv+kjyc2ak5z2b/0LrZkY8R2+fGkw/WeW+Zw5BHUQPfQdMR/5oC3EgjxhG/kVNut9iXb7xyzcFRY8YCvX+6t63wPqN7ZFgjJCetD7p/5d4W1B94N701NVYcMHY7eTwVyQpTf0ehrkhWnq80OJltP9PKFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343039; c=relaxed/simple;
	bh=T4ONxj9Q6toolPyZIZ3ZRAaoin1m2LOEif/CkEOVhDg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BzYhiIazQEJLqKm+Edj7RJOdpdR0u8A2d5gsYbhpB2NjAT5q2Be1gAHrESSBL/bq5OCqjaFQiU/kSaFwcjROsilTO3/9Pvm9TNP6cJS9p3onl2sAO0Vy6tEqZd2HJwk78xMwvHJjJjOnZwal2XBlraS7bzqCE6QfEoyHcgX7pN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q4WLCDSs; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q4WLCDSs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343038; x=1759879038;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=T4ONxj9Q6toolPyZIZ3ZRAaoin1m2LOEif/CkEOVhDg=;
  b=Q4WLCDSs5X2LBgdI+L6Br2mckKA6+88wdO9fIysxQNCyZzEhz9lidj2d
   WpVH18pQA/cZQjX0j4HKW4BI78Pvx7VYQCiH8kR+W/TaQJKbyyDkMpJhV
   z0JAisO2YkfrpRjTFuU1GmaIKuDm/oM4y4j/xRSC/vVDuTKSevDtoQcaY
   DJZ6CzU1RLYojd2YHkHEeMhzVfFbFZu+lPpxAPw/sEbce7bCHCv3H8GbN
   qDNeOpcewuWmZorj5lELjDG86RUwWceIV3T7BSKGfa8kGDJRWD/4QBwUU
   VEj8vmWBZ6o09GIPnAuIy4LGoRIkK2Og2pMGvfXEYOrKbDhPMJNXuWwXI
   w==;
X-CSE-ConnectionGUID: YGzL6mybT5KFurD39Qpv4A==
X-CSE-MsgGUID: 6ATvfHYYRC6hn3uZKr+LVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45036982"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="45036982"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:07 -0700
X-CSE-ConnectionGUID: 7QLL7YquS1aReGhNfIBBJA==
X-CSE-MsgGUID: Iwxus2qfSTeQ8YtBermmnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75309185"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:05 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 07 Oct 2024 18:16:24 -0500
Subject: [PATCH v4 18/28] cxl/pci: Factor out interrupt policy check
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-18-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=2095;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=T4ONxj9Q6toolPyZIZ3ZRAaoin1m2LOEif/CkEOVhDg=;
 b=Ri1LecsG4XkzHYhbxp+mFk0t/pwfR/hCtw5xySMuXrIHw+2iwhw0gKtFGK/ViRjhjdwk+tC3h
 vMKWANTbhXdDxLV+U/FEF4nPQrerCsObO2dfyLzaxGjwDu1jKItIdbg
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Factor out event interrupt setting validation.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: reword commit message]
[iweiny: keep review tags on simple patch]
---
 drivers/cxl/pci.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 29a863331bec..c6042db0653d 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -742,6 +742,21 @@ static bool cxl_event_int_is_fw(u8 setting)
 	return mode == CXL_INT_FW;
 }
 
+static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
+					  struct cxl_event_interrupt_policy *policy)
+{
+	if (cxl_event_int_is_fw(policy->info_settings) ||
+	    cxl_event_int_is_fw(policy->warn_settings) ||
+	    cxl_event_int_is_fw(policy->failure_settings) ||
+	    cxl_event_int_is_fw(policy->fatal_settings)) {
+		dev_err(mds->cxlds.dev,
+			"FW still in control of Event Logs despite _OSC settings\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
@@ -764,14 +779,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (cxl_event_int_is_fw(policy.info_settings) ||
-	    cxl_event_int_is_fw(policy.warn_settings) ||
-	    cxl_event_int_is_fw(policy.failure_settings) ||
-	    cxl_event_int_is_fw(policy.fatal_settings)) {
-		dev_err(mds->cxlds.dev,
-			"FW still in control of Event Logs despite _OSC settings\n");
+	if (!cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
-	}
 
 	rc = cxl_event_config_msgnums(mds, &policy);
 	if (rc)

-- 
2.46.0

