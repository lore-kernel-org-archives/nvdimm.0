Return-Path: <SRS0=Uutd=3R=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74992C33CB3
	for <linux-nvdimm@archiver.kernel.org>; Tue, 28 Jan 2020 10:31:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 28F0821739
	for <linux-nvdimm@archiver.kernel.org>; Tue, 28 Jan 2020 10:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=smtp3s.online header.i=@smtp3s.online header.b="Wjnm1Wb8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28F0821739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=smtp3s.online
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C87B41007B8EB;
	Tue, 28 Jan 2020 02:34:45 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=62.210.31.104; helo=gluhwein.club; envelope-from=support@smtp3s.online; receiver=<UNKNOWN> 
Received: from gluhwein.club (smtp3s.online [62.210.31.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E891B1007B8E5
	for <linux-nvdimm@lists.01.org>; Tue, 28 Jan 2020 02:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtp3s.online; s=dkim; h=Message-Id:Date:Reply-To:MIME-Version:Content-Type
	:To:Subject:From:Sender:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=oVDlScDq9z93bbdKoIbuHAUBWYbsX1m835GfGKw3lzI=; b=Wjnm1Wb8YKEzvX7JmLYTTV97by
	a1EKZkKCqj9wTjbgWN37Xdmo+O7+4IoVbI17IYK0lCxvcoSNO2v38mnZbcQrr2wePtGRsnE5HmeQm
	g5z8Pgcf1bHOHURquD9mVkU+8V8jMfSkttBaUCYpX/sclkuvbCkpqGpZy18Q4cAQlttw=;
Received: (helo=163.64.uzpak.uz)
	}}by gluhwein.club with esmtpa (Exim 4.90_1)
	(envelope-from <support@smtp3s.online>)
	id 1iwO9S-00044x-9V
	for linux-nvdimm@lists.01.org; Tue, 28 Jan 2020 11:31:23 +0100
From: "Sarvar" <support@smtp3s.online>
Subject: Handmade of Uzbekistan
To: "linux-nvdimm" <linux-nvdimm@lists.01.org>
MIME-Version: 1.0
Organization: Expo Uz
Date: Tue, 28 Jan 2020 15:31:21 +0500
Message-Id: <E1iwO9S-00044x-9V@gluhwein.club>
Message-ID-Hash: SBUYUN4LR6YKFV3YXGPTBNG4HMKSXGGU
X-Message-ID-Hash: SBUYUN4LR6YKFV3YXGPTBNG4HMKSXGGU
X-MailFrom: support@smtp3s.online
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: Sarvar <summs2015@gmail.com>
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SBUYUN4LR6YKFV3YXGPTBNG4HMKSXGGU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The wood carving art of Uzbekistan is part of the Central Asian artistic heritage and its origins date back to antiquity. Uzbekistan today is one of the oldest centers of woodcarving art in Central Asia. Uzbek woodcarvers have long been famous for their craftsmanship. Wood carvers use elm and other local trees. Cotton or linseed oil is used to preserve surfaces. In the attachment, we present you a catalog of some of the art of our masters. We also inform you that we are ready to fulfill any individual orders and deliver to anywhere in the world. With respect, Expo Uz

Our contacts:

tel: +998970011771 - WhatsApp/Telegramm/Viber

e-mail: summs2015@gmail.com

Unsubscribe

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
