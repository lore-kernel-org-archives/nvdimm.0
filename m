Received: from gerbil.ash.relay.mailchannels.net (gerbil.ash.relay.mailchannels.net [23.83.222.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7EE30BF69
	for <nvdimm@lists.linux.dev>; Tue, 10 Feb 2026 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770764138; cv=pass; b=hksPhsWgx5N5xWSa4s/457qszDQL+EPUT4AsSODbw42+P8M8ROX90nIcdEKehPcAlWLnuBW/A7mVZaIQ/BdUUd6+8uYdddi30Ln/GGIrm8wlIvsG4JeFdXfTcXZplsPeH9W83FcsGyI51SOOnPQQYYMztwVbv7bz2OjO2vINLPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770764138; c=relaxed/simple;
	bh=6l4ckHX/6pVGrqDqsmBqTOEevkOHKvnrl2h+xvBK0Mk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fd8y/2boA3mOyaxzdmTZuALbLWLqtil/SupUmeSkZO8pDB2XHXaX5saEtdUzlvlVrgZlG3MV9aBV9bTGKPalnJVJ3abkm448VNwMeWlDyWuTPDnOniTSBn3HB9NovEFtrxYFco+Qdz5Tuh3YgK/Hs10s+a9GNwjOo8I2BK73SjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=DHRPgEDd; arc=pass smtp.client-ip=23.83.222.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="DHRPgEDd"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7102A762B8D;
	Tue, 10 Feb 2026 22:48:12 +0000 (UTC)
Received: from pdx1-sub0-mail-a229.dreamhost.com (100-123-63-54.trex-nlb.outbound.svc.cluster.local [100.123.63.54])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 054CD7631D0;
	Tue, 10 Feb 2026 22:48:12 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770763692;
	b=MuBlO3s3B6onNvCtZARBaGVptJSjl1E3tA1ZhKcPnQRQeTjGOtmEnxGuUUt5uJJvF9eb+I
	qg1V5ihOr0AkqWuqLiHZJouo2j2PvDiU9RZqTGbzNIlhlQa2hHk9FMksyQgkLCLjES4bEJ
	rU4doXwCSYfjv7J7DTCFQDnNPWhr/ZMLX3tKxlH+IzJMLyrX4E251LVrbIK3vDfBm/j7qx
	U8AVoUDOJdtIdU05UGZCMvz1TSWv+AOV1czuIqfh3Rbwfdwwo8cyacEsS7Z8D4lnaGIwuF
	0Pq2bOewYRScYLNo6bOqsDlzX2eqHlXsr9uuYNnE+ynOGNxC67Do67dPsS4+Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770763692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=e7tx4DaSBWq1kHYaIfHT/Hj8UuDrWdqdFS7PfNEl+mY=;
	b=TElViKMpYuZVSYsv/5c6Vwr/Ph2YIZn3aqMrVZDAoIX4kc1i3bGwu0Jj6mC/SZGbeerkr5
	6gByCQaGNrRVBj5xle8+2VlH4uy8bPSpqpTkrbxNcVnennlUhi12dwU9HbJ2vT9RTJ24q6
	FwuaCipAAbM/WWJlpIjosXmpyqfzSXJ8vbTHS+f2R31YGXanYFXXPuteRoy5rGQsNaypki
	sYKtlQGdC6sw5U7co8/OxvVhY39CEh3LSSAdDQxwpjg6gV9uj5bFkW//fBiSKPd+GG4T4Q
	qSm9AfRZGWhdACSL1ZCZGqOR3g7QYrXNJa2HFPOBHjz/IrVpAh1pWHP6Vzc9OA==
ARC-Authentication-Results: i=1;
	rspamd-79bdc9947c-d9xz4;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Lyrical-Tangy: 0156ed4356ee5136_1770763692267_2372659078
X-MC-Loop-Signature: 1770763692267:1177476638
X-MC-Ingress-Time: 1770763692267
Received: from pdx1-sub0-mail-a229.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.63.54 (trex/7.1.3);
	Tue, 10 Feb 2026 22:48:12 +0000
Received: from offworld.lan (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a229.dreamhost.com (Postfix) with ESMTPSA id 4f9cCv3bf1zSr;
	Tue, 10 Feb 2026 14:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770763691;
	bh=e7tx4DaSBWq1kHYaIfHT/Hj8UuDrWdqdFS7PfNEl+mY=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=DHRPgEDdSX5gYSj/Ai1nRFoi15lrpQ0sbtJdysdmhobAs4gzMjTq6P4ChFa8eHEsv
	 kymwDelALLq46LDxQP6+XCon8r4Vgi2mf9vdD0R7C8G/DDeaVfZsYOp2XteAkdFYjC
	 vdgQIS9n884yZVrvkzDIvvJgBsJ7pB6+TNFTjgNpMLtCwRM81+sDcHB0xZGUlYHQrz
	 fUgt/c+LOhGatogrKPp/NUcdSR88Q4jGgJ0h3Vt5Re1LCSSPJAwL/Ia8TjB+1+eEsK
	 6jXgBUOJkIlUS73zVn6wiHRmS2sjnRjk3JX6F0gamCLFEkrdt8+5dSzNGoPYfyncO7
	 nurGFeBoTud9w==
From: Davidlohr Bueso <dave@stgolabs.net>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH] dax/kmem: account for partial dis-contiguous resource upon removal
Date: Tue, 10 Feb 2026 14:46:09 -0800
Message-Id: <20260210224609.150112-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dev_dax_kmem_probe() partially succeeds (at least one range
is mapped) but a subsequent range fails request_mem_region()
or add_memory_driver_managed(), the probe silently continues,
ultimately returning success.

However, dev_dax_kmem_remove() iterates care free on all ranges
where that remove_memory() returns 0 for "never added memory";
as walk_memory_blocks() will never see it in the memory_blocks
xarray. So ultimately passing a nil pointer to remove_resource(),
which can go boom.

Fix this by skipping these ranges altogether, with the consideration
that these are considered success, such that the cleanup is still
reached when all actually-added ranges are successfully removed.

Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/dax/kmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..edd62e68ffb7 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -227,6 +227,12 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		if (rc)
 			continue;
 
+		/* range was never added during probe */
+		if (!data->res[i]) {
+			success++;
+			continue;
+		}
+
 		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			remove_resource(data->res[i]);
-- 
2.39.5

