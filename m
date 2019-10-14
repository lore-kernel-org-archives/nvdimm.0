Return-Path: <SRS0=LwSK=YH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DEBC4CECE
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Oct 2019 09:50:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8EA4320663
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Oct 2019 09:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EA4320663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=helqlp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D235710FC6CD2;
	Mon, 14 Oct 2019 02:53:20 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=111.176.72.10; helo=helqlp.com; envelope-from=wa@helqlp.com; receiver=<UNKNOWN> 
Received: from helqlp.com (unknown [111.176.72.10])
	by ml01.01.org (Postfix) with ESMTP id 618A510FC6CCF
	for <linux-nvdimm@lists.01.org>; Mon, 14 Oct 2019 02:53:18 -0700 (PDT)
Message-ID: <A81D8E1688C6CD53EFDE351EB05DA0A1@helqlp.com>
From: =?utf-8?B?5L2V57uP55CG?= <wa@helqlp.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?NDAyODU3562U5aSN77ya?=
Date: Mon, 14 Oct 2019 17:50:16 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: TDXNSORBGC2JNAIHEXWJQSIVG2QWXUEY
X-Message-ID-Hash: TDXNSORBGC2JNAIHEXWJQSIVG2QWXUEY
X-MailFrom: wa@helqlp.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TDXNSORBGC2JNAIHEXWJQSIVG2QWXUEY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

6L2sICDlj5EuLi4uLi4NCuWPkeS7tuS6ujogIuS9lee7j+eQhiI7PHdhQGhlbHFscC5jb20+DQrl
j5HpgIHml7bpl7Q6IDIwMTktMTAtMTQvIDE3OjUwOjIyDQrmlLbku7bkuro6ICJsaW51eC1udmRp
bW0iPGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmc+DQogCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxp
bnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
