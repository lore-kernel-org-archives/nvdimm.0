Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088447C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 04:24:48 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28L3hRFP010947;
	Wed, 21 Sep 2022 04:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=hAh9FQih1pSef5wCDtddeaOkFop1tBkbHVA2d/ye1jU=;
 b=NQ62C1VJjc9a2Xr2PShYh8n++a1MnshOKkW6ll6liBbp+WSmBRGS7hHnLX2fpd0TZp1Z
 JOnWeMyVyEIGuM07hR36sTfwqhR2/iRisfpRvI0qi+KMRjYSUtqYofLKiqB3tXd21rCg
 BluRcNsKTi23O73ovD5EnOQjXr6Mv0oxzaySr8Nb+ZQjJae3Jq3p8YeYwz0EtImz4jme
 WDQC69AguVKFeVtvfGv9XuY3l+JcCJDHEI/TZh6+SlWbwfFlJtRJBiiCmDh7RgtqVg8H
 xLTrt+/WNzDR8GsgK1mGmWNOXQMVU/agQsvwvspd404qS6wDcudwi6LOIQ7Rp7Fpr1vg dw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqty1901p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Sep 2022 04:24:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28L4KHrK004919;
	Wed, 21 Sep 2022 04:24:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma03fra.de.ibm.com with ESMTP id 3jn5v8kfq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Sep 2022 04:24:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28L4OD2g22086070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Sep 2022 04:24:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CF355204F;
	Wed, 21 Sep 2022 04:24:13 +0000 (GMT)
Received: from [192.168.29.62] (unknown [9.43.10.2])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EDED45204E;
	Wed, 21 Sep 2022 04:24:11 +0000 (GMT)
Subject: [PATCH] ndctl: Fix the NDCTL_TIMEOUT environment variable parsing
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: vishal.l.verma@intel.com, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, sbhat@linux.ibm.com
Date: Wed, 21 Sep 2022 09:54:10 +0530
Message-ID: <166373424779.231228.12814077203589935658.stgit@LAPTOP-TBQTPII8>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qhVpVWKEApvfcXBKviWzrPfBmibiEq__
X-Proofpoint-GUID: qhVpVWKEApvfcXBKviWzrPfBmibiEq__
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 clxscore=1011
 mlxlogscore=999 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210025

The strtoul(x, y, size) returns empty string on y when the x is "only"
number with no other suffix strings. The code is checking if !null
instead of comparing with empty string.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 ndctl/lib/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ad54f06..b0287e8 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -334,7 +334,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 		char *end;
 
 		tmo = strtoul(env, &end, 0);
-		if (tmo < ULONG_MAX && !end)
+		if (tmo < ULONG_MAX && strcmp(end, "") == 0)
 			c->timeout = tmo;
 		dbg(c, "timeout = %ld\n", tmo);
 	}


