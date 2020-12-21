Return-Path: <SRS0=bCLp=FZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_95,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B95AC433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 16:33:44 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F77022ADF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 16:33:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F77022ADF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=freightquote.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 61C24100EC1E1;
	Mon, 21 Dec 2020 08:33:43 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=103.107.252.255; helo=host103-107-253-255.hustel.net; envelope-from=rowland4490@chr1pr1ex72.chrobinson.com; receiver=<UNKNOWN> 
Received: from host103-107-253-255.hustel.net (unknown [103.107.252.255])
	by ml01.01.org (Postfix) with ESMTP id 5A64A100EC1D6
	for <linux-nvdimm@lists.01.org>; Mon, 21 Dec 2020 08:33:27 -0800 (PST)
Received: from [179.80.100.31] (account resubmitted@mailgw8.chrobinson.com HELO er.nvmgp.vmj)
	by host103-107-253-255.hustel.net (Exim 4.89)
	with ESMTPA id 72A254005456 for linux-nvdimm@lists.01.org; Mon, 21 Dec 2020 22:03:35 +0530
Received: from [91.31.193.2] (helo=xw.yknwy.wgs)
	by host103-107-253-255.hustel.net with ESMTPA
	id k6mf9iab7go62co.0.20201221220335
	for linux-nvdimm@lists.01.org; Mon, 21 Dec 2020 22:03:35 +0530
Date: Mon, 21 Dec 2020 22:03:35 +0530
From: <customerservice@freightquote.com>
To: linux-nvdimm@lists.01.org
Subject: BOL for Order# 953629
MIME-Version: 1.0
Message-ID: <f942c732.d113cf50.db0778.d23831d3@yhudz.hpamjk.com>
Content-Language: us
Message-ID-Hash: AJ7EE557ZKELWBSMDOYG4P6IBHZC37FY
X-Message-ID-Hash: AJ7EE557ZKELWBSMDOYG4P6IBHZC37FY
X-MailFrom: rowland4490@CHR1PR1EX72.chrobinson.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AJ7EE557ZKELWBSMDOYG4P6IBHZC37FY/>
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
