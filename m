Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C77C5ACAE
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 08:15:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F1182171F
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 08:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F1182171F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 354C0202E290E;
	Thu, 12 Sep 2019 01:15:47 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=216.40.44.79;
 helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from smtprelay.hostedemail.com (smtprelay0079.hostedemail.com
 [216.40.44.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 561C8202C80B7
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 01:15:46 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
 [216.40.38.60])
 by smtprelay05.hostedemail.com (Postfix) with ESMTP id ABE5E1801585D;
 Thu, 12 Sep 2019 08:15:40 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: help45_1436e6ec66121
X-Filterd-Recvd-Size: 2134
Received: from XPS-9350.home (unknown [47.151.152.152])
 (Authenticated sender: joe@perches.com)
 by omf13.hostedemail.com (Postfix) with ESMTPA;
 Thu, 12 Sep 2019 08:15:38 +0000 (UTC)
Message-ID: <be3c626c2e9d14fe2fa9d0403bc02832231cc437.camel@perches.com>
Subject: Re: [PATCH 00/13] nvdimm: Use more common kernel coding style
From: Joe Perches <joe@perches.com>
To: Dan Williams <dan.j.williams@intel.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 12 Sep 2019 01:15:37 -0700
In-Reply-To: <CAPcyv4hzoSp-bFx19Yj71H7x3D66-TE4uCpcHm4S9sJsGtXugA@mail.gmail.com>
References: <cover.1568256705.git.joe@perches.com>
 <CAPcyv4hzoSp-bFx19Yj71H7x3D66-TE4uCpcHm4S9sJsGtXugA@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Thu, 2019-09-12 at 01:00 -0700, Dan Williams wrote:
> Hi Joe,
> 
> On Wed, Sep 11, 2019 at 7:55 PM Joe Perches <joe@perches.com> wrote:
> > Rather than have a local coding style, use the typical kernel style.
> 
> I'd rather automate this. I'm going to do once-over with clang-format
> and see what falls out.

I am adding Miguel Ojeda to the cc's.

Of course you are welcome to try it, but I believe that
clang-format doesn't work all that well yet.

It's more a work in progress rather than a "standard".

I believe you'll find that the patch series I sent
ends up with a rather more typical kernel style.

I suggest you try to apply the series I sent and then
run clang-format on that and see the differences.

Ideally one day, something tool like clang-format
might be locally applied by every developer for their
own personal style with some other neutral style the
content actually distributed.

cheers, Joe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
