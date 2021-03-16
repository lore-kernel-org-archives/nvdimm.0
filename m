Return-Path: <SRS0=FGGk=IO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD5AC433E6
	for <linux-nvdimm@archiver.kernel.org>; Tue, 16 Mar 2021 19:27:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C249664E4D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 16 Mar 2021 19:27:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C249664E4D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=conference21.biz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 98DF0100EBB9E;
	Tue, 16 Mar 2021 12:27:48 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=208.91.199.214; helo=us2-ob4-5.mailhostbox.com; envelope-from=kevin.rob@conference21.biz; receiver=<UNKNOWN> 
Received: from us2-ob4-5.mailhostbox.com (us2-ob4-5.mailhostbox.com [208.91.199.214])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DF428100EBB9C
	for <linux-nvdimm@lists.01.org>; Tue, 16 Mar 2021 12:27:45 -0700 (PDT)
Received: from DESKTOPCGVGNKH (unknown [157.45.157.34])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kevin.rob@conference21.biz)
	by us2.outbound.mailhostbox.com (Postfix) with ESMTPSA id 9C6A21C192D
	for <linux-nvdimm@lists.01.org>; Tue, 16 Mar 2021 19:27:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=conference21.biz;
	s=20210115; t=1615922864;
	bh=iQNU8WiuVEjjUFAvJT3JBjuwCH3tzyupw4DDopT4pGA=;
	h=From:To:Subject:Date;
	b=RUj5Ynsu1P/pcJdsfzQgomrZ47SjCPfGKoByNp4TE12cumSxgrKCRefPiAKYxesqZ
	 uXvjxQIjgHA3oKqSV8PKRNakE1/elcU7HKBtmtbtKyBE4jdzI4p5jS8+y7aBQX0jMb
	 vNtdlbGikTj9KE7L+jJ2q0/wjymfNX/zEBcDlPsU=
From: "Kevin Rob" <kevin.rob@conference21.biz>
To: <linux-nvdimm@lists.01.org>
Subject: Fintech Virtual 2021 Visitors List
Date: Tue, 16 Mar 2021 12:26:50 -0700
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAF8oXq68u+5AqDS4CeiUm9HCgAAAEAAAADfa7t0SsrlDgyMiKMEM+NsBAAAAAA==@conference21.biz>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdcamkKhWD2cecwtREqh+OZs3uo51A==
Content-Language: en-us
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=YrZxuLQX c=1 sm=1 tr=0
	a=qVdZ8gnkOi7ttGKuPb2jtA==:117 a=qVdZ8gnkOi7ttGKuPb2jtA==:17
	a=DAwyPP_o2Byb1YXLmDAA:9 a=P6fb_aSBUHYPBZy_Td8A:9 a=CjuIK1q_8ugA:10
	a=vH9TRLAwTU9BbFUGV30A:9 a=M4f8OiVYNRsRh4Ga:21 a=gKO2Hq4RSVkA:10
	a=UiCQ7L4-1S4A:10 a=hTZeC7Yk6K0A:10 a=frz4AuCg-hUA:10
Message-ID-Hash: 44TGES32AJG6CUUA7HMLBSRFEBUGQP2F
X-Message-ID-Hash: 44TGES32AJG6CUUA7HMLBSRFEBUGQP2F
X-MailFrom: kevin.rob@conference21.biz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/44TGES32AJG6CUUA7HMLBSRFEBUGQP2F/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 

 

Dear Exhibitor,

 

Would you be interested in obtaining the Fintech Virtual 2021 Pre-registered
Attendees List?

 

With All contacts are permission pass and provided with complete contact
information including direct business email address on an excel
spread-sheet.

 

We Have The Following Database:

 

*  Industry Experts

*  Key Decision Makers      

 

Information fields include: First Name, Last Name, Title, Company, Contact
Number, Website, Mailing address and contact person verified business email
address etc.

 

Kindly let me know your interest so that I can get back to you with Counts
and Pricing for attendees list.

 

Thank you and I Look forward to hearing from you.

 

Regards,

Kevin Rob

Fintech Virtual 2021 - Manager of Sales & Marketing

 

If you do not wish to receive future emails from us, reply as 'opt-out'.

 

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
