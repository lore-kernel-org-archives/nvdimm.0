Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2615E10EB
	for <nvdimm@lists.linux.dev>; Fri,  4 Nov 2022 07:31:20 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A46bi2c012829;
	Fri, 4 Nov 2022 07:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=u0Bf5ex/DksvDfhYW9rdcSByd45Q2+d5/DXWIL5wFH8=;
 b=PIZboCgxazkDUYMCL5xNt022GJN3nfh96S3B8LM+p7fdXSHFL9fW+miI4REVSpWale7N
 DmKyFqdoKFTkygNDgctFGcuJdOulUXvvm/XkgWiSz6LGPbQQQVeEdXGAAagGHCpjVmNj
 7UksyzJ2J4Emm9LyUcOcqxK1392xPp3ZA983U1Y8LeEcie4G7tKPfULQuwvopa7VgSUu
 dxI5x6hIBUR7lk4BrYQtzZlQBNujQVkrWfhfjXzbZWlCe4UMQrzsCbY/hhDW7TLOxd0X
 qu2vRtPIBFef7WBoPfTMycEok07cgDpY2bDr/xNzBPyZrxeQr/91byp+zqlvBKwRd1iQ 6g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpt0vk3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Nov 2022 07:31:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A47LmKo029242;
	Fri, 4 Nov 2022 07:31:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma06ams.nl.ibm.com with ESMTP id 3kguej20yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Nov 2022 07:31:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A47V4d91114676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Nov 2022 07:31:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37BD511C050;
	Fri,  4 Nov 2022 07:31:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CF7B11C04C;
	Fri,  4 Nov 2022 07:31:03 +0000 (GMT)
Received: from [192.168.122.70] (unknown [9.43.104.193])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  4 Nov 2022 07:31:02 +0000 (GMT)
Subject: [ndctl PATCH v2] ndctl: Fix the NDCTL_TIMEOUT environment variable
 parsing
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: vishal.l.verma@intel.com, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, sbhat@linux.ibm.com
Date: Fri, 04 Nov 2022 07:31:02 +0000
Message-ID: <166754703982.18057.1825839184901260588.stgit@fedora>
User-Agent: StGit/1.4
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cc4yqTbd7mNH9f-dAsbPGOJ77VxMPGHX
X-Proofpoint-ORIG-GUID: Cc4yqTbd7mNH9f-dAsbPGOJ77VxMPGHX
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211040047

The strtoul(x, y, size) returns empty string on y when the x is "only"
number with no other suffix strings. The code is checking if !null
instead of comparing with empty string.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
Changelog:
Since v1:
Link: https://lore.kernel.org/all/166373424779.231228.12814077203589935658.stgit@LAPTOP-TBQTPII8/
* Avoid using strcmp

 ndctl/lib/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ad54f06..77c31ab 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -334,7 +334,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 		char *end;
 
 		tmo = strtoul(env, &end, 0);
-		if (tmo < ULONG_MAX && !end)
+		if (tmo < ULONG_MAX && !*end)
 			c->timeout = tmo;
 		dbg(c, "timeout = %ld\n", tmo);
 	}


