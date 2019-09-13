Return-Path: <SRS0=lvEg=XI=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D06C4CEC5
	for <linux-nvdimm@archiver.kernel.org>; Fri, 13 Sep 2019 07:09:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8ABF220830
	for <linux-nvdimm@archiver.kernel.org>; Fri, 13 Sep 2019 07:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ABF220830
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwn.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8131C202E840E;
	Fri, 13 Sep 2019 00:09:41 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=45.79.88.28; helo=ms.lwn.net; envelope-from=corbet@lwn.net;
 receiver=linux-nvdimm@lists.01.org 
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 032F1202C80B4
 for <linux-nvdimm@lists.01.org>; Fri, 13 Sep 2019 00:09:39 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ms.lwn.net (Postfix) with ESMTPSA id D794177D;
 Fri, 13 Sep 2019 07:09:40 +0000 (UTC)
Date: Fri, 13 Sep 2019 01:09:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [Ksummit-discuss] [PATCH v2 3/3] libnvdimm, MAINTAINERS:
 Maintainer Entry Profile
Message-ID: <20190913010937.7fc20d93@lwn.net>
In-Reply-To: <9132e214-9b57-07dc-7ee2-f6bc52e960c5@kernel.dk>
References: <156821692280.2951081.18036584954940423225.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156821693963.2951081.11214256396118531359.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190911184332.GL20699@kadam>
 <9132e214-9b57-07dc-7ee2-f6bc52e960c5@kernel.dk>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
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
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Wed, 11 Sep 2019 16:11:29 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> On 9/11/19 12:43 PM, Dan Carpenter wrote:
> > 
> > I kind of hate all this extra documentation because now everyone thinks
> > they can invent new hoops to jump through.  
> 
> FWIW, I completely agree with Dan (Carpenter) here. I absolutely
> dislike having these kinds of files, and with subsystems imposing weird
> restrictions on style (like the quoted example, yuck).
> 
> Additionally, it would seem saner to standardize rules around when
> code is expected to hit the maintainers hands for kernel releases. Both
> yours and Martins deals with that, there really shouldn't be the need
> to have this specified in detail per sub-system.

This sort of objection came up at the maintainers summit yesterday; the
consensus was that, while we might not like subsystem-specific rules, they
do currently exist and we're just documenting reality.  To paraphrase
Phillip K. Dick, reality is that which, when you refuse to document it,
doesn't go away.

So I'm expecting to take this kind of stuff into Documentation/.  My own
personal hope is that it can maybe serve to shame some of these "local
quirks" out of existence.  The evidence from this brief discussion suggests
that this might indeed happen.

Thanks,

jon
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
