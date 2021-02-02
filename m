Return-Path: <SRS0=J6SA=HE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E317FC433DB
	for <linux-nvdimm@archiver.kernel.org>; Tue,  2 Feb 2021 18:04:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E8BF64F96
	for <linux-nvdimm@archiver.kernel.org>; Tue,  2 Feb 2021 18:04:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E8BF64F96
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 67E1F100EAB47;
	Tue,  2 Feb 2021 10:04:57 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=batv+78410b086ab5a19d433c+6372+infradead.org+hch@casper.srs.infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 35A02100EF276
	for <linux-nvdimm@lists.01.org>; Tue,  2 Feb 2021 10:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VyJH7voCGDtQQt4w1TbeXtHjXIusss7wUzDWNNwmpGk=; b=IOskqQICKJhmHUYSyZ0bIKcxSC
	YD51DXLjngLcDn194FfQCXJv9zvz5Jxh4are/lj4k24Adh+aXRs/U+3tV373RLw3lyzqN4rFS5I3a
	prGYth3McC/q8/tJbuE/nKVCBde40lMicMbqrztzsBqgb/xoONwYRLFcn0+j5LomiLLV++NPWtRRo
	dThWOChcYBPEEyy6nLAKIaVyzDDuTQu9qQRXYJc3dEY1uPo7IeCZrTIxtY6DignbximVToZEx6gEX
	04yp/33EIyC9HfZI7lT0h2jKgmq6kV4Y7b8rdFdpsW7R2ayBfvIUfsfS/tcSQskmt2jIJvxsFztDl
	Ee5uLZMg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
	id 1l702b-00FZAZ-K5; Tue, 02 Feb 2021 18:04:42 +0000
Date: Tue, 2 Feb 2021 18:04:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ben Widawsky <ben.widawsky@intel.com>
Subject: Re: [PATCH 02/14] cxl/mem: Map memory device registers
Message-ID: <20210202180441.GC3708021@infradead.org>
References: <20210130002438.1872527-1-ben.widawsky@intel.com>
 <20210130002438.1872527-3-ben.widawsky@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210130002438.1872527-3-ben.widawsky@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: FKACUWCHCWK3O77Z246CEYN3IRZMOURY
X-Message-ID-Hash: FKACUWCHCWK3O77Z246CEYN3IRZMOURY
X-MailFrom: BATV+78410b086ab5a19d433c+6372+infradead.org+hch@casper.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-cxl@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>, Jon Masters <jcm@jonmasters.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, daniel.lll@alibaba-inc.com, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/FKACUWCHCWK3O77Z246CEYN3IRZMOURY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Any reason not to merge a bunch of patches?  Both this one and
the previous one are rather useless on their own, making review
harder than necessary.

> + * cxl_mem_create() - Create a new &struct cxl_mem.
> + * @pdev: The pci device associated with the new &struct cxl_mem.
> + * @reg_lo: Lower 32b of the register locator
> + * @reg_hi: Upper 32b of the register locator.
> + *
> + * Return: The new &struct cxl_mem on success, NULL on failure.
> + *
> + * Map the BAR for a CXL memory device. This BAR has the memory device's
> + * registers for the device as specified in CXL specification.
> + */

A lot of text with almost no value over just reading the function.
What's that fetish with kerneldoc comments for trivial static functions?

> +		reg_type =
> +			(reg_lo >> CXL_REGLOC_RBI_SHIFT) & CXL_REGLOC_RBI_MASK;

OTOH this screams for a helper that would make the code a lot more
self documenting.

> +		if (reg_type == CXL_REGLOC_RBI_MEMDEV) {
> +			rc = 0;
> +			cxlm = cxl_mem_create(pdev, reg_lo, reg_hi);
> +			if (!cxlm)
> +				rc = -ENODEV;
> +			break;

And given that we're going to grow more types eventually, why not start
out with a switch here?  Also why return the structure when nothing
uses it?
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
