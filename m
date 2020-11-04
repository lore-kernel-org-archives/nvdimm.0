Return-Path: <SRS0=OyRv=EK=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E36EC2D0A3
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Nov 2020 17:37:14 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E70BA20795
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Nov 2020 17:37:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E70BA20795
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=adp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4B12316511341;
	Wed,  4 Nov 2020 09:37:13 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=182.183.206.180; helo=[182.183.206.180]; envelope-from=syllabifiedfui5@dc1prppedgevm03.ga.adp.com; receiver=<UNKNOWN> 
Received: from [182.183.206.180] (unknown [182.183.206.180])
	by ml01.01.org (Postfix) with ESMTP id 9EB131651131F
	for <linux-nvdimm@lists.01.org>; Wed,  4 Nov 2020 09:32:21 -0800 (PST)
Received: from  (
 [150.64.55.197])        by  with SMTP id
 FSAj5ACEcf1faFE.055; Wed, 4 Nov 2020 09:32:20 -0800
Subject: ADP Payroll Invoice(s) 04-NOV-2020: 918043732
From: run.payroll.invoice@adp.com
To: linux-nvdimm@lists.01.org
MIME-Version: 1.0
Message-ID: <62a076bb71d25ff101376954@xlyl.dc1prppedgevm03.ga.adp.com>
X-Priority: 3
Date: Wed, 4 Nov 2020 09:32:20 -0800
Message-ID-Hash: YFOQEZKWR5M4KMZN3FT46Z64IGCTUJ3B
X-Message-ID-Hash: YFOQEZKWR5M4KMZN3FT46Z64IGCTUJ3B
X-MailFrom: syllabifiedfui5@dc1prppedgevm03.ga.adp.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YFOQEZKWR5M4KMZN3FT46Z64IGCTUJ3B/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 Your ADP Payroll invoice for last week is attached for your review. If you have any questions regarding this invoice, please contact your ADP service team for assistance.Thank you for choosing ADP Payroll.Important: Please do not respond to this message. It comes from an unattended mailbox.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
