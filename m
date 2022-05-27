Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7571366
	for <nvdimm@lists.linux.dev>; Fri, 27 May 2022 10:30:40 +0000 (UTC)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24RAFcpK017714;
	Fri, 27 May 2022 10:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=p+hrfX+yngEvnm1+cEsLsCEgOmOIAjcMX/e5obuB+Cc=;
 b=VHjamw9hoGB0tBNmFDx3o3BNXehZQDU6CD3E0N7fEe8zn07L4U1S7oKgFKe2WI6Xug3Q
 upY92W75b0s3Yq/O5ypx+84uH5lSmksxITiEs1EcjxDJiyTZBdtEdDZEWKMvpRmKYb8m
 +i7qEMnMuGtbXJTYFy4PWqn+9098xCo/n/B3A2VmTmp7/tHmHsuAUFJRsl11y9t/hUrV
 Ntkn3TbmsbcLu1bxklvrbmGVvdyh7k5NE+HKaeyAfaDuH6dNEkntbNJgVjeM4tnkyRso
 tuD6gYDloPCLOBDFiJEX/b0Mxgsep1JhNqhxdMI+LM8+grvZbrT0HKC27I+TZhKo06Em 2g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gavr1879u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 May 2022 10:30:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24RAMniv009494;
	Fri, 27 May 2022 10:30:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3g93ux3t3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 May 2022 10:30:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24RAUSRp47645052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 May 2022 10:30:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82B565204F;
	Fri, 27 May 2022 10:30:28 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.36.181])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9372352050;
	Fri, 27 May 2022 10:30:25 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v4 0/2]ndctl/namespace: Fix and improve write-infoblock
Date: Fri, 27 May 2022 16:00:19 +0530
Message-Id: <20220527103021.452651-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vUV80-x_8ER803JUpIvvEsZDKPX_TqBX
X-Proofpoint-GUID: vUV80-x_8ER803JUpIvvEsZDKPX_TqBX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=738 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 phishscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205270047

This series resolves some issues with write-infoblock 
command and provide support to write-infoblock for sector 
mode namespace

write-infoblock command has issues regarding updating the 
align, uuid, parent_uuid. In case of no parameter passed 
for it, this command used to overwrite the existing values 
with defaults.

In PATCH 1/2 these parameters will be set to their original 
values, incase, values hasn't been passed in command 
arguments

write-infoblock command doesn't have support for sector/BTT 
mode namespaces. They can be converted to fsdax, but can 
not be written being in sector mode.

In PATCH 2/2, It creates a functionality which write 
infoblock of Sector/BTT namespace. Currently only uuid, 
parent_uuid can be updated. In future, Support for other 
parameters can easily be integrated in the
functionality.

---
v2:
  Updated the commit message (rephrasing) in patch 1/2
  Moved the ns_info struct to namespace.c from namespace.h
  put the results after --- to avoid long commit message

v3:
  reformat the commit message to meet 100 column condition

v4:
  - Moved the struct ns_info definition to the beginning of
  the block 
  - Initialized the buf of ns_info structure in ns_info_init
  - Change the format of comment in code from "//" to "/**/"
  - reword the commit message of patch 2/2

Tarun Sahu (2):
  ndctl/namespace: Fix multiple issues with write-infoblock
  ndctl/namespace: Implement write-infoblock for sector mode namespaces

 ndctl/namespace.c | 314 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 231 insertions(+), 83 deletions(-)

-- 
2.35.1

