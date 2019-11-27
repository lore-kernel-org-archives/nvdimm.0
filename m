Return-Path: <SRS0=exTn=ZT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC22C432C0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 27 Nov 2019 00:15:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 222C3206BF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 27 Nov 2019 00:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 222C3206BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kc.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8C48210113317;
	Tue, 26 Nov 2019 16:18:15 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=122.191.125.164; helo=kc.com; envelope-from=tavlyymex@kc.com; receiver=<UNKNOWN> 
Received: from kc.com (unknown [122.191.125.164])
	by ml01.01.org (Postfix) with ESMTP id 4C3FF1011330C
	for <linux-nvdimm@lists.01.org>; Tue, 26 Nov 2019 16:18:10 -0800 (PST)
Message-ID: <F2E471770B50F3CE336DFEBD86F1B7C0@kc.com>
From: =?utf-8?B?5LiB57uP55CG?= <tavlyymex@kc.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?MTc5MCDmlrDml6dRQ+S4g+Wkp+aJi+azlTExLzI5LTM=?=
	=?utf-8?B?MC/lub/lt54=?=
Date: Wed, 27 Nov 2019 08:14:43 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: O2RY7LUZOZRT2OTNE6W7CGXKOV4GUTZX
X-Message-ID-Hash: O2RY7LUZOZRT2OTNE6W7CGXKOV4GUTZX
X-MailFrom: tavlyymex@kc.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/O2RY7LUZOZRT2OTNE6W7CGXKOV4GUTZX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5p2l6IeqbGludXgtbnZkaW1t55qE6YKu5Lu2Li4uLi4uCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxp
bnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
