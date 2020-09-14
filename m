Return-Path: <SRS0=1g0Z=CX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FBAC433E2
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Sep 2020 17:06:42 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8C72206F4
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Sep 2020 17:06:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8C72206F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=outlook.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4CFB013F87142;
	Mon, 14 Sep 2020 10:06:41 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=40.92.18.108; helo=nam11-co1-obe.outbound.protection.outlook.com; envelope-from=will.jonson22085@outlook.com; receiver=<UNKNOWN> 
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2108.outbound.protection.outlook.com [40.92.18.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 182A013F87140
	for <linux-nvdimm@lists.01.org>; Mon, 14 Sep 2020 10:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSZj+CfrC8dLBKXOqTYhrvAjGo+qb9viDo04oeRK2/T4pu2fMzaF/sxKQAgzPqIkbETbm8Rs+WkbnYVX7GitDylmSKg/W5x1v8tBLLy3feWuJc9iPcL7M2X/vWinMvNfKcWvAftlh9yy45++vJ9f+v2qUs7ZBVpoHxI/OXjIR/d+/QCKTu0rc+uGg7nkuZcgaMXk/r6Igf6aFRfEuYYlw5iwCeKywNPpSbnO4qgfwCKG4knKWaEewqpD3FPWtwo4tvYV6HTvF0emLjzsNGGR9y+PJRvF92Nq79L5Z6DJVSXvHPMm2zravFuZUNHlY4AVHse+LXOeOYxvWi2YtrLRVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDWhIu3UOx5+bYA9o1/j56DEG3aaMC7HPwTihjPTGyo=;
 b=kx4IuYiEqiKp2TVvQx1FPfqOzgyl3ajEhNDdUv30TRh/ILVc40Vr378CUVG5Xaa/CKc/QZUlXMpoZvsji87HKAcdxZt9SsnbCsxVT056YVMnCKnsVoigIEuQ75jjbUCE5EvdK59YlKU10Q5NC8g9uGkSKaRY8ZffUpcvjb4jyph6Vh/RBWWOa32Pw0HfWg+pqg+ZURqUY4kKtLQ/ne+AnxLlM+FvTOtnqdfbvZBGm/ItBX5v4+nIfv6TVzGldNBUYp+CHcV8sD3OcyDy08+Whsal3F5sEwl7xRyifYO/pgFFUU3mbVik748OO8ysctrNFH7CJ6rbdAFj0v/1imtrfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDWhIu3UOx5+bYA9o1/j56DEG3aaMC7HPwTihjPTGyo=;
 b=jDbG7bmoN0puk4QktFXiC8WASaHjt+4nDgnx+7z/6uYTiMsR5MrYrwaZ1T+47+3GJZa/X12iYCT27/yhWkOM6kTWbQMl75jbpAKVKPlu1Eo+52UhGOk9SQ13J2Nxat5+E0eJaW7CbgqMmyE3T/o5FuRsA9LEE2aFW3oft8I9+fLlGQ4uj3L3uCxVs+jphUchadWeT5K/yCo68IzC4oaFN4EnMebfaEpkAJDUDRNnviiui1DZar0Iwd5ZwhmMRU1kAHPKPoA4vZD9Rtq75HHDIsnlESfIUSYA20QHfT2fbtZOtfC6DWnQL06BihFsKxDxCdUvcSjvfZ2aB6oiIqU1kw==
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2a01:111:e400:fc4d::4d) by
 DM6NAM11HT083.eop-nam11.prod.protection.outlook.com (2a01:111:e400:fc4d::125)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 17:06:37 +0000
