Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04470C4CEC8
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 15:34:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C62E6208E4
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 15:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C62E6208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D92B1202E6DE4;
	Thu, 12 Sep 2019 08:34:33 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=216.40.44.180;
 helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from smtprelay.hostedemail.com (smtprelay0180.hostedemail.com
 [216.40.44.180])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 491BC202E2918
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 08:34:32 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
 [216.40.38.60])
 by smtprelay06.hostedemail.com (Postfix) with ESMTP id E876C18224D65;
 Thu, 12 Sep 2019 15:34:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: room66_4419114b8213b
X-Filterd-Recvd-Size: 2754
Received: from XPS-9350.home (unknown [47.151.152.152])
 (Authenticated sender: joe@perches.com)
 by omf09.hostedemail.com (Postfix) with ESMTPA;
 Thu, 12 Sep 2019 15:34:27 +0000 (UTC)
Message-ID: <44c08faf43fa77fb271f8dbb579079fb09007716.camel@perches.com>
Subject: Re: [Ksummit-discuss] [PATCH v2 0/3] Maintainer Entry Profiles
From: Joe Perches <joe@perches.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Sep 2019 08:34:26 -0700
In-Reply-To: <6fe45562-9493-25cf-afdb-6c0e702a49b4@acm.org>
References: <156821692280.2951081.18036584954940423225.stgit@dwillia2-desk3.amr.corp.intel.com>
 <yq1o8zqeqhb.fsf@oracle.com> <6fe45562-9493-25cf-afdb-6c0e702a49b4@acm.org>
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
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 Steve French <stfrench@microsoft.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 "Tobin C. Harding" <me@tobin.cc>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Thu, 2019-09-12 at 14:31 +0100, Bart Van Assche wrote:
> On 9/11/19 5:40 PM, Martin K. Petersen wrote:
> > * Do not use custom To: and Cc: for individual patches. We want to see the
> >   whole series, even patches that potentially need to go through a different
> >   subsystem tree.

That's not currently feasible when cc'ing any vger.kernel.org list
as those lists have a maximum email header size and patches that
span multiple subsystems can have very long to: and cc: lists.

> > * The patch must compile without warnings (make C=1 CF="-D__CHECK_ENDIAN__")
> >   and does not incur any zeroday test robot complaints.
> 
> How about adding W=1 to that make command?

That's rather too compiler version dependent and new
warnings frequently get introduced by new compiler versions.

> How about existing drivers that trigger tons of endianness warnings,
> e.g. qla2xxx? How about requiring that no new warnings are introduced?

Adding a sparse clean C=2 requirement might be useful.

> > * The patch must have a commit message that describes, comprehensively and in
> >   plain English, what the patch does.
> 
> How about making this requirement more detailed and requiring that not
> only what has been changed is document but also why that change has been
> made?

I believe the "why" is rather more important than the "how"
and should be the primary thing described in the commit message.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
