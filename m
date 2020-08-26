Return-Path: <SRS0=TU+8=CE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAB9C433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 26 Aug 2020 03:32:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 249C420715
	for <linux-nvdimm@archiver.kernel.org>; Wed, 26 Aug 2020 03:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vSHPff2Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 249C420715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 08B4112017DB2;
	Tue, 25 Aug 2020 20:32:19 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=156.151.31.85; helo=userp2120.oracle.com; envelope-from=darrick.wong@oracle.com; receiver=<UNKNOWN> 
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3AF3E12017DAF
	for <linux-nvdimm@lists.01.org>; Tue, 25 Aug 2020 20:32:16 -0700 (PDT)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07Q3PJVC052820;
	Wed, 26 Aug 2020 03:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=okvAgslA9s05bet9RqzgtLjPhzBIyWiPkt2b3bP/bYE=;
 b=vSHPff2Yifsj0zi3bmrYfVGUepFiWCce0CYR5xvlgbAumROeM1EOejvnHiuIsCiCWJRQ
 8HgTlK5Z7iQNg3QDFgDDnGjOIxtOaZUpXE7Wwi0yakmhiBp466lVn8kcnnk/S3VhD/rF
 KhTCBvobMwE7DShABebEgbXrPj12M95ewXYzRGjWaWlCOgvFDO6bMYS149krW3h0/qto
 FJCuRzblMk9DvaSnn3Fx//0EUH4ngQdkwLPrQKJ1KGX/dKYydn1OkazzCdn6JbVLtLr/
 HA3GtnnBXroAuVjzqL1t47SyF8aqchwJNB8gkXf3FrnKOXRH06OgtrHaEU/rU8yx6/yx Iw==
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 333w6tvhmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 26 Aug 2020 03:32:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07Q3VLwM011072;
	Wed, 26 Aug 2020 03:32:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userp3030.oracle.com with ESMTP id 333r9kbj1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2020 03:32:10 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07Q3W9af008012;
	Wed, 26 Aug 2020 03:32:09 GMT
Received: from localhost (/10.159.139.182)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 25 Aug 2020 20:32:09 -0700
Date: Tue, 25 Aug 2020 20:32:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 5/9] iomap: Support arbitrarily many blocks per page
Message-ID: <20200826033208.GS6107@magnolia>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-6-willy@infradead.org>
 <20200825210203.GJ6096@magnolia>
 <20200826022623.GQ17456@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200826022623.GQ17456@casper.infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260024
Message-ID-Hash: Z7LE2K3LUHPNKKAN5B7BHTQCONZ37MXL
X-Message-ID-Hash: Z7LE2K3LUHPNKKAN5B7BHTQCONZ37MXL
X-MailFrom: darrick.wong@oracle.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/Z7LE2K3LUHPNKKAN5B7BHTQCONZ37MXL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 26, 2020 at 03:26:23AM +0100, Matthew Wilcox wrote:
> On Tue, Aug 25, 2020 at 02:02:03PM -0700, Darrick J. Wong wrote:
> > >  /*
> > > - * Structure allocated for each page when block size < PAGE_SIZE to track
> > > + * Structure allocated for each page when block size < page size to track
> > >   * sub-page uptodate status and I/O completions.
> > 
> > "for each regular page or head page of a huge page"?  Or whatever we're
> > calling them nowadays?
> 
> Well, that's what I'm calling a "page" ;-)
> 
> How about "for each page or THP"?  The fact that it's stored in the
> head page is incidental -- it's allocated for the THP.

Ok.

--D
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
