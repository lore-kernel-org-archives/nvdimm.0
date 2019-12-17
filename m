Return-Path: <SRS0=lqgf=2H=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,HK_NAME_MR_MRS,
	HTML_MESSAGE,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3883FC43603
	for <linux-nvdimm@archiver.kernel.org>; Tue, 17 Dec 2019 12:43:27 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9C6E2146E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 17 Dec 2019 12:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ratenewsstudio.top header.i=sales@ratenewsstudio.top header.b="jUM0g7cW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9C6E2146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=ratenewsstudio.top
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B9EB710113631;
	Tue, 17 Dec 2019 04:46:48 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=106.75.70.113; helo=ratenewsstudio.top; envelope-from=sales@ratenewsstudio.top; receiver=<UNKNOWN> 
Received: from ratenewsstudio.top (ratenewsstudio.top [106.75.70.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 47D891011362A
	for <linux-nvdimm@lists.01.org>; Tue, 17 Dec 2019 04:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=default; d=ratenewsstudio.top;
 h=From:Subject:To:Content-Type:Reply-To:Date:Message-Id; i=sales@ratenewsstudio.top;
 bh=+REHHBQ9nEtPrEWKczfkA19E8Is=;
 b=jUM0g7cW4dvpE1veNzO1JdZfW3PSGp5OYuksSr8ew1jnEi/j15EEC4Z0FROijXQlnJd8AMCf14KG
   apnwO9lC8EmRedamhY4aUWyJK+m+KeINt5oRIdgFSNFvDM3lgKQV0noeuaaTrDC7yJvk8lZ1kpqB
   KwJJCR+QPVYJZffmWtI=
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=default; d=ratenewsstudio.top;
 b=IfZ9LepVXGGklBJLobUBEeHHBraI97OnicsJzhuC3FNznd1vIniRaa0Gt1eS5Z5SiTIUbMIf1k+8
   a/+CRHs8qoTsV8w03pP/nGKeeltfuSLHpVd8DjMlpLGd/OaUcYqbnxT7lGvG+VmI9bZ2OMLi0ESK
   kQqo5wV29lId2qCo8so=;
From: "Mrs Karen Ngui (GMD/CIO/CFO)" <sales@ratenewsstudio.top>
Subject: SP: TO -> : linux-nvdimm@lists.01.org
To: <linux-nvdimm@lists.01.org>
Date: Tue, 17 Dec 2019 15:43:16 +0300
Message-Id: <17122019124315968B0CBF90$36B2BBD6E5@BLESSEDHEART>
Message-ID-Hash: 5LKH3UV3AHCMUFDWSDPFCRF6DF5JIJP3
X-Message-ID-Hash: 5LKH3UV3AHCMUFDWSDPFCRF6DF5JIJP3
X-MailFrom: sales@ratenewsstudio.top
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: invoicekngui054@gmail.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5LKH3UV3AHCMUFDWSDPFCRF6DF5JIJP3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============1037678638129627865=="

--===============1037678638129627865==
Content-Type: text/html; charset=iso-8859-1

<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  <META name=Generator content=10.90> <META name=viewport 
content="width=device-width, initial-scale=1"> <META 
name=format-detection content=telephone=no><title>SP: TO -> : 
linux-nvdimm@lists.01.org</title>
 </head>
 <body style="BACKGROUND-COLOR: #ffffff" bgColor=#ffffff> <P align=left>
<FONT size=3 face=Arial><FONT size=3 face=Arial></FONT>Email 
To:&nbsp;linux-nvdimm@lists.01.org</FONT></p><p align=left><FONT size=3 
face=Arial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hello i am writing to check if 
got proposal i sent to you via LinkedIn on the&nbsp;10th of this month, 
Kindly check and reply if you got it or not.</FONT></p><p align=left>
<FONT size=3 face=Arial>Regards<BR>Mrs Karen Ngui<BR>Group Managing 
Director&nbsp;&nbsp;</FONT></P></body>
 </html>

--===============1037678638129627865==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============1037678638129627865==--
