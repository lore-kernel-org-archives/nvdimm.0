Return-Path: <SRS0=D+VT=DZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C60DC4363A
	for <linux-nvdimm@archiver.kernel.org>; Sun, 18 Oct 2020 05:43:39 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6F9E208B8
	for <linux-nvdimm@archiver.kernel.org>; Sun, 18 Oct 2020 05:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="w5E1+nGV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6F9E208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7E2E01546CE4D;
	Sat, 17 Oct 2020 22:43:38 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6D4EC1546CE4A;
	Sat, 17 Oct 2020 22:43:36 -0700 (PDT)
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 781412080D;
	Sun, 18 Oct 2020 05:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602999815;
	bh=xQx4tam510oViG0aS6IAIECEgE6lGctfYht63oAFTjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w5E1+nGVmBfju9sqafA7RNAyWyGXNV3glWIi0a1uVAyl5PpHYhnZwSlrCnlNiRfzs
	 cfV4uO4ZitYRPtno4rRqk/s62SY+Vkk0iEk8aerfp+YXmT6bAocVlLg03Vxy6aXm6p
	 C7/g4QRFCPJ09/zXowenG6SzN/MQpYZKW+T/2i1s=
Date: Sun, 18 Oct 2020 07:43:32 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: trix@redhat.com
Subject: Re: [RFC] treewide: cleanup unreachable breaks
Message-ID: <20201018054332.GB593954@kroah.com>
References: <20201017160928.12698-1-trix@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201017160928.12698-1-trix@redhat.com>
Message-ID-Hash: 6GN3ZWZIIR4C3MRT6EFTCC6QDQH4EG3J
X-Message-ID-Hash: 6GN3ZWZIIR4C3MRT6EFTCC6QDQH4EG3J
X-MailFrom: gregkh@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org, linux-block@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-power@fi.rohmeurope.com, linux-gpio@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org, virtualization@lists.linux-foundation.org, spice-devel@lists.freedesktop.org, linux-iio@vger.kernel.org, linux-amlogic@lists.infradead.org, industrypack-devel@lists.sourceforge.net, linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-can@vger.kernel.org, netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org, ath10k@lists.infradead.org, linux-wireless@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, linux-nfc@lists.01.org, linux-nvdimm@lists.01.org, linux-pci@vger.
 kernel.org, linux-samsung-soc@vger.kernel.org, platform-driver-x86@vger.kernel.org, patches@opensource.cirrus.com, storagedev@microchip.com, devel@driverdev.osuosl.org, linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-watchdog@vger.kernel.org, ocfs2-devel@oss.oracle.com, bpf@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, alsa-devel@alsa-project.org, clang-built-linux@googlegroups.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/6GN3ZWZIIR4C3MRT6EFTCC6QDQH4EG3J/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This is a upcoming change to clean up a new warning treewide.
> I am wondering if the change could be one mega patch (see below) or
> normal patch per file about 100 patches or somewhere half way by collecting
> early acks.

Please break it up into one-patch-per-subsystem, like normal, and get it
merged that way.

Sending us a patch, without even a diffstat to review, isn't going to
get you very far...

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
