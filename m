Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D31027A130
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538800; cv=none; b=TPK0F+8J/i0OY2RaTBgS+rGLe6JOVdaQ4PH/xK9IPzyBDwc1cfRKo3JWznT9QzaiNgVgDR3XqVWsz7Khd/xmwD2qR88fuz8drxlSW9bxSkIsqgOSJwRpMXIZxGq8vQmq/qP04X37DaykC44HmL54MJpxLQOzIipC/zP8aP7+OhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538800; c=relaxed/simple;
	bh=smiYMCJ3GpxAWMiqb+arblnaWcl4SogFr6+11VFacFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lZPZ5RTYv8toExsud0+dpOR7o4fzLDFqIO8KUMm7jvwKbRy7HGS1qbHJTjH1/b4qkXGjIc07uOLyLfLsa10eNuhIeXgcRan7Fp5fg3w7m5z5S/23Pf92TFMdEumY6NISBgPzqty0D98ctZSTEJqwVGG2jHN8ZaGTjQSAkPG0F5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KlQDvjTt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KlQDvjTt"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251119075317epoutp018ede03502b8854d9e21e4acb69e5471f~5WTFRPVlD3209832098epoutp01d
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251119075317epoutp018ede03502b8854d9e21e4acb69e5471f~5WTFRPVlD3209832098epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538797;
	bh=Kg+JhK8ZnwwhPgJ82TO8KyWjNuZjCa1lJq/zsnBHHVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlQDvjTt5VEL+w+NpV41Yp7tGzipOuElnPKR6F235YLuZr6BdIEACwzPevl7+oZvX
	 BNE/h2b1lrGn9zRSWsIhldj3L3qHzdl91de+aYJ1HnrSk8iQq1TluqHvFG9fK9wHAZ
	 Ok42tZDDYO0u/6s9vvZe/vJF5mkCGaNqzxsQa/PI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251119075317epcas5p4c77b246971ef67641eaf9dddca9a75cc~5WTFCBjny2373623736epcas5p4x;
	Wed, 19 Nov 2025 07:53:17 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dBDHc1nQNz2SSKp; Wed, 19 Nov
	2025 07:53:16 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075315epcas5p2be6f51993152492f0dd64366863d70e2~5WTDzEfti1867518675epcas5p2F;
	Wed, 19 Nov 2025 07:53:15 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075313epsmtip1ee62d704c02f9eff2695f7ea412c25e8~5WTBnEPqp2565625656epsmtip1U;
	Wed, 19 Nov 2025 07:53:13 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 05/17] nvdimm/label: Skip region label during ns label
 DPA reservation
Date: Wed, 19 Nov 2025 13:22:43 +0530
Message-Id: <20251119075255.2637388-6-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251119075255.2637388-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075315epcas5p2be6f51993152492f0dd64366863d70e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075315epcas5p2be6f51993152492f0dd64366863d70e2
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075315epcas5p2be6f51993152492f0dd64366863d70e2@epcas5p2.samsung.com>

If Namespace label is present in LSA during nvdimm_probe() then DPA
reservation is required. But this reservation is not required by region
label. Therefore if LSA scanning finds any region label, skip it.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 6ccc51552822..e90e48672da3 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -469,6 +469,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		lsa_label = to_lsa_label(ndd, slot);
 		nd_label = &lsa_label->ns_label;
 
+		/* Skip region label. DPA reservation is for NS label only */
+		if (is_region_label(ndd, lsa_label))
+			continue;
+
 		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
-- 
2.34.1

