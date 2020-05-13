Return-Path: <SRS0=fBV/=63=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6712EC2D0F8
	for <linux-nvdimm@archiver.kernel.org>; Wed, 13 May 2020 08:00:42 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 058D223129
	for <linux-nvdimm@archiver.kernel.org>; Wed, 13 May 2020 08:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 058D223129
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=dhl-express.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id AE8A511AD982E;
	Wed, 13 May 2020 00:58:05 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=14.23.91.106; helo=mail-server.ex1.com; envelope-from=notification@dhl-express.com; receiver=<UNKNOWN> 
Received: from mail-server.EX1.COM (unknown [14.23.91.106])
	by ml01.01.org (Postfix) with ESMTP id 1014011AD0992
	for <linux-nvdimm@lists.01.org>; Wed, 13 May 2020 00:57:45 -0700 (PDT)
Received: from dhl-express.com ([192.168.100.218]) by mail-server.EX1.COM with Microsoft SMTPSVC(6.0.3790.3959);
	 Wed, 13 May 2020 15:53:47 +0800
From: DHL EXPRESS <notification@dhl-express.com>
To: linux-nvdimm@lists.01.org
Subject: Your shipment has arrived.
Date: 13 May 2020 00:58:17 -0700
Message-ID: <20200513005816.50AC5C52742AB7A1@dhl-express.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_859CF329.0125F35E"
X-OriginalArrivalTime: 13 May 2020 07:53:58.0468 (UTC) FILETIME=[A89B9840:01D628FB]
Message-ID-Hash: S5OQLO7KDGIHY6DIQ4EH3G4EVGW342VE
X-Message-ID-Hash: S5OQLO7KDGIHY6DIQ4EH3G4EVGW342VE
X-MailFrom: notification@dhl-express.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/S5OQLO7KDGIHY6DIQ4EH3G4EVGW342VE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_859CF329.0125F35E
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_859CF329.0125F35E--
