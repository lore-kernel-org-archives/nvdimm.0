Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A1383
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:51 +0000 (UTC)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230807063549epoutp01be740a6b9428ba4c563353d38ad5f748~5BmFCs-q00498404984epoutp01v
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230807063549epoutp01be740a6b9428ba4c563353d38ad5f748~5BmFCs-q00498404984epoutp01v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691390149;
	bh=Leo3A7Oaszp/5S8ja3I/nQK908gdWsvtnK3ZBXA6d14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9frTeBIO/WiyW4iLHc0zCdIYBJDOf86JLV2TPEFOlBJoKSDp4dS/Kr1WyKBQxtsT
	 cs3gnp3WcoTD68ShjTIWgq9JfGjzV4u5PZzcS0dg4VF6m1GrBwWWFRQ+fyNmDgf9ZC
	 6IG6sjui69CEDz+YeVDyeV5WhYZlqsBPgGDvXsz4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230807063549epcas2p1b287f00db141e525463430f31424eb10~5BmEl1OHB0959509595epcas2p1H;
	Mon,  7 Aug 2023 06:35:49 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.102]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4RK65c5n3Gz4x9Px; Mon,  7 Aug
	2023 06:35:48 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.53.49986.4C090D46; Mon,  7 Aug 2023 15:35:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230807063547epcas2p4ccb33e410e77a94e088f283b8c2925db~5BmDTkOLd2298722987epcas2p4T;
	Mon,  7 Aug 2023 06:35:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230807063547epsmtrp21083b8acda708987a7f7d44191720004~5BmDStPi72086220862epsmtrp2G;
	Mon,  7 Aug 2023 06:35:47 +0000 (GMT)
X-AuditID: b6c32a43-5f9ff7000000c342-75-64d090c4a3fa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EF.1F.34491.3C090D46; Mon,  7 Aug 2023 15:35:47 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230807063547epsmtip25ab034ba4198fd5b9a10c1356fd1bb94~5BmDBUzlQ2291222912epsmtip2S;
	Mon,  7 Aug 2023 06:35:47 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 3/3] cxl: Fix the checking value when listing
 device's health info
