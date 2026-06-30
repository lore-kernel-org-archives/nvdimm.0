Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199E33B19DB;
	Tue, 30 Jun 2026 09:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811455; cv=pass; b=cygtUoWa4vmso7KirTZUFaYnWxs37uoxYKhfdWKtDKV+ObII7js0BzLxXlLnc5U2SEIiJrMHGGxj/ySgYOm8euQrVInofJjB7S1c3RuPo2oGbpqe/oUYWNXLmz2uxxiD6LhrODCnc+oEXgn31uTDtuc1FBtRYO5dcBS3G5zGuTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811455; c=relaxed/simple;
	bh=FVRLoVU2x1e9kVO/ojquJ2fiHumg+mqrZuoAqOQ5d6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5fpVghgJ8PDQEg7jVMmibJ49xN5jVj02CEAvSpPZjVSethjviKny/5JaVW+wiuvkKoGXLNMLf4olgjIcyzSZ5SXjcBp8hKaH3XH11pIqcQuoguLI+pBY0lUGmyw4YHF2Rm+b6c3YLHif5gXUFmOaPLiCwBssxV7NHOWeb3YJrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=FNtKDr9H; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="FNtKDr9H"
ARC-Seal: i=1; a=rsa-sha256; t=1782811440; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QmDen2EKPAQR8NOJeE0ISaP66QaXHeSUi5GbkTWuFsdSfKkQC+Zt8LeU7iYZj9ooER+Mtb5A2o/GgBlEzmIgYr27WQhh78VsZkpsxHhAsuaP22d/fwKxK8OSJVxbCt93LVSqYt9KuUD9pWQU0U214SWWhF/0dOAoK2z3IaBgDu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811440; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QJa00D7FTAMPrQ9540Ey8SOzgEX3d1y5qLq4ph/FOJY=; 
	b=hc2HqgTmn+zesQLObZNL+E0MNyY4utneNLb/j6Bi7tBiBITXlT6DN9VXZDcL4GN+CI6SClmLf2eZm4HLeBaP+n6bsPGzOBUAT05HtiNMZ57Yd23vCKAoTXb7ORHgKXuUixMzEPwph1Yo5a8W5U/y76c2njEQ5Q7TzKXmNTfPRjE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811440;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=QJa00D7FTAMPrQ9540Ey8SOzgEX3d1y5qLq4ph/FOJY=;
	b=FNtKDr9HJdbk6twiElznkYH8ZaRWLJAoyIYHaxkPRk18HSxQ3wNOJ8KSrwffvRKp
	nnm6xSbCi3t2FHkzxa/XE0bccmbTpPzJAsKShP56JaZyNM3ikdd2z/9U5L7L1Gxd33I
	guMyn7LPSM8oOd5P/h9x3k4UOifO7KI5iI2PDq08=
Received: by mx.zohomail.com with SMTPS id 178281143783177.0947829247865;
	Tue, 30 Jun 2026 02:23:57 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 01/12] nvdimm: preserve flush callback -ENOMEM
Date: Tue, 30 Jun 2026 17:23:26 +0800
Message-ID: <20260630092338.2094628-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

nvdimm_flush() maps provider flush failures to -EIO. Keep that default
because provider callbacks can report host-side or backend failures that
should remain generic I/O errors to the guest.

Guest-side allocation failures should not be reported as I/O errors. In the
virtio-pmem path, the flush request allocation can fail with -ENOMEM before
any request is submitted to the host. Mapping that to -EIO makes resource
pressure look like media failure.

Preserve -ENOMEM from provider callbacks and continue to map other non-zero
provider failures to -EIO. The generic flush path still returns 0, and
pmem_submit_bio() already converts errno values to block status for bio
completion.

Suggested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v7:
- Preserve only -ENOMEM and keep other provider/backend failures mapped to
  -EIO, per Pankaj's feedback.
v3->v4:
- New patch.

 drivers/nvdimm/region_devs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f0..7cd2c2f0d3121 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1115,7 +1115,8 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 	if (!nd_region->flush)
 		rc = generic_nvdimm_flush(nd_region);
 	else {
-		if (nd_region->flush(nd_region, bio))
+		rc = nd_region->flush(nd_region, bio);
+		if (rc && rc != -ENOMEM)
 			rc = -EIO;
 	}
 
-- 
2.52.0
