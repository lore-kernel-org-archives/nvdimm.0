Return-Path: <SRS0=4/NT=6E=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8785C3815B
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Apr 2020 07:36:32 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 651102078C
	for <linux-nvdimm@archiver.kernel.org>; Mon, 20 Apr 2020 07:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 651102078C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=daehwagm.co.kr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9A6E5100A026A;
	Mon, 20 Apr 2020 00:36:29 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=142.11.249.189; helo=daehwagm.co.kr; envelope-from=sung@daehwagm.co.kr; receiver=<UNKNOWN> 
Received: from daehwagm.co.kr (hwsrv-714897.hostwindsdns.com [142.11.249.189])
	by ml01.01.org (Postfix) with ESMTP id 8CF47100A0268
	for <linux-nvdimm@lists.01.org>; Mon, 20 Apr 2020 00:36:12 -0700 (PDT)
From: sung <sung@daehwagm.co.kr>
To: linux-nvdimm@lists.01.org
Subject: RE:RFQ-1324455663 API 5L X 60
Date: 20 Apr 2020 00:36:14 -0700
Message-ID: <20200420003613.26A8CD8EE47CF804@daehwagm.co.kr>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_5381D011.5F717A3B"
Message-ID-Hash: 4IWPGFDOBEDEA4UJ7OQYKA2UK67NM3JD
X-Message-ID-Hash: 4IWPGFDOBEDEA4UJ7OQYKA2UK67NM3JD
X-MailFrom: sung@daehwagm.co.kr
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4IWPGFDOBEDEA4UJ7OQYKA2UK67NM3JD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_5381D011.5F717A3B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_5381D011.5F717A3B--
