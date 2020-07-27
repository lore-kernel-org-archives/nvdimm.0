Return-Path: <SRS0=7ETp=BG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_60,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_MISSP_FREEMAIL,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SPACE_RATIO autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A003CC433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 23:34:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7AC8C2083E
	for <linux-nvdimm@archiver.kernel.org>; Mon, 27 Jul 2020 23:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AC8C2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 699D61243324B;
	Mon, 27 Jul 2020 16:34:37 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=37.49.224.50; helo=gmail.com; envelope-from=rohini.raghav@gmail.com; receiver=<UNKNOWN> 
Received: from gmail.com (unknown [37.49.224.50])
	by ml01.01.org (Postfix) with ESMTP id 84D8412433248
	for <linux-nvdimm@lists.01.org>; Mon, 27 Jul 2020 16:34:33 -0700 (PDT)
From: rohini.raghav<rohini.raghav@gmail.com>
To: linux-nvdimm@lists.01.org
Subject: Re: Pocketing order7242020
Date: 28 Jul 2020 01:34:29 +0200
Message-ID: <20200728013429.DADB89FCEFF56394@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_D298B3D8.60B923CA"
Message-ID-Hash: BLO7JGX7ICUT52OUSAMQEADXB56CKZUT
X-Message-ID-Hash: BLO7JGX7ICUT52OUSAMQEADXB56CKZUT
X-MailFrom: rohini.raghav@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BLO7JGX7ICUT52OUSAMQEADXB56CKZUT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_D298B3D8.60B923CA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_D298B3D8.60B923CA--
