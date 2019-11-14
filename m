Return-Path: <SRS0=AdRK=ZG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6400FC43141
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 07:24:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44A88206E6
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 07:24:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44A88206E6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 896BF100DC43E;
	Wed, 13 Nov 2019 23:25:32 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=213.95.11.211; helo=verein.lst.de; envelope-from=hch@lst.de; receiver=<UNKNOWN> 
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id CF6EE100DC43B
	for <linux-nvdimm@lists.01.org>; Wed, 13 Nov 2019 23:25:29 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8459568AFE; Thu, 14 Nov 2019 08:23:54 +0100 (CET)
Date: Thu, 14 Nov 2019 08:23:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] mm: Cleanup __put_devmap_managed_page() vs
 ->page_free()
Message-ID: <20191114072354.GA26448@lst.de>
References: <157368992671.2974225.13512647385398246617.stgit@dwillia2-desk3.amr.corp.intel.com> <913133b7-58d8-9645-fc89-c2819825e1ee@nvidia.com> <CAPcyv4hK1hkDn9WohRn4F8JkAOBu94jzOJtU+43PP2qSX77Fqg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hK1hkDn9WohRn4F8JkAOBu94jzOJtU+43PP2qSX77Fqg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-ID-Hash: 2CQX44GJMEOJNE2OQQEZ5HTMNCCXS42E
X-Message-ID-Hash: 2CQX44GJMEOJNE2OQQEZ5HTMNCCXS42E
X-MailFrom: hch@lst.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2CQX44GJMEOJNE2OQQEZ5HTMNCCXS42E/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 13, 2019 at 04:47:38PM -0800, Dan Williams wrote:
> > Got it. This will appear in the next posted version of my "mm/gup: track
> > dma-pinned pages: FOLL_PIN, FOLL_LONGTERM" patchset.
> 
> Thanks!

John - can you please send a small series just doing the zone device
patches rework?  That way we can review it separately and maybe even get
it into 5.5.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
