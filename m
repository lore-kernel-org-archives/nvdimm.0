Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D211ADFF
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:19 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230810082117epoutp011b3046a4d7e0604c18fb258698cf3244~59_BJsFhk1082510825epoutp01h
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230810082117epoutp011b3046a4d7e0604c18fb258698cf3244~59_BJsFhk1082510825epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691655677;
	bh=BiuER2At4jDkAcJOxckMGncwwMHXN1DeBeM8JYSfCJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTa0Sl6pEFFUu7ql2A90nqc83j98f5irfd1MuaHu7xi8ndRxse41JzOZfDii2r9wp
	 +K743jl93OFJfeCyHz+4CQrfx6+uz9wrW+RVnV7EX7AS2+3k63rkAvYl1DoAABj3L+
	 ojHnWCUMT7brJm9pk/xWcMQQF7Mup0Ilr7sFPsnE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230810082116epcas2p2bd8cc5bd8a168db96e4b20e78d1b2ce6~59_AKp_Pb2819828198epcas2p2V;
	Thu, 10 Aug 2023 08:21:16 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.90]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4RM0Hw13bQz4x9Q3; Thu, 10 Aug
	2023 08:21:16 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	89.B7.49913.BFD94D46; Thu, 10 Aug 2023 17:21:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20230810082115epcas2p31c2f26887e54c9fdeab0215bbde49f0a~599-R-eTB1437714377epcas2p3y;
	Thu, 10 Aug 2023 08:21:15 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230810082115epsmtrp249288e19407cf84f7b9abaf59abfdb4c~599-QiW3S3060530605epsmtrp2W;
	Thu, 10 Aug 2023 08:21:15 +0000 (GMT)
X-AuditID: b6c32a45-5cfff7000000c2f9-a1-64d49dfbf04c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.24.64355.BFD94D46; Thu, 10 Aug 2023 17:21:15 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230810082115epsmtip1a473fe04e45bbb2279150faee0cdd782~599-FO3TI2164621646epsmtip1J;
	Thu, 10 Aug 2023 08:21:15 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 2/3] libcxl: Fix accessors for temperature field to
 support negative value
