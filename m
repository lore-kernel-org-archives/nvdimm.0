Return-Path: <SRS0=OD74=EZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D41C63697
	for <linux-nvdimm@archiver.kernel.org>; Thu, 19 Nov 2020 13:18:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F230322255
	for <linux-nvdimm@archiver.kernel.org>; Thu, 19 Nov 2020 13:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F230322255
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=ups.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5334B100EBB8B;
	Thu, 19 Nov 2020 05:18:29 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=37.73.82.41; helo=[37.73.82.41]; envelope-from=correspondencedr1@njrarlpapp001cc.linux.us.ups.com; receiver=<UNKNOWN> 
Received: from [37.73.82.41] (unknown [37.73.82.41])
	by ml01.01.org (Postfix) with ESMTP id A17A5100EBBB6
	for <linux-nvdimm@lists.01.org>; Thu, 19 Nov 2020 05:18:20 -0800 (PST)
Received: from  (
 [200.201.101.173])        by  with SMTP id
 fcEF0515; Thu, 19 Nov 2020 15:18:19 +0200
Received: from  (
 [150.146.81.145])        by  with SMTP id
 F42F5A6F36; Thu, 19 Nov 2020 15:18:19 +0200
To: linux-nvdimm@lists.01.org
From: upsbillingcenter@ups.com
Subject: Your UPS Invoice is Ready
Message-ID: <fc40b251-2916-5682-0985-@runvvzbs.nnapwvvtr.njrarlpapp001cc.linux.us.ups.com>
Date: Thu, 19 Nov 2020 15:18:19 +0200
MIME-Version: 1.0
Message-ID-Hash: 6T4SL2F6BHOZJUET53P4LEWUZ7AINGJX
X-Message-ID-Hash: 6T4SL2F6BHOZJUET53P4LEWUZ7AINGJX
X-MailFrom: correspondencedr1@njrarlpapp001cc.linux.us.ups.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: upsbillingcenter@ups.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/6T4SL2F6BHOZJUET53P4LEWUZ7AINGJX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
