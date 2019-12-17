Return-Path: <SRS0=lqgf=2H=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_ADSP_ALL,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF6FC43603
	for <linux-nvdimm@archiver.kernel.org>; Tue, 17 Dec 2019 13:13:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA90D206EC
	for <linux-nvdimm@archiver.kernel.org>; Tue, 17 Dec 2019 13:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA90D206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mail.ua
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D36E410113636;
	Tue, 17 Dec 2019 05:16:30 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=78.110.60.89; helo=78-110-60-89.net.hts.ru; envelope-from=info-sent@mail.ua; receiver=<UNKNOWN> 
Received: from 78-110-60-89.net.hts.ru (unknown [78.110.60.89])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 52E4210113631
	for <linux-nvdimm@lists.01.org>; Tue, 17 Dec 2019 05:16:27 -0800 (PST)
Message-ID: <6993D894994D684B9792DB5B7FEE751F@mail.ua>
From: =?windows-1251?B?0+rw4L/t8fzq4CDq4OLu4uAg6u7s7+Dts/8=?= <info-sent@mail.ua>
To: <linux-nvdimm@lists.01.org>
Subject: =?windows-1251?B?yvDg+bMg8e7w8ugg6uDi6CDy4CD34P4gLSDT?=
	=?windows-1251?B?6vDgv+3x/OrgIOrg4u7i4CDq7uzv4O2z/yE=?=
Date: Tue, 17 Dec 2019 15:13:02 +0200
MIME-Version: 1.0
Message-ID-Hash: DVU2XYLPIWNUKIOP4EOKRMTCEUNWVQTF
X-Message-ID-Hash: DVU2XYLPIWNUKIOP4EOKRMTCEUNWVQTF
X-MailFrom: info-sent@mail.ua
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DVU2XYLPIWNUKIOP4EOKRMTCEUNWVQTF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

1111111111111111
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
