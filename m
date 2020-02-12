Return-Path: <SRS0=sp4a=4A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	SUBJ_ALL_CAPS,TVD_SPACE_RATIO autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9680FC2BA83
	for <linux-nvdimm@archiver.kernel.org>; Wed, 12 Feb 2020 10:37:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69D3821739
	for <linux-nvdimm@archiver.kernel.org>; Wed, 12 Feb 2020 10:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=taishengglass.co header.i=@taishengglass.co header.b="ClwxsK3V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69D3821739
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aerocorpevionics.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5B35610FC3367;
	Wed, 12 Feb 2020 02:40:54 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=111.90.145.245; helo=server101620.domain.local; envelope-from=lzulueta@aerocorpevionics.com; receiver=<UNKNOWN> 
Received: from server101620.domain.local (taishengglass.co [111.90.145.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C6BF210FC3180
	for <linux-nvdimm@lists.01.org>; Wed, 12 Feb 2020 02:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=taishengglass.co; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Reply-To:From:Date:Subject:To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gQ5VJ+nguGmxCa1ITOjnBr3JX6NyPDi0+ba2k0G5UPo=; b=ClwxsK3VOHhcfWwoCL8W/l6CkR
	A8AhV49xhMPC4qzG1HuGX5tJ0ENL/M+LsepvluUwT/whJnYxQ7nHGY4MPW7Cj9hi0hQDP8lnQd9lO
	bNtj6j+K2PF8W8eD9nK1S1JzrjgR2oNWaEI9jNJdGgo7l+XVfY3EgQ2C+0GFgS5HpMXOSt0bqGpmB
	eThakPLuaZFcJHbUj3GtqUu/5e63rocip+AvWfp8Dg3H64Bq0clJ7X85uqjg0yDGWiNGcNa8rAQ9k
	QtA1GRnmO2RnACxz/oD1ZofASsD/lQ3Dvm8k40VQSfvKljITN+B0UHvrCcfafvhEiTltikSYXAuXC
	52oWlMDg==;
Received: from taishengglass by server101620.domain.local with local (Exim 4.92)
	(envelope-from <lzulueta@aerocorpevionics.com>)
	id 1j1pOc-0004zs-GS
	for linux-nvdimm@lists.01.org; Wed, 12 Feb 2020 18:37:30 +0800
To: linux-nvdimm@lists.01.org
Subject: SALES/PRODUCT INQUIRY
X-PHP-Script: taishengglass.co/ak/prolearner.php for 5.62.34.43
X-PHP-Originating-Script: 1001:prolearner.php
Date: Wed, 12 Feb 2020 10:37:30 +0000
From: Lily Tran Zulueta <lzulueta@aerocorpevionics.com>
Message-ID: <b243dace2653eed9507b6f20bd708ae4@taishengglass.co>
X-Mailer: Leaf PHPMailer 2.7 (leafmailer.pw)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="b1_b243dace2653eed9507b6f20bd708ae4"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server101620.domain.local
X-AntiAbuse: Original Domain - lists.01.org
X-AntiAbuse: Originator/Caller UID/GID - [1001 994] / [47 12]
X-AntiAbuse: Sender Address Domain - aerocorpevionics.com
X-Get-Message-Sender-Via: server101620.domain.local: authenticated_id: taishengglass/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: server101620.domain.local: taishengglass
X-Source: 
X-Source-Args: /opt/cpanel/ea-php54/root/usr/bin/php-cgi 
X-Source-Dir: taishengglass.co:/public_html/ak
Content-Transfer-Encoding: 7bit
Message-ID-Hash: 5KECB6VZF5FK7POIQMEEZ4ANC4NHUSQP
X-Message-ID-Hash: 5KECB6VZF5FK7POIQMEEZ4ANC4NHUSQP
X-MailFrom: lzulueta@aerocorpevionics.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: nysreydet@gmail.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5KECB6VZF5FK7POIQMEEZ4ANC4NHUSQP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

--b1_b243dace2653eed9507b6f20bd708ae4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--b1_b243dace2653eed9507b6f20bd708ae4--
