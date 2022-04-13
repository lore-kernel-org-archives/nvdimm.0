Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CF523BD
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 03:53:06 +0000 (UTC)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23D2sO5p032691;
	Wed, 13 Apr 2022 03:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HVCcciqPMmW+P5n3kQX2WF7wiWo5q9BAulz4UxRvEqc=;
 b=VeNjp37BfkxY9lM4uluZizrZSRPc96eu6VJEBumB9+eySUNdq4ghCpPgXa1dKbYjk1Af
 WFJXroFvESoLNlnpnXaCkJrhsF64l8v/BeKQldZBSKdYJvS1JehrXW5Wcu/Q4jWsN6o3
 WUr6PkxHcegRPXwho41CgjtGq9aK50UnZM6bGx1P5bUj24Jk3nPdHhJOeUbJlR3d4foM
 KkUMuv3aRUM23ZzTw9Bo42e01wVsPRuvlavcIOJ/vtyoSBTq9Qyhu6vS81mL0keWH7YI
 Z07DBOuAkO1Y+9cbtOPtFT0l25qehfIW1RkDs+HeRUkNhnuttR5110oesz+99GDtjUiG Dw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fdes2h8dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Apr 2022 03:53:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23D3lkim019602;
	Wed, 13 Apr 2022 03:53:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma06fra.de.ibm.com with ESMTP id 3fbsj03uhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Apr 2022 03:53:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23D3qwmb40370458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Apr 2022 03:52:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B602A42041;
	Wed, 13 Apr 2022 03:52:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13FED4203F;
	Wed, 13 Apr 2022 03:52:56 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.41.9])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 13 Apr 2022 03:52:55 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH 0/2] ndctl/namespace:Fix and improve write-infoblock
Date: Wed, 13 Apr 2022 09:22:50 +0530
Message-Id: <20220413035252.161527-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S8HEB6K1ISlMCVpofdCXW73f23FO3Qj6
X-Proofpoint-GUID: S8HEB6K1ISlMCVpofdCXW73f23FO3Qj6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 mlxlogscore=508 malwarescore=0
 impostorscore=0 spamscore=0 adultscore=0 clxscore=1011 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130018

This series resolves some issues with write-infoblock command
and provide support to write-infoblock for sector mode namespace

write-infoblock command has issues regarding updating the align, 
uuid, parent_uuid. In case of no parameter passed for it, this command
used to overwrite the existing values with defaults. 

In PATCH 1/2 these parameters will be set to their original values, incase, 
values hasn't been passed in command arguments

write-infoblock command doesn't have support for sector/BTT mode
namespaces. They can be converted to fsdax, but can not be written
being in sector mode.

In PATCH 2/2, It creates a functionality which write infoblock of
Sector/BTT namespace. Currently only uuid, parent_uuid can be updated.
In future, Support for other parameters can easily be integrated in the
functionality.

---

Tarun Sahu (2):
  Fix multiple issues with write-infoblock command
  Implement write-infoblock for sector mode namespaces.

 ndctl/namespace.c | 297 +++++++++++++++++++++++++++++++++-------------
 ndctl/namespace.h |   7 ++
 2 files changed, 223 insertions(+), 81 deletions(-)

-- 
2.18.1

