Return-Path: <SRS0=X/oK=2I=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAE1C43603
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Dec 2019 01:46:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26D14206EC
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Dec 2019 01:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26D14206EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=oy.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0E87010113636;
	Tue, 17 Dec 2019 17:49:47 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=58.50.70.116; helo=oy.net; envelope-from=mcqxe@oy.net; receiver=<UNKNOWN> 
Received: from oy.net (unknown [58.50.70.116])
	by ml01.01.org (Postfix) with ESMTP id 0AC2610113626
	for <linux-nvdimm@lists.01.org>; Tue, 17 Dec 2019 17:49:40 -0800 (PST)
Message-ID: <C3368E9EB903D1E77FF5885EE1165567@oy.net>
From: =?utf-8?B?6IOh57uP55CG?= <mcqxe@oy.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?56CU5Y+R6aG555uu566h55CG5Y+K5Lq65ZGY55qE6ICD5qC45LiO5r+A5YqxbGludXg=?=
	=?utf-8?B?LW52ZGltbUBsaXN0cy4wMS5vcmc=?=
Date: Wed, 18 Dec 2019 09:46:15 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: W75YO66YIYYGW6BRVM66SHLLUPRT5WER
X-Message-ID-Hash: W75YO66YIYYGW6BRVM66SHLLUPRT5WER
X-MailFrom: mcqxe@oy.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/W75YO66YIYYGW6BRVM66SHLLUPRT5WER/>
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
