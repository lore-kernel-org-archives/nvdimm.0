Return-Path: <SRS0=qiSW=FE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B48C64E8A
	for <linux-nvdimm@archiver.kernel.org>; Mon, 30 Nov 2020 15:09:28 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5459F20719
	for <linux-nvdimm@archiver.kernel.org>; Mon, 30 Nov 2020 15:09:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5459F20719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B7147100EC1F2;
	Mon, 30 Nov 2020 07:09:27 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=jack@suse.cz; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1C44F100EC1E9
	for <linux-nvdimm@lists.01.org>; Mon, 30 Nov 2020 07:09:24 -0800 (PST)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7FBA5AB63;
	Mon, 30 Nov 2020 15:09:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 1AF5E1E131B; Mon, 30 Nov 2020 16:09:23 +0100 (CET)
Date: Mon, 30 Nov 2020 16:09:23 +0100
From: Jan Kara <jack@suse.cz>
To: Amy Parker <enbyamy@gmail.com>
Subject: Re: [RFC PATCH 1/3] fs: dax.c: move fs hole signifier from
 DAX_ZERO_PAGE to XA_ZERO_ENTRY
Message-ID: <20201130150923.GM11250@quack2.suse.cz>
References: <CAE1WUT7ke9TR_H+et5_BUg93OYcDF0LD2ku+Cto59PhP6nz8qg@mail.gmail.com>
 <20201130133652.GK11250@quack2.suse.cz>
 <CAE1WUT5LbFiKTAmT8V-ERH-=aGUjhOw5ZMjPMmoNWTNTspzN9w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAE1WUT5LbFiKTAmT8V-ERH-=aGUjhOw5ZMjPMmoNWTNTspzN9w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: YLBY2PSIDLDD3RLJI4RLKN74LQPZZQKO
X-Message-ID-Hash: YLBY2PSIDLDD3RLJI4RLKN74LQPZZQKO
X-MailFrom: jack@suse.cz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@infradead.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YLBY2PSIDLDD3RLJI4RLKN74LQPZZQKO/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon 30-11-20 06:22:42, Amy Parker wrote:
> > > +/*
> > > + * A zero entry, XA_ZERO_ENTRY, is used to represent a zero page. This
> > > + * definition helps with checking if an entry is a PMD size.
> > > + */
> > > +#define XA_ZERO_PMD_ENTRY DAX_PMD | (unsigned long)XA_ZERO_ENTRY
> > > +
> >
> > Firstly, if you define a macro, we usually wrap it inside braces like:
> >
> > #define XA_ZERO_PMD_ENTRY (DAX_PMD | (unsigned long)XA_ZERO_ENTRY)
> >
> > to avoid unexpected issues when macro expands and surrounding operators
> > have higher priority.
> 
> Oops! Must've missed that - I'll make sure to get on that when
> revising this patch.
> 
> > Secondly, I don't think you can combine XA_ZERO_ENTRY with DAX_PMD (or any
> > other bits for that matter). XA_ZERO_ENTRY is defined as
> > xa_mk_internal(257) which is ((257 << 2) | 2) - DAX bits will overlap with
> > the bits xarray internal entries are using and things will break.
> 
> Could you provide an example of this overlap? I can't seem to find any.

Well XA_ZERO_ENTRY | DAX_PMD == ((257 << 2) | 2) | (1 << 1). So the way
you've defined XA_ZERO_PMD_ENTRY the DAX_PMD will just get lost. AFAIU (but
Matthew might correct me here), for internal entries (and XA_ZERO_ENTRY is
one instance of such entry) low 10-bits of the of the entry values are
reserved for internal xarray usage so DAX could use only higher bits. For
classical value entries, only the lowest bit is reserved for xarray usage,
all the rest is available for the user (and so DAX uses it).
 
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
