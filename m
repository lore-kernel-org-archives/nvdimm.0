Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.12.242.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792784168;
	b=23CChiOAVnNzqXjQ4Dygnt6IUraMdAnZglU98mg7eoPHMlaNedPqk/tCDLNXUMphZCJL
	 FtJCCNZDm3dEhoRjur/Jfho3vYOzgP4M8+5WrxRM5dGIc58rNdiTxLv5+uYg50bhqaKn9
	 3jpBvSvg2hvrb+GdqXiVn5mVZYO3Z0inBGBbh4k4YHhuTTgpgMiz6PkW6KVUcIWUpUOHJ
	 zA+25E1K7hZKVmZ8OIqfoFET/RDg6aO2fyl5FUyIBkq2fsVBF6qrYpV3L1LWEJ19P2RBG
	 wW7qkN+fsa4P6LaeULgXtpX6TWjdBy1DnF6pnj6b/9O5KQiUa4A39qkvbHx1Zw37Afw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792784168;
	h=DMARC-Filter:Received:DKIM-Signature:X-ME-Helo:X-ME-Auth:X-ME-Date:
	 X-ME-IP:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZiaP4kLv2D8fYMRZcHkWYSetdP0lzkbKmUnNE7xiQqo=;
	b=3FLJmLgiiU+WExKIROq5efXGlJBi/IVh8YGN3TU8iUCd63U0FImK01yYoqM0kf9/edyK
	 eayX0j2xLcbcBQ00L0PAGyx9l27wyPUgMaUf8nZkadXFPVKV1Lz6jCI1ovaaz8PdEwlQm
	 zdZ16uaInmSMAZRKykwdO52b5I2iI6vxFC8u77tpkfeKzTdNdXAkG+L3Oq2K6YownBUQh
	 qf6T0CLP622cHvsyPNvh/Y0n2AGkDkEIHlLP9zQM04/2WSLp3lvYJF4VGLQI3g/63TStL
	 XocJaQZnl94vsf80tMOTX9UQ+gawi6xs+Y5FSGXoplGxLoLdKbZYVx0PXB4bgJqCGXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wanadoo.fr;
	spf=pass smtp.mailfrom=wanadoo.fr;
	dkim=pass header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=NEqN9hNb;
	arc=none smtp.remote-ip=80.12.242.71
Received: from smtp.smtpout.orange.fr (smtp-71.smtpout.orange.fr [80.12.242.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF8606A31A
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 19:36:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10EF8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=NEqN9hNb
Received: from fedora.home ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id KL3VxxUqmjxmqKL3Vxa5mL; Fri, 23 Oct 2026 21:35:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1792784159;
	bh=ZiaP4kLv2D8fYMRZcHkWYSetdP0lzkbKmUnNE7xiQqo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=NEqN9hNbwOnRdtjgteZxySfTh7zeLIquHO9ADADyhPRHcwlt2xHbVBzrwfAm+aTJJ
	 l01ci3XzI0OxSnw4e5MswampLIDsSu5zr+5Kiaa9UBgnmho7j9KbKCmAzlU/n3+SDM
	 CAOKN4R5pr2g/RGStE844pit7/IRp6g0/frgPFjtSpxScIO1VHu/Drguz6NDFF1Bay
	 NStJMkom6MIM+NX+LZggtIJTT0eMcTVodZLcWf0h2W5fWzWdkG4VXJJjDjHlhaNXDU
	 IszOscVtioErTAwPGUSTsPtNc7vn2kt60IvfOAFlpPEKdBphgQJOaUvzNmOjeNYnzF
	 S0Cc5c8q0TkqA==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 23 Oct 2026 21:35:59 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: hemanth.selam@gmail.com,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	nvdimm@lists.linux.dev
Subject: [PATCH v2] nvdimm/pmem: Propagate devm_init_badblocks() error code
Date: Fri, 23 Oct 2026 21:35:40 +0200
Message-ID: <a24a19c429dd734c83c563f9b3c5fb5514cd7de0.1792784093.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.56.0
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

Propagate errors from devm_init_badblocks() instead of hard-coding a
-ENOMEM.

This change is a no-op. The sanity check in devm_init_badblocks() can't
fail, so -EINVAL can't be returned. And __badblocks_init() can only return
0 or -ENOMEM.

However, propagating the error code is cleaner and more future proof.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Changes in v2:
  - rebase with -next-20261023
  - Update the commit summary and description. It is not a fix anymore,
    just a clean-up. The Fix itself has already been applied in commit
    855a46681e0b ("nvdimm/pmem: Release gendisk on probe failure")

v1 (from 2021!):
  - https://lore.kernel.org/lkml/f1933a01d9cefe24970ee93d741babb8fe9c1b32.1636219557.git.christophe.jaillet@wanadoo.fr/
---
 drivers/nvdimm/pmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0766a6949b28..76e80eccc8e7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -563,10 +563,9 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb)) {
-		rc = -ENOMEM;
+	rc = devm_init_badblocks(dev, &pmem->bb);
+	if (rc)
 		goto out;
-	}
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.56.0

