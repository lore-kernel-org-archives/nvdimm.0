Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2185915CF
	for <nvdimm@lists.linux.dev>; Tue, 20 Jun 2023 14:34:54 +0000 (UTC)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KE8kuR006675;
	Tue, 20 Jun 2023 14:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=7K/xsQqVPbIPN37kjzszKxy8hUlBb8VKcQNWTP2aNZk=;
 b=YrRc2nily0Mxdazm5AXcppS3MolSKDWRYB9SPqjxhConKjAmqcITOIaLIMkc4UTRqRMS
 EQq/0m0hvWvMyyvNoSCs2J8mFRQtmZLWTLC+xlNXQUJPvm8FnTM7C+muqns5e1WuqYT3
 s90yy81hRkoCVZdCJQoltKKjj0kftTtamD3IehyH98VSBN+1UetN7AqIuv5NS10Mavjs
 EZw8JHECD+5xymvvv+kAsiztbUHwxyGfJ8elhHWv8GCNIYAbGUy+UGbtZd4XgK8P+lil
 Nmv4TxlWfRZr4nwU2MHBmSgBRFz6/EZAx9kBwykO3jIqnWoBvAfV7DYqBXgiMu8d3PKy dg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rbda9sc9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 14:34:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35KDl90a030431;
	Tue, 20 Jun 2023 14:03:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3r94f523u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jun 2023 14:03:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35KE3aUQ23659116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jun 2023 14:03:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD0BE2004B;
	Tue, 20 Jun 2023 14:03:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0A6920040;
	Tue, 20 Jun 2023 14:03:34 +0000 (GMT)
Received: from tarunpc.in.ibm.com (unknown [9.199.157.25])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Jun 2023 14:03:34 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, jaypatel@linux.ibm.com,
        tsahu@linux.ibm.com
Subject: [PATCH] dax/kmem: Pass valid argument to memory_group_register_static
Date: Tue, 20 Jun 2023 19:33:32 +0530
Message-Id: <20230620140332.30578-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HL3Nuj0em6Fb1yUMU-9ZvkkBmytcqfY_
X-Proofpoint-ORIG-GUID: HL3Nuj0em6Fb1yUMU-9ZvkkBmytcqfY_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_10,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200131

memory_group_register_static takes maximum number of pages as the argument
while dev_dax_kmem_probe passes total_len (in bytes) as the argument.

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
---
 drivers/dax/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 7b36db6f1cbd..898ca9505754 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -99,7 +99,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (!data->res_name)
 		goto err_res_name;
 
-	rc = memory_group_register_static(numa_node, total_len);
+	rc = memory_group_register_static(numa_node, PFN_UP(total_len));
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
-- 
2.31.1

