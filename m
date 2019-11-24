Return-Path: <SRS0=4QRz=ZQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7990AC432C3
	for <linux-nvdimm@archiver.kernel.org>; Sun, 24 Nov 2019 00:03:34 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27FA320714
	for <linux-nvdimm@archiver.kernel.org>; Sun, 24 Nov 2019 00:03:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27FA320714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ukr.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C1684100DC3E4;
	Sat, 23 Nov 2019 16:06:56 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=78.110.60.101; helo=78-110-60-101.net.hts.ru; envelope-from=sent-group@ukr.net; receiver=<UNKNOWN> 
Received: from 78-110-60-101.net.hts.ru (unknown [78.110.60.101])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 54A16100EEBAE
	for <linux-nvdimm@lists.01.org>; Sat, 23 Nov 2019 16:06:53 -0800 (PST)
Message-ID: <E319521E13C7E3B06C6920A0842F1399@ukr.net>
From: "Info" <sent-group@ukr.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?windows-1251?B?z/Du5OLo5uXt6OUg8eDp8u7iIO3gIO/l8OLz?=
	=?windows-1251?B?/iDx8vDg7ej28yBHb29nbGU=?=
Date: Sun, 24 Nov 2019 02:03:25 +0200
MIME-Version: 1.0
Message-ID-Hash: QUKLISOJ2SGUOFKKW556SZUXR7LBYEVJ
X-Message-ID-Hash: QUKLISOJ2SGUOFKKW556SZUXR7LBYEVJ
X-MailFrom: sent-group@ukr.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Type: text/plain; charset="windows-1251"
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QUKLISOJ2SGUOFKKW556SZUXR7LBYEVJ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: base64

0e7n5ODt6OUg6CDv8O7k4ujm5e3o5SDx4Ony7uIgz+7x7O7y8OXy/CDiIOHw4PPn5fDlIKANCg0K
z/Du5OLo5uXt6OUg8eDp8u7iIOIg0s7PIDEwDQoNCsfk8ODi8fLi8+ny5S4NCg0KzPsg5+Dt6Ozg
5ezx/yDv8O7k4ujm5e3o5ewg8eDp8u7iIOIg0s7PLTEwIEdPT0dMRSDv7iDt8+bt++wgwuDsIO/u
6PHq7uL77CD08ODn4OwuDQoNClNFTyDu7/Lo7Ojn4Pbo/yDx4Ony4A0KDQrR7vHy4OLr5e3o5SDx
5ezg7fLo9+Xx6u7j7iD/5PDgDQoNCs3g7+jx4O3o5SBTRU8g7u/y6Ozo5+jw7uLg7e379SDx8uDy
5ekNCg0Kz/Du5OLo5uXt6OUg8eDp8uAg7+4g6uv+9+Xi++wg9PDg5+DsDQoNCsDt4Ovo5yDq4Oog
wuD45ePuIPHg6fLgLCDy4Oog6CDx4Ony7uIg6u7t6vPw5e3y7uINCg0K0uDq5uUg5+Dt6Ozg5ezx
/yDw4Ofw4OHu8uru6SDx4Ony7uIhDQoNCs7h8OD54Ony5fH8LCDt4PjoIPHv5fbo4Ovo8fL7IO7y
4uXy//Ig7eAg4vHlIMLg+Ogg4u7v8O7x+ywg4O3g6+jnIPHg6fLgIOTr/yDk4Ov87eXp+OXj7iDv
8O7k4ujm5e3o/yDoIOv+4fvlIOru7fHz6/zy4Pbo6CDh5fHv6+Dy7e4uDQoNCtEg8+Lg5uXt6OXs
LA0K6u7s4O3k4CDx8vPk6Ogg7/Du5OLo5uXt6P8g6CDk6Ofg6e3gIPHg6fLu4g0KDQqpIENvcHly
aWdodCwgMjAxOQ0KzeD4IOXs4OnrOqAgaW5mb2dyb3VwcEBiaWdtaXIubmV0IA0KDQrS5esuOiAw
NjMtNDAxLTA3LTQxIA0KDQpTS1lQRTogb3JnLXJlZXN0cg0KDQrC+yDs7ubl8uUg7vLv6PHg8vzx
/yDu8iDw4PHx++vq6A0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxp
c3RzLjAxLm9yZwo=
