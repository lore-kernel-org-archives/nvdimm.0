Return-Path: <SRS0=uw/X=ER=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA20C56201
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Nov 2020 08:28:51 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD198206F1
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Nov 2020 08:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD198206F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4FBCC1686EB48;
	Wed, 11 Nov 2020 00:28:50 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5EA4C1685A08E
	for <linux-nvdimm@lists.01.org>; Wed, 11 Nov 2020 00:28:47 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 26B746736F; Wed, 11 Nov 2020 09:28:43 +0100 (CET)
Date: Wed, 11 Nov 2020 09:28:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 2/2] mm: simplify follow_pte{,pmd}
Message-ID: <20201111082842.GA23677@lst.de>
References: <20201029101432.47011-3-hch@lst.de> <20201111022122.1039505-1-ndesaulniers@google.com> <20201111081800.GA23492@lst.de> <673267d5-93f5-7278-7a9d-a7b35ede6d48@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <673267d5-93f5-7278-7a9d-a7b35ede6d48@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: DKCF2DIOLHWM5I7FRHVJ637MC26TGXMT
X-Message-ID-Hash: DKCF2DIOLHWM5I7FRHVJ637MC26TGXMT
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Christoph Hellwig <hch@lst.de>, Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, daniel@ffwll.ch, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, clang-built-linux@googlegroups.com, Linux-Next Mailing List <linux-next@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DKCF2DIOLHWM5I7FRHVJ637MC26TGXMT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 11, 2020 at 09:26:20AM +0100, Christian Borntraeger wrote:
> 
> On 11.11.20 09:18, Christoph Hellwig wrote:
> > On Tue, Nov 10, 2020 at 06:21:22PM -0800, Nick Desaulniers wrote:
> >> Sorry, I think this patch may be causing a regression for us for s390?
> >> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/432129279#L768
> >>
> >> (via https://lore.kernel.org/linux-mm/20201029101432.47011-3-hch@lst.de)
> > 
> > Hmm, the call to follow_pte_pmd in the s390 code does not actually exist
> > in my tree.
> 
> This is a mid-air collision in linux-next between
> 
> b2ff5796a934 ("mm: simplify follow_pte{,pmd}")
> a67a88b0b8de ("s390/pci: remove races against pte updates")

Ah.  The fixup is trivial: just s/follow_pte_pmd/follow_pte/.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
