Return-Path: <SRS0=Oj3b=JE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BB5C433B4
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Apr 2021 10:22:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D2B706139C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Apr 2021 10:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2B706139C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 43C63100EB823;
	Wed,  7 Apr 2021 03:22:02 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=148.163.158.5; helo=mx0a-001b2d01.pphosted.com; envelope-from=riteshh@linux.ibm.com; receiver=<UNKNOWN> 
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4F1B7100EBBDD
	for <linux-nvdimm@lists.01.org>; Wed,  7 Apr 2021 03:21:59 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137A3Okf194112;
	Wed, 7 Apr 2021 06:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=Pux/rCemv1tksd2MoaaFh8MmP6s+ALrFCia/3cagrfw=;
 b=NjFekmszqeQQRsSTLvvmmaV+/v3RsQtjZgNeyMiE8ahLD8D2K02oxoLE15YQJk4Xfp0t
 Lw2y49gOHtlYDFriqDHTEMiuiED27Y2T2zhHiRgean7eEHIurle6I5b8M0UsepGihF5c
 pm/GZ9nRoCbhnLrSn/QLKM6/Ea092it7aAdkw6dtdEB1yVgWt/h97t/ZLPOhwHkr4xX1
 Stcxae0dBGzAdWGh86en6+Uz0+LEYtN7sFGJrn99g5k+7KdiW0AAeo9auWBL3VQ5UB7a
 5XVUBsfTbR5Psa6SPSn51btlbnWGQOHXwYCBxlvegagm+IuEL7EwboH3mjRTQjqb0UM3 wg==
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0b-001b2d01.pphosted.com with ESMTP id 37rvm4cuc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Apr 2021 06:21:53 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137AJ7jX014759;
	Wed, 7 Apr 2021 10:21:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma04fra.de.ibm.com with ESMTP id 37rvc5garq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Apr 2021 10:21:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137ALnv246072090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Apr 2021 10:21:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 025CA52051;
	Wed,  7 Apr 2021 10:21:49 +0000 (GMT)
Received: from localhost (unknown [9.85.69.78])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AA53F5205F;
	Wed,  7 Apr 2021 10:21:48 +0000 (GMT)
Date: Wed, 7 Apr 2021 15:51:48 +0530
From: riteshh <riteshh@linux.ibm.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: Re: [PATCH 2/3] fsdax: Factor helper: dax_fault_actor()
Message-ID: <20210407102148.p2osxqohsthlrmxq@riteshh-domain>
References: <20210407063207.676753-1-ruansy.fnst@fujitsu.com>
 <20210407063207.676753-3-ruansy.fnst@fujitsu.com>
Content-Disposition: inline
In-Reply-To: <20210407063207.676753-3-ruansy.fnst@fujitsu.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 18TctFb1Simu9WH1e4RyqGDqfMUL6TDg
X-Proofpoint-ORIG-GUID: 18TctFb1Simu9WH1e4RyqGDqfMUL6TDg
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-06,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070070
Message-ID-Hash: HUFJX66LTETEPRSK7KQ6IZ7X3RCZDD7P
X-Message-ID-Hash: HUFJX66LTETEPRSK7KQ6IZ7X3RCZDD7P
X-MailFrom: riteshh@linux.ibm.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com, willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org, david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HUFJX66LTETEPRSK7KQ6IZ7X3RCZDD7P/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 21/04/07 02:32PM, Shiyang Ruan wrote:
> The core logic in the two dax page fault functions is similar. So, move
> the logic into a common helper function. Also, to facilitate the
> addition of new features, such as CoW, switch-case is no longer used to
> handle different iomap types.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 294 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 148 insertions(+), 146 deletions(-)

Thanks for addressing comments.
A msg in cover letter acknowledging that the review comments mentioned here[1]
were addressed is helpful for everyone.

Please feel free to add.
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>

[1]: https://patchwork.kernel.org/project/linux-nvdimm/patch/20210319015237.993880-3-ruansy.fnst@fujitsu.com/

-ritesh
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
