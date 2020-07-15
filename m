Return-Path: <SRS0=Guig=A2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,URIBL_DBL_SPAM autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCACC433E1
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Jul 2020 01:03:38 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 837E42074B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 15 Jul 2020 01:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hwinfotech.net header.i=info@hwinfotech.net header.b="tlVqhxap"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 837E42074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hwinfotech.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 359BB1191D1CD;
	Tue, 14 Jul 2020 18:03:38 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=142.44.162.93; helo=dish.hwinfotech.net; envelope-from=info@hwinfotech.net; receiver=<UNKNOWN> 
Received: from dish.hwinfotech.net (tata.hwinfotech.net [142.44.162.93])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 557A21191D1CB
	for <linux-nvdimm@lists.01.org>; Tue, 14 Jul 2020 18:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=hwinfotech.net;
 h=Message-ID:Date:Subject:From:Reply-To:To:MIME-Version:Content-Type:List-Unsubscribe:List-Id; i=info@hwinfotech.net;
 bh=glpvwDcGMUCs+mqRDkg9IIRhpOE=;
 b=tlVqhxap+TAPyBmXZFxZlzTcSpVMzog4nB6x6DzPNh5ttETabt+w4MT3ZCofI2tiGe6ybiwWKwhe
   xsfbMvJMxbW9v0E75wFOzNF5QW0qi/wB3+mS+aX5ndVP50aC8bXuhbjUmUSOX5ThShJBHBZ0Slp8
   tCY2iTobHXC0DkjSLEE=
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=hwinfotech.net;
 b=Gd1a1uw94W9t6e+cwdaM/RuuUM0Kzbl9Fvb5Kcw5Yq4MC7rbpbh7R9tBH66ZZ5eJTXZzNcWBE+DG
   8eCeles6/zSbisUZB78RtkLxGQQoGXzk+mpqRukU2rOf9OHDZGUHASKDa9CpS/dPMow9QkeJ3U3C
   85GFoLNF6jlV6999gvk=;
Message-ID: <03fbfdd8d21ec9f72d325888d2360d09@hwinfotech.net>
Date: Wed, 15 Jul 2020 01:03:33 +0000
Subject: Website and Mobile App Development
From: HW Infotech <info@hwinfotech.net>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
MIME-Version: 1.0
X-Sender: info@hwinfotech.net
X-Report-Abuse: Please report abuse for this campaign here:
 http://app.hwinfotech.net/index.php/campaigns/vg827adp9fa3c/report-abuse/re014kvw2wbb8/ao012gbsbja79
X-Receiver: linux-nvdimm@lists.01.org
X-Fxyn-Tracking-Did: 0
X-Fxyn-Subscriber-Uid: ao012gbsbja79
X-Fxyn-Mailer: SwiftMailer - 5.4.x
X-Fxyn-EBS: http://app.hwinfotech.net/index.php/lists/block-address
X-Fxyn-Delivery-Sid: 3
X-Fxyn-Customer-Uid: pp359780cbfd3
X-Fxyn-Customer-Gid: 0
X-Fxyn-Campaign-Uid: vg827adp9fa3c
Precedence: bulk
Feedback-ID: vg827adp9fa3c:ao012gbsbja79:re014kvw2wbb8:pp359780cbfd3
Message-ID-Hash: JTBZQ5B7UBT2AEQW2QXTQWNRNE6R4EEH
X-Message-ID-Hash: JTBZQ5B7UBT2AEQW2QXTQWNRNE6R4EEH
X-MailFrom: info@hwinfotech.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Reply-To: HW Infotech <info@hwinfotech.net>
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/JTBZQ5B7UBT2AEQW2QXTQWNRNE6R4EEH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

