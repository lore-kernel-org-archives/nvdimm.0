Return-Path: <SRS0=XhsV=6C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B60C38A29
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 19:54:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 217C5221F7
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 19:54:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 217C5221F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3523C10FC62EB;
	Sat, 18 Apr 2020 12:54:24 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.131.102.5; helo=netrider.rowland.org; envelope-from=stern+5e9eda24@rowland.harvard.edu; receiver=<UNKNOWN> 
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by ml01.01.org (Postfix) with SMTP id 53B8510FC51C4
	for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 12:54:21 -0700 (PDT)
Received: (qmail 9694 invoked by uid 500); 18 Apr 2020 15:54:12 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 18 Apr 2020 15:54:12 -0400
Date: Sat, 18 Apr 2020 15:54:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 5/9] usb: fix empty-body warning in sysfs.c
In-Reply-To: <20200418184409.GP5820@bombadil.infradead.org>
Message-ID: <Pine.LNX.4.44L0.2004181549020.8036-100000@netrider.rowland.org>
MIME-Version: 1.0
Message-ID-Hash: W7IV3XSFIAFVMVFUGY6GU45CMKQMGYLH
X-Message-ID-Hash: W7IV3XSFIAFVMVFUGY6GU45CMKQMGYLH
X-MailFrom: stern+5e9eda24@rowland.harvard.edu
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Zzy Wysm <zzy@zzywysm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/W7IV3XSFIAFVMVFUGY6GU45CMKQMGYLH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 18 Apr 2020, Matthew Wilcox wrote:

> On Sat, Apr 18, 2020 at 11:41:07AM -0700, Randy Dunlap wrote:
> > +++ linux-next-20200327/drivers/usb/core/sysfs.c
> > @@ -1263,7 +1263,7 @@ void usb_create_sysfs_intf_files(struct
> >  	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
> >  		alt->string = usb_cache_string(udev, alt->desc.iInterface);
> >  	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
> > -		;	/* We don't actually care if the function fails. */
> > +		do_empty(); /* We don't actually care if the function fails. */
> >  	intf->sysfs_files_created = 1;
> >  }
> 
> Why not just?
> 
> +	if (alt->string)
> +		device_create_file(&intf->dev, &dev_attr_interface);

This is another __must_check function call.

The reason we don't care if the call fails is because the file
being created holds the USB interface string descriptor, something
which is purely informational and hardly ever gets set (and no doubt
gets used even less often).

Is this another situation where the comment should be expanded and the 
code modified to include a useless test and cast-to-void?

Or should device_create_file() not be __must_check after all?

Greg?

Alan Stern
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
