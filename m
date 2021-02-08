Return-Path: <SRS0=Mf6P=HK=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEB7C433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon,  8 Feb 2021 15:14:25 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9136764EA4
	for <linux-nvdimm@archiver.kernel.org>; Mon,  8 Feb 2021 15:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9136764EA4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5A322100F226B;
	Mon,  8 Feb 2021 07:14:25 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 733A5100F2268
	for <linux-nvdimm@lists.01.org>; Mon,  8 Feb 2021 07:14:22 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D07EF68AFE; Mon,  8 Feb 2021 16:14:19 +0100 (CET)
Date: Mon, 8 Feb 2021 16:14:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 3/7] fsdax: Copy data before write
Message-ID: <20210208151419.GC12872@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com> <20210207170924.2933035-4-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210207170924.2933035-4-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: WMMCAL5ZV77DW64ZZTPLTCFRDVURFG2Z
X-Message-ID-Hash: WMMCAL5ZV77DW64ZZTPLTCFRDVURFG2Z
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com, willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/WMMCAL5ZV77DW64ZZTPLTCFRDVURFG2Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>  	switch (iomap.type) {
>  	case IOMAP_MAPPED:
> +cow:
>  		if (iomap.flags & IOMAP_F_NEW) {
>  			count_vm_event(PGMAJFAULT);
>  			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
>  			major = VM_FAULT_MAJOR;
>  		}
>  		error = dax_iomap_direct_access(&iomap, pos, PAGE_SIZE,
> -						NULL, &pfn);
> +						&kaddr, &pfn);

Any chance you could look into factoring out this code into a helper
to avoid the goto magic, which is a little too convoluted?

>  	switch (iomap.type) {
>  	case IOMAP_MAPPED:
> +cow:
>  		error = dax_iomap_direct_access(&iomap, pos, PMD_SIZE,
> -						NULL, &pfn);
> +						&kaddr, &pfn);
>  		if (error < 0)
>  			goto finish_iomap;
>  
>  		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
>  						DAX_PMD, write && !sync);
>  
> +		if (srcmap.type != IOMAP_HOLE) {

Same here.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
