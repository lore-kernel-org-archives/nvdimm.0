Return-Path: <SRS0=z2MS=A3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3D1C433DF
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Jul 2020 17:31:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7AF482067D
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Jul 2020 17:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NSs/8mBf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF482067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D565C11C74C50;
	Thu, 16 Jul 2020 10:31:49 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=141.146.126.78; helo=aserp2120.oracle.com; envelope-from=joao.m.martins@oracle.com; receiver=<UNKNOWN> 
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A3B4A11C74C44
	for <linux-nvdimm@lists.01.org>; Thu, 16 Jul 2020 10:31:46 -0700 (PDT)
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GHN3mr193895;
	Thu, 16 Jul 2020 17:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=aLwGHxNHfczutxHrXFv3zIR1Jruyl6obuE4G4874JbI=;
 b=NSs/8mBf+yxNCJZqx6ptVHHG9H6IZnGFMXZ/ngDwCJYpNjHnIfc95p1mXLNL9gjKCdn9
 uv62/0HoDsi/MPXgRriLkE3+ABFvRf5wS5ev+CNBSU4z9IUoDbtx5uGB6fXsI8ZZ4BZa
 PlZjz/t65xY+DgJYbzSXgg1o9NwovBpMvjZ/eO7YZLt9OvaCJA04wIBSzWsu2TEro5kE
 MRjggVjzFfdYEWXkqfUy8LEW0hDILD3QmMwRJxLBSiITm4InzM+y7wXe3olgQ1eX6ere
 a+WZE+MNkqJPnDy2yR/GhAJpQ6YvQjv2Hs+IPegbyuvK/zsNH8EvPebu7FiCNQYVDkZj 5Q==
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by aserp2120.oracle.com with ESMTP id 3275cmjtfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2020 17:31:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GHHiJH005585;
	Thu, 16 Jul 2020 17:29:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserp3030.oracle.com with ESMTP id 327q0tvk5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2020 17:29:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06GHTffc032689;
	Thu, 16 Jul 2020 17:29:41 GMT
Received: from paddy.uk.oracle.com (/10.175.173.87)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Thu, 16 Jul 2020 10:29:41 -0700
From: Joao Martins <joao.m.martins@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 3/4] dax/hmem: Introduce dax_hmem.region_idle parameter
Date: Thu, 16 Jul 2020 18:29:12 +0100
Message-Id: <20200716172913.19658-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200716172913.19658-1-joao.m.martins@oracle.com>
References: <20200716172913.19658-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9684 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160126
Message-ID-Hash: SOPCBODIHJVLBTYL2AWDUI6BLGCLAAV3
X-Message-ID-Hash: SOPCBODIHJVLBTYL2AWDUI6BLGCLAAV3
X-MailFrom: joao.m.martins@oracle.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SOPCBODIHJVLBTYL2AWDUI6BLGCLAAV3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce a new module parameter for dax_hmem which
initializes all region devices as free, rather than allocating
a pagemap for the region by default.

All hmem devices created with dax_hmem.region_idle=1 will have full
available size for creating dynamic dax devices.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/dax/hmem/hmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1a3347bb6143..1bf040dbc834 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -5,6 +5,9 @@
 #include <linux/pfn_t.h>
 #include "../bus.h"
 
+static bool region_idle;
+module_param_named(region_idle, region_idle, bool, 0644);
+
 static int dax_hmem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -30,7 +33,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = -1,
-		.size = resource_size(res),
+		.size = region_idle ? 0 : resource_size(res),
 	};
 	dev_dax = devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
-- 
2.17.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
