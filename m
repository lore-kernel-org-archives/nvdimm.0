Return-Path: <SRS0=X5qK=Z4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	SUBJ_ALL_CAPS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8A1C43603
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Dec 2019 03:42:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21DC72464E
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Dec 2019 03:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21DC72464E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grxxo.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 370921011350D;
	Thu,  5 Dec 2019 19:46:08 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=111.176.78.169; helo=grxxo.org; envelope-from=nelruhio@grxxo.org; receiver=<UNKNOWN> 
Received: from grxxo.org (unknown [111.176.78.169])
	by ml01.01.org (Postfix) with ESMTP id 3EEDF1011350B
	for <linux-nvdimm@lists.01.org>; Thu,  5 Dec 2019 19:46:03 -0800 (PST)
Message-ID: <ECD6AA2A00D88574BA346E2012EDFEF4@grxxo.org>
From: =?utf-8?B?5YKF6Z2Z?= <nelruhio@grxxo.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?Rk1FQeWkseaViOaooeW8j+S4juW9seWTjeWIhuaekCDlj4og5aaC5L2V5YeP5bCR?=
	=?utf-8?B?5Yi26YCg6L+H56iL5Lit55qE5LiD5aSn5rWq6LS5MTE6NDI6NDI=?=
Date: Fri, 6 Dec 2019 11:42:35 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: 6RAMMDV3LV2UISJ7XC3L7J724QUAFHBP
X-Message-ID-Hash: 6RAMMDV3LV2UISJ7XC3L7J724QUAFHBP
X-MailFrom: nelruhio@grxxo.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/6RAMMDV3LV2UISJ7XC3L7J724QUAFHBP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

TWVzc2FnZS1JRDogOTA3NTgyNTI0MTYyMA0KRnJvbTogPT9oY2RsbXo/Pz0gPGxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmc+DQpUbzogPG5lbHJ1aGlvQGdyeHhvLm9yZz4NCsK3wrflhoUgICDCt8K3
wrflrrnCt8K3ICDop4HCt8K3ICDpmYTCt8K3ICDku7bCt8K3Cl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0g
bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRv
IGxpbnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
