Return-Path: <SRS0=BnL6=G7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1641EC433E6
	for <linux-nvdimm@archiver.kernel.org>; Thu, 28 Jan 2021 13:28:16 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7379E64DD6
	for <linux-nvdimm@archiver.kernel.org>; Thu, 28 Jan 2021 13:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7379E64DD6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EA76E100EB84B;
	Thu, 28 Jan 2021 05:28:14 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=3.19.106.255; helo=gentwo.org; envelope-from=cl@linux.com; receiver=<UNKNOWN> 
Received: from gentwo.org (gentwo.org [3.19.106.255])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8E3F2100EB82D
	for <linux-nvdimm@lists.01.org>; Thu, 28 Jan 2021 05:28:12 -0800 (PST)
Received: by gentwo.org (Postfix, from userid 1002)
	id 7A84C3F4C1; Thu, 28 Jan 2021 13:28:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 77AFA3F461;
	Thu, 28 Jan 2021 13:28:10 +0000 (UTC)
Date: Thu, 28 Jan 2021 13:28:10 +0000 (UTC)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v16 07/11] secretmem: use PMD-size pages to amortize
 direct map fragmentation
In-Reply-To: <YBK1kqL7JA7NePBQ@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.22.394.2101281326360.10563@www.lameter.com>
References: <20210121122723.3446-1-rppt@kernel.org> <20210121122723.3446-8-rppt@kernel.org> <20210126114657.GL827@dhcp22.suse.cz> <303f348d-e494-e386-d1f5-14505b5da254@redhat.com> <20210126120823.GM827@dhcp22.suse.cz> <20210128092259.GB242749@kernel.org>
 <YBK1kqL7JA7NePBQ@dhcp22.suse.cz>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Message-ID-Hash: BUFD4IHCBSBJXNSENODIWQCMVED3LHA2
X-Message-ID-Hash: BUFD4IHCBSBJXNSENODIWQCMVED3LHA2
X-MailFrom: cl@linux.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Elena Reshetova <elena.reshetova@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, James Bottomley <jejb@linux.ibm.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Mark Rutland <mark.rutland@arm.com>, Mike Rapoport <rppt@linux.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, Peter Zijlstra <peterz@infradead.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Tycho And
 ersen <tycho@tycho.ws>, Will Deacon <will@kernel.org>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-riscv@lists.infradead.org, x86@kernel.org, Hagen Paul Pfeifer <hagen@jauu.net>, Palmer Dabbelt <palmerdabbelt@google.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BUFD4IHCBSBJXNSENODIWQCMVED3LHA2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 28 Jan 2021, Michal Hocko wrote:

> > So, if I understand your concerns correct this implementation has two
> > issues:
> > 1) allocation failure at page fault that causes unrecoverable OOM and
> > 2) a possibility for an unprivileged user to deplete secretmem pool and
> > cause (1) to others
> >
> > I'm not really familiar with OOM internals, but when I simulated an
> > allocation failure in my testing only the allocating process and it's
> > parent were OOM-killed and then the system continued normally.
>
> If you kill the allocating process then yes, it would work, but your
> process might be the very last to be selected.

OOMs are different if you have a "constrained allocation". In that case it
is the fault of the process who wanted memory with certain conditions.
That memory is not available. General memory is available though. In that
case the allocating process is killed.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
