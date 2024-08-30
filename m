Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05F91BF7FB
	for <nvdimm@lists.linux.dev>; Fri, 30 Aug 2024 20:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725050586; cv=none; b=tPND3KwaT6201iZ7WG4iB7fTbAoyIJroDQJsOqjRChGxRIy/zQ8nutqIHvFygF/ovHE3wZGv/XQjeDpDWVqUV26mFvZ8E5A1VuknqcjeN3KI6y5L+dsiHH9DgKgKJOuFTlyWtfZOEXvqjHoJa1XNBeljEmkiADZYRY2vLStcRLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725050586; c=relaxed/simple;
	bh=+1VIhFdEh9c242JHRFnObt/6ZXQk1sqCwVGogTTonSg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nFJStvJeySmOyUU4KSssftazyEAmjMS9SLxT6dnPUCZ+nFyEUHBjyD62TjmgHXeeMfEb4cz/DYPIR7TqFmJT4toZqZ79yKzcfzk+MlfGP/xIh6uNaJI2MWrdj+oh6zq7dGntaN5wXY3foq4B9kZ5AJjJlpVSPCZlQfCrgVaLByY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=gvGjnuh3; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="gvGjnuh3"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UIDfV4009275
	for <nvdimm@lists.linux.dev>; Fri, 30 Aug 2024 13:43:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=s2048-2021-q4; bh=OAV
	M1yu813YBKUroR3wfSWo/eZFI6dS9uwU/EGRFpVU=; b=gvGjnuh3fHLAFc07T9M
	BuPzQzz91R8IBc/BHheZIomXhoiMVeQjPL1QOEFOUdDMMVwmpX+87ZgUgtbtTF61
	LZ8MD2GidelaoiKu1obIohIK6X6/KoA8e4a6V5wZ5Zraj/YldsG4/xumqZDLiQuH
	brcs1Snz0+undJIDPR1OsZhYolDcp5M0Yuuq/Sxffl3QrI53HDMi7Scz1sQrEbTl
	9igGEMhOghUF74u1D8rSIfg3YBMCqE/XGGdsuHoRH7HHecdtZm373Is2wGkXMKWl
	KmDkgjzgN2zWJCaEcnPBafbv+5GOjWfLlbIY9bI31Dc7ykbbLIcpcUYr2cL6o9Gp
	2SA==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41ap64ksk6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <nvdimm@lists.linux.dev>; Fri, 30 Aug 2024 13:43:03 -0700 (PDT)
Received: from twshared34253.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 30 Aug 2024 20:43:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 1E962126FFBBC; Fri, 30 Aug 2024 13:42:56 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
        <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] btt: fix block integrity
Date: Fri, 30 Aug 2024 13:42:55 -0700
Message-ID: <20240830204255.4130362-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 73eSoF8TO7EBJpg5HKrXLUyDAknGf9bS
X-Proofpoint-ORIG-GUID: 73eSoF8TO7EBJpg5HKrXLUyDAknGf9bS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_10,2024-08-30_01,2024-05-17_01

From: Keith Busch <kbusch@kernel.org>

bip is NULL before bio_integrity_prep().

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvdimm/btt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 423dcd1909061..13594fb712186 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1435,8 +1435,8 @@ static int btt_do_bvec(struct btt *btt, struct bio_=
integrity_payload *bip,
=20
 static void btt_submit_bio(struct bio *bio)
 {
-	struct bio_integrity_payload *bip =3D bio_integrity(bio);
 	struct btt *btt =3D bio->bi_bdev->bd_disk->private_data;
+	struct bio_integrity_payload *bip;
 	struct bvec_iter iter;
 	unsigned long start;
 	struct bio_vec bvec;
@@ -1445,6 +1445,7 @@ static void btt_submit_bio(struct bio *bio)
=20
 	if (!bio_integrity_prep(bio))
 		return;
+	bip =3D bio_integrity(bio);
=20
 	do_acct =3D blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
--=20
2.43.5

