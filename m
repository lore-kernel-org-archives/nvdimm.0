Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA7626
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:16:16 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230616010614epoutp028b6b0807f7599c4d147446e76b70e9e7~o-jd4J98y2814528145epoutp02S
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:06:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230616010614epoutp028b6b0807f7599c4d147446e76b70e9e7~o-jd4J98y2814528145epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1686877574;
	bh=vA9DFA9kELh2hhQR8GlB+evZh96ipZlMIxxWmmxZZ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAKWifA3/Nw6Gq8o9MKL5E9lLIiYZhZBodLKMhZTCbD7vjknEPj7oYMTUUs/+/Epu
	 cr0oI+gYCi+xJvhaQeq+8+Av+RTY+cKLzgsTPP/H7xp9AiuPxtwDyftI/OUDr9w4yv
	 uHtzKFnEHuHNAtyYNyIPJQ+kFdUQMO4x4+vbnmAQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20230616010614epcas2p3fc3062a13d2516da02d3bdd2057feeb7~o-jdX_U-h0162901629epcas2p34;
	Fri, 16 Jun 2023 01:06:14 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.91]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Qj1FK3THFz4x9Pw; Fri, 16 Jun
	2023 01:06:13 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	A0.4F.11450.585BB846; Fri, 16 Jun 2023 10:06:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230616010613epcas2p4970d8588a29154fa355e14f44943a80b~o-jchl8_41248912489epcas2p4A;
	Fri, 16 Jun 2023 01:06:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230616010613epsmtrp20a0b05e074b3b5f12846d04a6cd28142~o-jcfo7GX2823928239epsmtrp2Y;
	Fri, 16 Jun 2023 01:06:13 +0000 (GMT)
X-AuditID: b6c32a45-1dbff70000022cba-7c-648bb5859e7f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	45.2A.28392.485BB846; Fri, 16 Jun 2023 10:06:13 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230616010612epsmtip1a7eca9e25b89c5fdda7b35ac1ff49f64~o-jcTTNJI1453014530epsmtip1a;
	Fri, 16 Jun 2023 01:06:12 +0000 (GMT)
From: Jehoon PARK <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH 2/2] libcxl: Fix accessors for temperature field to
 support negative value
