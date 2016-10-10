Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on071f.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::71f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E5D41A1DE9
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 08:26:07 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] use a nocache copy for bvecs in copy_from_iter_nocache()
Date: Mon, 10 Oct 2016 15:26:03 +0000
Message-ID: <1476113071.20881.15.camel@hpe.com>
References: <20161007155511.21502-1-brian.boylston@hpe.com>
 <20161007170842.GQ19539@ZenIV.linux.org.uk>
In-Reply-To: <20161007170842.GQ19539@ZenIV.linux.org.uk>
Content-Language: en-US
Content-ID: <49938475457C2849B27452052CD4DCE6@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "Boylston, Brian" <brian.boylston@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTEwLTA3IGF0IDE4OjA4ICswMTAwLCBBbCBWaXJvIHdyb3RlOg0KPiBPbiBG
cmksIE9jdCAwNywgMjAxNiBhdCAxMDo1NToxMUFNIC0wNTAwLCBCcmlhbiBCb3lsc3RvbiB3cm90
ZToNCj4gPiANCj4gPiBjb3B5X2Zyb21faXRlcl9ub2NhY2hlKCkgaXMgb25seSAibm9jYWNoZSIg
Zm9yIGlvdmVjcy7CoMKgRW5oYW5jZSBpdA0KPiA+IHRvIGFsc28gdXNlIGEgbm9jYWNoZSBjb3B5
IGZvciBidmVjcy7CoMKgVGhpcyBpbXByb3ZlcyBwZXJmb3JtYW5jZSBieQ0KPiA+IDItM1ggd2hl
biBzcGxpY2UoKWluZyB0byBhIGZpbGUgaW4gYSBEQVgtbW91bnRlZCwgcG1lbS1iYWNrZWQgZmls
ZQ0KPiA+IHN5c3RlbS4NCj4gDQo+ID4gDQo+ID4gK3N0YXRpYyB2b2lkIG1lbWNweV9mcm9tX3Bh
Z2Vfbm9jYWNoZShjaGFyICp0bywgc3RydWN0IHBhZ2UgKnBhZ2UsDQo+ID4gc2l6ZV90IG9mZnNl
dCwgc2l6ZV90IGxlbikNCj4gPiArew0KPiA+ICsJY2hhciAqZnJvbSA9IGttYXBfYXRvbWljKHBh
Z2UpOw0KPiA+ICsJX19jb3B5X2Zyb21fdXNlcl9pbmF0b21pY19ub2NhY2hlKHRvLCBmcm9tLCBs
ZW4pOw0KPiA+ICsJa3VubWFwX2F0b21pYyhmcm9tKTsNCj4gPiArfQ0KPiANCj4gQXQgdGhlIHZl
cnkgbGVhc3QsIGl0IHdpbGwgYmxvdyB1cCBvbiBhbnkgYXJjaGl0ZWN0dXJlIHdpdGggc3BsaXQN
Cj4gdXNlcmxhbmQgYW5kIGtlcm5lbCBNTVUgY29udGV4dHMuwqDCoFlvdSAqY2FuJ3QqIGZlZWQg
YSBrZXJuZWwgcG9pbnRlcg0KPiB0byB0aGluZ3MgbGlrZSB0aGF0IGFuZCBleHBlY3QgaXQgdG8g
d29yay7CoMKgQXQgdGhlIHZlcnkgbGVhc3QsIHlvdQ0KPiBuZWVkIHRvIGFkZCBtZW1jcHlfbm9j
YWNoZSgpIGFuZCBoYXZlIGl0IGRlZmF1bHQgdG8gbWVtY3B5KCksIHdpdGgNCj4gbm9uLWR1bW15
IHZlcnNpb24gb24geDg2LsKgwqBBbmQgdXNlIF90aGF0XywgcmF0aGVyIHRoYW4gbWVzc2luZyB3
aXRoDQo+IF9fY29weV9mcm9tX3VzZXJfaW5hdG9taWNfbm9jYWNoZSgpDQoNCkdvb2QgcG9pbnQu
IMKgSSB0aGluayB3ZSBjYW4gYWRkIG1lbWNweV9ub2NhY2hlKCkgd2hpY2ggY2FsbHMNCl9fY29w
eV9mcm9tX3VzZXJfaW5hdG9taWNfbm9jYWNoZSgpIG9uIHg4NiBhbmQgZGVmYXV0cyB0byBtZW1j
cHkoKSBvbg0Kb3RoZXIgYXJjaGl0ZWN0dXJlcy4NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWls
aW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
