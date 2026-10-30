Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793356470;
	b=shckYlw4Mt31WBjuJWRsiIown5afZzA+ynBwVO4gq/FEX0/X9Ip7GbQT8yOJMaZrrBkK
	 zqxrIXx5Ql7yk5ltpLPz0ssgK4QNi+7frWKMld9WdgJirysh06m8LVyxywFgGwVg7vLi0
	 4YJvsIb+dAcvNgYkjt+98xYkRvcV89vbXMNf3dXMY9NZeBhB4qmAmxGKX0VrzBLHtTtO9
	 28/ZVt0FGdxY6tWF/KNg30t2t/dPCRWctSm7dKyiq21GM8+1V/wGS4giOV5NthJ+NjDAb
	 UJvnN0UK7sqCnMUvP2k2JThMME2IxnWrp+q0BftVyGW0NDhy3ybIWvSmBdeu69UzLjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793356470;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=+c1ihJ1Xln4zEcrREqgDAfDTBrnVULNOnFAexlBeung=;
	b=4v7z8kl+xSmV6L0O54xptBlbvnkvEMUbCMonBPY/40p3YjE7a/UUP8yF1ny569EapD7x
	 BpjcY1EPCi8rFlVGUsqNNmpyIWeQkHBFOfpBslVET8oxNJ6XmE1feDg2B0BvekmPhzyDU
	 rlyJ8VLSzpvs+Xhae7KDojk14OZ0DBAOZNFr5RCo25QoVgp4bjVu0N6Ss2q29G4w6DNgq
	 zKHitpHgJ8oODzmITZtbzkkih/S915ODytn1SrhhonB3cHOn6Ph3010vLRZs8XB6VKcda
	 CtABJQttDm6Fspm2eLrlbegvmURf85BlFgFVWLqF/xu09ueHPDKujlOPF+8jw4lgfWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="mt/vlXZ1";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667260A3804
	for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 10:34:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C667260A3804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=mt/vlXZ1
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8F1xQ2395373;
	Fri, 30 Oct 2026 10:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+c1ihJ
	1Xln4zEcrREqgDAfDTBrnVULNOnFAexlBeung=; b=mt/vlXZ1DYWCtoZ9NLFkwW
	pmIREyhUzcuLjPtMbZsJfQrafl7/MVB+Tjlr2jP5/3g8SxlWmHha7/+45ggMwG3g
	QChpcbkNgIFtzNelUHjjaX/t3WjKQWWH/ej/8mGBi+QXYx8NYD5x/zZ9x2k3vvNB
	rtXnJ0EL9cenodmySnDnXWqxS2QJ+/sj0Dq0bIQtmc50sJxXyWVBlj1lex85odoJ
	FqrC0R/gYtY6MFMfVyHFch9ZVAoELKZmlZLOjAzrxf3rBg87X82POHpWkLm0MKxC
	WTNuD96Vw+vfq8lHk3PZt6O8BQQqMSnvCiX5OF/FpHVoKsuokMkAzM9eL1Ct388g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hmeb027hk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 10:33:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69U8oNOX3288769;
	Fri, 30 Oct 2026 10:33:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hmr330a7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 10:33:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69UAXj8W49545682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Oct 2026 10:33:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CD9C2004D;
	Fri, 30 Oct 2026 10:33:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A9182004B;
	Fri, 30 Oct 2026 10:33:42 +0000 (GMT)
Received: from li-49acbccc-2994-11b2-a85c-d51b89e344f1.ibm.com.com (unknown [9.43.39.23])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 Oct 2026 10:33:42 +0000 (GMT)
From: Pavithra <pavrampu@linux.ibm.com>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org, alison.schofield@intel.com,
        dave.jiang@intel.com, djbw@kernel.org, joao.m.martins@oracle.com,
        linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
        muchun.song@linux.dev, nvdimm@lists.linux.dev, ritesh.list@gmail.com,
        stable@vger.kernel.org, pavrampu@linux.ibm.com,
        vishal.l.verma@intel.com
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
Date: Fri, 30 Oct 2026 16:03:39 +0530
Message-ID: <20261030103339.414145-1-pavrampu@linux.ibm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016054914.2601510-1-songmuchun@bytedance.com>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: YsSLdPEumXKLleFEXkBsi-1wjpQCQNXu
X-Proofpoint-GUID: eyhc_jbcvH2WBCbuDro4qt9ghJLhkYSS
X-Authority-Analysis: v=2.4 cv=JIyuIMKb c=1 sm=1 tr=0 ts=6ae4728c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Uv9NjG45AAAA:20 a=VnNF1IyMAAAA:8
 a=8zS9G5xvJLahJeJr1kgA:9 a=zgiPjhLxNE0A:10 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA0MCBTYWx0ZWRfX9DPHAg0iuUip
 YbcZXvCuK98/L67BDNHKlH6XV7TETkJ3Nnjrrqdvu1s4uFudOBNmUCWyA9TltdpsxNvh4iE1xiv
 6/d08oj40y69sNO0jDXzSi19HQAumgK2do2kR6Ymfh3I6Pq3VeGDKlQwvZ5Tn6xQN2JfBgxmPKg
 gpOBVTQl7xA3HvFuaPp3FxOwr/YBs3BIjFF2JXHUG+1BLXo5BsjnmjVqXYVMLR8SuwROkUHleSy
 NNC/mavzliBBOGO271rt11x/E9fHz809g7r0n089UAAxz4D7D0MyehSpHF00XuFeXmRzgHzXlFt
 sxP6GYFK2JACTY864iTEJy2rts9/8sx+9YcvXJ1WOn2JLpyQs0OHME7XtE43+ey/bJyW8jDPPbo
 MY+z8gyQ94xri8HViFfQ1r0u6FVK+2hQqyYKlWE4A6vodh2rrhGObSXfY37VzVVIjeQlSuvoqxB
 BHseTtgAEGNhyJoPgNw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA0MCBTYWx0ZWRfXyGR3abNVAIKN
 MZ16cExgbEasvN0Zd5nRwWQOiDUCSoBXq0+1u+CBiYfMwE6UGSOljtCY0H+hXWfpworyMg/Y6Zf
 maQcQyif3oUbvXyoncEzppWmvX4lu08=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610300040

Tested on Power10 (ppc64le)

Test configurations validated:
  Page sizes : 4K, 64K, 2MB hugepage, 1GB hugepage

Test suites run:
  - libhugetlbfs test suite
  - LTP hugetlb tests
  - mm selftests (tools/testing/selftests/mm)
  - ndctl test suite via avocado (--map=mem and --map=dev,
    2MB and 1GB alignment)
    https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py
  - HTX mdt.pmem_all
  - Memory savings validation with 1GB alignment
  - Hash mode basic pmem tests

No issues observed. Thanks for the patches.

Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>
