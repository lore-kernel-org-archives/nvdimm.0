Return-Path: <SRS0=baXv=HT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86F2C433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 17 Feb 2021 01:43:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E71E64DFF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 17 Feb 2021 01:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E71E64DFF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E20CC100F2240;
	Tue, 16 Feb 2021 17:43:01 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:5300:60:148a::1; helo=zeniv-ca.linux.org.uk; envelope-from=viro@ftp.linux.org.uk; receiver=<UNKNOWN> 
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id AFA5A100EC1D7
	for <linux-nvdimm@lists.01.org>; Tue, 16 Feb 2021 17:42:59 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
	id 1lC4pR-00Egds-Ey; Tue, 16 Feb 2021 18:12:05 +0000
Date: Tue, 16 Feb 2021 18:12:05 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Ben Widawsky <ben.widawsky@intel.com>
Subject: Re: [PATCH v4 4/9] cxl/mem: Add basic IOCTL interface
Message-ID: <YCwK9SblYCh/1lZS@zeniv-ca.linux.org.uk>
References: <20210216014538.268106-1-ben.widawsky@intel.com>
 <20210216014538.268106-5-ben.widawsky@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210216014538.268106-5-ben.widawsky@intel.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Message-ID-Hash: QAIFY4OW3QRWT53U7EXQ4C76V2N6XD3I
X-Message-ID-Hash: QAIFY4OW3QRWT53U7EXQ4C76V2N6XD3I
X-MailFrom: viro@ftp.linux.org.uk
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-cxl@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>, David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>, Jon Masters <jcm@jonmasters.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>, kernel test robot <lkp@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QAIFY4OW3QRWT53U7EXQ4C76V2N6XD3I/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 15, 2021 at 05:45:33PM -0800, Ben Widawsky wrote:
> +	if (cmd->info.size_in) {
> +		mbox_cmd.payload_in = kvzalloc(cmd->info.size_in, GFP_KERNEL);
> +		if (!mbox_cmd.payload_in) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
> +
> +		if (copy_from_user(mbox_cmd.payload_in,
> +				   u64_to_user_ptr(in_payload),
> +				   cmd->info.size_in)) {
> +			rc = -EFAULT;
> +			goto out;
> +		}

Umm...  Do you need to open-code vmemdup_user()?  The only difference is
GFP_KERNEL allocation instead of GFP_USER one, and the latter is arguably
saner here...  Zeroing is definitely pointless - you either overwrite
the entire buffer with copy_from_user(), or you fail and free the damn
thing.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
