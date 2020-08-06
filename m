Return-Path: <SRS0=w3VX=BQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B3AC433E1
	for <linux-nvdimm@archiver.kernel.org>; Thu,  6 Aug 2020 11:03:11 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF55A22CA1
	for <linux-nvdimm@archiver.kernel.org>; Thu,  6 Aug 2020 11:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF55A22CA1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hinet.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 50C2412967E61;
	Wed,  5 Aug 2020 23:14:51 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=162.241.204.248; helo=162-241-204-248.unifiedlayer.com; envelope-from=server@hinet.net; receiver=<UNKNOWN> 
Received: from 162-241-204-248.unifiedlayer.com (unknown [162.241.204.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9303F12967E5F
	for <linux-nvdimm@lists.01.org>; Wed,  5 Aug 2020 23:14:48 -0700 (PDT)
Received: from [45.137.22.67] (port=56764 helo=hinet.net)
	by server.radhashyampaints.partners with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <server@hinet.net>)
	id 1k3ZAh-0009x2-Te
	for linux-nvdimm@lists.01.org; Thu, 06 Aug 2020 06:14:37 +0000
From: Daniel Chen < server@hinet.net>
To: linux-nvdimm@lists.01.org
Subject: Immediate quote required
Date: 5 Aug 2020 23:14:35 -0700
Message-ID: <20200805231435.D7EF90CD4EB699EE@hinet.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_625146C4.6C9811DA"
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
Message-ID-Hash: 3DBHMFYJP4Y7SIUU6WDSU3NF33XOINWW
X-Message-ID-Hash: 3DBHMFYJP4Y7SIUU6WDSU3NF33XOINWW
X-MailFrom: server@hinet.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3DBHMFYJP4Y7SIUU6WDSU3NF33XOINWW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_625146C4.6C9811DA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_625146C4.6C9811DA--
