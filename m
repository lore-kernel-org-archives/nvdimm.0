Return-Path: <SRS0=1/yj=5T=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4EBC2BA16
	for <linux-nvdimm@archiver.kernel.org>; Fri,  3 Apr 2020 20:59:15 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6D331206F6
	for <linux-nvdimm@archiver.kernel.org>; Fri,  3 Apr 2020 20:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dtl99mgO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D331206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 753F610FC51C9;
	Fri,  3 Apr 2020 14:00:04 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=156.151.31.85; helo=userp2120.oracle.com; envelope-from=joao.m.martins@oracle.com; receiver=<UNKNOWN> 
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 02AD810FC51C1
	for <linux-nvdimm@lists.01.org>; Fri,  3 Apr 2020 14:00:01 -0700 (PDT)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033Kgpj0091279;
	Fri, 3 Apr 2020 20:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=d3oLS7q7Bt4xe2EehGTJWVS620I5smV04E/wu/kUuTA=;
 b=dtl99mgOVsCnZR2sOWlwsgvpdp2VHGLZM6mU/0kwjSd/Q4iqJgRloQsMm7+3E7xSB/Pv
 jtWVbg8LI6doSDE+pPHi7Nrbo4rhPip/qNRHC4+/F5ru0rpHPGIZb8N2ogyxG5wi2XRq
 KTxnVC64x6CBca92RiDyoeFkHoBjOXpWLz8Wkt/ZZfVlXFGmd3qSSkSxq6dyhRPJiQEV
 Q+NID5TfAhplCMgH6mmBstbhot+o+AzDh0NWG1nKKkVYCNgJT4ogEO6cL7oK/1BIfkBV
 ImNgQ2Ts6KLo117zuzG9oXmuVQHyoWVak5kkIcTHwd7Q8UIod+vE+hYHsWuIHnRjWBKJ Nw==
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by userp2120.oracle.com with ESMTP id 303aqj3p71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2020 20:59:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033KgPbW033023;
	Fri, 3 Apr 2020 20:59:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserp3030.oracle.com with ESMTP id 302g4y65wn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2020 20:59:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033Kx9cO017739;
	Fri, 3 Apr 2020 20:59:09 GMT
Received: from paddy.uk.oracle.com (/10.175.206.152)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Fri, 03 Apr 2020 13:59:09 -0700
From: Joao Martins <joao.m.martins@oracle.com>
To: linux-nvdimm@lists.01.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl v1 01/10] daxctl: Cleanup whitespace
Date: Fri,  3 Apr 2020 21:58:51 +0100
Message-Id: <20200403205900.18035-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200403205900.18035-1-joao.m.martins@oracle.com>
References: <20200403205900.18035-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030165
Message-ID-Hash: UFBIN7NOT3XFNV5UH5MSE737WNF42QJL
X-Message-ID-Hash: UFBIN7NOT3XFNV5UH5MSE737WNF42QJL
X-MailFrom: joao.m.martins@oracle.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UFBIN7NOT3XFNV5UH5MSE737WNF42QJL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Dan Williams <dan.j.williams@intel.com>

Re-indent util_daxctl_region_filter() to match expectations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/filter.c b/util/filter.c
index af72793929e2..7d0159f8cef6 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -344,7 +344,7 @@ struct daxctl_region *util_daxctl_region_filter(struct daxctl_region *region,
 		return region;
 
 	if ((sscanf(ident, "%d", &region_id) == 1
-       || sscanf(ident, "region%d", &region_id) == 1)
+				|| sscanf(ident, "region%d", &region_id) == 1)
 			&& daxctl_region_get_id(region) == region_id)
 		return region;
 
-- 
2.17.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
