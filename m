Return-Path: <SRS0=5H+k=AE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.7 required=3.0 tests=DATE_IN_FUTURE_03_06,
	DKIM_ADSP_ALL,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FE1C433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue, 23 Jun 2020 11:20:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0C9220791
	for <linux-nvdimm@archiver.kernel.org>; Tue, 23 Jun 2020 11:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=givolettoan.us header.i=rypeta@givolettoan.us header.b="zsdGB6ad"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0C9220791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=givolettoan.us
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7540D10FC447E;
	Tue, 23 Jun 2020 04:20:06 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=104.168.204.142; helo=givolettoan.us; envelope-from=rypeta@givolettoan.us; receiver=<UNKNOWN> 
Received: from givolettoan.us (givolettoan.us [104.168.204.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 85CBA10FC3777
	for <linux-nvdimm@lists.01.org>; Tue, 23 Jun 2020 04:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=mail; d=givolettoan.us;
 h=Subject:Content-Type:Message-ID:MIME-Version:Date:To:From:List-Help;
 i=rypeta@givolettoan.us;
 bh=4kFTFeS5BDWzsc4PN048e+Nu9Lj06K/C3W8QgAKmYwo=;
 b=zsdGB6ads/w9gwK2sJs6mG23K+jsZ1sAiGg9cP4natfU1ODJ6S7Z518/b57CjM0MWFDq3hjYMiNm
   L+NbDvdXGWDqZdOfUWpS347BY8VLRLiPMSukDfZeGJx05BHc+RlJYMZQ69OWXXn4IttnAGRzV5gR
   uvDoPLRoXYWZ6+FjwlA=
Subject: Report FR9352UE05
Message-ID: <6901270619588-68sjca49-hp8rf663-o7f282v8@givolettoan.us>
MIME-Version: 1.0
Date: Tue, 23 Jun 2020 08:13:09 -0700
To: linux-nvdimm@lists.01.org
From: "Elephant & Castle Group, Inc. " <rypeta@givolettoan.us>
X-Mailer: Chilkat Software Inc (http://www.chilkatsoft.com)
Message-ID-Hash: LUYQDMI35OQXRSJLLZGM2EN33YZUWFTX
X-Message-ID-Hash: LUYQDMI35OQXRSJLLZGM2EN33YZUWFTX
X-MailFrom: rypeta@givolettoan.us
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Type: text/plain; charset="us-ascii"
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LUYQDMI35OQXRSJLLZGM2EN33YZUWFTX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: 7bit

Dear Customer ,
This is to confirm that one or more of your parcels has been shipped.
Shipment Label is attached to this email.

Yours sincerely,
Grover Glasser

Station Agent.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
