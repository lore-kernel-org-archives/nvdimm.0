Return-Path: <SRS0=tGdH=HU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5B8C433DB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 18 Feb 2021 08:32:38 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B4D6B64E6F
	for <linux-nvdimm@archiver.kernel.org>; Thu, 18 Feb 2021 08:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4D6B64E6F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 27AC9100EBBBE;
	Thu, 18 Feb 2021 00:32:37 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B227D100EC1DA
	for <linux-nvdimm@lists.01.org>; Thu, 18 Feb 2021 00:32:34 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id B425D6736F; Thu, 18 Feb 2021 09:32:30 +0100 (CET)
Date: Thu, 18 Feb 2021 09:32:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v3 05/11] mm, fsdax: Refactor memory-failure handler
 for dax mapping
Message-ID: <20210218083230.GA17913@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com> <20210208105530.3072869-6-ruansy.fnst@cn.fujitsu.com> <20210210133347.GD30109@lst.de> <45a20d88-63ee-d678-ad86-6ccd8cdf7453@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <45a20d88-63ee-d678-ad86-6ccd8cdf7453@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: JR4LALG5I6MS6AZEGIXVOCQMZSEWDYA4
X-Message-ID-Hash: JR4LALG5I6MS6AZEGIXVOCQMZSEWDYA4
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, darrick.wong@oracle.com, david@fromorbit.com, agk@redhat.com, snitzer@redhat.com, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/JR4LALG5I6MS6AZEGIXVOCQMZSEWDYA4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 17, 2021 at 10:56:11AM +0800, Ruan Shiyang wrote:
> I'd like to confirm one thing...  I have checked all of this patchset by 
> checkpatch.pl and it did not report the overly long line warning.  So, I 
> should still obey the rule of 80 chars one line?

checkpatch.pl is completely broken, I would not rely on it.

Here is the quote from the coding style document:

"The preferred limit on the length of a single line is 80 columns.

Statements longer than 80 columns should be broken into sensible chunks,
unless exceeding 80 columns significantly increases readability and does
not hide information."
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
