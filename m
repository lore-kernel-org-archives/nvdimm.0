Return-Path: <SRS0=Fweo=FX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDA3C4361B
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Dec 2020 20:02:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2737623136
	for <linux-nvdimm@archiver.kernel.org>; Sat, 19 Dec 2020 20:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2737623136
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B10F5100ED4BC;
	Sat, 19 Dec 2020 12:02:17 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=85.233.191.1; helo=mail-out-auth3.hosts.co.uk; envelope-from=antlists@youngman.org.uk; receiver=<UNKNOWN> 
Received: from mail-out-auth3.hosts.co.uk (mail-out-auth3.hosts.co.uk [85.233.191.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A0259100ED4AC
	for <linux-nvdimm@lists.01.org>; Sat, 19 Dec 2020 12:02:13 -0800 (PST)
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1kqiQd-000BHA-9x; Sat, 19 Dec 2020 20:02:11 +0000
Subject: Re: [RFC PATCH] badblocks: Improvement badblocks_set() for handling
 multiple ranges
To: Coly Li <colyli@suse.de>, axboe@kernel.dk, dan.j.williams@intel.com,
 vishal.l.verma@intel.com
References: <20201203171535.67715-1-colyli@suse.de>
From: antlists <antlists@youngman.org.uk>
Message-ID: <3f4bf4c4-1f1f-b1a6-5d91-2dbe02f61e67@youngman.org.uk>
Date: Sat, 19 Dec 2020 20:02:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203171535.67715-1-colyli@suse.de>
Content-Language: en-GB
Message-ID-Hash: N6Y42KONPOZXT4ZLKMSJAHKUS63XJTAB
X-Message-ID-Hash: N6Y42KONPOZXT4ZLKMSJAHKUS63XJTAB
X-MailFrom: antlists@youngman.org.uk
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/N6Y42KONPOZXT4ZLKMSJAHKUS63XJTAB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

On 03/12/2020 17:15, Coly Li wrote:
> This patch is an initial effort to improve badblocks_set() for setting
> bad blocks range when it covers multiple already set bad ranges in the
> bad blocks table, and to do it as fast as possible.

Is this your patch, or submitted as part of the bug report?

"Heavily based on MD badblocks code from Neil Brown"

How much has this code got to do with the mdraid subsystem? Because 
badblocks in mdraid has an appalling reputation, with many people 
wanting to just rip it out.

If this code is separate from the mdraid implementation, any chance you 
can work with it, and fix that at the same time? Or make it redundant! I 
don't quite see why mdraid should need a badblocks list given modern 
disk drives.

And it's on my to-do list (if I can find the time!!!) to integrate 
dm-integrity into mdraid, at which point md badblocks should be irrelevant.

Hope I'm not being a shower of cold water, and if you want to fix all 
this, good on you, but to the extent that this is relevant to 
linux-raid, I think a lot of people will be asking "What's the point?"

Cheers,
Wol
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