V2UgaGF2ZSDinIUgNTAwKyBjbG9uZSBTY3JpcHRIaSwNCkkgYW0gV2FzZWVtIEZyb20gSFcgSW5m
b3RlY2guIEkgd2FzIHN1cmZpbmcgb24gdGhlIGludGVybmV0IGFuZCBmb3VuZA0KeW91ciBlbWFp
bCBpZC4NCsKgDQpTbywgaWYgeW91IGFyZSBsb29raW5nIHRvIGRldmVsb3AgYW55IHdlYnNpdGUg
b3IgbW9iaWxlIGFwcGxpY2F0aW9uDQp0aGVuIHBsZWFzZSBzaGFyZSB5b3VyIHBob25lIG51bWJl
ciBvciBTa3lwZSBpZCwgV2hhdHNhcHAgZm9yIGZ1dHVyZQ0KZGlzY3Vzc2lvbi4NCldvcmsgaW4g
dGhlIGZvbGxvd2luZyBhcmVhIDoNCuKchSBDbG9uZSBTY3JpcHQgZm9yIGFueSBXZWJzaXRlIGFu
ZCBNb2JpbGUgQVBQIC1EZXZlbG9wbWVudCBhbmQNCkRpZ2l0YWwgTWFya2V0aW5nIGZvciBBcHAs
IFdlYiwgU29mdHdhcmUgQ2xvbmUgU2NyaXB0cw0K4pyFUmVhZHltYWRlIFNjcmlwdCBmb3IgdXNl
ZnVsIHByb2R1Y3QgLVNob3AgV2Vic2l0ZSBUZW1wbGF0ZXMsIENsb25lDQpTY3JpcHRzLCAmIE1h
cmtldHBsYWNlIFNvZnR3YXJlIHwgSFcgSW5mb3RlY2gNCuKchVNvZnR3YXJlIFJlcXVpcmVtZW50
IFNwZWNpZmljYXRpb24gRG9jdW1lbnRhdGlvbg0K4pyFQSB3aXJlZnJhbWUgZGVzaWduIGZvciBX
ZWJzaXRlLCBFUlAsIFByb2R1Y3QgJk1vYmlsZSBhcHANCuKchVBIUCBGcmFtZXdvcmsgJiBNWVNR
TCwgSFRNTDUsIENTUzMsIEphdmFTY3JpcHQsIGpRdWVyeSwgWE1MLCBKU09OLg0K4pyFZUNvbW1l
cmNlLCBXb3JkUHJlc3MsTWFnZW50byxPcGVuIENhcnQsIEpvb21sYSwgTWFnZW50byAyLA0KUHJl
c3Rhc2hvcA0K4pyFTW9iaWxlIEFQUC0gQW5kcm9pZCwgSU9TLCBQaG9uZSBHYXAgYW5kIEZsdXR0
ZXINCuKchVNFTywgU01PLCBhbmQgUFBDDQrinIVJbnN0YWxsIGFuZCBjb25maWcgdGhlIHByb2pl
Y3QNCuKchVBsdWdpbjogQ3VzdG9taXplIGFuZCBjcmVhdGUgYSBuZXcgcGx1Z2luDQrinIVNaWdy
YXRlICYgVXBncmFkZTogc3VzdGFpbmFibGUgZGV2ZWxvcG1lbnQgYW5kIGxvbmctdGVybQ0K4pyF
V0hNIFBhbmVsIHNlcnZlciBjb25maWd1cmF0aW9uDQrinIVTZXJ2ZXIgT3B0aW1pemF0aW9uDQri
nIVXZWJzaXRlIGFuZCBTZXJ2ZXIgUGVuZXRyYXRpb24gdGVzdGluZw0K4pyFTG9hZCBCYWxhbmNp
bmcgYW5kIEZhaWxvdmVyIGNsdXN0ZXJpbmcgU2VydmVyDQrinIVNYWlsIFNlcnZlciBjb25maWd1
cmF0aW9uIGZvciBidWxrIGVtYWlsaW5nDQpDb250YWN0IHVzIC0gSGlyZSBBIERldmVsb3BlciB8
IFdlYiBhbmQgQXBwIERldmVsb3BtZW50IFNlcnZpY2VzIHwgSFcNCkluZm90ZWNoDQpSZWdhcmRz
DQpXYXNlZW0NCnd3dy5od2luZm90ZWNoLmNvbcKgwqBHdXJ1Z3JhbSB8IENhbGlmb3JuaWEgfCBM
b25kb24gfCBWYW5jb3V2ZXIgfA0KQWJ1amEgfCBNZWxib3VybmUNCmh0dHA6Ly9hcHAuaHdpbmZv
dGVjaC5uZXQvaW5kZXgucGhwL2xpc3RzL3JlMDE0a3Z3MndiYjgvdW5zdWJzY3JpYmUvYW8wMTJn
YnNiamE3OS92ZzgyN2FkcDlmYTNjDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBs
aXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0t
bGVhdmVAbGlzdHMuMDEub3JnCg==
