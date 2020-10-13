Return-Path: <SRS0=scD+=DU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA60DC433E7
	for <linux-nvdimm@archiver.kernel.org>; Tue, 13 Oct 2020 08:11:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 60708207C3
	for <linux-nvdimm@archiver.kernel.org>; Tue, 13 Oct 2020 08:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fastestway24.com header.i=@fastestway24.com header.b="EZRLPtrS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60708207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fastestway24.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id DAFEB15830A7F;
	Tue, 13 Oct 2020 01:11:32 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=5.249.159.217; helo=mail.fastestway24.com; envelope-from=william.jones@fastestway24.com; receiver=<UNKNOWN> 
Received: from mail.fastestway24.com (mail.fastestway24.com [5.249.159.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 12CA415823012
	for <linux-nvdimm@lists.01.org>; Tue, 13 Oct 2020 01:11:30 -0700 (PDT)
Received: by mail.fastestway24.com (Postfix, from userid 1001)
	id B4A0AA2E50; Tue, 13 Oct 2020 09:11:22 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fastestway24.com;
	s=mail; t=1602576687;
	bh=YGOlxoddnI3PXnh41XMWUfU0z9xsorZLZcAPNbcZr/c=;
	h=Date:From:To:Subject:From;
	b=EZRLPtrSxp8bRUI+g61DcOgbyuQh/GHFTUXjzcXdsRe05tpil6r7D20FAnF52xMW7
	 aw5tpCc7BLjkJDKL5YPQ8M59h4CjeYPXmn2Ow9dcXu3Kv7DfMOLVzPazRTpM7i+rK2
	 RaGLy35QL6ao7pTHVsP7f6lymejkWHnfPlQ7TASzjIXLSVN4qwZY8Z5vEa0TF2nhvU
	 CWHjO0ZKN86/ncYZxMXytzgdvbi2r285f9PCXxwaO/oAOq2hbiD4kAD7ncmyFgqgyu
	 czjYLP5LqGEPBpVWomJ/BciSaw66POmHgihXWxQdLjipY9Z8vnNz4umikf29kiFami
	 e2+4OsOKkdV+Q==
Received: by mail.fastestway24.com for <linux-nvdimm@lists.01.org>; Tue, 13 Oct 2020 08:11:18 GMT
Message-ID: <20201013074502-0.1.4d.9khr.0.fcrfardta5@fastestway24.com>
Date: Tue, 13 Oct 2020 08:11:18 GMT
From: "William Jones" <william.jones@fastestway24.com>
To: <linux-nvdimm@lists.01.org>
Subject: Disinfectant
X-Mailer: mail.fastestway24.com
MIME-Version: 1.0
Message-ID-Hash: 7MHPC7N44IACUOBSZS2TTO4UBUVSTXMA
X-Message-ID-Hash: 7MHPC7N44IACUOBSZS2TTO4UBUVSTXMA
X-MailFrom: william.jones@fastestway24.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7MHPC7N44IACUOBSZS2TTO4UBUVSTXMA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Good morning,

looking for companies interested in raising additional capital by diversifying their offer in soaps, liquids and gels for hand disinfection and cosmetics for body and hair care.

The distribution of innovative products corresponding to the current preferences of customers in the field of hygiene and preventive healthcare allows our partners to gain new markets and achieve better economic results.

In addition to products with bactericidal action, our range includes shower gels, shampoos and hair conditioners, as well as efficient, concentrated detergents.

The versatility (suitable for all skin types) combined with an affordable price means that customers make an informed choice of a product among others available on the market.

Are you interested in cooperation?


William Jones
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
