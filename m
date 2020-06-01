Return-Path: <SRS0=BnuH=7O=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE91C433DF
	for <linux-nvdimm@archiver.kernel.org>; Mon,  1 Jun 2020 13:48:48 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E6D0120772
	for <linux-nvdimm@archiver.kernel.org>; Mon,  1 Jun 2020 13:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6D0120772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3E40D100DD896;
	Mon,  1 Jun 2020 06:44:03 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=srs0=mjak=7o=goodmis.org=rostedt@kernel.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9FF85100DDCC0
	for <linux-nvdimm@lists.01.org>; Mon,  1 Jun 2020 06:44:00 -0700 (PDT)
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id BB4202068D;
	Mon,  1 Jun 2020 13:48:43 +0000 (UTC)
Date: Mon, 1 Jun 2020 09:48:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH v8 2/5] seq_buf: Export seq_buf_printf
Message-ID: <20200601094842.3cd0cab6@gandalf.local.home>
In-Reply-To: <87367f9eqs.fsf@linux.ibm.com>
References: <20200527041244.37821-1-vaibhav@linux.ibm.com>
	<20200527041244.37821-3-vaibhav@linux.ibm.com>
	<87367f9eqs.fsf@linux.ibm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Message-ID-Hash: 5INDLSZFOD5KHZA3CF7OK5ZE5KGQNCJQ
X-Message-ID-Hash: 5INDLSZFOD5KHZA3CF7OK5ZE5KGQNCJQ
X-MailFrom: SRS0=MJaK=7O=goodmis.org=rostedt@kernel.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Christoph Hellwig <hch@infradead.org>, Cezary Rojewski <cezary.rojewski@intel.com>, Piotr Maziarz <piotrx.maziarz@linux.intel.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5INDLSZFOD5KHZA3CF7OK5ZE5KGQNCJQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 01 Jun 2020 17:31:31 +0530
Vaibhav Jain <vaibhav@linux.ibm.com> wrote:

> Hi Christoph and Steven,
> 
> Have addressed your review comment to update the patch description and
> title for this patch. Can you please provide your ack to this patch.
> 
> 

I thought I already did, but it appears it was a reply to a private email
you sent to me. I didn't realize it was off list.

Anyway:

 Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
