Return-Path: <SRS0=XhsV=6C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A349C352BE
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:50:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E32321D93
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="musbWlm7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E32321D93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D855110FC62DB;
	Sat, 18 Apr 2020 11:50:56 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 56BD510FC62D6
	for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 11:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M2qa3/vc2/myvbMk+MYALeJsSLdNzC1fZAyoJyG68gE=; b=musbWlm7i2hjImd1CYGB5QW7l8
	Wn/kGpq4MEnK3EQO7eZeKDFT8eS5LR23e3CnYhCDStAgjQAFY5YBGVt6kelglv19B681ienPPYSaq
	YfDJC+H0H5NLdOmuRZEmcigYq143fNpyKGLW6QQRzawQ8loN2w3Tr8KqH0mfYRp8Pfor829wVUHqA
	l1trL/tl9vJG07nJcZqpDQmkbddJurRYVp9wZ2ld/OgdRFRqUkk7SeljH7WfG/EzD5GnLgRWzeBn2
	+F+hn6JAaMQT4MLsGR2BZlvqMq0c/4rnwpzB0mmIRStMWYlkSjUiT2M0RY1BWI/jkco5Jw22oyFTf
	oqBggJew==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jPsXx-0005fx-6n; Sat, 18 Apr 2020 18:50:33 +0000
Date: Sat, 18 Apr 2020 11:50:33 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 7/9] drivers/base: fix empty-body warnings in
 devcoredump.c
Message-ID: <20200418185033.GQ5820@bombadil.infradead.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-8-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200418184111.13401-8-rdunlap@infradead.org>
Message-ID-Hash: 4TEVYK7JJ3BNLAJSC5OTHTMID6ASC322
X-Message-ID-Hash: 4TEVYK7JJ3BNLAJSC5OTHTMID6ASC322
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Zzy Wysm <zzy@zzywysm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4TEVYK7JJ3BNLAJSC5OTHTMID6ASC322/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 18, 2020 at 11:41:09AM -0700, Randy Dunlap wrote:
> @@ -294,11 +295,11 @@ void dev_coredumpm(struct device *dev, s
>  
>  	if (sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
>  			      "failing_device"))
> -		/* nothing - symlink will be missing */;
> +		do_empty(); /* nothing - symlink will be missing */
>  
>  	if (sysfs_create_link(&dev->kobj, &devcd->devcd_dev.kobj,
>  			      "devcoredump"))
> -		/* nothing - symlink will be missing */;
> +		do_empty(); /* nothing - symlink will be missing */
>  
>  	INIT_DELAYED_WORK(&devcd->del_wk, devcd_del);
>  	schedule_delayed_work(&devcd->del_wk, DEVCD_TIMEOUT);

Could just remove the 'if's?

+	sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
+			"failing_device");
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
