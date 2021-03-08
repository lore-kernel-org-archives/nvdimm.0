Return-Path: <SRS0=v1JN=IG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D1BC433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon,  8 Mar 2021 07:09:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 97F31650BB
	for <linux-nvdimm@archiver.kernel.org>; Mon,  8 Mar 2021 07:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97F31650BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2A962100EBBC3;
	Sun,  7 Mar 2021 23:09:23 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B6A44100EC1CC;
	Sun,  7 Mar 2021 23:09:19 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9B6A68B02; Mon,  8 Mar 2021 08:09:15 +0100 (CET)
Date: Mon, 8 Mar 2021 08:09:15 +0100
From: "hch@lst.de" <hch@lst.de>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [block]  52f019d43c: ndctl.test-libndctl.fail
Message-ID: <20210308070915.GA32695@lst.de>
References: <20210305055900.GC31481@xsang-OptiPlex-9020> <20210305074204.GA17414@lst.de> <6f40b1f53c029788e20fe175618d8772e36d648c.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6f40b1f53c029788e20fe175618d8772e36d648c.camel@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: KSUWHPRP5EARRB35MRMFJB6KTV3QKLST
X-Message-ID-Hash: KSUWHPRP5EARRB35MRMFJB6KTV3QKLST
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "hch@lst.de" <hch@lst.de>, lkp <lkp@intel.com>, "hare@suse.de" <hare@suse.de>, "olkuroch@cisco.com" <olkuroch@cisco.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "lkp@lists.01.org" <lkp@lists.01.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "Sang, Oliver" <oliver.sang@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KSUWHPRP5EARRB35MRMFJB6KTV3QKLST/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Mar 06, 2021 at 08:33:04PM +0000, Williams, Dan J wrote:
> Yes, it looks like my unit test checks for exactly the behavior you
> changed. It was convenient to test that the device could be switched
> back to rw via BLKROSET, but I don't require that. The new behaviour of
> letting the disk->ro take precedence makes more sense to me, so I'll
> update the test for the new behaviour.
> 
> I.e. I don't think regressing a unit test counts as a userspace
> regression.

Ok, thanks for the confirmation.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
