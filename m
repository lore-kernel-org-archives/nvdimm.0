Received: from buffalo.tulip.relay.mailchannels.net (buffalo.tulip.relay.mailchannels.net [23.83.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3442D061D
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764367382; cv=pass; b=BmeonH7KGr6NHh8l2sLJsQD41ilL/B+7ZeoRdoOCRv3wk2bCBiV4Q4etHEFpcALvUDamhYxKgjzuOFkeMRnNtmjOGzHzbiDbY3fw3LqR51KWttIjQl0wF0zoxxpkGHW0gfib/Ojw1bBSVurv2QGSP+toxmIAVeGxNhhk/pcgjxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764367382; c=relaxed/simple;
	bh=K0a6bK8tDOW7lYpg+jxM+uHkwNlnPd3XQEag7cD90gA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KpIKvQ29YxnTCfv2jOu9lAXOwUgOTHthU47H/ALQQ0tniVSseHMcgp5RC6dvIf2Tk0ZBtGAdBcO0mfvot9WF8wCfiPZvi/8rZm7W+i7LqMI+b1tgIVd/ihfivu9ZUPxUq5tcN7C6NsSsPYOQDalvSUNhwTGATb66Va0yCIP2BmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=RvDG+2yD; arc=pass smtp.client-ip=23.83.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="RvDG+2yD"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E7A78800C0C;
	Fri, 28 Nov 2025 21:23:10 +0000 (UTC)
Received: from pdx1-sub0-mail-a252.dreamhost.com (trex-green-9.trex.outbound.svc.cluster.local [100.102.148.76])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 84531800B79;
	Fri, 28 Nov 2025 21:23:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1764364990;
	b=vxR64DgZ3KdujCtEdYrecbFgZqHGJph3x6Z59dKdOiUrEuDPEM5MB47/xMhF4uiHzbPoyc
	Nm27+ZRYCUKwPU6xYi3qmjCrMB7d9AoV8vJoS73CNcVF9HULkbjoxD7viIooJFqKlOn3Fa
	nKQgnSSpS2QD03S7GWLYSHLodoyuCyONpa/Wy8L/r7la+V/Mzk13Wdh8opBHRQ6KhomzyH
	vOZwtU+Cm2vRQqG+TM0o8iTS80GdTDoPBcgO5rQ/zRX1dMs0/7RbQL1x9InP7rGyalDU4B
	IgOx/cl2cawQUdNgrWM9mwFBQXnFaZY0a5xChESQOe/lqzgxl4RSpxdTDihRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1764364990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=jYHOyMy2SoqRqm1HCA7uqwIWTwSDiYufINfDVDJIerU=;
	b=TNfsGgf51Usfs2aG3t2ZeQs0bVRGZrshYB3069+AN6/jChkoLNtwxQdmWfJd0aVc20xIEz
	VIB4e/JMKI+B6dzmL2rWHYPyntUgKmhqttxtwSa5Ql6slPZpJf0knOrLuTq/a72PGFiigB
	kU3aypXIPwKoLaoDGmztmLdcwh1SJ7QH6UxEAgqDI2wm9NcnV3wZmSFU3de9KX0YhK9wY+
	y9Ie9fVyySJYlxqL06CzH6sYBsFRqBHdZu3VY1GrYPc4JjuQBZsgt/GonLXueHP0Jo4kUC
	Laa36RIJriEqSYBj9dSfeKE71K7taA8lZ2kjsTJLKMcpg/1i3csxGnGzuGKhZg==
ARC-Authentication-Results: i=1;
	rspamd-545f6844bd-dvp77;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Industry: 05e4d16e6d340686_1764364990798_3858559878
X-MC-Loop-Signature: 1764364990798:2090581189
X-MC-Ingress-Time: 1764364990797
Received: from pdx1-sub0-mail-a252.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.102.148.76 (trex/7.1.3);
	Fri, 28 Nov 2025 21:23:10 +0000
Received: from offworld.lan (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a252.dreamhost.com (Postfix) with ESMTPSA id 4dJ5qx6wkvz105b;
	Fri, 28 Nov 2025 13:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1764364990;
	bh=jYHOyMy2SoqRqm1HCA7uqwIWTwSDiYufINfDVDJIerU=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=RvDG+2yDmeLzuaD+0+iSqDkhHR6xqIvSspYmk81Tll9K8LSikZyWcYxZ9G3mZIRpj
	 ta+0j15Zr62WiMlck/k2y82UmQRsYdPhESApW5SdkfBo6pYdazRd0xF/pLAD1aeVJo
	 RlpMaRx3VoSnZLlOvOVy1pWRB5x3O8xo6Vo6iKRVOHcDgXcsAvddetT3GzXPZbh9S1
	 zbYGkQPDUZYW2QT9NWLsCDT79ADFMB+69HkScYA1qddZOryFCY9m8xNeDWEBMOCHKF
	 2K4itYWrKqZM+I7vWHbDdu/aJI+EDX50Tba1XaaBUK8f7zUpiOKxK1hrrWru1Pxz1G
	 gKLYQIp8ZtK5Q==
From: Davidlohr Bueso <dave@stgolabs.net>
To: vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH] drivers/nvdimm: Use local kmaps
Date: Fri, 28 Nov 2025 13:23:03 -0800
Message-Id: <20251128212303.2170933-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the now deprecated kmap_atomic() with kmap_local_page().

Optimizing nvdimm/pmem for highmem makes no sense as this is always
64bit, and the mapped regions for both btt and pmem do not require
disabling preemption and pagefaults. Specifically, kmap does not care
about the caller's atomic context (such as reads holding the btt arena
spinlock) or NVDIMM_IO_ATOMIC semantics to avoid error handling when
accessing the btt arena in general. Same for the memcpy cases. kmap
local temporary mappings will hold valid across any context switches.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/nvdimm/btt.c  | 12 ++++++------
 drivers/nvdimm/pmem.c |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index a933db961ed7..237edfa1c624 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1104,10 +1104,10 @@ static int btt_data_read(struct arena_info *arena, struct page *page,
 {
 	int ret;
 	u64 nsoff = to_namespace_offset(arena, lba);
-	void *mem = kmap_atomic(page);
+	void *mem = kmap_local_page(page);
 
 	ret = arena_read_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
-	kunmap_atomic(mem);
+	kunmap_local(mem);
 
 	return ret;
 }
@@ -1117,20 +1117,20 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
 {
 	int ret;
 	u64 nsoff = to_namespace_offset(arena, lba);
-	void *mem = kmap_atomic(page);
+	void *mem = kmap_local_page(page);
 
 	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
-	kunmap_atomic(mem);
+	kunmap_local(mem);
 
 	return ret;
 }
 
 static void zero_fill_data(struct page *page, unsigned int off, u32 len)
 {
-	void *mem = kmap_atomic(page);
+	void *mem = kmap_local_page(page);
 
 	memset(mem + off, 0, len);
-	kunmap_atomic(mem);
+	kunmap_local(mem);
 }
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 05785ff21a8b..92c67fbbc1c8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -128,10 +128,10 @@ static void write_pmem(void *pmem_addr, struct page *page,
 	void *mem;
 
 	while (len) {
-		mem = kmap_atomic(page);
+		mem = kmap_local_page(page);
 		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
 		memcpy_flushcache(pmem_addr, mem + off, chunk);
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		len -= chunk;
 		off = 0;
 		page++;
@@ -147,10 +147,10 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 	void *mem;
 
 	while (len) {
-		mem = kmap_atomic(page);
+		mem = kmap_local_page(page);
 		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
 		rem = copy_mc_to_kernel(mem + off, pmem_addr, chunk);
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		if (rem)
 			return BLK_STS_IOERR;
 		len -= chunk;
-- 
2.39.5

