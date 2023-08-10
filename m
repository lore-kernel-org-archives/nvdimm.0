Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818B3366
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:18 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230810082110epoutp01d0c7ab4759d7b193ad274fab94ae52a0~5996NYQHa1139811398epoutp01E
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230810082110epoutp01d0c7ab4759d7b193ad274fab94ae52a0~5996NYQHa1139811398epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691655670;
	bh=EKbo0WUTNsLO5aA9YClOBcslLNoazkQ4NnjHSwDdiO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtAuxXbEWrtY07qYvAyE7zQYR73M3K6iaWwUHk7Q6lOOeLd469nzgNBqnkjDBF84E
	 NWwOR4bQ5MI/mforZd5b4vwfhhOE4n8d/TyTXwKO0y3vJhd3eCSvq1RKkkFwRuLb//
	 6R+H7s5e8dD2McAi13zKhEM9XJ9G6E0CSjWtBXrI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230810082109epcas2p151fa13821dd19f5106ea88f1e10b5d53~5995pUQJ_2693426934epcas2p12;
	Thu, 10 Aug 2023 08:21:09 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.70]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RM0Hm72x5z4x9QB; Thu, 10 Aug
	2023 08:21:08 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	6E.DC.49986.4FD94D46; Thu, 10 Aug 2023 17:21:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230810082108epcas2p49dce460a55b44ece76c8df4122313514~5994d03CW0623306233epcas2p4t;
	Thu, 10 Aug 2023 08:21:08 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230810082108epsmtrp162e037a6647407190c3d97c42e96bcce~5994dB7zF3202032020epsmtrp1t;
	Thu, 10 Aug 2023 08:21:08 +0000 (GMT)
X-AuditID: b6c32a43-84dfa7000000c342-c5-64d49df4e554
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	C7.24.64355.4FD94D46; Thu, 10 Aug 2023 17:21:08 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230810082108epsmtip15d4a2bac85823c02d93bb298c28f0c82~5994OBMxM1945419454epsmtip1R;
	Thu, 10 Aug 2023 08:21:08 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 1/3] libcxl: Update a outdated value to the latest
 revision
Date: Thu, 10 Aug 2023 17:23:52 +0900
Message-Id: <20230810082354.5992-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230810082354.5992-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmqe6XuVdSDLZtMre4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO2LbgLHPBfraKLXuOszYwHmLtYuTk
	kBAwkehuWM7SxcjFISSwg1Fi45Q5rBDOJ0aJ1+unMMI53bP6GGFank69yAyR2MkosfjTeqiW
	XiaJJSt72ECq2AS0Je5v3wBmiwjISjSve8AEUsQssJlZYtnOc2AJYYEwieOvr4JdwiKgKrFp
	6lcwm1fAWuLZxyVQF8pLrN5wgBnE5hSwkfi8dyXYNgmBt+wShzbuhypykTjSNgnqPmGJV8e3
	sEPYUhIv+9ug7HyJnydvQdUXSHz68oEFwjaWeHfzOVCcA+g6TYn1u/RBTAkBZYkjt8AqmAX4
	JDoO/2WHCPNKdLQJQTSqSnQd/wC1VFri8JWjzBC2h8SGJ0uhIdfPKPFy4V/GCYxysxAWLGBk
	XMUollpQnJuemmxUYAiPsuT83E2M4DSo5byD8cr8f3qHGJk4GA8xSnAwK4nw2gZfShHiTUms
	rEotyo8vKs1JLT7EaAoMu4nMUqLJ+cBEnFcSb2hiaWBiZmZobmRqYK4kznuvdW6KkEB6Yklq
	dmpqQWoRTB8TB6dUA5NpzdpVcjfXTujzZlt1apl6krrS76Lo/nklLP+CRB6raT0V45nb2/gq
	MSCj1O3IoTbGIK+9ITd1Y5flmMdxcWufFZF/ObtGdZ/Pnn8qjU6fd3zedn4fQ47rwVlm4d82
	vH69Y4kzz4+V399mKJn9sK76nMagOlFOsW9Oy7Qv/j87zFZF69YkSr4MmZJ4+FDFlCPHNtTo
	HGMtS1cP/n207cQvscVxy+btYm/7NeG3+aHtSe024nvFizyPqf2W2Dkn0EXBsnhTevbs83uf
	9RZpix58mFBhc5Zt7j45ObfC3CfWJiuc95q0b3W8k1jL9LI+ZvOUQ8nf9qSlll/U4jd6fjle
	+tW5ThGDzBSu7x2tHEosxRmJhlrMRcWJAGM6uUoMBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnO6XuVdSDHaeErK4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFcdmkpOZklqUW6dslcGVsW3CWuWA/
	W8WWPcdZGxgPsXYxcnJICJhIPJ16kbmLkYtDSGA7o8Svl8eZIBLSEvear7BD2MIS91uOsEIU
	dTNJfN35DSzBJqAtcX/7BjYQW0RAVqJ53QMmkCJmgb3MEh0zz4OtEBYIkTjYu50FxGYRUJXY
	NPUrWJxXwFri2cclUGfIS6zecIAZxOYUsJH4vHclWFwIqGbG0nmsExj5FjAyrGIUTS0ozk3P
	TS4w1CtOzC0uzUvXS87P3cQIDlStoB2My9b/1TvEyMTBeIhRgoNZSYTXNvhSihBvSmJlVWpR
	fnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwenVANTp7dKWurWXfl++VcXb67+
	0BQ+jfFg3USD4rn5zVe4anI9tefO8P3zaJqaUL/ZtTXhy8Xa/EUsdbcf/T7BaTmj6INKNgmR
	nWuaK6csT/LktH5fGjEjd/GUs7rHLPaKzxVXzSjcrHrKaPdJ+wuskRfWiU7vNkzblqDVNmfS
	e4/Nln+2a8af9jn07u5a0eg30gw1FVMjjl38dHfXYoWTsl+Ms6Y8cd4qkNT0etb7c/KBb3gc
	P2uelhJPuXxS2mlZMU/LzoqEG3VMV37oN99y9FrpfO7oz4sB/xav15gx++OzuJrUGQf13ovy
	Z7W9mb39/jOxFfdVlOqVL8298/1AjW3R+Y0vy+fk5Z36tz0pzzRyuhJLcUaioRZzUXEiAJGb
	ogzDAgAA
X-CMS-MailID: 20230810082108epcas2p49dce460a55b44ece76c8df4122313514
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230810082108epcas2p49dce460a55b44ece76c8df4122313514
References: <20230810082354.5992-1-jehoon.park@samsung.com>
	<CGME20230810082108epcas2p49dce460a55b44ece76c8df4122313514@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Update the predefined value for device temperature field when it is not
implemented. (Revised in CXL 2.0 Errata F38)

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