Date: Mon,  7 Aug 2023 15:35:49 +0900
Message-Id: <20230807063549.5942-4-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807063549.5942-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmqe6RCRdSDA7M0rG4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOeNWcUfCLs6Jt+UH2BsbZHF2MnBwS
	AiYS7csmsXYxcnEICexglNh55hQbhPOJUWLKu0ZGCOcbo8T152eYYVr6D51ngkjsZZSYOPcm
	VFUvk8TP/ndgVWwC2hL3t29gA7FFBGQlmtc9AOtgFtjMLLFs5zmwhLBArMT7o3fZuxg5OFgE
	VCVarrqAhHkFrCVWtS2E2iYvsXrDATCbU8BGYt3Fd6wQ8Y/sEvN7tSFsF4k7tz4zQdjCEq+O
	b2GHsKUkPr/bywZh50v8PHkLqrdA4tOXDywQtrHEu5vPWUFOYBbQlFi/Sx/ElBBQljhyC6yC
	WYBPouPwX3aIMK9ER5sQRKOqRNfxD4wQtrTE4StHoQ72kFjYDmELCfQDA3F38gRGuVkI8xcw
	Mq5iFEstKM5NT002KjCER1dyfu4mRnD603LewXhl/j+9Q4xMHIyHGCU4mJVEeOc9OZ8ixJuS
	WFmVWpQfX1Sak1p8iNEUGHATmaVEk/OBCTivJN7QxNLAxMzM0NzI1MBcSZz3XuvcFCGB9MSS
	1OzU1ILUIpg+Jg5OqQYmbwH5KcKur5Marn69mVRmXPinoFRDjvHrrX1bEib42PlsTS00Lb5f
	OOUg8/EVsuE6R31PPTLJezBrs3Dp6xOf9iU2+5e8m8LFuOCLiulqabe20qMr6j5kCqhHmVs8
	y3o12fTtzm1Gn+2LdT68X/vgmU1gwY0kRVlO3yeTZIvfPTj5xa3L/eCU+kuzIn73fVu7cFFO
	4xMuG7FAk887D/gHrWmZdiN53scMVn3l6M4zV8Rr2t19U/KYn9W3MpXuN+u1SNzyf2rztqgr
	fMdsGNru3nK1eBLfyzTz7zqj7sO9yufy5m9/xrP/3Y71scwz7l0/WiWRa7SNVfrN/MC/tSwO
	x22EmmZ+Vlunfufq06umSizFGYmGWsxFxYkAsa4BrwgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSvO7hCRdSDPpmGVvcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiiuGxSUnMyy1KL9O0SuDJeNWcU/OKs
	aFt+kL2BcTZHFyMnh4SAiUT/ofNMXYxcHEICuxkl5jZ2M0IkpCXuNV9hh7CFJe63HGGFKOpm
	kli/5x0zSIJNQFvi/vYNbCC2iICsRPO6B2CTmAX2Mkt0zDwP1MHBISwQLfH3qw2IySKgKtFy
	1QWknFfAWmJV20JmiPnyEqs3HACzOQVsJNZdfAfWKQRUc/xe4gRGvgWMDKsYJVMLinPTc4sN
	CwzzUsv1ihNzi0vz0vWS83M3MYIDVUtzB+P2VR/0DjEycTAeYpTgYFYS4Z335HyKEG9KYmVV
	alF+fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkmDk6pBqb0Tf9Z0zgXnDc1fC+3
	/6p0j3vuwZX77T/43TrgtXX2tm2vo49UHZt1JO5mb2hE3exlKuznj0RMXiq9Ia5/7d/ov3Em
	j0555exR6jlrOO1zTm/G/9lr9l5epq/pNFvuumjS5YnRWd61rvmTrH1tViptnc+VZLnHSS/c
	LJh788U7p6rfZSukNealnP6ecmn//JJPEUp7m5Yre87IX/TnaW/Q308yAhN+vZ5xh79uSohm
	2b6OtOt8d1NfV9xd+Khw0SmrGyHbu/45nmDd25LeOVPTX75rxlPH5Nilu9RvWksuNVjM8+pp
	YPodK669nrWrPrn9W79nnYTIwnR38Vvy6ode9vp47PJ+sWLa75cVGZxPlFiKMxINtZiLihMB
	SjpmfMMCAAA=
X-CMS-MailID: 20230807063547epcas2p4ccb33e410e77a94e088f283b8c2925db
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063547epcas2p4ccb33e410e77a94e088f283b8c2925db
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063547epcas2p4ccb33e410e77a94e088f283b8c2925db@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Fix the value for checking device's life used and temperature fields are
implemented.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/json.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 7678d02..102bfaf 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
+#include <errno.h>
 #include <limits.h>
 #include <util/json.h>
 #include <uuid/uuid.h>
@@ -238,15 +239,15 @@ static struct json_object *util_cxl_memdev_health_to_json(
 		json_object_object_add(jhealth, "ext_corrected_persistent", jobj);
 
 	/* other fields */
-	field = cxl_cmd_health_info_get_life_used(cmd);
-	if (field != 0xff) {
-		jobj = json_object_new_int(field);
+	rc = cxl_cmd_health_info_get_life_used(cmd);
+	if (rc != -EOPNOTSUPP) {
+		jobj = json_object_new_int(rc);
 		if (jobj)
 			json_object_object_add(jhealth, "life_used_percent", jobj);
 	}
 
 	field = cxl_cmd_health_info_get_temperature(cmd);
-	if (field != 0xffff) {
+	if (field != INT_MAX) {
 		jobj = json_object_new_int(field);
 		if (jobj)
 			json_object_object_add(jhealth, "temperature", jobj);
-- 
2.17.1

