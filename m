Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1831D626
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:12:19 +0000 (UTC)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230616010606epoutp018d4b373f8c6b65869d08d7f5ffc12dc3~o-jWGlsf61848318483epoutp01W
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:06:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230616010606epoutp018d4b373f8c6b65869d08d7f5ffc12dc3~o-jWGlsf61848318483epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1686877566;
	bh=1RD42/3HhrAJUGHbUqWPQ03lONA6GWvvAqGel7VQqnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p00WxwO3WyfuPNMeTkB8s9Psoc7vXKGSesH2HN3QdkMTVHGPM4HzgSnLI5tV+GXii
	 eT1dboY3e28UCyy91o0Z+hUPjmBFdZK21QcWDwPYKG3/kz3knVUOJqw0vXsOKAuaDt
	 v3PFmaOoqaGMe0ookMeGdl05Fh48iwIPbB5Elpgs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20230616010605epcas2p3432f0d5566b4aaa4905726c6627b53cb~o-jVilu6o0389903899epcas2p3C;
	Fri, 16 Jun 2023 01:06:05 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.92]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Qj1F916tbz4x9Q2; Fri, 16 Jun
	2023 01:06:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0B.0F.11450.D75BB846; Fri, 16 Jun 2023 10:06:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20230616010604epcas2p3399f53ee96eb819678fc79eff2ae6ab6~o-jUxv13d0162901629epcas2p3a;
	Fri, 16 Jun 2023 01:06:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230616010604epsmtrp137a1a9b7a1ead3c0a645224f0704f870~o-jUxDeBH2991329913epsmtrp1E;
	Fri, 16 Jun 2023 01:06:04 +0000 (GMT)
X-AuditID: b6c32a45-1dbff70000022cba-3b-648bb57d18ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5F.23.27706.C75BB846; Fri, 16 Jun 2023 10:06:04 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230616010604epsmtip10213b934bf775696447b25fca056bc7f~o-jUmClsJ2136821368epsmtip1Z;
	Fri, 16 Jun 2023 01:06:04 +0000 (GMT)
