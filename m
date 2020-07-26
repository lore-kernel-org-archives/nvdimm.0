Return-Path: <SRS0=A3Mq=BF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C3BC433E0
	for <linux-nvdimm@archiver.kernel.org>; Sun, 26 Jul 2020 12:20:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2552320714
	for <linux-nvdimm@archiver.kernel.org>; Sun, 26 Jul 2020 12:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2552320714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D352811D54C4B;
	Sun, 26 Jul 2020 05:20:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=148.163.156.1; helo=mx0a-001b2d01.pphosted.com; envelope-from=vaibhav@linux.ibm.com; receiver=<UNKNOWN> 
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7C58E11D15746
	for <linux-nvdimm@lists.01.org>; Sun, 26 Jul 2020 05:20:49 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06QC37Tw065500;
	Sun, 26 Jul 2020 08:20:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 32gdmbmg07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Jul 2020 08:20:41 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06QC541Q068942;
	Sun, 26 Jul 2020 08:20:41 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 32gdmbmfyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Jul 2020 08:20:41 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06QCC7sJ030975;
	Sun, 26 Jul 2020 12:20:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 32gcqgh6n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 Jul 2020 12:20:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06QCJBw266388354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2020 12:19:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4359A11C050;
	Sun, 26 Jul 2020 12:20:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0391511C04A;
	Sun, 26 Jul 2020 12:20:33 +0000 (GMT)
Received: from vajain21-in-ibm-com (unknown [9.85.81.63])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Sun, 26 Jul 2020 12:20:32 +0000 (GMT)
Received: by vajain21-in-ibm-com (sSMTP sendmail emulation); Sun, 26 Jul 2020 17:50:31 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
Subject: [RESEND PATCH v2 0/2] powerpc/papr_scm: add support for reporting NVDIMM 'life_used_percentage' metric
Date: Sun, 26 Jul 2020 17:50:28 +0530
Message-Id: <20200726122030.31529-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-26_03:2020-07-24,2020-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007260093
Message-ID-Hash: 22YQQUUV4ML46OQSIBBBHHMV2ECL6R45
X-Message-ID-Hash: 22YQQUUV4ML46OQSIBBBHHMV2ECL6R45
X-MailFrom: vaibhav@linux.ibm.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Vaibhav Jain <vaibhav@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/22YQQUUV4ML46OQSIBBBHHMV2ECL6R45/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Changes since v2[1]:

* Rebased the patch series on latest ppc-next tree located [2]

[1] https://lore.kernel.org/linux-nvdimm/20200701133510.4613-1-vaibhav@linux.ibm.com/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git
---

This small patchset implements kernel side support for reporting
'life_used_percentage' metric in NDCTL with dimm health output for
papr-scm NVDIMMs. With corresponding NDCTL side changes output for
should be like:

$ sudo ndctl list -DH
[
  {
    "dev":"nmem0",
    "health":{
      "health_state":"ok",
      "life_used_percentage":0,
      "shutdown_state":"clean"
    }
  }
]

PHYP supports H_SCM_PERFORMANCE_STATS hcall through which an LPAR can
fetch various performance stats including 'fuel_gauge' percentage for
an NVDIMM. 'fuel_gauge' metric indicates the usable life remaining of
an NVDIMM expressed as percentage and  'life_used_percentage' can be
calculated as 'life_used_percentage = 100 - fuel_gauge'.

Structure of the patchset
=========================
First patch implements necessary scaffolding needed to issue the
H_SCM_PERFORMANCE_STATS hcall and fetch performance stats
catalogue. The patch also implements support for 'perf_stats' sysfs
attribute to report the full catalogue of supported performance stats
by PHYP.

Second and final patch implements support for sending this value to
libndctl by extending the PAPR_PDSM_HEALTH pdsm payload to add a new
field named 'dimm_fuel_gauge' to it.

Vaibhav Jain (2):
  powerpc/papr_scm: Fetch nvdimm performance stats from PHYP
  powerpc/papr_scm: Add support for fetching nvdimm 'fuel-gauge' metric

 Documentation/ABI/testing/sysfs-bus-papr-pmem |  27 +++
 arch/powerpc/include/uapi/asm/papr_pdsm.h     |   9 +
 arch/powerpc/platforms/pseries/papr_scm.c     | 184 ++++++++++++++++++
 3 files changed, 220 insertions(+)

-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