Received: from DM6PR02MB3963.namprd02.prod.outlook.com
 (2a01:111:e400:fc4d::52) by DM6NAM11FT015.mail.protection.outlook.com
 (2a01:111:e400:fc4d::133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend
 Transport; Mon, 14 Sep 2020 17:06:37 +0000
Received: from DM6PR02MB3963.namprd02.prod.outlook.com
 ([fe80::b0bd:dfaf:cb2:3333]) by DM6PR02MB3963.namprd02.prod.outlook.com
 ([fe80::b0bd:dfaf:cb2:3333%6]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 17:06:37 +0000
From: will jonson <will.jonson22085@outlook.com>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Subject: RE: Obstetrician-Gynecologist Contact Details
Thread-Topic: Obstetrician-Gynecologist Contact Details
Thread-Index: AdaGxAodH7Fhv9a2SZmc4/G7Rt9aVgD9egiA
Date: Mon, 14 Sep 2020 17:06:36 +0000
Message-ID: 
 <DM6PR02MB3963AA6E727276EBC941715EC8230@DM6PR02MB3963.namprd02.prod.outlook.com>
References: 
 <BYAPR02MB3959E8A038FCAA07BCAC4114C8260@BYAPR02MB3959.namprd02.prod.outlook.com>
In-Reply-To: 
 <BYAPR02MB3959E8A038FCAA07BCAC4114C8260@BYAPR02MB3959.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-incomingtopheadermarker: 
 OriginalChecksum:9EDC71DBDF7111D5A84C971CB4CCAA2A49CBD58E506DFB3B82956FCEFBDDAEF1;UpperCasedChecksum:1D13DDEB3A6B7C34D89DEE7E25C3D2ABF87879188AD842016C688B64F0B33A05;SizeAsReceived:3084;Count:45
x-tmn: [ZEcK9FOmM1dZHpGsMDsSxwrmp2YyN0ekFRjwJa2DtmylrWDFfRWvgAmsmKKSxfUK]
x-ms-publictraffictype: Email
x-incomingheadercount: 45
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 5e2d485e-cf57-467a-389c-08d858d08a5a
x-ms-traffictypediagnostic: DM6NAM11HT083:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 O2bLK7ORvtCwvQURMFpRg2yNy2i8sgZM0cwQsEyAX0EmtMb+h2Ge5Yi+QcSaD+6Zk/JCCxaKnViGjWDbJOAz8jUggsoO3tBUtkr5p3x2C+/C6aXhKRl+0tQtOWMCI3ZIJJevXe47w/5Ca3N+tV8+qWCmefzOh6IoA3xhKqVHpS09vRCf3+T9n0rncQVAAyQh
x-ms-exchange-antispam-messagedata: 
 4+qtTThuwVXtelPkqD58H1ZcQzN2Z8Y3yTJ+DT6GkIt8d2yX8mdKjN2eSMwoInKKs8PKXS4HDduI3NHRCrYKAcCCkcq0exzqBv8bHkqNvx3PJ0UBeyh/wRslD9Rx5UrZObFLsL4WlJk+hFjHbVZH5PQ5Rlr31bpaoQIVq7qY5lL0tM0jMeQcWA5pfg/x/mHXLziYxNW7socYkUt0RdOVYg==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2d485e-cf57-467a-389c-08d858d08a5a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 17:06:36.9456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6NAM11HT083
Message-ID-Hash: HURJPVVO56LEYH2QRDUKKYHGPNF3UZ6P
X-Message-ID-Hash: HURJPVVO56LEYH2QRDUKKYHGPNF3UZ6P
X-MailFrom: will.jonson22085@outlook.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Type: text/plain; charset="us-ascii"
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/C6COWWP5I7K3CIU4VXMLEOXNWDKSV4NU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: 7bit

Hi,

Did you had a chance to review the email which I sent across?

Please let me know if you are interested or have any questions so that I will provide you more information on counts and pricing.

I would appreciate your reaction.

Regards,
Will

From: will jonson
Sent: Wednesday, 9 September, 2020 11:25 PM
To: linux-nvdimm@lists.01.org
Subject: Obstetrician-Gynecologist Contact Details


Hi,



I wanted to check if you'd be interested in acquiring Obstetrician-Gynecologist Contact List for your sales and marketing initiatives?



Note: We can help customize the lists for any specific requirement based on your criteria.



Please send me your target geographical location, so that I can send you the available counts and pricing for your review.



Regards,

Will Jonson

Sr. Marketing Manager



If you do not wish to receive further emails, please respond with "Opt Out" in subject line.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
