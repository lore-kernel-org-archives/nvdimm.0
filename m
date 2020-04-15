Return-Path: <SRS0=2TNe=57=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC43C3815B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Apr 2020 11:47:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BAE3E21655
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Apr 2020 11:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=foursquaremedia.co.in header.i=@foursquaremedia.co.in header.b="SUmQqXkN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAE3E21655
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=yasuda-shipyard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 57BD01010631A;
	Wed, 15 Apr 2020 04:47:46 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=192.163.213.48; helo=vps.99businesssolutions.com; envelope-from=s.sone@yasuda-shipyard.com; receiver=<UNKNOWN> 
Received: from vps.99businesssolutions.com (192-163-213-48.unifiedlayer.com [192.163.213.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B705A1010631B
	for <linux-nvdimm@lists.01.org>; Wed, 15 Apr 2020 04:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=foursquaremedia.co.in; s=default; h=Content-Type:MIME-Version:Message-ID:
	Date:Subject:To:From:Reply-To:Sender:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EHIE2Osd1tA4rLayexwOEQlKw2DMxbwXovC8PYGNPow=; b=SUmQqXkNKZ2jkg5NXxoQqnCWiL
	yEv11ytR20/0nedVzG90/nYninecaurDPSW0opV8WIII75+SKDJPnUcJKgIF/VGK5KM9a9wqYejpt
	r8CIlMKHNqp80OMkYIpJb128I1oyORQC7c2gMWJQGr1CHUBvm6jqPBA2H5jpeTvoJ/yY=;
Received: from [37.49.230.116] (port=54670 helo=yasuda-shipyard.com)
	by vps.99businesssolutions.com with esmtpa (Exim 4.93)
	(envelope-from <s.sone@yasuda-shipyard.com>)
	id 1jOgVc-00086z-7z
	for linux-nvdimm@lists.01.org; Wed, 15 Apr 2020 17:17:12 +0530
From: s.sone@yasuda-shipyard.com<s.sone@yasuda-shipyard.com>
To: linux-nvdimm@lists.01.org
Subject: Coral Sky General Trading L.L.C[Urgent Order]
Date: 15 Apr 2020 13:47:11 +0200
Message-ID: <20200415134711.A80B03B2E671AFF2@yasuda-shipyard.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_7648AA34.677CD440"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - vps.99businesssolutions.com
X-AntiAbuse: Original Domain - lists.01.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - yasuda-shipyard.com
X-Get-Message-Sender-Via: vps.99businesssolutions.com: authenticated_id: info@foursquaremedia.co.in
X-Authenticated-Sender: vps.99businesssolutions.com: info@foursquaremedia.co.in
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Message-ID-Hash: 3YYAWQG7STOHJBU2BQPVCM3Q3MDCPI5B
X-Message-ID-Hash: 3YYAWQG7STOHJBU2BQPVCM3Q3MDCPI5B
X-MailFrom: s.sone@yasuda-shipyard.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: s.sone@yasuda-shipyard.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3YYAWQG7STOHJBU2BQPVCM3Q3MDCPI5B/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_7648AA34.677CD440
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_7648AA34.677CD440--
