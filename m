Return-Path: <SRS0=5Nm1=ZE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D079AC43331
	for <linux-nvdimm@archiver.kernel.org>; Tue, 12 Nov 2019 09:49:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B116520656
	for <linux-nvdimm@archiver.kernel.org>; Tue, 12 Nov 2019 09:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B116520656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4ADFF100DC408;
	Tue, 12 Nov 2019 01:51:47 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx1.suse.de; envelope-from=jack@suse.cz; receiver=<UNKNOWN> 
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5BACA100EA61A
	for <linux-nvdimm@lists.01.org>; Tue, 12 Nov 2019 01:51:44 -0800 (PST)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx1.suse.de (Postfix) with ESMTP id 97B26B039;
	Tue, 12 Nov 2019 09:49:54 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 3F48C1E47E5; Tue, 12 Nov 2019 10:49:54 +0100 (CET)
Date: Tue, 12 Nov 2019 10:49:54 +0100
From: Jan Kara <jack@suse.cz>
To: Bharat Kumar Gogada <bharatku@xilinx.com>
Subject: Re: DAX filesystem support on ARMv8
Message-ID: <20191112094954.GC1241@quack2.suse.cz>
References: <MN2PR02MB63362F7B019844D94D243CE2A5770@MN2PR02MB6336.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <MN2PR02MB63362F7B019844D94D243CE2A5770@MN2PR02MB6336.namprd02.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: UTOPOCCHB6LOPES3J6KHEJCLHCNI3FNY
X-Message-ID-Hash: UTOPOCCHB6LOPES3J6KHEJCLHCNI3FNY
X-MailFrom: jack@suse.cz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.cz" <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UTOPOCCHB6LOPES3J6KHEJCLHCNI3FNY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi!

On Tue 12-11-19 02:12:09, Bharat Kumar Gogada wrote:
> As per Documentation/filesystems/dax.txt
> 
> The DAX code does not work correctly on architectures which have virtually
> mapped caches such as ARM, MIPS and SPARC.
> 
> Can anyone please shed light on dax filesystem issue w.r.t ARM architecture ? 

I've CCed Dan, he might have idea what that comment means :)

Out of curiosity, why do you care?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
