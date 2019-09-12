Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E62C4CEC7
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 15:01:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4272820830
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 15:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4272820830
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A0B92202E2938;
	Thu, 12 Sep 2019 08:01:53 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=216.40.44.19;
 helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from smtprelay.hostedemail.com (smtprelay0019.hostedemail.com
 [216.40.44.19])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F26A02194EB77
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 08:01:51 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
 [216.40.38.60])
 by smtprelay06.hostedemail.com (Postfix) with ESMTP id B13BC18224D69;
 Thu, 12 Sep 2019 15:01:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: pump00_49bc2d71dfd50
X-Filterd-Recvd-Size: 1798
Received: from XPS-9350.home (unknown [47.151.152.152])
 (Authenticated sender: joe@perches.com)
 by omf13.hostedemail.com (Postfix) with ESMTPA;
 Thu, 12 Sep 2019 15:01:46 +0000 (UTC)
Message-ID: <33c0f43ef2334de5885e5fcf041483a2afb13787.camel@perches.com>
Subject: Re: [PATCH 01/13] nvdimm: Use more typical whitespace
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@infradead.org>
Date: Thu, 12 Sep 2019 08:01:45 -0700
In-Reply-To: <20190912121707.GA16029@infradead.org>
References: <cover.1568256705.git.joe@perches.com>
 <7a5598bda6a3d18d75c3e76ab89d9d95e8952500.1568256705.git.joe@perches.com>
 <20190912121707.GA16029@infradead.org>
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Thu, 2019-09-12 at 05:17 -0700, Christoph Hellwig wrote:
> Instead of arguing what is better just stick to what the surrounding
> code does.

That's not always feasible nor readable.

Especially for the logic inversion blocks where
the existing code does unreadable and error prone
things like hiding semicolons immediately after
comments.

	if (foo)
		/* longish comment */;
	else {
		<code>;
	}

> Or in other words:  Feel free to be a codingstyle nazi for your code
> (I am for some of mine), but leave others peoples code alone with
> "cleanup" patches.

My point was to avoid documenting per-subsystem
coding style rules.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
