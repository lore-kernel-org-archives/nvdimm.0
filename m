Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1F7468
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 06:26:35 +0000 (UTC)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230717062626epoutp042cf9bc18afe541149f74d68c472f3af9~yk65CBAZ20399503995epoutp04W
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 06:26:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230717062626epoutp042cf9bc18afe541149f74d68c472f3af9~yk65CBAZ20399503995epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1689575186;
	bh=J5pfay+vlkQzijjCfhEB6lCY4J+B6tZrRk6bAir7ttg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI8pMMEDdfzjtvdBd59TerDaCkBYOIVc97nlrmrbXekcpdzkzk+cCOCppbsb10/kO
	 iqZjgcFa9Vs2oauDcvOIm4ZcBnPZ3MFG2pXbY3FEUKWenpYXgHWem9cahgshwn9a7G
	 a5qxY9Tq7hmGePIyeLLEI0DeuXbSi813721aBzIQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20230717062626epcas2p3b5b4d2e28f4219513a38aa33cf858e08~yk64fhWZy0784607846epcas2p3c;
	Mon, 17 Jul 2023 06:26:26 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.100]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4R4BtT54T0z4x9Pv; Mon, 17 Jul
	2023 06:26:25 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	16.8E.40133.11FD4B46; Mon, 17 Jul 2023 15:26:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636~yk63N8kX13261632616epcas2p2z;
	Mon, 17 Jul 2023 06:26:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230717062624epsmtrp20af06d8ef2adeb0a1cc010ce2dd367e5~yk63M4Zok0871408714epsmtrp2N;
	Mon, 17 Jul 2023 06:26:24 +0000 (GMT)
X-AuditID: b6c32a46-4edb870000009cc5-97-64b4df11f83e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	75.9F.34491.01FD4B46; Mon, 17 Jul 2023 15:26:24 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230717062624epsmtip259361e9fe7e20a78254512b004bd0a84~yk62_uWHm1559215592epsmtip2i;
	Mon, 17 Jul 2023 06:26:24 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH RESEND 1/2] cxl: Update a revision by CXL 3.0
 specification
Date: Mon, 17 Jul 2023 15:29:07 +0900
Message-Id: <20230717062908.8292-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230717062908.8292-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmha7g/S0pBs+WKVrcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiism0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgE5UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnXL48kbFgCWfF9kv9jA2Mt9m7GDk5
	JARMJHpWLWPrYuTiEBLYwShx/edidgjnE6PEp+unmSCcb4wS2+aegWvZt/I3I0RiL6PEmTOL
	mCGcXiaJzm0dTCBVbALaEve3b2ADsUUEZCWa1z0AG8UssJlZYtnOc2AJYYFgiflP28HGsgio
	Styf/hKsmVfAWuJ/5yYmiHXyEqs3HGAGsTkFbCRmTP/KCBH/yi6xbZ8BhO0i8f3gaTYIW1ji
	1fEtUKdKSXx+txcqni/x8+QtVgi7QOLTlw8sELaxxLubz4HiHEDHaUqs36UPYkoIKEscuQVW
	wSzAJ9Fx+C87RJhXoqNNCKJRVaLr+AeoY6QlDl85ygxhe0h0rV3MCgmSfkaJpU8+M01glJuF
	sGABI+MqRrHUguLc9NRiowIjeIwl5+duYgQnQS23HYxT3n7QO8TIxMF4iFGCg1lJhPf7qk0p
	QrwpiZVVqUX58UWlOanFhxhNgUE3kVlKNDkfmIbzSuINTSwNTMzMDM2NTA3MlcR577XOTRES
	SE8sSc1OTS1ILYLpY+LglGpgMnwQUzTDbrrExLk37kxRdI3UZg26N3/rMS5pi5K9i54l703h
	bBaIZXDVNyts31n1/UXjrMtPWueumsKoMvPQvEOHb2Z8d6iP0ayb8GH6NHPW25MSjT/tOTNT
	39LunfmdTYsZ92kve1+4KmS9n1r6NnO7wCcbFXndohnWTV5V90roaOJptTU793wPclg5a/38
	b58P7DvVVRN9+0/S7pzTAp98TI3ZX03akLrL11vLzm5B4I+HpdsXFtucjfBnmfmV4cQ766nT
	OdtU1APCK71nT29aoZT1ZJYly7Jbey3LmyI/fXSL4E1PX/hDudx5fd/JSeHL2suyuHOEtRo/
	H4tInHF3Z1R+vI5t+mNhNad8NiWW4oxEQy3mouJEAC86mZkLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvK7A/S0pBuuajCzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBmXL09kLFjC
	WbH9Uj9jA+Nt9i5GTg4JAROJfSt/M3YxcnEICexmlNj/BiYhLXGv+QqULSxxv+UIK0RRN5PE
	us/bmEESbALaEve3b2ADsUUEZCWa1z1gAiliFtjLLNEx8zwrSEJYIFBi1sqFYJNYBFQl7k9/
	yQRi8wpYS/zv3MQEsUFeYvWGA2BDOQVsJGZM/8oIYgsB1Tx48Zt5AiPfAkaGVYySqQXFuem5
	xYYFhnmp5XrFibnFpXnpesn5uZsYwQGrpbmDcfuqD3qHGJk4GA8xSnAwK4nwfl+1KUWINyWx
	siq1KD++qDQntfgQozQHi5I4r/iL3hQhgfTEktTs1NSC1CKYLBMHp1QDk8T2kwuk9sv9PazG
	sexsfutJh5+dijsspnSHRi0LmyPasesK57NZqQ3uHBwX+GoT/t//OJHBRufCgiWsjKuW/tp8
	h8c6hXXhvvX/XzPU8s5TOBKzYJPI8rrXMT0bmy8c+3hu3o2+qmcnTHfKXjmTYXXD8P43X/mI
	YosDO3Ywvlr8o7/5x7K7q/kfvC173fU+3FJ726kWpRals/5XOTuWln1I8T8wwd8uIbvML2eD
	2TOdvXWKjPGLrm3WWSda9ZtrYlFfVeLaTx4e/PellzwyWyOUNmWn+HKOiotuvK+zZ+xbqh7z
	7mV8Y2TRIomY5/ybZ/+Ws92/9ZXdReYjSnKLFlQIOTBH67K4lO48ET3JpUmJpTgj0VCLuag4
	EQCbSymNxwIAAA==
X-CMS-MailID: 20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636
References: <20230717062908.8292-1-jehoon.park@samsung.com>
	<CGME20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

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

