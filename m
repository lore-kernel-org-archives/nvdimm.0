Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F73C257844;
	Wed, 24 Jun 2026 04:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274743; cv=none; b=P1wvd2vA6LT5RuCw+nNmFejqr5+L6catksVw3uKVhthXCRp83UkmblyAaynmLkuxAQrhZe1/1cFcTzhmxZFCctArrgB5PZIUV5efb5eDzlD31SqiIQtbHLtvDadUmGBzoBS1DUcXyZI4G8sm33idIkOy516BnXyJ+rKF4hjEhUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274743; c=relaxed/simple;
	bh=IF76+bi8vVUJi85fMXfnnIAagGFOCYS6w3SxOSwQ03Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dD8CJaFeK3LBS4BMLIOZrq5HlSb/e8OlIf6YRPoOWkwtVMKSFYyrB/ShFkFgN2Z/PlevcEudAJVsiWGns46tlZKDQuQx/k9SmbNtaRsKQxcZ+tHktbQqvsYwD6c3GuzBAl4v3ptqy0LUfrovvrApkMmYVnqn8j5DfcLRF6ini7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4mN55++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4mN55++"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1E77C2BCF4;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782274742;
	bh=IF76+bi8vVUJi85fMXfnnIAagGFOCYS6w3SxOSwQ03Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h4mN55++t5YUtKVvp4vVU45nPOXNmnjPWCIz3Bu7yS5mxU/5gttkI6wK11R9joSe7
	 JEz4YySJjRapgVFTaw2BRZYyPxECQTv9YOQDEW5FNNYKrdwSthqG/sS4Q5DcJjXY7V
	 /LHTCqEFlTGBmtIWOJuL5mn4TO9IodTYotz/cjAeMOgQy3eOQntWc0V+lskZ8ndGO1
	 0Earkyrnw5RFy531PBwbPnx/THTyoLOF1iESoydylNfhxzmV1j/9QcFc7CztraqiLe
	 cxRI7LteNnSWT5OUoQdnZ8jCNYMURjrnNg53uNka5ashiHa5zXjTqj0HUzEQYYWuE4
	 BDHcWjWz+R0Zg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC443CDB481;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Tue, 23 Jun 2026 23:19:03 -0500
Subject: [PATCH v2 2/2] libnvdimm/labels: reject an implausibly large
 on-media slot count
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260623-b4-disp-1f2c537a-v2-2-59af73f1f090@proton.me>
References: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
In-Reply-To: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
To: Ira Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782274741; l=2142;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=2tqdVOXGrP3V/0SevNfIQBF49FyQ7PW7p3H8Z9FOK7I=;
 b=8RLtTIfJu3Nxr/7NWZq68j+42eciXwKhk35vyYWjXy/+TOsAxYm1bvIkH4byfD6MDoi+a4CbR
 aAfNWPktGcLDk3wH4Xfwo77kVPkp2S7b/JkUoTTY186EfEdV2ln50zk
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

Even with the bound evaluated in 64-bit, nslot is constrained only by
config_size, which nvdimm_init_nsarea() takes verbatim from the dimm's
ND_CMD_GET_CONFIG_SIZE response with no upper sanity check.  A firmware
or emulated device reporting a large config_size would let a
correspondingly large on-media nslot pass validation and drive a large
allocation and memset loop in nd_label_data_init().

Reject an nslot above NSINDEX_NSLOT_MAX (64K).  The largest legitimate
count is config_size / label_size -- about 1K on a real ~128K label area
-- so this cannot affect a conforming device, and it bounds the slot loop
independently of the firmware-reported config_size.

Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/nvdimm/label.c | 4 ++++
 drivers/nvdimm/label.h | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index ec12ce72cfe2..ce1e43d67bab 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -202,6 +202,10 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 		}
 
 		nslot = __le32_to_cpu(nsindex[i]->nslot);
+		if (nslot > NSINDEX_NSLOT_MAX) {
+			dev_dbg(dev, "nsindex%d nslot: %u implausibly large\n", i, nslot);
+			continue;
+		}
 		if ((u64)nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->nsarea.config_size) {
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 0650fb4b9821..74d7c1cc7476 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -28,6 +28,13 @@ enum {
 	ND_LABEL_MIN_SIZE = 256 * 4, /* see sizeof_namespace_index() */
 	ND_LABEL_ID_SIZE = 50,
 	ND_NSINDEX_INIT = 0x1,
+	/*
+	 * A sane ceiling on the on-media slot count.  The largest legitimate
+	 * value is config_size / label_size -- about 1K on a real ~128K label
+	 * area.  A count this large cannot describe a real device; it would
+	 * only drive a large allocation in nd_label_data_init(), so reject it.
+	 */
+	NSINDEX_NSLOT_MAX = 64 * 1024,
 };
 
 /**

-- 
2.43.0


