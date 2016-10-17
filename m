Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam03on072a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe4a::72a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EB861A1E20
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 10:41:03 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] DAX: enable iostat for read/write
Date: Mon, 17 Oct 2016 17:40:56 +0000
Message-ID: <1476725956.20881.68.camel@hpe.com>
References: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
 <20161015075443.GG27872@dastard>
In-Reply-To: <20161015075443.GG27872@dastard>
Content-Language: en-US
Content-ID: <BDB33442C34819479FF793191B0641AF@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCAyMDE2LTEwLTE1IGF0IDE4OjU0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+
IE9uIEZyaSwgT2N0IDE0LCAyMDE2IGF0IDExOjI1OjEzQU0gLTA2MDAsIFRvc2hpIEthbmkgd3Jv
dGU6DQrCoDoNCj4gPiArc3RhdGljIHZvaWQgZGF4X2lvc3RhdF9zdGFydChzdHJ1Y3QgZ2VuZGlz
ayAqZGlzaywgc3RydWN0IGlvdl9pdGVyDQo+ID4gKml0ZXIsDQo+ID4gKwkJCcKgwqDCoMKgwqB1
bnNpZ25lZCBsb25nICpzdGFydCkNCj4gPiArew0KPiA+ICsJaW50IHJ3ID0gaW92X2l0ZXJfcnco
aXRlcik7DQo+ID4gKwlpbnQgc2VjID0gaW92X2l0ZXJfY291bnQoaXRlcikgPj4gOTsNCj4gPiAr
CWludCBjcHUgPSBwYXJ0X3N0YXRfbG9jaygpOw0KPiA+ICsNCj4gPiArCSpzdGFydCA9IGppZmZp
ZXM7DQo+ID4gKwlwYXJ0X3JvdW5kX3N0YXRzKGNwdSwgJmRpc2stPnBhcnQwKTsNCj4gPiArCXBh
cnRfc3RhdF9pbmMoY3B1LCAmZGlzay0+cGFydDAsIGlvc1tyd10pOw0KPiA+ICsJcGFydF9zdGF0
X2FkZChjcHUsICZkaXNrLT5wYXJ0MCwgc2VjdG9yc1tyd10sIHNlYyk7DQo+ID4gKwlwYXJ0X2lu
Y19pbl9mbGlnaHQoJmRpc2stPnBhcnQwLCBydyk7DQo+ID4gKwlwYXJ0X3N0YXRfdW5sb2NrKCk7
DQo+ID4gK30NCj4gDQo+IFdoeSByZWltcGxlbWVudCBnZW5lcmljX3N0YXJ0X2lvX2FjY3QoKSBh
bmQgZ2VuZXJpY19lbmRfaW9fYWNjdCgpPw0KDQpJdCB3YXMgbW9kZWxlZCBhZnRlciBfX25kX2lv
c3RhdF9zdGFydCgpIC8gbmRfaW9zdGFydF9lbmQoKS4gwqBJIGFncmVlDQp0aGF0IHdlIGNhbiB1
c2XCoGdlbmVyaWNfc3RhcnRfaW9fYWNjdCgpIGFuZCBnZW5lcmljX2VuZF9pb19hY2N0KCkgaGVy
ZS4NCg0KU2hvdWxkIHdlIGFsc28gY2hhbmdlIHRoZSBuZCBpbnRlcmZhY2UgdG8gdXNlIHRoZSBn
ZW5lcmljIHZlcnNpb24gYXMNCndlbGw/DQoNClRoYW5rcywNCi1Ub3NoaQ0KDQpwcy4NClNvcnJ5
IEkgcmVhbGl6ZWQgdGhpcyBjb21tZW50IGFmdGVyIHNlbmRpbmcgb3V0IHYyLi4uCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWls
aW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
