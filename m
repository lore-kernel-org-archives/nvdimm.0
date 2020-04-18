Return-Path: <SRS0=XhsV=6C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F67AC352BE
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:44:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 234EE21D6C
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XZDspZHL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 234EE21D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D3E3B10FC62CE;
	Sat, 18 Apr 2020 11:44:30 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=willy@infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5B37010FC3BBA
	for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 11:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tL7oBItZTGP6Ja0KJzj5epfoD8nvKm3R0ync/alPIPM=; b=XZDspZHLNEdieJauqz1tT3tU6E
	YTnCIpvp5xSBzMeKUYN/ZrY33Xv8ujXKOpRTHETYgjlXYNG9Bevf+VNJTem44EiEuHW7Kf02I1k/X
	SJhnpcUnJ6bRMlTie1XiEGAADIuP2UhPDajunCcwmIaLQ9R7A0f83xZxenWNGKa6FZUj7cMWrxEBg
	PSon0anIZCVaqUvfDbOlu0w9rllj/BKv5pm+pUXO24gnqsHCRmlgucoKgC2iB8Ur4nykcm4RDvIcd
	Z3/5U9tzWaeZCnR4s79Lw+eywQDgY2zp8dPurJQWwcNvxfQ7gTQUf4A+LyA8bN9q1CVLcYHJlvoR/
	44a0PpaA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jPsRm-0008GS-2P; Sat, 18 Apr 2020 18:44:10 +0000
Date: Sat, 18 Apr 2020 11:44:09 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 5/9] usb: fix empty-body warning in sysfs.c
Message-ID: <20200418184409.GP5820@bombadil.infradead.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-6-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200418184111.13401-6-rdunlap@infradead.org>
Message-ID-Hash: CTVOBC7MNN2T2TUIOTFBSJXW2QP7TXGP
X-Message-ID-Hash: CTVOBC7MNN2T2TUIOTFBSJXW2QP7TXGP
X-MailFrom: willy@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Zzy Wysm <zzy@zzywysm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CTVOBC7MNN2T2TUIOTFBSJXW2QP7TXGP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 18, 2020 at 11:41:07AM -0700, Randy Dunlap wrote:
> +++ linux-next-20200327/drivers/usb/core/sysfs.c
> @@ -1263,7 +1263,7 @@ void usb_create_sysfs_intf_files(struct
>  	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
>  		alt->string = usb_cache_string(udev, alt->desc.iInterface);
>  	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
> -		;	/* We don't actually care if the function fails. */
> +		do_empty(); /* We don't actually care if the function fails. */
>  	intf->sysfs_files_created = 1;
>  }

Why not just?

+	if (alt->string)
+		device_create_file(&intf->dev, &dev_attr_interface);
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
