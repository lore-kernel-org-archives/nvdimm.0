Return-Path: <SRS0=mfYO=6U=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5468C28CBC
	for <linux-nvdimm@archiver.kernel.org>; Wed,  6 May 2020 16:08:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8302A20736
	for <linux-nvdimm@archiver.kernel.org>; Wed,  6 May 2020 16:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8302A20736
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=irie.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9C544116D7934;
	Wed,  6 May 2020 09:06:58 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=124.219.160.254; helo=irie.jp; envelope-from=postmaster@irie.jp; receiver=<UNKNOWN> 
Received: from irie.jp (p7cdba0fe.hyogff01.ap.so-net.ne.jp [124.219.160.254])
	by ml01.01.org (Postfix) with SMTP id 7C954116D7931
	for <linux-nvdimm@lists.01.org>; Wed,  6 May 2020 09:06:56 -0700 (PDT)
Received: (qmail 12029 invoked by uid 0); 6 May 2020 15:31:57 +0900
Received: from unknown (HELO irie.jp) (postmaster@irie.jp@46.38.145.171)
  by 0 with SMTP; 6 May 2020 15:31:57 +0900
From: "SF EXPRESS" <postmaster@irie.jp>
To: linux-nvdimm@lists.01.org
Subject: =?UTF-8?B?6LSn6L+Q6YCa55+lICA=?=
Date: 05 May 2020 23:39:01 -0700
Message-ID: <20200505145705.3AA270ECBA27EA60@irie.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_879CE635.89E72ADA"
Message-ID-Hash: MEWENAX7TBVULXQDNVIS6WHM4WZ6W7KR
X-Message-ID-Hash: MEWENAX7TBVULXQDNVIS6WHM4WZ6W7KR
X-MailFrom: postmaster@irie.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MEWENAX7TBVULXQDNVIS6WHM4WZ6W7KR/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_879CE635.89E72ADA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_879CE635.89E72ADA--
