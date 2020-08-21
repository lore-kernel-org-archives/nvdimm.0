Return-Path: <SRS0=yZaU=B7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_05,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4AEC433DF
	for <linux-nvdimm@archiver.kernel.org>; Fri, 21 Aug 2020 22:56:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E1A82207C3
	for <linux-nvdimm@archiver.kernel.org>; Fri, 21 Aug 2020 22:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iI4dJvXr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1A82207C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ABDE4123B99AC;
	Fri, 21 Aug 2020 15:56:54 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 370C412188D94
	for <linux-nvdimm@lists.01.org>; Fri, 21 Aug 2020 15:56:51 -0700 (PDT)
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 452372067C;
	Fri, 21 Aug 2020 22:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598050610;
	bh=ZrUsTOSSrUKu+XmJ3n3QrX2IzU2U3VsMZK0kOK4GMiE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iI4dJvXrsyw1+Tk8OEZKoXVwWx2kqLp0ly8GxASNosQKHAXDZv5hwcn5CC134bPNF
	 caEROIqNlU8S+OxwkzchiFzFM3PRmD56ol/2Kerc6cXsp7ApDyw1xvfhmsSsve7A27
	 J1H7gbEkUDr4MCZZrQPSaW1dzJPF0DqbhJe8baJc=
Date: Fri, 21 Aug 2020 15:56:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 15/23] device-dax: Add resize support
Message-Id: <20200821155649.6a9fe5eb22a013833f94427c@linux-foundation.org>
In-Reply-To: <159643102625.4062302.7431838945566033852.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159643094279.4062302.17779410714418721328.stgit@dwillia2-desk3.amr.corp.intel.com>
	<159643102625.4062302.7431838945566033852.stgit@dwillia2-desk3.amr.corp.intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Message-ID-Hash: DFSB6EAHLDR2PMZUNM6CQANO3CBWZXFF
X-Message-ID-Hash: DFSB6EAHLDR2PMZUNM6CQANO3CBWZXFF
X-MailFrom: akpm@linux-foundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: peterz@infradead.org, dave.hansen@linux.intel.com, ard.biesheuvel@linaro.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, joao.m.martins@oracle.com, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DFSB6EAHLDR2PMZUNM6CQANO3CBWZXFF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, 02 Aug 2020 22:03:46 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> Make the device-dax 'size' attribute writable to allow capacity to be
> split between multiple instances in a region. The intended consumers of
> this capability are users that want to split a scarce memory resource
> between device-dax and System-RAM access, or users that want to have
> multiple security domains for a large region.
> 
> By default the hmem instance provider allocates an entire region to the
> first instance. The process of creating a new instance (assuming a
> region-id of 0) is find the region and trigger the 'create' attribute
> which yields an empty instance to configure. For example:
> 
>     cd /sys/bus/dax/devices
>     echo dax0.0 > dax0.0/driver/unbind
>     echo $new_size > dax0.0/size
>     echo 1 > $(readlink -f dax0.0)../dax_region/create
>     seed=$(cat $(readlink -f dax0.0)../dax_region/seed)
>     echo $new_size > $seed/size
>     echo dax0.0 > ../drivers/{device_dax,kmem}/bind
>     echo dax0.1 > ../drivers/{device_dax,kmem}/bind
> 
> Instances can be destroyed by:
> 
>     echo $device > $(readlink -f $device)../dax_region/delete

This userspace interface doesn't seem to be documented anywhere, so
there's nothing to update for this patch :(
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
