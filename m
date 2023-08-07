Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251BC1C04
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:42 +0000 (UTC)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230807063540epoutp023d3d9879768affd9e04829dc7a7f893a~5Bl8roipx2951329513epoutp02X
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230807063540epoutp023d3d9879768affd9e04829dc7a7f893a~5Bl8roipx2951329513epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691390140;
	bh=UdZyML6B24ScUvSgDKW8/+eMj4Rfa9MYaG249Qxddzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk5VdhhOt4CIgy8tUtIB/FsnIPid/id5Wsa81UZPZ1IL0eGPnWsYGHZndAdLxYqlc
	 w6+zKrDH+inE41nsPjAfHJqxfBxYQp/50UX3K2u/V9GbERrxmRaoL70P396KgIT5ec
	 mEhSY8revEcChjc4VaS4LU7vcFsjLALxy3AW1FPk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20230807063540epcas2p3b86d2b1bcbfb8ffc62d2982b65b7d7ba~5Bl8HD7yV0737307373epcas2p30;
	Mon,  7 Aug 2023 06:35:40 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.91]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RK65R4S0sz4x9QB; Mon,  7 Aug
	2023 06:35:39 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	FE.66.32393.BB090D46; Mon,  7 Aug 2023 15:35:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95~5Bl67FpCa0920509205epcas2p43;
	Mon,  7 Aug 2023 06:35:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230807063538epsmtrp15a4709b12f6903875d791f18d8e1ca6e~5Bl66AjFX2729227292epsmtrp1J;
	Mon,  7 Aug 2023 06:35:38 +0000 (GMT)
X-AuditID: b6c32a48-adffa70000007e89-b1-64d090bb61b8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DD.1F.34491.AB090D46; Mon,  7 Aug 2023 15:35:38 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230807063538epsmtip228fdd2b9d55344aa2776e77cf46889fd~5Bl6ua8ly1913019130epsmtip2g;
	Mon,  7 Aug 2023 06:35:38 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 2/3] libcxl: Fix accessors for temperature field to
 support negative value
