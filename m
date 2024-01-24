Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0F17BC5
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087745; cv=none; b=ZfXUhdHCGKlWFrlX3JBM09MkxJ72BrHO8yCrfHa27jCR8F5nBqmYF+0aYdC0jPHe9UHYTeB8EscRwRHjsPbgJr7nkQWNxd25CvHDVExHX7/nRfBhWjSGdyC5MXWxTyHXaCnGHqrUuOw3RlYlZEde3Q/gwwnfDlMuRUO1kIxqJE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087745; c=relaxed/simple;
	bh=yXbJVVb12rsqTs5XniUFfuGO6KFzaV53IQiFefxxjOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lwtzTzvDBsgNXOcfitXd99EGkXO4Wd1FKicOpIcoYM6P8fSau56+o/MfphDixWDsHhiCFcxgRGNjHVpiopJIF6Q7MH0iF8zEpQ5l+ekW2Om2eLlfYvN28mXDdA2pyQFG1kAF+nn4npBukGYv5KeKvJmozg/S2bjNLDv4XwAQQt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=sXVYCUeW; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="sXVYCUeW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1706087742; x=1737623742;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yXbJVVb12rsqTs5XniUFfuGO6KFzaV53IQiFefxxjOU=;
  b=sXVYCUeWse8sA/d/PGAAy+bVo3QQnokCVPXomX8lSSa5taxCk20uPY/3
   fj0/dX1KxZVg/1x6jrO0XPb6ZFXjUREbgqa7Gf/5WBa66Lodn1UVUwjZB
   +q11kjfxOUd2zvLG/pu92tyPttyxgtZbPRuk7h5HRRSvcNBdPqpT80Nz6
   Hgi3UymyxUKzbuLYdbMUxFsE9qa0qIJrRm6olESMV9ldeJTwSpEwGMlN1
   JZB4LKDeFqvh9pKOpaCASfnTN4R+Lc8yzHLPli9ATmEbOQIYAIR2U/GMf
   rHa8mGUESEpsVtNNzKbYGJfa4jSPGVIRqsxbxLXHFxfqXf7iN4Y60n9Yi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="146970291"
X-IronPort-AV: E=Sophos;i="6.05,216,1701097200"; 
   d="scan'208";a="146970291"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:15:33 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 24957D9D92
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 18:15:31 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5FB4BBF4D8
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 18:15:30 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E4FA320097AC5
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 18:15:29 +0900 (JST)
Received: from Fedora-38-3.g08.fujitsu.local (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 310F41A006C;
	Wed, 24 Jan 2024 17:15:29 +0800 (CST)
From: Quanquan Cao <caoqq@fujitsu.com>
To: dave.jiang@intel.com,
	vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Quanquan Cao <caoqq@fujitsu.com>
Subject: [PATCH] =?UTF-8?q?cxl/region=EF=BC=9AFix=20overflow=20issue=20in?= =?UTF-8?q?=20alloc=5Fhpa()?=
Date: Wed, 24 Jan 2024 17:15:26 +0800
Message-ID: <20240124091527.8469-1-caoqq@fujitsu.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28138.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28138.006
X-TMASE-Result: 10--1.482900-10.000000
X-TMASE-MatchedRID: H4VA+h+lPSsjQvIpMtTP/1jhP2vy09zoBPY4SegK3jw8cwBuO6HB35tX
	hf4dcLJZOINY3OUapTCvKROQDK31eK+CQswOit7P0+DFDiN5F0HBOVz0Jwcxl6vCrG0TnfVUg9x
	e4gtUJtpX5O/oNPKt7OLiwkw2Vk7GWcA4Y6culFZKzjuZtPtIBH0tCKdnhB58ZYJ9vPJ1vSBp7q
	EhmmPgy46HM5rqDwqtG8vwxGAyKz6zYyndM+vQybAREUbP6yF+gErn0NzfulTPmd47uNafDW0mM
	BMuLI6/+NxMmlwpQ2TlVwStRSF8+DBD7g1O8OiD9UElV5SMCCrLt16YWtxzeF9NpZbddHv73iGQ
	YUPZme7O51vq1xhTsg==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Creating a region with 16 memory devices caused a problem. The div_u64_rem
function, used for dividing an unsigned 64-bit number by a 32-bit one,
faced an issue when SZ_256M * p->interleave_ways. The result surpassed
the maximum limit of the 32-bit divisor (4G), leading to an overflow
and a remainder of 0.
note: At this point, p->interleave_ways is 16, meaning 16 * 256M = 4G

To fix this issue, I replaced the div_u64_rem function with div64_u64_rem
and adjusted the type of the remainder.

Signed-off-by: Quanquan Cao <caoqq@fujitsu.com>
---
 drivers/cxl/core/region.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 0f05692bfec3..ce0e2d82bb2b 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -525,7 +525,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
 	struct cxl_region_params *p = &cxlr->params;
 	struct resource *res;
-	u32 remainder = 0;
+	u64 remainder = 0;
 
 	lockdep_assert_held_write(&cxl_region_rwsem);
 
@@ -545,7 +545,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
 	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
 		return -ENXIO;
 
-	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
+	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
 	if (remainder)
 		return -EINVAL;
 
-- 
2.43.0