Date: Fri, 16 Jun 2023 10:08:41 +0900
Message-Id: <20230616010841.3632-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616010841.3632-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7bCmqW7r1u4Ug8bzUhZ3H19gs2ievJjR
	YvrUC4wWJ242slnsf/qcxeLA6wZ2i/OzTrFYrPzxh9Xi1oRjTA6cHov3vGTy2LSqk83jxeaZ
	jB59W1YxenzeJBfAGpVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLxArzgxt7g0L10v
	L7XEytDAwMgUqDAhO6NrzVu2gm/SFQfnf2NrYFwq3sXIySEhYCKxs/8rSxcjF4eQwA5Gid0P
	T7FBOJ8YJZZuvgmV+cwosWzPUjaYlql7LzFBJHYxShz4uheqpZdJYs3lZ4wgVWwC2hLtfW/B
	bBEBWYnmdQ/AOpgFNjBJrFh4jLmLkYNDWCBJ4ukWG5AaFgFViXXvzzGB2LwC1hIdK68yQWyT
	l1i94QAziM0pYCMxbcdbsDkSApfYJaZfussMUeQiMXXVLRYIW1ji1fEt7BC2lMTnd3uhzs6X
	+HnyFiuEXSDx6csHqHpjiXc3n7OC3MMsoCmxfpc+iCkhoCxxBGIiswCfRMfhv+wQYV6JjjYh
	iEZVia7jHxghbGmJw1eOQh3jIdF67wA0SPoZJV53PGKawCg3C2HBAkbGVYxiqQXFuempxUYF
	hvAYS87P3cQITnBarjsYJ7/9oHeIkYmD8RCjBAezkgjvshNdKUK8KYmVValF+fFFpTmpxYcY
	TYFhN5FZSjQ5H5hi80riDU0sDUzMzAzNjUwNzJXEeaVtTyYLCaQnlqRmp6YWpBbB9DFxcEo1
	MC2IeiCXeyz6VcPF73WPhd9YTWua7VKWv0ebx9Bt9f7DkndWfwxbc8ug+P/u287FFTo751ZU
	6gXvEkh/spHjSeFyNtc5rf+nzRK/uSqF/baryhHVig5Fzb1i0R4eDR8FN9s+u63B49Z3M9z7
	ZPFMk+R9LddmLEy7+/95m11NBV9mgGGK0uM33//bXRSqlroye7Kbar1zaf4fPgXBp9OXxb43
	T8id8a3xaOH+kJo/kw/01p3y3Nq1MejMK7e2hZPLPqnFndJ4t/a6n0N6z36+7ENfLhkZTtWQ
	YbxUry92SL9f986/RRG+kT9boz7rT/cX9K35EPb38DVdszpxf/lVPG073njMlJ3xocBw1/cZ
	a5VYijMSDbWYi4oTAeu3qXz5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsWy7bCSnG7r1u4UgxOTmS3uPr7AZtE8eTGj
	xfSpFxgtTtxsZLPY//Q5i8WB1w3sFudnnWKxWPnjD6vFrQnHmBw4PRbvecnksWlVJ5vHi80z
	GT36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEro2vNW7aCb9IVB+d/Y2tgXCrexcjJISFgIjF1
	7yWmLkYuDiGBHYwSPUf3sUAkpCXuNV9hh7CFJe63HGGFKOpmkth49SIjSIJNQFuive8tmC0i
	ICvRvO4B2CRmgR1MEge39DKBJIQFEiR2rVgHNolFQFVi3ftzYHFeAWuJjpVXmSA2yEus3nCA
	GcTmFLCRmLbjLVhcCKjm+ofP7BMY+RYwMqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/d
	xAgORi2tHYx7Vn3QO8TIxMF4iFGCg1lJhHfZia4UId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwX
	uk7GCwmkJ5akZqemFqQWwWSZODilGpikP/GcXhhdvtHhhLs7T4m88bWS2P0cEd9m5T0/13Cm
	7t4RjSutCbXWVzO7Z/Eo6LXUyO879NSo92qHpPnt7HQutTlPkkVv8gWI6jj2fNge1b26Id9w
	J2toSOfMU9xluwQUZtifzp0yrdr0Z47edKv4lvNlS9uz7vBdn2h6Kv1Aq1Ny66JFQf8vlzU2
	vQ2cdXev3AGvY7F7RE4929hQ5hMwT+jwN/WLHAsjeq9ZLjSptzjcpVF7L2a9wMOaqPTHSl1L
	vJRrxXbPKXy4b+nOulNCfR53TfbpvbnQ9n7O0itXjitGGoU7fy3p+MbHZGW1y0rCwsLi6T29
	8rpFu+0ijPdPnxbv7zlDs9ytplfqmxJLcUaioRZzUXEiALmEdDO1AgAA
X-CMS-MailID: 20230616010613epcas2p4970d8588a29154fa355e14f44943a80b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230616010613epcas2p4970d8588a29154fa355e14f44943a80b
References: <20230616010841.3632-1-jehoon.park@samsung.com>
	<CGME20230616010613epcas2p4970d8588a29154fa355e14f44943a80b@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

From: Jehoon Park <jehoon.park@samsung.com>

Add a new macro function to retrieve a signed value such as a temperature.
Replace indistinguishable error numbers with debug message.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/lib/libcxl.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 769cd8a..fca7faa 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3452,11 +3452,21 @@ cxl_cmd_alert_config_get_life_used_prog_warn_threshold(struct cxl_cmd *cmd)
 			 life_used_prog_warn_threshold);
 }
 
+#define cmd_get_field_s16(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return 0xffff;						\
+	return (int16_t)le16_to_cpu(c->field);					\
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
 
@@ -3464,7 +3474,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_under_temperature_crit_alert_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_under_temperature_crit_alert_threshold);
 }
 
@@ -3472,7 +3482,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_over_temperature_prog_warn_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_over_temperature_prog_warn_threshold);
 }
 
@@ -3480,7 +3490,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_under_temperature_prog_warn_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_under_temperature_prog_warn_threshold);
 }
 
@@ -3695,28 +3705,34 @@ static int health_info_get_life_used_raw(struct cxl_cmd *cmd)
 CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
 {
 	int rc = health_info_get_life_used_raw(cmd);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
 
 	if (rc < 0)
-		return rc;
+		dbg(ctx, "%s: Invalid command status\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
-		return -EOPNOTSUPP;
+		dbg(ctx, "%s: Life Used not implemented\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	return rc;
 }
 
 static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
+	cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
 				 temperature);
 }
 
 CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
 {
 	int rc = health_info_get_temperature_raw(cmd);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
 
-	if (rc < 0)
-		return rc;
+	if (rc == 0xffff)
+		dbg(ctx, "%s: Invalid command status\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
-		return -EOPNOTSUPP;
+		dbg(ctx, "%s: Device Temperature not implemented\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	return rc;
 }
 
-- 
2.17.1

