Return-Path: <SRS0=QkFa=IB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_05,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B750C433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed,  3 Mar 2021 09:45:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4036064EEE
	for <linux-nvdimm@archiver.kernel.org>; Wed,  3 Mar 2021 09:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4036064EEE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C5925100EB325;
	Wed,  3 Mar 2021 01:44:58 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DCEC2100EB321
	for <linux-nvdimm@lists.01.org>; Wed,  3 Mar 2021 01:44:56 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4F89968CFE; Wed,  3 Mar 2021 10:44:54 +0100 (CET)
Date: Wed, 3 Mar 2021 10:44:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Subject: Re: [PATCH v2 05/10] fsdax: Replace mmap entry in case of CoW
Message-ID: <20210303094454.GA15967@lst.de>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com> <OSBPR01MB2920FB5AD1C9ADC64100238AF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OSBPR01MB2920FB5AD1C9ADC64100238AF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: QBB64Y7ZI2FVJZ3ERIFBGHWQTC6R2HQG
X-Message-ID-Hash: QBB64Y7ZI2FVJZ3ERIFBGHWQTC6R2HQG
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "willy@infradead.org" <willy@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "david@fromorbit.com" <david@fromorbit.com>, "rgoldwyn@suse.de" <rgoldwyn@suse.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QBB64Y7ZI2FVJZ3ERIFBGHWQTC6R2HQG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 03, 2021 at 09:41:54AM +0000, ruansy.fnst@fujitsu.com wrote:
> 
> > >
> > >       if (dirty)
> > >               __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> > 
> > I still think the __mark_inode_dirty should just be moved into the one
> > caller that needs it.
> 
> I found that the dirty flag will be used in the next few lines, so I keep
> this function inside. If I move it outside, the drity flag should be passed
> in as well. 
> 
> @@ -774,6 +780,9 @@ static void *dax_insert_entry(struct xa_state *xas,
>          if (dirty)
>                  xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
>  
> +       if (cow)
> +               xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
> +
>          xas_unlock_irq(xas);
>          return entry;
> }
> 
> 
> So, may I ask what's your purpose for doing in that way?

Oh, true.  We can't just move that out as the xas needs to stay
locked.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
