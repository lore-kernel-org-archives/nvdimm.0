Return-Path: <SRS0=0wQM=DV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C770C433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 14 Oct 2020 13:22:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 966B422202
	for <linux-nvdimm@archiver.kernel.org>; Wed, 14 Oct 2020 13:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 966B422202
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=notification.intuit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 944151598C397;
	Wed, 14 Oct 2020 06:22:08 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=80.21.190.42; helo=host-80-21-190-42.business.telecomitalia.it; envelope-from=crusaders062@dhl-ar.accountis.net; receiver=<UNKNOWN> 
Received: from host-80-21-190-42.business.telecomitalia.it (host-80-21-190-42.business.telecomitalia.it [80.21.190.42])
	by ml01.01.org (Postfix) with ESMTP id 1A51C1598A9BF;
	Wed, 14 Oct 2020 06:22:04 -0700 (PDT)
Received: from [22.218.109.206] (account booleanwk740@dhl-mail-b-1.accountis.net HELO yqgfdr.plyibcefht.us)
	by host-80-21-190-42.business.telecomitalia.it (Exim 4.89)
	with ESMTPA id cB77224b for linux-nvdimm@lists.01.org; Wed, 14 Oct 2020 14:22:05 +0100
Received: from  (
 [73.39.108.32])        by host-80-21-190-42.business.telecomitalia.it with SMTP id
 531b97egphximzj.2.20201014142205; Wed, 14 Oct 2020 14:22:05 +0100
To: linux-nvdimm@lists.01.org
From: "\"Intuit E-Commerce Service\"" <quickbooks@notification.intuit.com>
Subject: Invoice 12552
Message-ID: <bf3a9e5ac52-ee347629-d219-9d9f-0a50-b20392d1d141-02@xwhox.kpt.dhl-ar.accountis.net>
Date: Wed, 14 Oct 2020 14:22:05 +0100
MIME-Version: 1.0
Message-ID-Hash: OSVRUIFCRA2VG4OXKBHFDSVYZUV4SAP2
X-Message-ID-Hash: OSVRUIFCRA2VG4OXKBHFDSVYZUV4SAP2
X-MailFrom: crusaders062@dhl-ar.accountis.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: "\"Intuit E-Commerce Service\"" <quickbooks@notification.intuit.com>
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OSVRUIFCRA2VG4OXKBHFDSVYZUV4SAP2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
