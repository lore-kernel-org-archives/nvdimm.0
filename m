Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55576EA4
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 08:23:52 +0000 (UTC)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26I8Dmqk032246;
	Mon, 18 Jul 2022 08:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=Dvdsv6qQGUVmrQZaa7rGsnnz3ShNYUtZ1RRv7Lw20go=;
 b=ZNm8T1aTQI1Enns5BjDBsyH8Nv0jWVn0yThTqqGfzxhfJoD1ikiQo1v1XCw/y9wjXJB5
 mXKDeIzIddzvcf8nfsbYnHdOVHZb6FMtbJWEy6Z8Dt3zwGgaIoHNR8cktFrerkU94aUc
 slSJ25o94ucXCULfSdvJCee7ELZmbTUWfJnsmtUZO1wVk/CAOsJ2sY0l6Ts9u+QApDZB
 4hjw2+lgPviDX7Vnxzip112LTmyzBRNxBjcq+SijNiQIgWKopqkjsjK+Na/P1ytuce8M
 UT+Rxl1CfVKn6d+vCUbRkXE0Kzr3QKB9WnD/y+1F1hTM0UxyNUlcggQIC/ZejdPQUi1D wg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hd3ttr5yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Jul 2022 08:23:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26I8Ka3K001724;
	Mon, 18 Jul 2022 08:23:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8t8mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Jul 2022 08:23:41 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26I8NcZd20250906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Jul 2022 08:23:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 818565204F;
	Mon, 18 Jul 2022 08:23:38 +0000 (GMT)
Received: from [192.168.29.61] (unknown [9.43.124.131])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 84D715204E;
	Mon, 18 Jul 2022 08:23:36 +0000 (GMT)
Subject: [PATCH] libcxl: Fix memory leakage in cxl_port_init()
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Cc: dan.j.williams@intel.com, vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        aneesh.kumar@linux.ibm.com
Date: Mon, 18 Jul 2022 13:53:35 +0530
Message-ID: <165813258358.95191.6678871197554236554.stgit@LAPTOP-TBQTPII8>
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
X-Proofpoint-ORIG-GUID: rGpM8Q4NfzKis2JCQEYSlJAFZih8blm1
X-Proofpoint-GUID: rGpM8Q4NfzKis2JCQEYSlJAFZih8blm1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_04,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 impostorscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180034

The local variable 'path' is not freed in cxl_port_init() for success case.
The patch fixes that.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 cxl/lib/libcxl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index be6bc2c..e52896f 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -770,6 +770,7 @@ static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		port->module = util_modalias_to_module(ctx, buf);
 
+	free(path);
 	return 0;
 err:
 	free(port->dev_path);


