Return-Path: <SRS0=YTbH=BY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9A3C433DF
	for <linux-nvdimm@archiver.kernel.org>; Fri, 14 Aug 2020 10:17:25 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 67277207DA
	for <linux-nvdimm@archiver.kernel.org>; Fri, 14 Aug 2020 10:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67277207DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 26D50130DD2F7;
	Fri, 14 Aug 2020 03:17:25 -0700 (PDT)
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C230B130D2BAE
	for <linux-nvdimm@lists.01.org>; Fri, 14 Aug 2020 03:17:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Fix the problem of Canon Printer in error state easily!
From: michaels1990johnson@gmail.com
To: linux-nvdimm@lists.01.org
Date: Fri, 14 Aug 2020 10:17:19 -0000
Message-ID: <20200814101719.2837.92441@ml01.vlan13.01.org>
User-Agent: HyperKitty on https://ml01.01.org/
Message-ID-Hash: 2D5PCGMV7FPBFENUCHLAX3ODR5EY47HZ
X-Message-ID-Hash: 2D5PCGMV7FPBFENUCHLAX3ODR5EY47HZ
X-MailFrom: michaels1990johnson@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2D5PCGMV7FPBFENUCHLAX3ODR5EY47HZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: base64

SWYgeW91ciBDYW5vbiBwcmludGVyIGlzIGluIGVycm9yIHN0YXRlIHRoZW4gaXQgY291bGQgYmUg
YmVjYXVzZSBvZiBzb21lIGNvbm5lY3Rpb24gaXNzdWUgb3IgaW5jb21wYXRpYmxlIGRyaXZlcnMu
IEluIG9yZGVyIHRvIGZpeCBjYW5vbiBwcmludGVyIGluIGVycm9yIHN0YXRlIGlzc3VlLCB5b3Ug
Y2FuIHN0YXJ0IG9mZiBieSBjaGVja2luZyB0aGUgY29ubmVjdGlvbiBiZXR3ZWVuIHRoZSBwcmlu
dGVyIGFuZCB0aGUgbGFwdG9wLiBFbnN1cmUgdGhhdCB0aGUgd2lyZWxlc3MgbmV0d29yayBvciBj
YWJsZSB0aGF0IHlvdSBhcmUgdXNpbmcgaXNu4oCZdCBmYXVsdHkuIFlvdSBjYW4gYWxzbyB2aXNp
dCBjYW5vbuKAmXMgb2ZmaWNpYWwgd2Vic2l0ZSBhbmQgY2hlY2sgZm9yIGFueSBsYXRlc3QgdXBk
YXRlcyBvZiB0aGUgcHJpbnRlciBkcml2ZXIuIElmIHRoZXJlIGlzIG5vIHVwZGF0ZSB0aGVuIHlv
dSBjYW4gdW5pbnN0YWxsIGFuZCByZWluc3RhbGwgdGhlIGNvbXBhdGlibGUgZHJpdmVycy4gUmVz
dGFydCB5b3VyIHByaW50ZXIgYW5kIGxhcHRvcCB0byBjaGVjayBpZiB5b3UgYXJlIHN0aWxsIGZh
Y2luZyB0aGUgZXJyb3Igc3RhdGUgcHJvYmxlbS4gSWYgaXQgaXMgc3RpbGwgbm90IHNvbHZlZCB0
aGVuIHlvdSBjYW4gY29udGFjdCB1cyBhbmQgd2Ugd2lsbCBoZWxwIHlvdSBvdXQuDQpodHRwczov
L3d3dy5jYW5vbnByaW50ZXJzdXBwb3J0cHJvLnVzL2Jsb2cvZml4LWNhbm9uLXByaW50ZXItaW4t
ZXJyb3Itc3RhdGUtaXNzdWUvCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2
ZUBsaXN0cy4wMS5vcmcK
