Return-Path: <SRS0=lZYl=EC=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25266C55178
	for <linux-nvdimm@archiver.kernel.org>; Tue, 27 Oct 2020 12:11:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6C2F0222C8
	for <linux-nvdimm@archiver.kernel.org>; Tue, 27 Oct 2020 12:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C2F0222C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1AD321625C7A3;
	Tue, 27 Oct 2020 05:11:16 -0700 (PDT)
Received-SPF: Pass (helo) identity=helo; client-ip=193.175.24.41; helo=elvis.franken.de; envelope-from=tsbogend@alpha.franken.de; receiver=<UNKNOWN> 
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by ml01.01.org (Postfix) with ESMTP id 8F6771620D982
	for <linux-nvdimm@lists.01.org>; Tue, 27 Oct 2020 05:11:11 -0700 (PDT)
Received: from uucp (helo=alpha)
	by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
	id 1kXNoj-0002cz-00; Tue, 27 Oct 2020 13:11:09 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
	id 3193BC0592; Tue, 27 Oct 2020 13:01:42 +0100 (CET)
Date: Tue, 27 Oct 2020 13:01:42 +0100
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] MIPS: export has_transparent_hugepage() for modules
Message-ID: <20201027120142.GA13777@alpha.franken.de>
References: <20201023194440.13371-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201023194440.13371-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: MPSMSX32XEOLKKCQR7EKLSQMQOXLSSIB
X-Message-ID-Hash: MPSMSX32XEOLKKCQR7EKLSQMQOXLSSIB
X-MailFrom: tsbogend@alpha.franken.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>, linux-mips@vger.kernel.org, linux-nvdimm@lists.01.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MPSMSX32XEOLKKCQR7EKLSQMQOXLSSIB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 23, 2020 at 12:44:40PM -0700, Randy Dunlap wrote:
> MIPS should export its local version of "has_transparent_hugepage"
> so that loadable modules (dax) can use it.
> 
> Fixes this build error:
> ERROR: modpost: "has_transparent_hugepage" [drivers/dax/dax.ko] undefined!
> 
> Fixes: fd8cfd300019 ("arch: fix has_transparent_hugepage()")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: linux-mips@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/mips/mm/tlb-r4k.c |    1 +
>  1 file changed, 1 insertion(+)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
