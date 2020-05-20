Return-Path: <SRS0=4SdM=7C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930F5C433DF
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 May 2020 09:52:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7A40208C3
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 May 2020 09:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=weber-monitiq.gq header.i=sales@weber-monitiq.gq header.b="LUeajtvQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A40208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=weber-monitiq.gq
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3274E11F2B603;
	Wed, 20 May 2020 02:49:34 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.95.171.105; helo=rdns0.weber-monitiq.gq; envelope-from=sales@weber-monitiq.gq; receiver=<UNKNOWN> 
Received: from rdns0.weber-monitiq.gq (rdns0.weber-monitiq.gq [45.95.171.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E803711F2B5C0
	for <linux-nvdimm@lists.01.org>; Wed, 20 May 2020 02:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=weber-monitiq.gq;
 h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
 i=sales@weber-monitiq.gq;
 bh=GS64GblZjkoFIKvwh9DPfKwMBKK3VclfPrJ8a//ulaA=;
 b=LUeajtvQsv9NW8G9tTTKGFfmTHeK/oK8JI/PqnJG/szYlNstyYQhSMaJ0OFiKxt35uJdSw6ITNNe
   /ZrYEEYpFw8atBlNz6FzY/uml0+J76BTQ0oYf0wtI9gYSxcQsvLt/eirvHnbYpIRTAv+wmDTdAwr
   JH/L279y4r1gKYfvcg4=
From: "Abdul Rauf"<sales@weber-monitiq.gq>
To: linux-nvdimm@lists.01.org
Subject: Item Rates & Packing List For Your Reference - Weber Monitiq Ltd
Date: 20 May 2020 02:52:50 -0700
Message-ID: <20200520025250.1CFADEF77F28F7FF@weber-monitiq.gq>
MIME-Version: 1.0
Message-ID-Hash: LS56MEGOX3RTSS3RB67QULLSY6WABYQT
X-Message-ID-Hash: LS56MEGOX3RTSS3RB67QULLSY6WABYQT
X-MailFrom: sales@weber-monitiq.gq
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LS56MEGOX3RTSS3RB67QULLSY6WABYQT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dear linux-nvdimm,

Attached packing list has been sent on behalf of our customer.

Kindly review and confirm receipt of packing list as attached.

I await your reply.



Regards

Abdul Rauf

Weber Monitiq LTD
Unit 6,
55 Hastings Road,
Leicester,
Leicestershire,
LE5 0BT

Tel: 0044 1163741222
Mob: 0044 7958262557
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
