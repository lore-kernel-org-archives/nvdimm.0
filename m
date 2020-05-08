Return-Path: <SRS0=VXyD=6W=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A11C47247
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 May 2020 16:27:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D5CD2173E
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 May 2020 16:27:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D5CD2173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C9EA0118807AE;
	Fri,  8 May 2020 09:25:03 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=srs0=brsq=6w=goodmis.org=rostedt@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 41E32118807AC
	for <linux-nvdimm@lists.01.org>; Fri,  8 May 2020 09:25:01 -0700 (PDT)
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 1C114208CA;
	Fri,  8 May 2020 16:27:05 +0000 (UTC)
Date: Fri, 8 May 2020 12:27:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 2/5] seq_buf: Export seq_buf_printf() to external
 modules
Message-ID: <20200508122703.6ee5cae0@gandalf.local.home>
In-Reply-To: <20200508160935.GB19436@zn.tnic>
References: <20200508104922.72565-1-vaibhav@linux.ibm.com>
	<20200508104922.72565-3-vaibhav@linux.ibm.com>
	<20200508113100.GA19436@zn.tnic>
	<87blmy8wm8.fsf@linux.ibm.com>
	<20200508160935.GB19436@zn.tnic>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Message-ID-Hash: HYVL5ZK65PNX5LZPZIWADBYBKJ4VK6FU
X-Message-ID-Hash: HYVL5ZK65PNX5LZPZIWADBYBKJ4VK6FU
X-MailFrom: SRS0=BRSq=6W=goodmis.org=rostedt@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K . V  <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Piotr Maziarz" <piotrx.maziarz@linux.intel.com>, Cezary Rojewski <cezary.rojewski@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HYVL5ZK65PNX5LZPZIWADBYBKJ4VK6FU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 8 May 2020 18:09:35 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Fri, May 08, 2020 at 05:30:31PM +0530, Vaibhav Jain wrote:
> > I am referring to Kernel Loadable Modules with MODULE_LICENSE("GPL")
> > here.  
> 
> And what does "external" refer to? Because if it is out-of-tree, we
> don't export symbols for out-of-tree modules.

I've always wondered about this. Why not?

-- Steve
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
