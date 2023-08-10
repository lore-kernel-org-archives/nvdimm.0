Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078ED1DDDD
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:25 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230810082123epoutp039f27d6d89a0b6ca6e41cb641e6ac0cbe~59_GS_8se2647826478epoutp03c
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230810082123epoutp039f27d6d89a0b6ca6e41cb641e6ac0cbe~59_GS_8se2647826478epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691655683;
	bh=TV9praheqYMa1Yz2hAnqcTTM6ObCGENXWShMrnyGeO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2KR69SaZwGnynpTN94SfvOXBHxbQ4Lc1M8KE0LO9M0VpPJ21scipdliY5o0wbyZ6
	 wfRIGYJytjFv9XD4mx7ZCVWABYbsMYHn9MWMS7ZV88PmTUnzeMKnSOAs0cszqxwMsS
	 RfsuWKi5AlOKzL4NKHFVhmfCC93tnkkBW891Gq8Y=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20230810082122epcas2p435c50358082de854b89f74129e1c3e7e~59_FzSk5B2037220372epcas2p4-;
	Thu, 10 Aug 2023 08:21:22 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4RM0J20lVNz4x9Q1; Thu, 10 Aug
	2023 08:21:22 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	55.E1.40133.10E94D46; Thu, 10 Aug 2023 17:21:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20230810082121epcas2p3eb7acc9bdf13cafe9ef79a6fdd06b679~59_ENlXZw2608826088epcas2p3I;
	Thu, 10 Aug 2023 08:21:21 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230810082121epsmtrp14b948958d0cb16bec4292a75ba5d23eb~59_EM2ivI3202132021epsmtrp1A;
	Thu, 10 Aug 2023 08:21:21 +0000 (GMT)
X-AuditID: b6c32a46-4edb870000009cc5-c1-64d49e01189c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0C.24.64355.00E94D46; Thu, 10 Aug 2023 17:21:20 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230810082120epsmtip14a0b07628db31283f3e1f4241692741d~59_D7iKzo1945419454epsmtip1U;
	Thu, 10 Aug 2023 08:21:20 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 3/3] cxl/json.c: Fix the error checking logic when
 listing device's health info
Date: Thu, 10 Aug 2023 17:23:54 +0900
Message-Id: <20230810082354.5992-4-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230810082354.5992-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmqS7jvCspBncatSzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCcqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
	S2yVUgtScgrMC/SKE3OLS/PS9fJSS6wMDQyMTIEKE7Iz/n2YwFhwj6Niwf19TA2Mc9i7GDk5
	JARMJCZev8jaxcjFISSwg1Fi8v8NbBDOJ0aJbV1djHDOq+8rmGFaJlxYwA6R2MkoMb9jPwuE
	08skse34QRaQKjYBbYn720FmcXKICMhKNK97wARSxCywmVli2c5zYAlhgSyJuQ+/M4HYLAKq
	Eg/33QWzeQWsJV70XWaBWCcvsXrDAbDVnAI2Ep/3rgS7VkLgLbvE9TNtjBBFLhL/l8+EahCW
	eHV8C9R7UhIv+9ug7HyJnydvsULYBRKfvnyAqjeWeHfzOVCcA+g6TYn1u/RBTAkBZYkjt8Aq
	mAX4JDoO/2WHCPNKdLQJQTSqSnQd/wB1gLTE4StHoQHkIfFz+VMmSJj0M0rMfT6LaQKj3CyE
	BQsYGVcxiqUWFOempxYbFRjBoyw5P3cTIzgNarntYJzy9oPeIUYmDsZDjBIczEoivLbBl1KE
	eFMSK6tSi/Lji0pzUosPMZoCw24is5Rocj4wEeeVxBuaWBqYmJkZmhuZGpgrifPea52bIiSQ
	nliSmp2aWpBaBNPHxMEp1cBUPoGh9stFI0Vpf4d5HhpfC97828wqVsrktGSD/u49Yfl3G9LZ
	dbY2reu/pRQ6v/mw/o+yLbIJKs/dRO8EzHjrf6twP9v0aZ/TJGtfnt69eu7MP4+62q+Lz1h5
	Lu/9jPD2HNELTSIRGt1lG/KL55fcvF8oKHJSXq4+eYO7orl07gqrj653lobdv7z8kdvtYz2G
	rrZdl/yaXJq2CVhlueY8Dta82Z/FvcYjV0TZbqPL34I/Dz9Oub162zImyf4Pt9a2e1xXkNJL
	/VjxKN6xgaN1y8V3Zf4Lr68+J/CCbVV/4KoFySu3L5NMV17XsJJZ826rU8zj/ccnPjjEm3vs
	09RJy0WjT2r6t/+r2GDk6fBNiaU4I9FQi7moOBEAzEBbGQwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnC7DvCspBi82m1rcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiiuGxSUnMyy1KL9O0SuDL+fZjAWHCP
	o2LB/X1MDYxz2LsYOTkkBEwkJlxYAGRzcQgJbGeUON7fzwiRkJa413wFqkhY4n7LEVaIom4m
	idYzJ9lAEmwC2hL3t28As0UEZCWa1z1gAiliFtjLLNEx8zwrSEJYIEOitWUzM4jNIqAq8XDf
	XSYQm1fAWuJF32UWiA3yEqs3HACr4RSwkfi8dyVYrxBQzYyl81gnMPItYGRYxSiaWlCcm56b
	XGCoV5yYW1yal66XnJ+7iREcqFpBOxiXrf+rd4iRiYPxEKMEB7OSCK9t8KUUId6UxMqq1KL8
	+KLSnNTiQ4zSHCxK4rzKOZ0pQgLpiSWp2ampBalFMFkmDk6pBibh1v7Qeo8l3ZarHl85uu7y
	a6P929foT+e593nqNMYLvOwnbt/XyjirECF5QY1ZZbZE7Nef76Jkqqdd2O7ec3KdjFGrSaj1
	jf8vDi7W/XxF8+hqqwWmP2V+vZqtuubzU68XFtvu/Jpsv9278f2RLUvzOwQkbjqrf1Oa8r38
	TQZDKc9O+T6v//0fLj4T6RT6E7yTyVNY/4O0r1mRlL2vSVSSKUP8PPVrMpLLV7l/Citm/eiy
	eNFLi1UPdkl/+spsN2ertsFvYfWlHSFufxLNH/azv6o8P/VAD+/dQxnaHXdcSyTE55prH2tY
	sfy8B9vvjD2vNn1tWOR1f/eRzeWcU0wzXk6a6dJzUrh6uvy04itdSizFGYmGWsxFxYkA2OEt
	e8MCAAA=
X-CMS-MailID: 20230810082121epcas2p3eb7acc9bdf13cafe9ef79a6fdd06b679
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230810082121epcas2p3eb7acc9bdf13cafe9ef79a6fdd06b679
References: <20230810082354.5992-1-jehoon.park@samsung.com>
	<CGME20230810082121epcas2p3eb7acc9bdf13cafe9ef79a6fdd06b679@epcas2p3.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Change the variable type for storing result of life used field accessor
: u32 to int.
Fix the value for checking device's life used field is implemented.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/json.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 89e5fd0..102bfaf 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
+#include <errno.h>
 #include <limits.h>
 #include <util/json.h>
 #include <uuid/uuid.h>
@@ -238,9 +239,9 @@ static struct json_object *util_cxl_memdev_health_to_json(
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
-- 
2.17.1

