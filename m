Return-Path: <SRS0=NTWP=AU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD22C433E0
	for <linux-nvdimm@archiver.kernel.org>; Thu,  9 Jul 2020 15:00:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7CCFC20720
	for <linux-nvdimm@archiver.kernel.org>; Thu,  9 Jul 2020 15:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sXjsW/W8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CCFC20720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4010211427DBD;
	Thu,  9 Jul 2020 08:00:58 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=batv+9909843fd9ad822e0971+6164+infradead.org+hch@casper.srs.infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B57AC111FF49B
	for <linux-nvdimm@lists.01.org>; Thu,  9 Jul 2020 08:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d6Fy1Ff8XKWJW7cdhpnfoPEQT8m7nn2QugrKA2y4BTE=; b=sXjsW/W8stofL0fSqv1devL9iA
	NF8pTtSu1pmMI2cx2Ezm5BoeofYSnPN6/rZYmpD+i2SwKMs8rbtY2EPcBcEn7LmzBMlRLH+HYv4ou
	IIiSGFJU8JQLbSCfDquQtv8nlD8xpYOQ1F33SWeREt+m+MKW2AS9lsim693P8pOA6Vn81rDU4U0pQ
	5CL7N1SiSxz2S6PRS4eEqvntN+bK6HeL9i5oI+CCBxoYMsT/JAjCwF5JHINgYNRZxp7hyfyhsJm5A
	TrgN6ANkFqMOJfU2KX4+HzhiTpzqnYh8wY/zml3sRidyoIzqKYX3E/qQYPkqN/E1WGtoJpXZ0IVyl
	KCO5FDkg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jtY2d-0004br-7k; Thu, 09 Jul 2020 15:00:51 +0000
Date: Thu, 9 Jul 2020 16:00:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 11/12] PM, libnvdimm: Add 'mem-quiet' state and
 callback for firmware activation
Message-ID: <20200709150051.GA17342@infradead.org>
References: <159408711335.2385045.2567600405906448375.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159408717289.2385045.14094866475168644020.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <159408717289.2385045.14094866475168644020.stgit@dwillia2-desk3.amr.corp.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Message-ID-Hash: W2JWMKYHYTSNTDO3K2QLZLIHK5A7K72X
X-Message-ID-Hash: W2JWMKYHYTSNTDO3K2QLZLIHK5A7K72X
X-MailFrom: BATV+9909843fd9ad822e0971+6164+infradead.org+hch@casper.srs.infradead.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/W2JWMKYHYTSNTDO3K2QLZLIHK5A7K72X/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 06, 2020 at 06:59:32PM -0700, Dan Williams wrote:
> The runtime firmware activation capability of Intel NVDIMM devices
> requires memory transactions to be disabled for 100s of microseconds.
> This timeout is large enough to cause in-flight DMA to fail and other
> application detectable timeouts. Arrange for firmware activation to be
> executed while the system is "quiesced", all processes and device-DMA
> frozen.
> 
> It is already required that invoking device ->freeze() callbacks is
> sufficient to cease DMA. A device that continues memory writes outside
> of user-direction violates expectations of the PM core to be to
> establish a coherent hibernation image.
> 
> That said, RDMA devices are an example of a device that access memory
> outside of user process direction. RDMA drivers also typically assume
> the system they are operating in will never be hibernated. A solution
> for RDMA collisions with firmware activation is outside the scope of
> this change and may need to rely on being able to survive the platform
> imposed memory controller quiesce period.

Yikes.  I don't think we should support such a broken runtime firmware
activation.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