Date: Mon,  7 Aug 2023 15:35:48 +0900
Message-Id: <20230807063549.5942-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807063549.5942-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmhe7uCRdSDLa9VbS4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOmPx6HlPBVsmKWeusGxg7RLsYOTkk
	BEwkVnWtYOxi5OIQEtjBKPHhz2U2COcTo8T2czeZIJxvjBIvfn5lg2n5fvMxK0RiL6PEjY/b
	2SGcXiaJttObGEGq2AS0Je5v3wDWISIgK9G87gHYKGaBzcwSy3aeA0sIC6RK3L17gBnEZhFQ
	leh/MxUszitgLXH32QwWiHXyEqs3QNRwCthIrLv4Dmy1hMBXdolJj3czQRS5SFzt2gR1n7DE
	q+Nb2CFsKYmX/W1Qdr7Ez5O3WCHsAolPXz5ALTCWeHfzOVCcA+g6TYn1u/RBTAkBZYkjt8Aq
	mAX4JDoO/2WHCPNKdLQJQTSqSnQd/8AIYUtLHL5ylBnC9pBYcPs3NOT6GSW23N/JOIFRbhbC
	ggWMjKsYxVILinPTU4uNCkzgMZacn7uJEZwEtTx2MM5++0HvECMTB+MhRgkOZiUR3nlPzqcI
	8aYkVlalFuXHF5XmpBYfYjQFht1EZinR5HxgGs4riTc0sTQwMTMzNDcyNTBXEue91zo3RUgg
	PbEkNTs1tSC1CKaPiYNTqoGJ4fbcHfPql/eUPd1wx3OxHnPR/ZuOQlqGp3jufuIMTZS9GfAi
	6oni/EcOSxcd+n/3h5qXQfyrHJtVb33OzdolfEJ994mv+yTsvb/UT75oyn1xX4zgDpUT4pbr
	EyqNxQuK1vDVr7t5yEdZxtvYNP34Voa3f5MEXiY7iM5j8b254R9Hg7jotMjHq/JfTfGdvZbn
	NG8Y/ySFTZEsD74YXv3XVnbmOt8zxxcFoTqs2qEStWpz09hEg9f6B05/FROf93FZndj/03+v
	bpnl9r11zWyx8696v9wq6Jh5tmzyOfHyKoO/z+6aOErHbFRQtK6INlQ6G//61fqVVpOOrFX6
	1tpaKrFXab62w42ZCzv/7a3MV2Ipzkg01GIuKk4EAN4N+AALBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWy7bCSvO6uCRdSDLadN7O4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFcdmkpOZklqUW6dslcGVMfj2PqWCr
	ZMWsddYNjB2iXYycHBICJhLfbz5m7WLk4hAS2M0o8XPiLkaIhLTEveYr7BC2sMT9liNQRd1M
	Elc7noIVsQloS9zfvoENxBYRkJVoXveACaSIWWAvs0THzPOsIAlhgWSJrtl/mEBsFgFVif43
	U8EaeAWsJe4+m8ECsUFeYvWGA8wgNqeAjcS6i++AejmAtllLHL+XOIGRbwEjwypGydSC4tz0
	3GLDAsO81HK94sTc4tK8dL3k/NxNjOBg1dLcwbh91Qe9Q4xMHIyHGCU4mJVEeOc9OZ8ixJuS
	WFmVWpQfX1Sak1p8iFGag0VJnFf8RW+KkEB6YklqdmpqQWoRTJaJg1OqgWl69O4Zuc7HuWtY
	jI8Xx/c1/690ORAmbG5amVys/XJCTkXJfCXJ3fclVzLFcSQdbdSfIGQ+06WxQa8zYc99AcEp
	N7fdYmnxn/hhkaLpzuM8t3fbzt82r7DylVi4xiZtv9kW60M6F8q9sDB3fLj51peqqzcKvzw9
	UDXxnIrPvHVvdZ4W3xBXZeONdqqujv8Zk3Cra8qry/PYXv7UVN1pc+ktR5t324bfFhMPrLD4
	I7WvyrT6yFqB3VLbL/TNK0m0fRK4XWHiW/db8X9fbz+bFlO5MG7iH+FJZyu3/TZLbWJTk33t
	0xo9LSLtz88VmTuWH2u1TKrSEDhQxyvqfXi+yEOLvqiCpZt8Y/+zlB3f8V2JpTgj0VCLuag4
	EQC+NW3bxQIAAA==
X-CMS-MailID: 20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Add a new macro function to retrieve a signed value such as a temperature.
Modify accessors for signed value to return INT_MAX when error occurs and
set errno to corresponding errno codes.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/lib/libcxl.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index af4ca44..fc64de1 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3661,11 +3661,23 @@ cxl_cmd_alert_config_get_life_used_prog_warn_threshold(struct cxl_cmd *cmd)
 			 life_used_prog_warn_threshold);
 }
 
+#define cmd_get_field_s16(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)	{							\
+		errno = -rc;						\
+		return INT_MAX;						\
+	}								\
+	return (int16_t)le16_to_cpu(c->field);				\
+} while(0)
+
 CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_over_temperature_crit_alert_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_over_temperature_crit_alert_threshold);
 }
 
@@ -3673,7 +3685,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_under_temperature_crit_alert_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_under_temperature_crit_alert_threshold);
 }
 
@@ -3681,7 +3693,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_over_temperature_prog_warn_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_over_temperature_prog_warn_threshold);
 }
 
@@ -3689,7 +3701,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_under_temperature_prog_warn_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_under_temperature_prog_warn_threshold);
 }
 
@@ -3905,8 +3917,6 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
 {
 	int rc = health_info_get_life_used_raw(cmd);
 
-	if (rc < 0)
-		return rc;
 	if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
 		return -EOPNOTSUPP;
 	return rc;
@@ -3914,7 +3924,7 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
 
 static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
+	cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
 				 temperature);
 }
 
@@ -3922,10 +3932,10 @@ CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
 {
 	int rc = health_info_get_temperature_raw(cmd);
 
-	if (rc < 0)
-		return rc;
-	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
-		return -EOPNOTSUPP;
+	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL) {
+		errno = EOPNOTSUPP;
+		return INT_MAX;
+	}
 	return rc;
 }
 
-- 
2.17.1

