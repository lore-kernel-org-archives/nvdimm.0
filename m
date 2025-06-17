Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9F2EAD01
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165212; cv=none; b=sQ46jNZfvtyIRVnTvOlZLuBOMQgFzHl+GgfNK4+D7slQjYlgvgGhFbohOCJybvPuiIjgFJNjT3gq56Cpo7AtnlKQvAHT00yFIzTquvaNJvuMXOXEUYJqG9d213jr6kZ2HoMYeNcYe6VIIEdaMo7U9DbaQXp2d/u3Zs/b7HV4Cwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165212; c=relaxed/simple;
	bh=y6iIBkSfQpc3/TmTqlFfXP50Swq+9QwG7cEVpJdcS3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=IHZmouw2gll8G7/NyaicZxXUymco18GFki9yKKZcQWpA/pHjolib7hdbfjNkczS7exRsCMqER7uL6iomaKptcAmGxWaIWia0jaa8OeQ9oHp/n6S4AW0nZcuMHQ+eqRb9MJdC6Ec9mdYfRkjmEGDQ4RuUb8+Dw6H4igptzYmLL20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jpjrgdMV; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jpjrgdMV"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250617130006epoutp03af8f7bf7892d56458f5e533d151f2f7b~J1ft5q6HO1779017790epoutp03i
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250617130006epoutp03af8f7bf7892d56458f5e533d151f2f7b~J1ft5q6HO1779017790epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165206;
	bh=FfEMNSF2SjxETkkknpiXVsaeo76vBAkdkVZScA5l+vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpjrgdMVST80a3jjFNaiwbLvMeNz5nevCsvWBdwnBEEgCxT4CimdRGO/sL2/I9qvp
	 lq2w6EH6R+2q3VWnnWT/GaH4HSYCxlPmka1s6nX3kBS2x+1C0xATYQTthLuItJZP4r
	 +vvfHJE/jlw2hbA5bznULxvgvbXaFG7aG1HPQvl4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130005epcas5p1a584e26385ebd15770b3934d7d8d3964~J1ftW2kx-2447924479epcas5p1z;
	Tue, 17 Jun 2025 13:00:05 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bM6R94Zvzz6B9m4; Tue, 17 Jun
	2025 13:00:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a~J1OigNtnm1366613666epcas5p1X;
	Tue, 17 Jun 2025 12:40:25 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124023epsmtip2a96c6c44466709ae38bfa7e8e9597bc4~J1OgAJRnQ2545625456epsmtip2b;
	Tue, 17 Jun 2025 12:40:22 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Date: Tue, 17 Jun 2025 18:09:31 +0530
Message-Id: <720167805.241750165205630.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a@epcas5p1.samsung.com>

nd_mapping->labels maintains the list of labels present into LSA.
init_labels function prepares this list while adding new label
into LSA and updates nd_mapping->labels accordingly. During cxl
region creation nd_mapping->labels list and LSA was updated with
one region label. Therefore during new namespace label creation
pre-include the previously created region label, so increase
num_labels count by 1.

Also updated nsl_set_region_uuid with region uuid with which
namespace is associated with.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 9381c50086fc..108100c4bf44 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -947,7 +947,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_slot(ndd, ns_label, slot);
 	nsl_set_alignment(ndd, ns_label, 0);
 	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
-	nsl_set_region_uuid(ndd, ns_label, NULL);
+	nsl_set_region_uuid(ndd, ns_label, &nd_set->uuid);
 	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
 	nsl_calculate_checksum(ndd, ns_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
@@ -1114,7 +1114,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 				count++;
 		WARN_ON_ONCE(!count);
 
-		rc = init_labels(nd_mapping, count);
+		/* Adding 1 to pre include the already added region label */
+		rc = init_labels(nd_mapping, count + 1);
 		if (rc < 0)
 			return rc;
 
-- 
2.34.1


