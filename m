Return-Path: <SRS0=BlKz=CD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EC7C433E3
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 20:52:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE33B2075E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 20:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jroyZo4/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE33B2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 82719119F4823;
	Tue, 25 Aug 2020 13:52:45 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=156.151.31.86; helo=userp2130.oracle.com; envelope-from=darrick.wong@oracle.com; receiver=<UNKNOWN> 
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D551B114493CF
	for <linux-nvdimm@lists.01.org>; Tue, 25 Aug 2020 13:52:39 -0700 (PDT)
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PKipJV156187;
	Tue, 25 Aug 2020 20:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=auC1QONwDp3dgkmIBt9CYKiGBVa5ZJTSWe0A2XEhlOg=;
 b=jroyZo4/g0Ix8rW8adNAhTYqRd7Lxv3X8YrSWiyjBdtsB5IlyHpukUBF1A8S/ef70uk5
 m1qQOLHOqR3GOk5N1fN5gK6PQOMpPtK3sMUbhGVEVOYeTatjz5Z5esXD3ul5sX30TI+M
 vLaD7uV8LRKjIA54bybx6/XYTe3GKUyGWJky4JlNVSCtOlYmikxcceES60hJoiOZlZG2
 EugiHtQFnDDJOeasZ3m+LUzAQcmPBlP3LIh24cRawh2me07iTXsmNHmL23BUDrvkFwco
 mX7g0LlIzy5vjPcLB4ZhAwEiGWSjIZXvuHXVpMbHzTTUCM0Q7QkPWNtNQYCFI33hFung FQ==
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by userp2130.oracle.com with ESMTP id 333csj4xj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2020 20:52:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PKinCo171916;
	Tue, 25 Aug 2020 20:50:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserp3030.oracle.com with ESMTP id 333r9kc0fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Aug 2020 20:50:36 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07PKoadf021420;
	Tue, 25 Aug 2020 20:50:36 GMT
Received: from localhost (/10.159.234.29)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 25 Aug 2020 13:50:36 -0700
Date: Tue, 25 Aug 2020 13:50:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH 4/9] iomap: Use bitmap ops to set uptodate bits
Message-ID: <20200825205034.GI6096@magnolia>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-5-willy@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200824145511.10500-5-willy@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250157
Message-ID-Hash: I35I72LQFHTX2MO7GLTZLLYJ7FSNTGOO
X-Message-ID-Hash: I35I72LQFHTX2MO7GLTZLLYJ7FSNTGOO
X-MailFrom: darrick.wong@oracle.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/I35I72LQFHTX2MO7GLTZLLYJ7FSNTGOO/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 24, 2020 at 03:55:05PM +0100, Matthew Wilcox (Oracle) wrote:
> Now that the bitmap is protected by a spinlock, we can use the
> more efficient bitmap ops instead of individual test/set bit ops.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yay!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap/buffered-io.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 639d54a4177e..dbf9572dabe9 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -134,19 +134,11 @@ iomap_iop_set_range_uptodate(struct page *page, unsigned off, unsigned len)
>  	struct inode *inode = page->mapping->host;
>  	unsigned first = off >> inode->i_blkbits;
>  	unsigned last = (off + len - 1) >> inode->i_blkbits;
> -	bool uptodate = true;
>  	unsigned long flags;
> -	unsigned int i;
>  
>  	spin_lock_irqsave(&iop->uptodate_lock, flags);
> -	for (i = 0; i < i_blocks_per_page(inode, page); i++) {
> -		if (i >= first && i <= last)
> -			set_bit(i, iop->uptodate);
> -		else if (!test_bit(i, iop->uptodate))
> -			uptodate = false;
> -	}
> -
> -	if (uptodate)
> +	bitmap_set(iop->uptodate, first, last - first + 1);
> +	if (bitmap_full(iop->uptodate, i_blocks_per_page(inode, page)))
>  		SetPageUptodate(page);
>  	spin_unlock_irqrestore(&iop->uptodate_lock, flags);
>  }
> -- 
> 2.28.0
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
