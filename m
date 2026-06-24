Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7C836A367;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274743; cv=none; b=YrQ6iriknYqVGC/ytOwjeRggDI08RPdbERGkU+ZoXWyhQ4OX2/QKN9udC7KOG7X7QiUSToPgnq/azZcO91MYeuCFgyiHh6i77+iaN362ezww0F7Pwax7ncoYCu2fstpUluJ7IgFdN+LEttZQiMoBnGcT+YFQyfNIItvk4hyXfs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274743; c=relaxed/simple;
	bh=ru3LDxrx8/+pkYWd85/cD1RvnwWEQRsQbLUH4qg7JmU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BThSv7y+3CDHiQRnPwiqJw8TljfQkBtB4DmfJArIsBZ2wICEh1gURrk0u2llB63Ua6b0FEBHFwubvS6l2j9QjH/HHwaZAQcj4Aod8pTFK7afrrpn1mV5bbmjl0/bGEBuCtqI3k8s82BmY/9iETxQj02nBk4nIPnEIHMGxmRei5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVzcjXb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVzcjXb1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C28FDC2BCB4;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782274742;
	bh=ru3LDxrx8/+pkYWd85/cD1RvnwWEQRsQbLUH4qg7JmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OVzcjXb1xMFxE2BUGOjq9lOff5b88TbZ9eKZdhK358WltIMoUKXpUBBeQy56fhwM8
	 YV5htD50k9siNj27C2v2IEquDF0Jgysve0yyfPAZeYa0gGdVY3j8DlY37m/LciAVZ7
	 VcaFRIi+ZCFXU5TW68wDufw8y+anH+Rz2mPaADoMxO8nAQcWGgOxRDgmHLiJOVp1DA
	 WvXsFPeohM+FYbCC1rmQtD0dN/8C9gehcKoPkFGxr7bC9qoeuHxnEaoCDvPyyoC4jk
	 Oxro8NVjsMStUllDl9RdcpdFar9y0mGrhfeXNTEKRyNrrQ2F458kRY+SYA/HeWFrIj
	 ICCcvRMWc1gyA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD758CDB479;
	Wed, 24 Jun 2026 04:19:02 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Tue, 23 Jun 2026 23:19:02 -0500
Subject: [PATCH v2 1/2] libnvdimm/labels: Prevent integer overflow in
 __nd_label_validate()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260623-b4-disp-1f2c537a-v2-1-59af73f1f090@proton.me>
References: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
In-Reply-To: <20260623-b4-disp-1f2c537a-v2-0-59af73f1f090@proton.me>
To: Ira Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782274741; l=1939;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=q0i06gR6biCNC+Je6Bjwu/WLkEUdu04uI3r3m216Cng=;
 b=C/kxooCTdWphtHwNI9K7/yru0NxiZdlww6pyZnaogrNihvEOhr7SUdrhJA1dqGhg0bnZ3KOKt
 Pg/NmSnM/EhB97Ou3aMJhacigf3RV3rGVOySbFzIOD8F8HvOCA+U2bd
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
namespace indices: read and validate") -- it multiplied by sizeof(struct
nd_namespace_label), a size_t, so the product was 64-bit.  Commit
564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
narrowed it to 32 bits when the label size became a runtime value read
via sizeof_namespace_label().

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


