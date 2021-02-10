Return-Path: <SRS0=q8t/=HM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9C8C433E9
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Feb 2021 13:21:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BD0C764D92
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Feb 2021 13:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD0C764D92
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 77A7C100EAAE7;
	Wed, 10 Feb 2021 05:21:44 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E5F7F100EAB7D
	for <linux-nvdimm@lists.01.org>; Wed, 10 Feb 2021 05:21:41 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C95C68B02; Wed, 10 Feb 2021 14:21:39 +0100 (CET)
Date: Wed, 10 Feb 2021 14:21:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v3 02/11] blk: Introduce ->corrupted_range() for block
 device
Message-ID: <20210210132139.GC30109@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com> <20210208105530.3072869-3-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210208105530.3072869-3-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: RJ7XQOLP76SKYVCUHOG4H34SSDGQ6SE6
X-Message-ID-Hash: RJ7XQOLP76SKYVCUHOG4H34SSDGQ6SE6
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, agk@redhat.com, snitzer@redhat.com, rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RJ7XQOLP76SKYVCUHOG4H34SSDGQ6SE6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 08, 2021 at 06:55:21PM +0800, Shiyang Ruan wrote:
> In fsdax mode, the memory failure happens on block device.  So, it is
> needed to introduce an interface for block devices.  Each kind of block
> device can handle the memory failure in ther own ways.

As told before: DAX operations please do not add anything to the block
device.  We've been working very hard to decouple DAX from the block
device, and while we're not done regressing the split should not happen.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
