Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155770
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 15:27:42 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QF4GKv124325;
	Wed, 26 May 2021 11:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=CWkSzCTP7KHishIlWZEHZbVXHEKF0RcJj82EkBvgvQs=;
 b=Qw1AY/V3IpicJBXqCC0z8JXppWdx1HMTgKnQPTLSMk2InyJzQrrLa0ic4INQliP0Ps3l
 FMAwPu/youaz1Sg8VJnJYHCKXIgClTFT7ipbhYswdePFYuV2UCjSJjnX1u8GZ3gTT/YN
 7H0dD2yxhMTGGObyVcq4f1CSH3fTsQSlh7qwOc+whNyPdhWsfhyGCL3RBnDYQG0r/uTw
 rTEpatBhhplUtOufPmEMplWFWM2ngdrgDVbH4zbvKD1MvWTBxYnnXI2aQZkMtgliZv+L
 S6mYLalZebfssYlWRijVsJnc/8GhShYruk1sbrrT6QRHyvjsDdo4/0bC6OhkNs9eAlmE Ew== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38spv8my4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 May 2021 11:27:22 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QFD0Ii009344;
	Wed, 26 May 2021 15:27:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma05fra.de.ibm.com with ESMTP id 38s1r50cwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 May 2021 15:27:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QFQlZf21954992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 May 2021 15:26:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22C6B42042;
	Wed, 26 May 2021 15:27:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4143742041;
	Wed, 26 May 2021 15:27:16 +0000 (GMT)
Received: from [172.17.0.4] (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 26 May 2021 15:27:16 +0000 (GMT)
Subject: [PATCH] spapr: nvdimm: Fix the persistent-memory root node name in
 device tree
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev
Date: Wed, 26 May 2021 11:27:15 -0400
Message-ID: <162204278956.219.9061511386011411578.stgit@cc493db1e665>
User-Agent: StGit/0.21
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: csjGxA3AkIXG2GNhbhRDYYLZmxKDHanm
X-Proofpoint-ORIG-GUID: csjGxA3AkIXG2GNhbhRDYYLZmxKDHanm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260102

The FDT code is adding the pmem root node by name "persistent-memory"
which should have been "ibm,persistent-memory".

The linux fetches the device tree nodes by type and it has been working
correctly as the type is correct. If someone searches by its intended
name it would fail, so fix that.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 hw/ppc/spapr_nvdimm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
index 252204e25f..d7a4a0a051 100644
--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -163,11 +163,11 @@ int spapr_pmem_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
 
 void spapr_dt_persistent_memory(SpaprMachineState *spapr, void *fdt)
 {
-    int offset = fdt_subnode_offset(fdt, 0, "persistent-memory");
+    int offset = fdt_subnode_offset(fdt, 0, "ibm,persistent-memory");
     GSList *iter, *nvdimms = nvdimm_get_device_list();
 
     if (offset < 0) {
-        offset = fdt_add_subnode(fdt, 0, "persistent-memory");
+        offset = fdt_add_subnode(fdt, 0, "ibm,persistent-memory");
         _FDT(offset);
         _FDT((fdt_setprop_cell(fdt, offset, "#address-cells", 0x1)));
         _FDT((fdt_setprop_cell(fdt, offset, "#size-cells", 0x0)));


