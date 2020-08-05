Return-Path: <SRS0=4vrS=BP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SPACE_RATIO autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861E6C433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Aug 2020 10:43:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B2542173E
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Aug 2020 10:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B2542173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hinet.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EF7EA128BB399;
	Wed,  5 Aug 2020 03:43:09 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=162.241.204.248; helo=162-241-204-248.unifiedlayer.com; envelope-from=server@hinet.net; receiver=<UNKNOWN> 
Received: from 162-241-204-248.unifiedlayer.com (unknown [162.241.204.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D60A312866BCB
	for <linux-nvdimm@lists.01.org>; Wed,  5 Aug 2020 03:43:06 -0700 (PDT)
Received: from [45.137.22.67] (port=52686 helo=hinet.net)
	by server.radhashyampaints.partners with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <server@hinet.net>)
	id 1k3Gst-0008Wh-DI
	for linux-nvdimm@lists.01.org; Wed, 05 Aug 2020 10:43:00 +0000
From: Daniel Chen < server@hinet.net>
To: linux-nvdimm@lists.01.org
Subject: Immediate quote required
Date: 5 Aug 2020 03:42:58 -0700
Message-ID: <20200805034258.E8D195D85518F317@hinet.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_40A7D0D8.0F6E24E2"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server.radhashyampaints.partners
X-AntiAbuse: Original Domain - lists.01.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - hinet.net
X-Get-Message-Sender-Via: server.radhashyampaints.partners: authenticated_id: server@hinet.net
X-Authenticated-Sender: server.radhashyampaints.partners: server@hinet.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Message-ID-Hash: PDMYQARL3ZZCV6FPO4T7YM4JKPLQ7FQ3
X-Message-ID-Hash: PDMYQARL3ZZCV6FPO4T7YM4JKPLQ7FQ3
X-MailFrom: server@hinet.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PDMYQARL3ZZCV6FPO4T7YM4JKPLQ7FQ3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_40A7D0D8.0F6E24E2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_40A7D0D8.0F6E24E2--