Date: Thu, 10 Aug 2023 17:23:53 +0900
Message-Id: <20230810082354.5992-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230810082354.5992-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmqe6fuVdSDC58YbK4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOeP68qmCZdMWkfY1sDYxnxLoYOTkk
	BEwkfv6dyQJiCwnsYJS4sVa2i5ELyP7EKNF+v5cFznn86RYrTMfkKRcZIRI7GSXuPn3HCuH0
	MkncWn6ODaSKTUBb4v72DWC2iICsRPO6B0wgRcwCm5kllu2EKBIWSJX41XiXHcRmEVCVWPDx
	K1icV8Ba4v/Sz8wQ6+QlVm84AGZzCthIfN67EmybhMBLdonJLfsYIYpcJHZ+m8gCYQtLvDq+
	hR3ClpL4/G4vG4SdL/HzJMwPBRKfvnyAqjeWeHfzOVCcA+g6TYn1u/RBTAkBZYkjt8AqmAX4
	JDoO/2WHCPNKdLQJQTSqSnQd/wB1gLTE4StHoS72kLi4cQ8TJEz6GSX2zd/GNIFRbhbCggWM
	jKsYxVILinPTU4uNCgzhEZacn7uJEZwCtVx3ME5++0HvECMTB+MhRgkOZiURXtvgSylCvCmJ
	lVWpRfnxRaU5qcWHGE2BYTeRWUo0OR+YhPNK4g1NLA1MzMwMzY1MDcyVxHnvtc5NERJITyxJ
	zU5NLUgtgulj4uCUamCacP70h59izw3jJsip3+RPC7Or2hsafWU2z0VBu44nj9qP3w3KZ85f
	OVWl2sff36fJq4zfaue8+xFffc4Fs9dGP29dlHxBzZ9h8eGpAcsWGt9qMFokbLYiw1Hu+sez
	1iqSJd/O9/Gprwgr3McQ5ysr/MuM48ictq9RiYk6xUuWXF5SNvu/GCvj5vClz3t1dy75vHrK
	5NsBf2PnxP2/N+uuzY/3Ag5VHcun7VfVabzC9Ti0pefeup2824XZN1yPT+pL+C2+/vax/77m
	Hv1NG9eYb89bbi5bYJT362lB04WvvnfrvyyIDYhK9DltrbZtl8Oc748tNsau2X3HfJKas0fZ
	/lvnrn9xt3iad77vw3EbJZbijERDLeai4kQAx3cVvAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnO7vuVdSDD6+UrO4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFcdmkpOZklqUW6dslcGU8f15VsEy6
	YtK+RrYGxjNiXYycHBICJhKTp1xk7GLk4hAS2M4osfnyMlaIhLTEveYr7BC2sMT9liNgcSGB
	biaJRw+5QWw2AW2J+9s3sIHYIgKyEs3rHjCBDGIW2Mss0THzPFiDsECyxJOX28FsFgFViQUf
	v4I18ApYS/xf+pkZYoG8xOoNB8BsTgEbic97V0Its5aYsXQe6wRGvgWMDKsYRVMLinPTc5ML
	DPWKE3OLS/PS9ZLzczcxgoNUK2gH47L1f/UOMTJxMB5ilOBgVhLhtQ2+lCLEm5JYWZValB9f
	VJqTWnyIUZqDRUmcVzmnM0VIID2xJDU7NbUgtQgmy8TBKdXAtGv2m3rDL8zuYRxz5k/8zH0j
	eb7yhc93Lp2dqCLHek59zk2F60U3NG5aFL8NM93Z2Lr77/uaWbxbGy9bWl04N0PSN/+N5xSR
	R2e9QnxdjnDNcjAJmSin8vn2ZYsOJXs12VmnFRkm51otfvo+OeFUaECYSldhPh/3+Qi/m9ts
	l76RZ41PWuhl76mWMatj6SzlyUKV3o/sM66dTn2nG33c+efxd5clZOcsiunUm1DxIGFnSP9m
	u2ufmgteLf729u1BmZrFR/J+dp1/opNkmDVBm/ug4t3pG7NuGEpNdJlc7HHF+H7fp103eA4X
	iR3b3RG2cdbppC2Of387H+Nr63X4yZ5ru/5yIt8XTSHfcusvD5VYijMSDbWYi4oTAcdsK6bB
	AgAA
X-CMS-MailID: 20230810082115epcas2p31c2f26887e54c9fdeab0215bbde49f0a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230810082115epcas2p31c2f26887e54c9fdeab0215bbde49f0a
References: <20230810082354.5992-1-jehoon.park@samsung.com>
	<CGME20230810082115epcas2p31c2f26887e54c9fdeab0215bbde49f0a@epcas2p3.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Add a new macro function to retrieve a signed value such as a temperature.
Modify accessors for signed value to return INT_MAX when error occurs and
set errno to corresponding errno codes.
Fix the error checking value of the temperature accessor in cxl/json.c.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/json.c       |  2 +-
 cxl/lib/libcxl.c | 30 +++++++++++++++++++++---------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 7678d02..89e5fd0 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -246,7 +246,7 @@ static struct json_object *util_cxl_memdev_health_to_json(
 	}
 
 	field = cxl_cmd_health_info_get_temperature(cmd);
-	if (field != 0xffff) {
+	if (field != INT_MAX) {
 		jobj = json_object_new_int(field);
 		if (jobj)
 			json_object_object_add(jhealth, "temperature", jobj);
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index af4ca44..53c9b25 100644
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
 
@@ -3914,7 +3926,7 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
 
 static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
+	cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
 				 temperature);
 }
 
@@ -3922,10 +3934,10 @@ CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
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

