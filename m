Return-Path: <SRS0=bCLp=FZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_95,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9022EC433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 15:31:27 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4467D22C97
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 15:31:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4467D22C97
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=freightquote.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E5973100EC1D5;
	Mon, 21 Dec 2020 07:31:26 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=79.7.246.12; helo=host-79-7-246-12.business.telecomitalia.it; envelope-from=veeredyr55@chr1pr1ex72.chrobinson.com; receiver=<UNKNOWN> 
Received: from host-79-7-246-12.business.telecomitalia.it (host-79-7-246-12.business.telecomitalia.it [79.7.246.12])
	by ml01.01.org (Postfix) with ESMTP id 5C90F100EC1C3
	for <linux-nvdimm@lists.01.org>; Mon, 21 Dec 2020 07:25:00 -0800 (PST)
Received: from  (
 [104.62.156.90])        by host-79-7-246-12.business.telecomitalia.it with SMTP id
 fb88a13A; Mon, 21 Dec 2020 16:24:59 +0100
Subject: BOL for Order# 228433
From: <customerservice@freightquote.com>
To: linux-nvdimm@lists.01.org
MIME-Version: 1.0
Message-ID: <e2d1e2c5-67f2-6382-19f7-@unqucrec.htywrd.qgm>
X-Priority: 3
Date: Mon, 21 Dec 2020 16:24:59 +0100
Message-ID-Hash: 5VFKKFVRSIJAZCAI5HAUWSBDCLI4INWQ
X-Message-ID-Hash: 5VFKKFVRSIJAZCAI5HAUWSBDCLI4INWQ
X-MailFrom: veeredyr55@CHR1PR1EX72.chrobinson.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5VFKKFVRSIJAZCAI5HAUWSBDCLI4INWQ/>
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
