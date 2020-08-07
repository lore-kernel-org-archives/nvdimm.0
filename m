Return-Path: <SRS0=04Zv=BR=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C1EC433DF
	for <linux-nvdimm@archiver.kernel.org>; Fri,  7 Aug 2020 12:32:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EDD7E2086A
	for <linux-nvdimm@archiver.kernel.org>; Fri,  7 Aug 2020 12:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AkubhqUE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDD7E2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B337012C9E7DB;
	Fri,  7 Aug 2020 05:32:08 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=148.163.158.5; helo=mx0a-001b2d01.pphosted.com; envelope-from=vaibhav@linux.ibm.com; receiver=<UNKNOWN> 
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6AC7B12C428FD
	for <linux-nvdimm@lists.01.org>; Fri,  7 Aug 2020 05:32:06 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077CViBb089381;
	Fri, 7 Aug 2020 08:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pHk0rJ1y3W/KcscNfyKUHkE404icWevfwXAlqGGp9mM=;
 b=AkubhqUEH9Amws2sjV81gh5Qhcr9bWxzT8RD26zYxE1upv8wcd3zlS+Etkg/6dCwdKVI
 SDXluLdRAST+sQ+9meZK3qwVuJmTsEgVBGEL0HW8Fxeco68M6jxr56QEHofT3W5Tn3gq
 AT6LRvAD/3faW1EJ9n9qadBIRNWdOxEgvz1Qe8GRvMNWmtI2PE1jds2zFvYq7a/9oBzb
 u58fr7euZ0l81XEeAnFCGrtduwMyqT5MN9VNNTZJMsb3CLaRXojULAwtaDcoFDE039H9
 vydMWxOf5SoAJo6cWE+UNHWtvu3VmJabWQ6cgNMlvm0kLJkpkKZO2HWwfPfXBfnkJZ6k dw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 32rnu9v8j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2020 08:31:57 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 077CVuYI090184;
	Fri, 7 Aug 2020 08:31:56 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0b-001b2d01.pphosted.com with ESMTP id 32rnu9v8hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2020 08:31:56 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 077CFxPx013065;
	Fri, 7 Aug 2020 12:31:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma04fra.de.ibm.com with ESMTP id 32n018c2dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2020 12:31:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 077CVpTP26280242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2020 12:31:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D93FA404D;
	Fri,  7 Aug 2020 12:31:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A4FEA4040;
	Fri,  7 Aug 2020 12:31:48 +0000 (GMT)
Received: from vajain21-in-ibm-com (unknown [9.85.74.235])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Fri,  7 Aug 2020 12:31:48 +0000 (GMT)
Received: by vajain21-in-ibm-com (sSMTP sendmail emulation); Fri, 07 Aug 2020 18:01:47 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
Subject: [PATCH] powerpc/papr_scm: Make access mode of 'perf_stats' attribute file to '0400'
Date: Fri,  7 Aug 2020 18:01:46 +0530
Message-Id: <20200807123146.11037-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_08:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070088
Message-ID-Hash: EGKB45GQ7RWEN3PLLX2XJLTPEC4MMWLZ
X-Message-ID-Hash: EGKB45GQ7RWEN3PLLX2XJLTPEC4MMWLZ
X-MailFrom: vaibhav@linux.ibm.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Vaibhav Jain <vaibhav@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EGKB45GQ7RWEN3PLLX2XJLTPEC4MMWLZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The newly introduced 'perf_stats' attribute uses the default access
mode of 0444 letting non-root users access performance stats of an
nvdimm and potentially force the kernel into issuing large number of
expensive HCALLs. Since the information exposed by this attribute
cannot be cached hence its better to ward of access to this attribute
from non-root users.

Hence this patch updates the access-mode of 'perf_stats' sysfs
attribute file to 0400 to make it only readable to root-users.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index f439f0dfea7d1..31864d167a2ce 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -822,7 +822,7 @@ static ssize_t perf_stats_show(struct device *dev,
 	kfree(stats);
 	return rc ? rc : seq_buf_used(&s);
 }
-DEVICE_ATTR_RO(perf_stats);
+DEVICE_ATTR(perf_stats, 0400, perf_stats_show, NULL);
 
 static ssize_t flags_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
