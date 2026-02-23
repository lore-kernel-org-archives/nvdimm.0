Received: from sienna.cherry.relay.mailchannels.net (sienna.cherry.relay.mailchannels.net [23.83.223.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D36361641
	for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878339; cv=pass; b=pL14v0GwxhJKjxo+3ISAiMT21VXlH/1HGD8imxeJKGaSPHeaWlg870HEhRoFLUFe7MjfVcgqrvUlwCl+2UUajFqEcZ1S6URPXjfcU83mDQ7RbCpbTJfqBOt+RjXXHuNOzsr5TYo4ZxUZnYV227O4zZZ9nh6euIoAAJ8cyAQPeGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878339; c=relaxed/simple;
	bh=ekf6e+nPHeTQJMvQ6yWX0/LYM4cZwOTrXiQY1gABwO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PuDbSE/e9fOfmz5r5uMUdvEbBH1g8bJu5vA0cGmvXTDPVh6IRIRIZP8J4+BZl/rpPepJJ+MCEOrKkudYvj54qTxC+o+/YhbrrWu5H8QvW9razteyYyipfqqcTtEBQEdVt5FUQW1xz1AkF9LbOjW6afZtydIe+uZTkNX+b2uhvsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=GuCkQUR/; arc=pass smtp.client-ip=23.83.223.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="GuCkQUR/"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id CCCB0822197;
	Mon, 23 Feb 2026 20:15:23 +0000 (UTC)
Received: from pdx1-sub0-mail-a223.dreamhost.com (trex-green-1.trex.outbound.svc.cluster.local [100.99.123.233])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5711A822F70;
	Mon, 23 Feb 2026 20:15:23 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1771877723;
	b=TnFmY4bmS+0GVz6chJ9QJfUT+4n/IKYCZ9KGq/Pyt4Dx2IviOhv9/RPEMJOwhwMrer1efk
	xG+QwXm9T155PlHumoKgPZCWtTZ9Kdb3JWVqZITa3N8S3uBxYO9VYiPGz33Z4pgK6Sjj2A
	galu5GAgGT5ZhP0KYM0RCrfH+9qgvBYL5vlojmBuM/Gz/uMcXdaJEd+kPa5QqMn/QnOiDR
	1PIboQUFeY8kXcnOuozhmWxmIVS2JZv033RnFYZJ4wqeoUxitqRjyqfuKEIWc4HOPud+l3
	50gResNPeDj5OOL0FeXHvUw8nvLY+X5OtITRttXisj/y6owe/fRJbNgGoAQ8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1771877723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=8ihYEdPtitx3DHHP0f7Db/Lmo6pPSrakWF+cfj53YAA=;
	b=zDehrEnTWgjxq/HWLHoUeYVnM2B7gD7LpbROfO4N/ByQ6kco0s1IpXgjGTk7iktZz3WzJk
	QSptSV/MvCaECXSOAaxPOP935lVL9NhCRvfHa5eZodyMn6hX2k3d0THLD7Xc3yvEvdmB2y
	BE/+/cctiS7fRcKX6Ar/vehZQy84mx8NsHFOnfvIJwxjlViWWLbso0qXSgyW01QSz/DSha
	mjL4tBijU8e9z9MJQGrRp3UOAdHvi+NuMIqChgghikVlYS00NUuZiXLXsbwybu2enF3maq
	qn5S6dNdNnG3V9T8mTeCcHbZ90DuciOaGKW2ye4BAMoNdwy4uRb+gtUdLK4Yaw==
ARC-Authentication-Results: i=1;
	rspamd-7f65b64645-q8gvw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Whimsical-White: 752be4815a60e312_1771877723645_262619074
X-MC-Loop-Signature: 1771877723645:1665630446
X-MC-Ingress-Time: 1771877723644
Received: from pdx1-sub0-mail-a223.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.123.233 (trex/7.1.3);
	Mon, 23 Feb 2026 20:15:23 +0000
Received: from offworld.lan (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a223.dreamhost.com (Postfix) with ESMTPSA id 4fKXCZ3stjzSv;
	Mon, 23 Feb 2026 12:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1771877723;
	bh=8ihYEdPtitx3DHHP0f7Db/Lmo6pPSrakWF+cfj53YAA=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=GuCkQUR/DsB3BoVm8Q0YzNs8PX62W5r4xJkFIrGRAp4DlRVWh5DDHx4Y+Ww43Q/GV
	 KxPsdXnYxV+8mowXvVve931Rd/rNdnWTHDJrbWzagzYLMPl9FRC8OuWFuztbd+fbam
	 mqYsgVyWfmCJEPDeaq5pyXqeDwOaAuD2Bt0TiFVjfthY9VYeRJFwLyfkizkqkQMdPz
	 rQPzVmUJLMKxMvcSZN0fXW9Et2n0aXOHLXu2jgusseSr8O4nsCeUcKYv20gBmhaV7j
	 X76GjSApsagWwQ0PDgTdnswV714FvLCpDOklAfndxnVoAOyzdx0YNkMjDLcIwjCFA6
	 027X/0FR8ErxA==
From: Davidlohr Bueso <dave@stgolabs.net>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ben Cheatham <benjamin.cheatham@amd.com>
Subject: [PATCH v2] dax/kmem: account for partial dis-contiguous resource upon removal
Date: Mon, 23 Feb 2026 12:15:16 -0800
Message-Id: <20260223201516.1517657-1-dave@stgolabs.net>
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
ultimately returning success, but with the corresponding range
resource NULL'ed out.

dev_dax_kmem_remove() iterates over all dax_device ranges regardless
of if the underlying resource exists. When remove_memory() is
called later, it returns 0 because the memory was never added which
causes dev_dax_kmem_remove() to incorrectly assume the (nonexistent)
resource can be removed and attempts cleanup on a NULL pointer.

Fix this by skipping these ranges altogether, noting that these
cases are considered success, such that the cleanup is still
reached when all actually-added ranges are successfully removed.

Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
Changes from v1: reword some of the changelog (Ben)

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

