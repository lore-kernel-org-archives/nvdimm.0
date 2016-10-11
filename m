Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on0718.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe41::718])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E3301A1E8E
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 06:26:09 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [PATCH] use a nocache copy for bvecs in copy_from_iter_nocache()
Date: Tue, 11 Oct 2016 13:26:07 +0000
Message-ID: <CS1PR84MB0119D6AB03D91248DAFE0E538EDA0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161007155511.21502-1-brian.boylston@hpe.com>
 <20161007170842.GQ19539@ZenIV.linux.org.uk>
 <1476113071.20881.15.camel@hpe.com>
In-Reply-To: <1476113071.20881.15.camel@hpe.com>
Content-Language: en-US
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

S2FuaSwgVG9zaGltaXRzdSB3cm90ZSBvbiAyMDE2LTEwLTEwOg0KPiBPbiBGcmksIDIwMTYtMTAt
MDcgYXQgMTg6MDggKzAxMDAsIEFsIFZpcm8gd3JvdGU6DQo+PiBPbiBGcmksIE9jdCAwNywgMjAx
NiBhdCAxMDo1NToxMUFNIC0wNTAwLCBCcmlhbiBCb3lsc3RvbiB3cm90ZToNCj4+PiANCj4+PiBj
b3B5X2Zyb21faXRlcl9ub2NhY2hlKCkgaXMgb25seSAibm9jYWNoZSIgZm9yIGlvdmVjcy7CoMKg
RW5oYW5jZSBpdA0KPj4+IHRvIGFsc28gdXNlIGEgbm9jYWNoZSBjb3B5IGZvciBidmVjcy7CoMKg
VGhpcyBpbXByb3ZlcyBwZXJmb3JtYW5jZSBieQ0KPj4+IDItM1ggd2hlbiBzcGxpY2UoKWluZyB0
byBhIGZpbGUgaW4gYSBEQVgtbW91bnRlZCwgcG1lbS1iYWNrZWQgZmlsZQ0KPj4+IHN5c3RlbS4N
Cj4+IA0KPj4+IA0KPj4+ICtzdGF0aWMgdm9pZCBtZW1jcHlfZnJvbV9wYWdlX25vY2FjaGUoY2hh
ciAqdG8sIHN0cnVjdCBwYWdlICpwYWdlLA0KPj4+IHNpemVfdCBvZmZzZXQsIHNpemVfdCBsZW4p
DQo+Pj4gK3sNCj4+PiArCWNoYXIgKmZyb20gPSBrbWFwX2F0b21pYyhwYWdlKTsNCj4+PiArCV9f
Y29weV9mcm9tX3VzZXJfaW5hdG9taWNfbm9jYWNoZSh0bywgZnJvbSwgbGVuKTsNCj4+PiArCWt1
bm1hcF9hdG9taWMoZnJvbSk7DQo+Pj4gK30NCj4+IA0KPj4gQXQgdGhlIHZlcnkgbGVhc3QsIGl0
IHdpbGwgYmxvdyB1cCBvbiBhbnkgYXJjaGl0ZWN0dXJlIHdpdGggc3BsaXQNCj4+IHVzZXJsYW5k
IGFuZCBrZXJuZWwgTU1VIGNvbnRleHRzLsKgwqBZb3UgKmNhbid0KiBmZWVkIGEga2VybmVsIHBv
aW50ZXINCj4+IHRvIHRoaW5ncyBsaWtlIHRoYXQgYW5kIGV4cGVjdCBpdCB0byB3b3JrLsKgwqBB
dCB0aGUgdmVyeSBsZWFzdCwgeW91DQo+PiBuZWVkIHRvIGFkZCBtZW1jcHlfbm9jYWNoZSgpIGFu
ZCBoYXZlIGl0IGRlZmF1bHQgdG8gbWVtY3B5KCksIHdpdGgNCj4+IG5vbi1kdW1teSB2ZXJzaW9u
IG9uIHg4Ni7CoMKgQW5kIHVzZSBfdGhhdF8sIHJhdGhlciB0aGFuIG1lc3Npbmcgd2l0aA0KPj4g
X19jb3B5X2Zyb21fdXNlcl9pbmF0b21pY19ub2NhY2hlKCkNCj4gDQo+IEdvb2QgcG9pbnQuIMKg
SSB0aGluayB3ZSBjYW4gYWRkIG1lbWNweV9ub2NhY2hlKCkgd2hpY2ggY2FsbHMNCj4gX19jb3B5
X2Zyb21fdXNlcl9pbmF0b21pY19ub2NhY2hlKCkgb24geDg2IGFuZCBkZWZhdXRzIHRvIG1lbWNw
eSgpIG9uDQo+IG90aGVyIGFyY2hpdGVjdHVyZXMuDQoNClRoYW5rcywgQWwgYW5kIFRvc2hpLCBm
b3IgdGhlIGZlZWRiYWNrLiAgSSdsbCByZS13b3JrIGFuZCBjb21lIGJhY2suDQoNCkJyaWFuDQoN
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
