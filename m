Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBF0C433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 09:49:13 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DC5A206CD
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 09:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DC5A206CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gurkhaguard.com.hk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5DD8011075BCF;
	Tue,  7 Jul 2020 02:49:13 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=37.49.224.4; helo=gurkhaguard.com.hk; envelope-from=kimmy@gurkhaguard.com.hk; receiver=<UNKNOWN> 
Received: from gurkhaguard.com.hk (unknown [37.49.224.4])
	by ml01.01.org (Postfix) with ESMTP id 92FD7110122B1
	for <linux-nvdimm@lists.01.org>; Tue,  7 Jul 2020 02:49:09 -0700 (PDT)
From: GGS <ringo@gurkhaguard.com.hk>
To: linux-nvdimm@lists.01.org
Subject: =?UTF-8?B?5Li75peoOiBQYXltZW50IGhhcyBiZWVuIG1hZGUgYnkgRmlyc3QgRXJhIExpbWl0ZWQgZm9yIEd1cmtoYSBHdWFyZCBTZXJ2aWNlTHRkIGZvciAkIDQ3?=,000.00
Date: 7 Jul 2020 11:49:08 +0200
Message-ID: <20200707114908.B05C78C37D0A736C@gurkhaguard.com.hk>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_E0162DCD.350198C9"
Message-ID-Hash: MZ4SM7273R5PUP224POEZSONHTL6OXHI
X-Message-ID-Hash: MZ4SM7273R5PUP224POEZSONHTL6OXHI
X-MailFrom: kimmy@gurkhaguard.com.hk
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MZ4SM7273R5PUP224POEZSONHTL6OXHI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_E0162DCD.350198C9
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_E0162DCD.350198C9--
