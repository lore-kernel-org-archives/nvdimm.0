Return-Path: <SRS0=iqJD=EP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE603C4742C
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 01:35:40 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2CBC206E3
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 01:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmTs2TRa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2CBC206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4541E165D4364;
	Sun,  8 Nov 2020 17:35:39 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=141.146.126.78; helo=aserp2120.oracle.com; envelope-from=darrick.wong@oracle.com; receiver=<UNKNOWN> 
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 27791165C1E06
	for <linux-nvdimm@lists.01.org>; Sun,  8 Nov 2020 17:35:36 -0800 (PST)
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A91Yj3e014180;
	Mon, 9 Nov 2020 01:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=muJfxRFhn2lydOWKxWHNNKL/op+SFa08lc1Nde0V9Pk=;
 b=jmTs2TRadqJuVgAQOTTn2t6E7eGKV74EpyaiWNADA917QtOAEMxHCopFeyNK2qT2E0P+
 75bMr/kCwv/pRwUxqWQBrd1CYct2JJMGgwle+Lq2ARxQZAxZF21N34Dz52zFu/p5+w/0
 d3rhPeKRueXLwxmi8m80M4Nv7f6yayceaM32J5RR7jddNAH3bl9aN/vDaZau9JP6aBV3
 4tZ7k6cmN7BmMf7QCwySfrZH2pLEzmi7yDtULddVV5xqqZGKL5T/dqMaedveREQlkRTw
 PUb6SH5FQYY+Yg/YTX5OPzd4UCKbpMYCm74+uav6NBzw1RXgPUWCZvr9HFjoaEh6QkqZ pw==
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 34nkhkkdgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 09 Nov 2020 01:35:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A91Uwsk185503;
	Mon, 9 Nov 2020 01:33:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userp3020.oracle.com with ESMTP id 34p5bpv7nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Nov 2020 01:33:26 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A91XN2q001176;
	Mon, 9 Nov 2020 01:33:24 GMT
Received: from localhost (/10.159.144.121)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Sun, 08 Nov 2020 17:33:23 -0800
Date: Sun, 8 Nov 2020 17:33:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Amy Parker <enbyamy@gmail.com>
Subject: Re: Best solution for shifting DAX_ZERO_PAGE to XA_ZERO_ENTRY
Message-ID: <20201109013322.GA9685@magnolia>
References: <CAE1WUT6O6uP12YMU1NaU-4CR-AaxRUhhWHY=zUtNXpHUfxrF=A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAE1WUT6O6uP12YMU1NaU-4CR-AaxRUhhWHY=zUtNXpHUfxrF=A@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9799 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9799 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090007
Message-ID-Hash: D6Q6NAA4RXZYEBTQOV6CLCSAPQU2OSHW
X-Message-ID-Hash: D6Q6NAA4RXZYEBTQOV6CLCSAPQU2OSHW
X-MailFrom: darrick.wong@oracle.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/D6Q6NAA4RXZYEBTQOV6CLCSAPQU2OSHW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Nov 08, 2020 at 05:15:55PM -0800, Amy Parker wrote:
> I've been writing a patch to migrate the defined DAX_ZERO_PAGE
> to XA_ZERO_ENTRY for representing holes in files.

Why?  IIRC XA_ZERO_ENTRY ("no mapping in the address space") isn't the
same as DAX_ZERO_PAGE ("the zero page is mapped into the address space
because we took a read fault on a sparse file hole").

--D

> XA_ZERO_ENTRY
> is defined in include/linux/xarray.h, where it's defined using
> xa_mk_internal(257). This function returns a void pointer, which
> is incompatible with the bitwise arithmetic it is performed on with.
> 
> Currently, DAX_ZERO_PAGE is defined as an unsigned long,
> so I considered typecasting it. Typecasting every time would be
> repetitive and inefficient. I thought about making a new definition
> for it which has the typecast, but this breaks the original point of
> using already defined terms.
> 
> Should we go the route of adding a new definition, we might as
> well just change the definition of DAX_ZERO_PAGE. This would
> break the simplicity of the current DAX bit definitions:
> 
> #define DAX_LOCKED      (1UL << 0)
> #define DAX_PMD               (1UL << 1)
> #define DAX_ZERO_PAGE  (1UL << 2)
> #define DAX_EMPTY      (1UL << 3)
> 
> Any thoughts on this, and what could be the best solution here?
> 
> Best regards,
> Amy Parker
> (they/them)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
