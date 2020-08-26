Return-Path: <SRS0=TU+8=CE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700CAC433E1
	for <linux-nvdimm@archiver.kernel.org>; Wed, 26 Aug 2020 07:38:40 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C88EC20767
	for <linux-nvdimm@archiver.kernel.org>; Wed, 26 Aug 2020 07:38:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=allanhaighhaulage.co.uk header.i=@allanhaighhaulage.co.uk header.b="SXWD8IzL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C88EC20767
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=getnada.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 95D5D1233C136;
	Wed, 26 Aug 2020 00:38:39 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.61.151.237; helo=rs237.mailgun.us; envelope-from=bounce+fbdc28.14fcfb-linux-nvdimm=lists.01.org@allanhaighhaulage.co.uk; receiver=<UNKNOWN> 
Received: from rs237.mailgun.us (rs237.mailgun.us [209.61.151.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with UTF8SMTPS id 01DC31214BB30
	for <linux-nvdimm@lists.01.org>; Wed, 26 Aug 2020 00:38:35 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=allanhaighhaulage.co.uk;
 q=dns/txt; s=pic; t=1598427516; h=Reply-To: Date: From: To: Subject:
 MIME-Version: Content-Type: Message-Id: Sender;
 bh=WFt+PF/ub5XSE2ahfvPIdhtDHcW9URqbrJi5sW0zOCQ=; b=SXWD8IzLoc81IPYXAnRRrvVNSmcrzYji0bUz8iqZ3yhDSRKzChUS78sXuP1xhfQE01AGPq/F
 xN6TYqSZ0HNpUSHYWKWygubj70+iYHxIrEG7K/f5b+Uv0bD4KNL+Ejn05mNhkMfQ72nOJsyQ
 4kW7TA0I/56rJLEgA+tFtJMm5ho=
X-Mailgun-Sending-Ip: 209.61.151.237
X-Mailgun-Sid: WyI4ZTAxYiIsICJsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnIiwgIjE0ZmNmYiJd
Received: from [192.168.8.100] (<unknown> [154.118.47.180]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f4611794bd493d13eb594ed; Wed, 26 Aug 2020 07:38:33 GMT
Sender: msachez=getnada.com@allanhaighhaulage.co.uk
Message-Id: <20200826073833.b7ff0bb9e1ed4354@allanhaighhaulage.co.uk>
MIME-Version: 1.0
Subject: Business Partnership.
To: linux-nvdimm@lists.01.org
From: Miguel Sanchez <msachez@getnada.com>
Date: Wed, 26 Aug 2020 15:38:25 +0800
Message-ID-Hash: JENKJNWBJ4BHZKL7557IZ7G46R4XHVGX
X-Message-ID-Hash: JENKJNWBJ4BHZKL7557IZ7G46R4XHVGX
X-MailFrom: bounce+fbdc28.14fcfb-linux-nvdimm=lists.01.org@allanhaighhaulage.co.uk
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Description: Mail message body
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: msanchez2@163.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/JENKJNWBJ4BHZKL7557IZ7G46R4XHVGX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello, I have a proposal that would be beneficial to you. Kindly get back to me. Miguel Sanchez.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
