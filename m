Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92897B
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 17:22:41 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGDuZd025185;
	Tue, 26 Apr 2022 17:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=eamDKsKXiERfCBNYE0b4AzZm1XVuZJvvh/jMzav7XS0=;
 b=pNjUyClvppBor06tKI+XMTBluGSTBqf143MHGWjidXaIrDGc2/n4s9SKbM5gVFwTQGF1
 3C33TzklNIzJgJhoDvo2Yf0cPfDJP5uXpi17OPwQQu/saYQzLi6opJiJFRVcZ3l8oS/z
 RE2OqaPtBMtaBOK1GTco77DoFJRBsDg54FGO7+6tXV4FkbodBVZPj3o5yVH9wPGepL9w
 XZ8dRAZyZTkATdM0D6T3oOvWI0elcc3WuQaJCJPFMdUPyOl2qsPpJxZinPoYkZtw4tYw
 4fFH3t7XZQiXkwJcKnA2C6JM4T6huyOmDnC1+/68AqFCvOjVOeJwUGT6f5hFq4bL3wsw Tw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpm2v9aqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Apr 2022 17:22:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QHDP0f008703;
	Tue, 26 Apr 2022 17:22:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma05fra.de.ibm.com with ESMTP id 3fm938uqx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Apr 2022 17:22:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QHMQMo40501592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Apr 2022 17:22:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C15914203F;
	Tue, 26 Apr 2022 17:22:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 261AB42042;
	Tue, 26 Apr 2022 17:22:24 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.5.136])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 26 Apr 2022 17:22:23 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v3 0/2] ndctl/namespace:Fix and improve write-infoblock
Date: Tue, 26 Apr 2022 22:50:54 +0530
Message-Id: <20220426172056.122789-1-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YFcdIrOOGduI5iQ2Lw0vys6CVGY9PuTl
X-Proofpoint-ORIG-GUID: YFcdIrOOGduI5iQ2Lw0vys6CVGY9PuTl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=670 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260109

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

Tarun-Sahu (2):
  ndctl/namespace:Fix multiple issues with write-infoblock
  ndctl/namespace:Implement write-infoblock for sector mode namespaces

 ndctl/namespace.c | 308 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 225 insertions(+), 83 deletions(-)

-- 
2.35.1

