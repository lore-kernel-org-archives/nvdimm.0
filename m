Return-Path: <SRS0=VF5K=7A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E411C433DF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 18 May 2020 05:33:16 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FB70207D4
	for <linux-nvdimm@archiver.kernel.org>; Mon, 18 May 2020 05:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FB70207D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=dhl-express.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7011011DEDEEC;
	Sun, 17 May 2020 22:30:06 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=173.26.159.66; helo=mx.nettack.tech; envelope-from=notification@dhl-express.com; receiver=<UNKNOWN> 
Received: from mx.nettack.tech (173-26-159-66.client.mchsi.com [173.26.159.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EE92511DE954F
	for <linux-nvdimm@lists.01.org>; Sun, 17 May 2020 22:30:03 -0700 (PDT)
Received: from dhl-express.com (Unknown [69.61.84.242])
	by mx.nettack.tech with ESMTPA
	; Wed, 13 May 2020 16:32:04 -0500
From: DHL EXPRESS <notification@dhl-express.com>
To: linux-nvdimm@lists.01.org
Subject: Your shipment has arrived.
Date: 13 May 2020 14:30:12 -0700
Message-ID: <20200513143012.687C0B820FC749DD@dhl-express.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_33D55C3D.5218A78D"
Message-ID-Hash: B4NB73QPKJDBCC7EZQ2PGI3J6RVAQ6G3
X-Message-ID-Hash: B4NB73QPKJDBCC7EZQ2PGI3J6RVAQ6G3
X-MailFrom: notification@dhl-express.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/B4NB73QPKJDBCC7EZQ2PGI3J6RVAQ6G3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_33D55C3D.5218A78D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_33D55C3D.5218A78D--
