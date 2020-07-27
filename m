Return-Path: <SRS0=7ETp=BG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0775C433E5
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 21:44:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 578E820729
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 21:44:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 578E820729
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 08164123D91FB;
	Mon, 27 Jul 2020 14:44:52 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=jack@suse.cz; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BA3B0123D91D7
	for <linux-nvdimm@lists.01.org>; Mon, 27 Jul 2020 14:44:49 -0700 (PDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id F2018AC97;
	Mon, 27 Jul 2020 21:44:57 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 471021E12C7; Mon, 27 Jul 2020 23:44:47 +0200 (CEST)
Date: Mon, 27 Jul 2020 23:44:47 +0200
From: Jan Kara <jack@suse.cz>
To: Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v3] dax: print error message by pr_info() in
 __generic_fsdax_supported()
Message-ID: <20200727214447.GN5284@quack2.suse.cz>
References: <20200725162450.95999-1-colyli@suse.de>
 <7366fc46-48ee-8c9a-c8f2-8e4e03919880@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7366fc46-48ee-8c9a-c8f2-8e4e03919880@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: N5K4AXVXNTV4D34NJNYMNRHXK7I2C7NN
X-Message-ID-Hash: N5K4AXVXNTV4D34NJNYMNRHXK7I2C7NN
X-MailFrom: jack@suse.cz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Coly Li <colyli@suse.de>, linux-nvdimm@lists.01.org, msuchanek@suse.com, ailiopoulos@suse.com, Jan Kara <jack@suse.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/N5K4AXVXNTV4D34NJNYMNRHXK7I2C7NN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon 27-07-20 10:02:11, Jane Chu wrote:
> Hi,
> 
> On 7/25/2020 9:24 AM, Coly Li wrote:
> > It is not simple to make dax_supported() from struct dax_operations
> > or __generic_fsdax_supported() to return exact failure type right now.
> > So the simplest fix is to use pr_info() to print all the error messages
> > inside __generic_fsdax_supported(). Then users may find informative clue
> > from the kernel message at least.
> 
> I happen to notice that some servers set their printk levels at 4 by default
> to minimize console messages:
> # cat /proc/sys/kernel/printk
>  4   4   1  7
> So I'm wondering if you would consider pr_error() instead of pr_info() ?

I don't think this is a good reason to raise priority of this message -
with this logic applied, all info messages should be raised to error level
because someone may find them useful :). And then people raise printk
loglevel because the kernel is too noisy... Personally I think that
pr_info() is fine because there will be error message about unsupported dax
setup from the filesystem and if sysadmin wishes, (s)he can always lookup
info messages in dmesg.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
