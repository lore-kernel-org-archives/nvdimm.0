Return-Path: <SRS0=bCLp=FZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.8 required=3.0 tests=BAYES_99,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFB2C433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 14:57:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE5B222B45
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 14:57:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE5B222B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=freightquote.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E8271100EC1CD;
	Mon, 21 Dec 2020 06:57:04 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=89.97.205.202; helo=89-97-205-202.ip19.fastwebnet.it; envelope-from=nimblestl018@mail11.mailinglist.brt.it; receiver=<UNKNOWN> 
Received: from 89-97-205-202.ip19.fastwebnet.it (89-97-205-202.ip19.fastwebnet.it [89.97.205.202])
	by ml01.01.org (Postfix) with ESMTP id 87C88100ED4A7
	for <linux-nvdimm@lists.01.org>; Mon, 21 Dec 2020 06:57:01 -0800 (PST)
Received: from [56.164.18.33] (account rompedxcq836@mail5.mailinglist.brt.it HELO byee.mgaegjkm.zjc)
	by 89-97-205-202.ip19.fastwebnet.it (Postfix)
	with esmtpa id 22545AF7A086 for linux-nvdimm@lists.01.org; Mon, 21 Dec 2020 15:57:00 +0100
Received: from  (
 [165.123.154.17])        by 89-97-205-202.ip19.fastwebnet.it with SMTP id
 vnf927c46iqhegs.4.20201221155700; Mon, 21 Dec 2020 15:57:00 +0100
Date: Mon, 21 Dec 2020 15:57:00 +0100
From: <customerservice@freightquote.com>
To: linux-nvdimm@lists.01.org
Message-ID: <213865.20201221155700@uk.phey.zpc>
Subject: BOL for Order# 186542
MIME-Version: 1.0
Priority: normal
Message-ID-Hash: VW3XMD7QOAGXIJCIVOCA7IMV76WLWFZI
X-Message-ID-Hash: VW3XMD7QOAGXIJCIVOCA7IMV76WLWFZI
X-MailFrom: nimblestl018@mail11.mailinglist.brt.it
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: customerservice@freightquote.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VW3XMD7QOAGXIJCIVOCA7IMV76WLWFZI/>
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
