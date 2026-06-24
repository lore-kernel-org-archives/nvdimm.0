Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38848386C36;
	Wed, 24 Jun 2026 06:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782281026; cv=none; b=LTVF27yNs1FZ/CSl/kKTFEKES4ZX5F5e3quq5pJzDKukCYGBFs1hzM1ct++TlUdOvVBdeXKFRtlmdEOxq6UmHY6BpSSTNKCnTh2WXN6KekLVtqwCoF+e4tZojfb7tWVADEHoCFQKcmEg1HWq3s4EGeFyoQBQeYfprRRBHj6yMKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782281026; c=relaxed/simple;
	bh=FpQrQoPqPJW3h6WyS+ln+mYHPK2LlUvR/MySMZU1FPI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ox+NOIJ3/B1aedBr8bQAjwYj0puUlXuOtPjSMtyvlErQCo1ujBf/+hVc+fYOmMuCa9GOF3npzVlQnbTCbZ+Yw0R/mldEiy29FmBRgQnx5QabuBAXZ6UBDgR/476Fv9cqoOpqkojsgX8JT1U8+Puj/hgnMd4tIWG2gDCHzOIH4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXfKe0hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXfKe0hR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8E74C2BCB4;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782281025;
	bh=FpQrQoPqPJW3h6WyS+ln+mYHPK2LlUvR/MySMZU1FPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZXfKe0hRFu7SpoAVfHNqVxdZAN8YH2xVlPCAMCNLG7XVBC2FjijMadB8bboUpLk2X
	 VF0kKK7xvb06zzFqhiZRLhbw8DkJ3bpxQYfWtnHFGgy+bIqjMQEI0xsF2jTlXJIjdd
	 vJTluRTuF6h/2Mv+CCG/7+oOvyXjGP2maEnws3RbHtvm30Ikjd/xwmj53ptydhTQ+o
	 w7D+y7Yrfd46rRO/oRBMWCjsa+EdB+C8j0YZtdqiNM0K8JUgpjfprTMc+atsn9rHoJ
	 c5f4kHbhWltFcHGCCTIRwVJXfL0c0tv3B67sPy/gXStD+A7SPvRwcOKr+ZZ36OIf8y
	 9/ED8BpUB131A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D675CDB470;
	Wed, 24 Jun 2026 06:03:45 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Wed, 24 Jun 2026 01:03:45 -0500
Subject: [PATCH v3 1/2] libnvdimm/labels: Prevent integer overflow in
 __nd_label_validate()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-b4-disp-d8279485-v3-1-cdb6cab28b41@proton.me>
References: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
In-Reply-To: <20260624-b4-disp-d8279485-v3-0-cdb6cab28b41@proton.me>
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams <djbw@kernel.org>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 David Laight <david.laight.linux@gmail.com>, linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782281024; l=1957;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=iBEqX8HPWjAgcZWGDGjBLr0kG9lZNDGGFL2JmOhPZfY=;
 b=+Upio+vIexII5OXdL3yy4kHq5Xu9Cae/FTXba91+xIIt9Cs9U0Jym4A80Dvys6gWCxLm25aAo
 jl7bUm18jufAmb2Me4rgjbzkEDK5c8BV9hxG9350qjnd1XoyZfQ4Fwf
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

The on-media namespace index field nslot is a u32 read from the DIMM
label storage area.  __nd_label_validate() bounds it against the config
area size, but sizeof_namespace_label() returns unsigned, so the product
nslot * label_size is evaluated in 32-bit and wraps modulo 2^32 before
the comparison.  A crafted nslot passes the bound and is then used as the
loop trip count in nd_label_data_init(), whose memset() walks off the end
of the config_size buffer: an out-of-bounds write.

The field is not trusted -- it comes from the medium, or from userspace
via ND_CMD_SET_CONFIG_DATA.  Evaluate the product in 64-bit so the bound
check is exact; conforming labels are unaffected.

The check was safe when introduced by commit 4a826c83db4e ("libnvdimm:
namespace indices: read and validate"): it multiplied by sizeof(struct
nd_namespace_label), a size_t, so on a 64-bit build the product did not
wrap.  Commit 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label
definitions") narrowed it to 32 bits when the label size became a runtime
value read via sizeof_namespace_label().

Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
Cc: stable@vger.kernel.org
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/nvdimm/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 4218e3ac4a2a..ec12ce72cfe2 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -202,7 +202,7 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
 		}
 
 		nslot = __le32_to_cpu(nsindex[i]->nslot);
-		if (nslot * sizeof_namespace_label(ndd)
+		if ((u64)nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->nsarea.config_size) {
 			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",

-- 
2.43.0