From: Jehoon PARK <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH 1/2] cxl: Update a revision by CXL 3.0 specification
Date: Fri, 16 Jun 2023 10:08:40 +0900
Message-Id: <20230616010841.3632-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616010841.3632-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7bCmmW7t1u4Ugytn2SzuPr7AZtE8eTGj
	xfSpFxgtTtxsZLPY//Q5i8WB1w3sFudnnWKxWPnjD6vFrQnHmBw4PRbvecnksWlVJ5vHi80z
	GT36tqxi9Pi8SS6ANSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgXmBXnFibnFpXrpe
	XmqJlaGBgZEpUGFCdsbSCz/ZCi5zVsw/XNvA2MzRxcjJISFgInG8dS9rFyMXh5DADkaJNW83
	sEA4nxgldu+ezg7hfGOUaF/ZCpThAGvpf1sDEd/LKNG5YhtUey+TxJ3NN1hA5rIJaEu0971l
	BLFFBGQlmtc9YAIpYhbYwCSxYuExZpCEsICXxKunL9lBbBYBVYnnTd/BmnkFrCVuLp/MCHGg
	vMTqDQfA6jkFbCSm7XgLNkhC4Bq7xNWfi9kgilwkHq3vYYGwhSVeHd/CDmFLSbzsb4Oy8yV+
	nrzFCmEXSHz68gGq3lji3c3nrCCvMQtoSqzfpQ/xpbLEkVtgFcwCfBIdh/+yQ4R5JTrahCAa
	VSW6jn+AulJa4vCVo8wQtofE7B+b2CBh0s8osfX5HJYJjHKzEBYsYGRcxSiWWlCcm55abFRg
	CI+w5PzcTYzg9KbluoNx8tsPeocYmTgYDzFKcDArifAuO9GVIsSbklhZlVqUH19UmpNafIjR
	FBh2E5mlRJPzgQk2ryTe0MTSwMTMzNDcyNTAXEmcV9r2ZLKQQHpiSWp2ampBahFMHxMHp1QD
	0949N9O5uA5X6HAUCu9eY3Xsfaiy0i+msy+1vKYWfzxkupDVvIah33ta+QMXoWnnb2W9XnBk
	ypSJs0/8rvyes0Eoxdb28euHP3atkli9XyNg7Sve6XpsL2/5sn3eqe97Z4+VqvE9QWPu81Xc
	D5zkmHPWzH3vsmi2gMjG65P6NgeJHTQ6db3pm/yKq8Y/f3+VEYue9bb/QfNMf52kdSYHwty7
	3jVb/VmblSvb/7WydFvUMs1ZbwwNHzexXr7GxRIkcsT3iQfvtRbtyrPpUwJPldzWPr/12plL
	M2Ucf2wNFa4smyPw9dvvawc4nt5w+spyWjF78oZJJb9Xbath+fRtTVTPh5kTuT0af2UsvTXZ
	clqjEktxRqKhFnNRcSIAOq2Lu/gDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsWy7bCSnG7N1u4Ug8dnDS3uPr7AZtE8eTGj
	xfSpFxgtTtxsZLPY//Q5i8WB1w3sFudnnWKxWPnjD6vFrQnHmBw4PRbvecnksWlVJ5vHi80z
	GT36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY+mFn2wFlzkr5h+ubWBs5uhi5OCQEDCR6H9b
	08XIxSEksJtRYtrqFvYuRk6guLTEveYrULawxP2WI6wQRd1MEhu+HmUESbAJaEu0970Fs0UE
	ZCWa1z1gAiliFtjBJHFwSy8TSEJYwEvi1dOXYJNYBFQlnjd9ZwGxeQWsJW4un8wIsUFeYvWG
	A8wgNqeAjcS0HW/BeoWAaq5/+Mw+gZFvASPDKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT8
	3E2M4EDU0tzBuH3VB71DjEwcjIcYJTiYlUR4l53oShHiTUmsrEotyo8vKs1JLT7EKM3BoiTO
	e6HrZLyQQHpiSWp2ampBahFMlomDU6qB6YyJsfrZL5PTj566/tJ2zY59zkeytsxsTmd1m1U4
	y+B6rFnFRv5DvgHM4YslPZKMuQ99M7Jq4F9wJuNb/n9Bo1t2M9sUeSO+5q2vmrl01/y362te
	fbk3+2qr1CL97MpNn0q0eTf8ONo5wXPmr58ydU3d93qedE05yx1o7xAVNOdnmkTWk98Tux/a
	Ldoz3z58pVJRb8JdsxKvtAu1q9qcene+33fhQ3/Y+yzHm+Ucy/Rnh/xleuzGttvSo/bkh4Vm
	acyS3NOPZNyfZWHH4J3zTE9+/68tcaGpk6J7U+63/r4g4KXN0lT5e76YQxnfjv8udTYFd/Zy
	/NiW+/TXJbasmZXxDH46e9hLxIpuFeaWK7EUZyQaajEXFScCAOMs5J6zAgAA
X-CMS-MailID: 20230616010604epcas2p3399f53ee96eb819678fc79eff2ae6ab6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230616010604epcas2p3399f53ee96eb819678fc79eff2ae6ab6
References: <20230616010841.3632-1-jehoon.park@samsung.com>
	<CGME20230616010604epcas2p3399f53ee96eb819678fc79eff2ae6ab6@epcas2p3.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

From: Jehoon Park <jehoon.park@samsung.com>

Update the value of device temperature field when it is not implemented.
(CXL 3.0 8.2.9.8.3.1)

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/json.c        | 2 +-
 cxl/lib/private.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 9a4b5c7..3661eb9 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -155,7 +155,7 @@ static struct json_object *util_cxl_memdev_health_to_json(
 	}
 
 	field = cxl_cmd_health_info_get_temperature(cmd);
-	if (field != 0xffff) {
+	if (field != 0x7fff) {
 		jobj = json_object_new_int(field);
 		if (jobj)
 			json_object_object_add(jhealth, "temperature", jobj);
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index d49b560..e92592d 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -324,7 +324,7 @@ struct cxl_cmd_set_partition {
 #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
 
 #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
-#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
+#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
 
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
-- 
2.17.1

