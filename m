Return-Path: <SRS0=wOoQ=HD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D44C433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon,  1 Feb 2021 19:27:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E611A64EB8
	for <linux-nvdimm@archiver.kernel.org>; Mon,  1 Feb 2021 19:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E611A64EB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 97696100F2240;
	Mon,  1 Feb 2021 11:27:18 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.151; helo=mga17.intel.com; envelope-from=ben.widawsky@intel.com; receiver=<UNKNOWN> 
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EC05F100EBB82
	for <linux-nvdimm@lists.01.org>; Mon,  1 Feb 2021 11:27:14 -0800 (PST)
IronPort-SDR: rlMvUWcJYmKV/qRvNcFEmuvRhkOljKyeGtqw8dm/SsCFG6rb8nJ/9tcXXRpq0/fNf0Ghv7joi2
 0HpMIiZ4PQdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="160506194"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400";
   d="scan'208";a="160506194"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 11:27:10 -0800
IronPort-SDR: Ar5npZIlmRyHOQSbD4WFo7BWVfXRSQKlTGiCVd73BlEHcqRFpJZVT35dVyiUYoiQkJZUvgY63t
 /fFyaLde9z+Q==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400";
   d="scan'208";a="355891726"
Received: from jambrizm-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.133.15])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 11:27:09 -0800
Date: Mon, 1 Feb 2021 11:27:08 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 09/14] cxl/mem: Add a "RAW" send command
Message-ID: <20210201192708.5cvyecbcdrwx77de@intel.com>
References: <20210130002438.1872527-1-ben.widawsky@intel.com>
 <20210130002438.1872527-10-ben.widawsky@intel.com>
 <20210201182400.GK197521@fedora>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210201182400.GK197521@fedora>
Message-ID-Hash: SE44ZWQFSPHHXTBEUFAG2F52N77NGMCA
X-Message-ID-Hash: SE44ZWQFSPHHXTBEUFAG2F52N77NGMCA
X-MailFrom: ben.widawsky@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-cxl@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>, Jon Masters <jcm@jonmasters.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, daniel.lll@alibaba-inc.com, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SE44ZWQFSPHHXTBEUFAG2F52N77NGMCA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 21-02-01 13:24:00, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 29, 2021 at 04:24:33PM -0800, Ben Widawsky wrote:
> > The CXL memory device send interface will have a number of supported
> > commands. The raw command is not such a command. Raw commands allow
> > userspace to send a specified opcode to the underlying hardware and
> > bypass all driver checks on the command. This is useful for a couple of
> > usecases, mainly:
> > 1. Undocumented vendor specific hardware commands
> > 2. Prototyping new hardware commands not yet supported by the driver
> 
> This sounds like a recipe for ..
> 
> In case you really really want this may I recommend you do two things:
> 
> - Wrap this whole thing with #ifdef
>   CONFIG_CXL_DEBUG_THIS_WILL_DESTROY_YOUR_LIFE
> 
>  (or something equivalant to make it clear this should never be
>   enabled in production kernels).
> 
>  - Add a nice big fat printk in dmesg telling the user that they
>    are creating a unstable parallel universe that will lead to their
>    blood pressure going sky-high, or perhaps something more professional
>    sounding.
> 
> - Rethink this. Do you really really want to encourage vendors
>   to use this raw API instead of them using the proper APIs?

Again, the ideal is proper APIs. Barring that they get a WARN, and a taint if
they use the raw commands.

> 
> > 
> > While this all sounds very powerful it comes with a couple of caveats:
> > 1. Bug reports using raw commands will not get the same level of
> >    attention as bug reports using supported commands (via taint).
> > 2. Supported commands will be rejected by the RAW command.
> > 
> > With this comes new debugfs knob to allow full access to your toes with
> > your weapon of choice.
> 
> Problem is that debugfs is no longer "debug" but is enabled in
> production kernel.

I don't see this as my problem. Again, they've been WARNed and tainted. If they
want to do this, that's their business. They will be asked to reproduce without
RAW if they file a bug report.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
