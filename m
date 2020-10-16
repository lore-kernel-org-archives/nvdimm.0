Return-Path: <SRS0=jOyn=DX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E770C433DF
	for <linux-nvdimm@archiver.kernel.org>; Fri, 16 Oct 2020 06:59:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE157207C4
	for <linux-nvdimm@archiver.kernel.org>; Fri, 16 Oct 2020 06:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VUmAniLL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE157207C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 08CFE1605FAE4;
	Thu, 15 Oct 2020 23:59:09 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=batv+3f298eef0c732a4c5343+6263+infradead.org+hch@casper.srs.infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DC8F51605FAE2
	for <linux-nvdimm@lists.01.org>; Thu, 15 Oct 2020 23:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hIWsgXRwwrdjTKWdcTDNxo1KkS1hr9+bm71pdZvcsgM=; b=VUmAniLLQhHQnbgFkmGnuIOW+E
	sm9Ply16VmMLDqM30lkMQl4EuwGjoati5bjov/lmVdITZYbbgE5TUfojIcEP7hFfAcEH4jrGYn+Wr
	3gShscQ8Wpyxb4U9kidvJ8q/YnN0Qz0sYhMBIzbhWH5+CmbPVML2yHOCeT0aE+UN0fOvskT4JaSv5
	AiBRp8BJi+wmBusF8CfOOgh4w1mrHhIH5xs5s3Ts7MU1w2K03c7FHEiScHZOWup+8xOlrTVSNKcGI
	f4sOV6AlP0ycXjSMZfYbGpIAZSFhM00DoRSfJVeuZfZ/aAUQugN+xbvj/5463rhYdYE/EHouZUR/D
	7ZDoXuLQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kTJhd-0002om-Js; Fri, 16 Oct 2020 06:59:01 +0000
Date: Fri, 16 Oct 2020 07:59:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH] Clarify COPYING
Message-ID: <20201016065901.GA10448@infradead.org>
References: <160281074218.3146890.3209259735282870612.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <160281074218.3146890.3209259735282870612.stgit@dwillia2-desk3.amr.corp.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: KTKDM5HRTLRWEHFPRORLCAQG43R2KDXA
X-Message-ID-Hash: KTKDM5HRTLRWEHFPRORLCAQG43R2KDXA
X-MailFrom: BATV+3f298eef0c732a4c5343+6263+infradead.org+hch@casper.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KTKDM5HRTLRWEHFPRORLCAQG43R2KDXA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 15, 2020 at 06:12:22PM -0700, Dan Williams wrote:
> The tools and the libraries this project produces are licensed under the
> GPLv2 and LGPLv2.1 licenses respectively. Add a COPYING file that
> highlights this arrangement and fixup files in */lib that mistakenly had
> a GPLv2 header applied.

Maybe it is time to move to formal SPDX annotations and the LICENSES/
infrastructure from the kernel?
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
