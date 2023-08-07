Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D973A138E
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:33 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230807063525epoutp0338b48648474bb4f6bb07c79b71e2be4f~5BlubWbu90692006920epoutp03Y
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230807063525epoutp0338b48648474bb4f6bb07c79b71e2be4f~5BlubWbu90692006920epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691390125;
	bh=R8tzhSUTvRNXdClB/JlrKxNNA4AXoAcodJElwVcpW6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AARV/7DRDWZYkVIr30aK6Xwof+22WnQbt+yuMLoSMmv33EQZlhktRgF43q8Dx+j0K
	 u/MjRWN8CE2mwAbfUeMe6ABMWzZqEmIT4H8tuJxKxOW5PVIlyPDna9wVoHy5hSHUiz
	 1W7vgxQF1AcfbtkhH6jlybbZ/VXo5ynvVPCZziPE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230807063525epcas2p20ac8b66c9cdeeae743dcde3069cb8ab1~5Blt9yXT70052100521epcas2p2y;
	Mon,  7 Aug 2023 06:35:25 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.99]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4RK6583Qn5z4x9Q2; Mon,  7 Aug
	2023 06:35:24 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	BC.2B.40133.CA090D46; Mon,  7 Aug 2023 15:35:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998~5Bls7IWBA0402604026epcas2p4p;
	Mon,  7 Aug 2023 06:35:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230807063523epsmtrp1e84ac40901595d0dfee31f6da776bf77~5Bls6UaYq2722927229epsmtrp1f;
	Mon,  7 Aug 2023 06:35:23 +0000 (GMT)
X-AuditID: b6c32a46-4edb870000009cc5-7b-64d090acd1aa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AF.B2.30535.BA090D46; Mon,  7 Aug 2023 15:35:23 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230807063523epsmtip20a72cfca40ef6d4a7087939c06ebebd9~5BlsrJl8-1913319133epsmtip2C;
	Mon,  7 Aug 2023 06:35:23 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 1/3] libcxl: Update a revision by CXL 3.0
 specification
Date: Mon,  7 Aug 2023 15:35:47 +0900
Message-Id: <20230807063549.5942-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807063549.5942-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmhe6aCRdSDKbfkrS4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO+Ht4EUvBD9aKvy0yDYwtrF2MnBwS
	AiYS7Ru3M4PYQgI7GCVan5R1MXIB2Z8YJTZc38sM4XxjlHh3ZTo7TMfxq38YIRJ7GSWuXu5k
	h3B6mSSObPrDBFLFJqAtcX/7BjYQW0RAVqJ53QMmkCJmgc3MEst2ngNLCAsESdzaehBsOYuA
	qsShezfAjuIVsJZo//qcBWKdvMTqDQfAajgFbCTWXXzHCjJIQuAru8SLq0uYIIpcJL7+WcsM
	YQtLvDq+BepWKYmX/W1Qdr7Ez5O3oL4ukPj05QPUAmOJdzefA8U5gK7TlFi/Sx/ElBBQljhy
	C6yCWYBPouPwX3aIMK9ER5sQRKOqRNfxD4wQtrTE4StHoQ7wkPi37xE0TPoZJToef2aawCg3
	C2HBAkbGVYxiqQXFuempxUYFRvAIS87P3cQIToFabjsYp7z9oHeIkYmD8RCjBAezkgjvvCfn
	U4R4UxIrq1KL8uOLSnNSiw8xmgLDbiKzlGhyPjAJ55XEG5pYGpiYmRmaG5kamCuJ895rnZsi
	JJCeWJKanZpakFoE08fEwSnVwJQ4Y6t6W+T/3/FzAs2zBYwMbYoenDHsu732x4f3XJFsAac2
	/f9yuk+z4c65g+te8/JXsX/rtvfyEHrwUPGFaedpG6P1rc5de/ffWzhTbUvwq/lqTG4LOl0F
	/HYeWqImufJIxLEQx/shHKZsgt9Oc7UrSdy405as4+N603tJwN4lBkblRw9tvT3liqJBRsbs
	6Ws/bf/EE2SXJyTD/34LY5d7Q3PDfjertS8uvJD1W5F9w9Rr85wc0fRUSceHHl5Fji/mxEV/
	4Y5SvH7MrVitqPJot+lj42LB7XFW+2U3l1teXz3FaetVrWnaVR98fOquXvu1/sSpWrNPBR8q
	VLa+Uw26tcV4186E6s97/+ZN7VBiKc5INNRiLipOBACquWyTCgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWy7bCSvO7qCRdSDH4vNrG4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFcdmkpOZklqUW6dslcGX8PbyIpeAH
	a8XfFpkGxhbWLkZODgkBE4njV/8wdjFycQgJ7GaUOHJ/EgtEQlriXvMVdghbWOJ+yxFWiKJu
	JolL0w4wgiTYBLQl7m/fwAZiiwjISjSve8AEUsQssJdZomPmebAVwgIBEn9+bASzWQRUJQ7d
	uwFm8wpYS7R/fQ61TV5i9YYDzCA2p4CNxLqL74BqOIC2WUscv5c4gZFvASPDKkbJ1ILi3PTc
	YsMCo7zUcr3ixNzi0rx0veT83E2M4GDV0trBuGfVB71DjEwcjIcYJTiYlUR45z05nyLEm5JY
	WZValB9fVJqTWnyIUZqDRUmc99vr3hQhgfTEktTs1NSC1CKYLBMHp1QDk0w3z+2+befXPC7e
	aa4/aePThdbv77X8OCGS9SN8j77Yk6fLrd7tYyvJuKH4tMEizKHh+6aa+3MmOrBWeKotMN/C
	JP17ta3tLkvGD/r+PPfX/H13MuPA080B/HO/vfyTu0R9H18K13zZN6vTeRNZAzeoSm/f+r9W
	KHbR6qU2v5Mjr/RPu6ETcEFFb79/gb2YTNi++i2cCz4knxCp0nq17Jz64jUr5beISrs87uPd
	f7SA+e3kZ9d2xuerHwpjVOa7Mnslw/KgJd881SqOsO7PVLBvil15LnVD5uWT+189vPPZd86O
	BtXr36Z2TTx05XDlmZzLh//dE3MrNSnO8bvFttqmked/quSXQMPjH9oZpzgrsRRnJBpqMRcV
	JwIAo4l45sUCAAA=
X-CMS-MailID: 20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063523epcas2p45f74891b764d920b2a9bd22ddf6b6998@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Update the predefined value for device temperature field when it is not
implemented. (CXL 3.0.8.2.9.8.3.1)

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/lib/private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index a641727..a692fd5 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -360,7 +360,7 @@ struct cxl_cmd_set_partition {
 #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
 
 #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
-#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
+#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
 
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
-- 
2.17.1

