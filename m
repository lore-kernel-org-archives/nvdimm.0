Return-Path: <SRS0=CUdZ=ED=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=BAYES_50,DKIM_ADSP_ALL,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ABFC388F7
	for <linux-nvdimm@archiver.kernel.org>; Wed, 28 Oct 2020 11:38:05 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D930E246C7
	for <linux-nvdimm@archiver.kernel.org>; Wed, 28 Oct 2020 11:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D930E246C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F3BBF162FD6E3;
	Wed, 28 Oct 2020 04:38:03 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=51.253.120.69; helo=[51.253.120.69]; envelope-from=desmond65@o4.e.notification.intuit.com; receiver=<UNKNOWN> 
Received: from [51.253.120.69] (unknown [51.253.120.69])
	by ml01.01.org (Postfix) with ESMTP id 2E6BE162FD6E0
	for <linux-nvdimm@lists.01.org>; Wed, 28 Oct 2020 04:37:56 -0700 (PDT)
Received: from WOHAWOK.o4.e.notification.intuit.com (WOHAWOK.o4.e.notification.intuit.com
 [51.152.165.5])        by  with SMTP id
 iivclpn9f5tqrq9.6.20201028143755; Wed, 28 Oct 2020 14:37:55 +0300
Subject: FBA Inbound Shipment Bill of Lading Ready (FBASGD9E4WCO)
From: "Amazon.com" <fba-noreply@amazon.com>
To: linux-nvdimm@lists.01.org
MIME-Version: 1.0
Message-ID: <202058.326850@WOHAWOK.o4.e.notification.intuit.com>
X-Priority: 3
Date: Wed, 28 Oct 2020 14:37:55 +0300
Message-ID-Hash: TGA7FTC2TRV3KUFJUKTZDYV57XFACNW4
X-Message-ID-Hash: TGA7FTC2TRV3KUFJUKTZDYV57XFACNW4
X-MailFrom: desmond65@o4.e.notification.intuit.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Disposition: inline
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TGA7FTC2TRV3KUFJUKTZDYV57XFACNW4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Greetings from Amazon.com

The Bill of Lading document on your inbound shipment (FBASGD9E4WCO)

For your convenience, we have also attached a copy of the initial Bill of Lading to this email.

Your carrier contact information:
CENTRAL TRANSPORT INTERNATIONAL INC



You can track the status of all inbound shipments, online by visiting Seller Central at:
https://sellercentral.amazon.com/gp/ssof/shipping-queue.html

If you've examined your shipment, but still need assistance,
please contact Seller Support.

Thank you for using Fulfillment by Amazon.

Sincerely, 
Amazon Services

--------------------------------------------------------------------------
This email was sent from a notification-only address that
cannot accept incoming email. Please do not reply to this message.
--------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
