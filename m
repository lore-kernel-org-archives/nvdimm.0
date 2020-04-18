Return-Path: <SRS0=XhsV=6C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CECCC3A5A0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:56:05 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F33722223D
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:56:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F33722223D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A01B010FC62E5;
	Sat, 18 Apr 2020 11:56:12 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=216.40.44.186; helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com; receiver=<UNKNOWN> 
Received: from smtprelay.hostedemail.com (smtprelay0186.hostedemail.com [216.40.44.186])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B2A0510FC62DF
	for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 11:56:10 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
	by smtprelay06.hostedemail.com (Postfix) with ESMTP id BBBA618018500;
	Sat, 18 Apr 2020 18:56:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: money21_1707d78e8f515
X-Filterd-Recvd-Size: 3611
Received: from XPS-9350.home (unknown [47.151.136.130])
	(Authenticated sender: joe@perches.com)
	by omf03.hostedemail.com (Postfix) with ESMTPA;
	Sat, 18 Apr 2020 18:55:58 +0000 (UTC)
Message-ID: <6c796219ea79d87093409f2dd1d3bf8e4a157ed7.camel@perches.com>
Subject: Re: [PATCH 6/9] nfsd: fix empty-body warning in nfs4state.c
From: Joe Perches <joe@perches.com>
To: Chuck Lever <chuck.lever@oracle.com>, Randy Dunlap
 <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 11:53:44 -0700
In-Reply-To: <CDCF7717-7CBC-47CA-9E83-3A18ECB3AB89@oracle.com>
References: <20200418184111.13401-1-rdunlap@infradead.org>
	 <20200418184111.13401-7-rdunlap@infradead.org>
	 <CDCF7717-7CBC-47CA-9E83-3A18ECB3AB89@oracle.com>
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Message-ID-Hash: YTXPZ75HHDHC4EHZQWZQG5FAZLFCGOQ7
X-Message-ID-Hash: YTXPZ75HHDHC4EHZQWZQG5FAZLFCGOQ7
X-MailFrom: joe@perches.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Bruce Fields <bfields@fieldses.org>,
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, linux-nvdimm@lists.01.org,
	"Martin K."@ml01.01.org, Petersen@ml01.01.org,
	" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "@ml01.01.org,
	target-devel@vger.kernel.org, Zzy Wysm <zzy@zzywysm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YTXPZ75HHDHC4EHZQWZQG5FAZLFCGOQ7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCAyMDIwLTA0LTE4IGF0IDE0OjQ1IC0wNDAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
PiBPbiBBcHIgMTgsIDIwMjAsIGF0IDI6NDEgUE0sIFJhbmR5IER1bmxhcCA8cmR1bmxhcEBpbmZy
YWRlYWQub3JnPiB3cm90ZToNCj4gPiANCj4gPiBGaXggZ2NjIGVtcHR5LWJvZHkgd2FybmluZyB3
aGVuIC1XZXh0cmEgaXMgdXNlZDoNCj4gPiANCj4gPiAuLi9mcy9uZnNkL25mczRzdGF0ZS5jOjM4
OTg6Mzogd2FybmluZzogc3VnZ2VzdCBicmFjZXMgYXJvdW5kIGVtcHR5IGJvZHkgaW4gYW4g4oCY
ZWxzZeKAmSBzdGF0ZW1lbnQgWy1XZW1wdHktYm9keV0NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5
OiBSYW5keSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCj4gPiBDYzogTGludXMgVG9y
dmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiA+IENjOiBBbmRyZXcgTW9y
dG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiA+IENjOiAiSi4gQnJ1Y2UgRmllbGRz
IiA8YmZpZWxkc0BmaWVsZHNlcy5vcmc+DQo+ID4gQ2M6IENodWNrIExldmVyIDxjaHVjay5sZXZl
ckBvcmFjbGUuY29tPg0KPiA+IENjOiBsaW51eC1uZnNAdmdlci5rZXJuZWwub3JnDQo+IA0KPiBJ
IGhhdmUgYSBwYXRjaCBpbiBteSBxdWV1ZSB0aGF0IGFkZHJlc3NlcyB0aGlzIHBhcnRpY3VsYXIg
d2FybmluZywNCj4gYnV0IHlvdXIgY2hhbmdlIHdvcmtzIGZvciBtZSB0b28uDQo+IA0KPiBBY2tl
ZC1ieTogQ2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+DQo+IA0KPiBVbmxlc3Mg
QnJ1Y2Ugb2JqZWN0cy4NCj4gDQo+IA0KPiA+IC0tLQ0KPiA+IGZzL25mc2QvbmZzNHN0YXRlLmMg
fCAgICAzICsrLQ0KPiA+IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCj4gPiANCj4gPiAtLS0gbGludXgtbmV4dC0yMDIwMDQxNy5vcmlnL2ZzL25mc2QvbmZz
NHN0YXRlLmMNCj4gPiArKysgbGludXgtbmV4dC0yMDIwMDQxNy9mcy9uZnNkL25mczRzdGF0ZS5j
DQo+ID4gQEAgLTM0LDYgKzM0LDcgQEANCj4gPiANCj4gPiAjaW5jbHVkZSA8bGludXgvZmlsZS5o
Pg0KPiA+ICNpbmNsdWRlIDxsaW51eC9mcy5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgva2VybmVs
Lmg+DQo+ID4gI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4NCj4gPiAjaW5jbHVkZSA8bGludXgvbmFt
ZWkuaD4NCj4gPiAjaW5jbHVkZSA8bGludXgvc3dhcC5oPg0KPiA+IEBAIC0zODk1LDcgKzM4OTYs
NyBAQCBuZnNkNF9zZXRjbGllbnRpZChzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwDQo+ID4gCQljb3B5
X2NsaWQobmV3LCBjb25mKTsNCj4gPiAJCWdlbl9jb25maXJtKG5ldywgbm4pOw0KPiA+IAl9IGVs
c2UgLyogY2FzZSA0IChuZXcgY2xpZW50KSBvciBjYXNlcyAyLCAzIChjbGllbnQgcmVib290KTog
Ki8NCj4gPiAtCQk7DQo+ID4gKwkJZG9fZW1wdHkoKTsNCj4gPiAJbmV3LT5jbF9taW5vcnZlcnNp
b24gPSAwOw0KPiA+IAlnZW5fY2FsbGJhY2sobmV3LCBzZXRjbGlkLCBycXN0cCk7DQo+ID4gCWFk
ZF90b191bmNvbmZpcm1lZChuZXcpOw0KDQpUaGlzIGVtcHR5IGVsc2Ugc2VlbXMgc2lsbHkgYW5k
IGNvdWxkIGxpa2VseSBiZSBiZXR0ZXIgaGFuZGxlZCBieQ0KYSBjb21tZW50IGFib3ZlIHRoZSBm
aXJzdCBpZiwgc29tZXRoaW5nIGxpa2U6DQoNCgkvKiBmb3Igbm93IG9ubHkgaGFuZGxlIGNhc2Ug
MTogcHJvYmFibGUgY2FsbGJhY2sgdXBkYXRlICovDQoJaWYgKGNvbmYgJiYgc2FtZV92ZXJmKCZj
b25mLT5jbF92ZXJpZmllciwgJmNsdmVyaWZpZXIpKSB7DQoJCWNvcHlfY2xpZChuZXcsIGNvbmYp
Ow0KCQlnZW5fY29uZmlybShuZXcsIG5uKTsNCgl9DQoNCndpdGggbm8gZWxzZSB1c2UuDQoNCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGlt
bSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmli
ZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
