Return-Path: <SRS0=VXyD=6W=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED531C38A2A
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 May 2020 16:09:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B67A4216FD
	for <linux-nvdimm@archiver.kernel.org>; Fri,  8 May 2020 16:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="iN9Em3ee"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B67A4216FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 880391187B6D3;
	Fri,  8 May 2020 09:07:40 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=5.9.137.197; helo=mail.skyhub.de; envelope-from=bp@alien8.de; receiver=<UNKNOWN> 
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BD7F41187B6D0
	for <linux-nvdimm@lists.01.org>; Fri,  8 May 2020 09:07:36 -0700 (PDT)
Received: from zn.tnic (p200300EC2F0C9800329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:9800:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 00FBC1EC008F;
	Fri,  8 May 2020 18:09:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1588954179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=UqLtVT0FeQmzUfsO+zZA7Gur4b3vfPoCKM3UXxWw5Nc=;
	b=iN9Em3ee7IKvXVDRD1gnQ6cbvugr2wQhogKP7eXqD67gtswC7rOOtpxi2IILZZn8R6GhhB
	cq1F/95hEoQ9cUrVJvKxF3tw7BPxTL6iOodu1idhke6d6zMWH302H08EUQxncJtOq0ikzO
	weWQiPe2GP+hHs2/d+mxS9W+ZmcBJLY=
Date: Fri, 8 May 2020 18:09:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH v7 2/5] seq_buf: Export seq_buf_printf() to external
 modules
Message-ID: <20200508160935.GB19436@zn.tnic>
References: <20200508104922.72565-1-vaibhav@linux.ibm.com>
 <20200508104922.72565-3-vaibhav@linux.ibm.com>
 <20200508113100.GA19436@zn.tnic>
 <87blmy8wm8.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87blmy8wm8.fsf@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: 42XVIMJWDIETKR4263R6ZKDBGF7JCOD4
X-Message-ID-Hash: 42XVIMJWDIETKR4263R6ZKDBGF7JCOD4
X-MailFrom: bp@alien8.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Steven Rostedt <rostedt@goodmis.org>, Piotr Maziarz <piotrx.maziarz@linux.intel.com>, Cezary Rojewski <cezary.rojewski@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/42XVIMJWDIETKR4263R6ZKDBGF7JCOD4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 08, 2020 at 05:30:31PM +0530, Vaibhav Jain wrote:
> I am referring to Kernel Loadable Modules with MODULE_LICENSE("GPL")
> here.

And what does "external" refer to? Because if it is out-of-tree, we
don't export symbols for out-of-tree modules.

Looks like you're exporting it for that papr_scm.c thing, which is fine.
But that is not "external".

So?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
