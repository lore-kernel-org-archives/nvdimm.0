Return-Path: <SRS0=UChI=AT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FROM_WSP_TRAIL,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82F1C433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed,  8 Jul 2020 03:02:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AA33B20774
	for <linux-nvdimm@archiver.kernel.org>; Wed,  8 Jul 2020 03:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=snjbe.com header.i=@mail3.snjbe.com header.b="IOn2OzYz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA33B20774
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=globelinkvn.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 73A15110BA96D;
	Tue,  7 Jul 2020 20:02:09 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=164.90.144.134; helo=mail3.snjbe.com; envelope-from=purchase.exp@globelinkvn.com; receiver=<UNKNOWN> 
Received: from mail3.snjbe.com (bizcloud-send.snjbe.com [164.90.144.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9A3CB110B96A4
	for <linux-nvdimm@lists.01.org>; Tue,  7 Jul 2020 20:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=dkim; d=snjbe.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
 i=@mail3.snjbe.com;
 bh=ENeilKhRATtGuWEFrEAzpWS1tahIY1VwnVmtQr1PSBY=;
 b=IOn2OzYzVKB+Du7i8m+9KyRDK/ybe5EmGW9sx7bsuweb5Yvxffsr/fSZc42Kq+mPqtz8lnZ74moQ
   mA4UzcZPlBgf1lr0yQsYy4jKgSV0qHTqaML37E4RE+gJXu+27YpuhF1zKm3vZgzm0rOObxu19lnl
   ThAvl39AOmysqN098Sg=
From: Tuyen Bui <purchase.exp@globelinkvn.com >
To: linux-nvdimm@lists.01.org
Subject: Re: Proposed Qrder For Supplaying
Date: 8 Jul 2020 03:02:06 +0000
Message-ID: <20200708030206.AAAC7A52EDAC538F@globelinkvn.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_B26AF460.BFFF0420"
Message-ID-Hash: CYJSV7V52VQEX5ZK2RV4OI3TFSZEADNX
X-Message-ID-Hash: CYJSV7V52VQEX5ZK2RV4OI3TFSZEADNX
X-MailFrom: purchase.exp@globelinkvn.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: aftersalestsigkas@afoiliapi
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CYJSV7V52VQEX5ZK2RV4OI3TFSZEADNX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_B26AF460.BFFF0420
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_B26AF460.BFFF0420--
