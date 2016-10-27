Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on072a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::72a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8604D1A1DEF
 for <linux-nvdimm@lists.01.org>; Thu, 27 Oct 2016 14:48:43 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: Infinite loop with DAX PMD faults
Date: Thu, 27 Oct 2016 21:48:41 +0000
Message-ID: <1477604810.20881.104.camel@hpe.com>
References: <20161027190750.GA28888@quack2.suse.cz>
 <CAPcyv4gS3LwAq77t31aRCxuHu9UeC4axJbQmxS-JQJzBVV=GmQ@mail.gmail.com>
 <20161027210343.GA12217@linux.intel.com>
In-Reply-To: <20161027210343.GA12217@linux.intel.com>
Content-Language: en-US
Content-ID: <B7832ACE766CC9449D649ABF8A6276B8@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTEwLTI3IGF0IDE1OjAzIC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDI3LCAyMDE2IGF0IDEyOjQ2OjMyUE0gLTA3MDAsIERhbiBXaWxsaWFtcyB3
cm90ZToNCj4gPiANCj4gPiBPbiBUaHUsIE9jdCAyNywgMjAxNiBhdCAxMjowNyBQTSwgSmFuIEth
cmEgPGphY2tAc3VzZS5jej4gd3JvdGU6DQo+ID4gPiANCj4gPiA+IEhlbGxvLA0KPiA+ID4gDQo+
ID4gPiBXaGVuIHRlc3RpbmcgbXkgREFYIHBhdGNoZXMgcmViYXNlZCBvbiB0b3Agb2YgUm9zcycg
REFYIFBNRA0KPiA+ID4gc2VyaWVzLCBJJ3ZlIGNvbWUgYWNyb3NzIHRoZSBmb2xsb3dpbmcgaXNz
dWUgd2l0aCBnZW5lcmljLzM0NA0KPiA+ID4gdGVzdCBmcm9tIHhmc3Rlc3RzLiBUaGUgdGVzdCBl
bmRzIGluIGFuIGluZmluaXRlIGZhdWx0IGxvb3Agd2hlbg0KPiA+ID4gd2UgZmF1bHQgaW5kZXgg
MCBvdmVyIGFuZCBvdmVyIGFnYWluIG5ldmVyIGZpbmlzaGluZyB0aGUgZmF1bHQuDQo+ID4gPiBU
aGUgcHJvYmxlbSBpcyB0aGF0IHdlIGRvIGEgd3JpdGUgZmF1bHQNCj4gPiA+IGZvciBpbmRleCAw
IHdoZW4gdGhlcmUgaXMgUE1EIGZvciB0aGF0IGluZGV4LiBTbyB3ZSBlbnRlcg0KPiA+ID4gd3Bf
aHVnZV9wbWQoKS4gRm9yIHdoYXRldmVyIHJlYXNvbiB0aGF0IHJldHVybnMgVk1fRkFVTFRfRkFM
TEJBQ0sNCj4gPiA+IHNvIHdlIGNvbnRpbnVlIHRvIGhhbmRsZV9wdGVfZmF1bHQoKS4gVGhlcmUg
d2UgZG8NCj4gPiA+IA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChwbWRfdHJhbnNfdW5zdGFi
bGUodm1mLT5wbWQpIHx8IHBtZF9kZXZtYXAoKnZtZi0NCj4gPiA+ID5wbWQpKQ0KPiA+ID4gDQo+
ID4gPiBjaGVjayB3aGljaCBpcyB0cnVlIC0gdGhlIFBNRCB3ZSBoYXZlIGlzIHBtZF90cmFuc19o
dWdlKCkgLSBzbyB3ZQ0KPiA+ID4gJ3JldHVybiAwJyBhbmQgdGhhdCByZXN1bHRzIGluIHJldHJ5
aW5nIHRoZSBmYXVsdCBhbmQgYWxsIGhhcHBlbnMNCj4gPiA+IGZyb20gdGhlIGJlZ2lubmluZyBh
Z2Fpbi4NCj4gPiA+IA0KPiA+ID4gSXQgaXNuJ3QgcXVpdGUgb2J2aW91cyBob3cgdG8gYnJlYWsg
dGhhdCBjeWNsZSB0byBtZS4gVGhlIGNvbW1lbnQNCj4gPiA+IGJlZm9yZSBwbWRfbm9uZV9vcl90
cmFuc19odWdlX29yX2NsZWFyX2JhZCgpIGdvZXMgdG8gZ3JlYXQNCj4gPiA+IGxlbmd0aHMgZXhw
bGFpbmluZyBwb3NzaWJsZSByYWNlcyB3aGVuIFBNRCBpcyBwbWRfdHJhbnNfaHVnZSgpIHNvDQo+
ID4gPiBpdCBuZWVkcyBjYXJlZnVsIGV2YWx1YXRpb24gd2hhdCBuZWVkcyB0byBiZSBkb25lIGZv
ciBEQVguIFJvc3MsDQo+ID4gPiBhbnkgaWRlYT8NCj4gPiANCj4gPiBDYW4geW91IGJpc2VjdCBp
dCB3aXRoIENPTkZJR19CUk9LRU4gcmVtb3ZlZCBmcm9tIG9sZGVyIGtlcm5lbHM/DQo+ID4gDQo+
ID4gSSByZW1lbWJlciB0cmFja2luZyBkb3duIHNvbWV0aGluZyBsaWtlIHRoaXMgd2hlbiBpbml0
aWFsbHkgZG9pbmcNCj4gPiB0aGUgcG1kIHN1cHBvcnQuwqDCoEl0IGVuZGVkIHVwIGJlaW5nIGEg
bWlzc2VkIHBtZF9kZXZtYXAoKSBjaGVjayBpbg0KPiA+IHRoZSBmYXVsdCBwYXRoLCBzbyBpdCBt
YXkgbm90IGJlIHRoZSBzYW1lIGlzc3VlLsKgwqBJdCB3b3VsZCBhdCBsZWFzdA0KPiA+IGJlIGlu
dGVyZXN0aW5nIHRvIHNlZSBpZiA0LjYgZmFpbHMgaW4gYSBzaW1pbGFyIG1hbm5lciB3aXRoIHRo
aXMNCj4gPiB0ZXN0IGFuZCBGU19EQVhfUE1EIGVuYWJsZWQuDQo+IA0KPiBJJ3ZlIGJlZW4gYWJs
ZSB0byByZXByb2R1Y2UgdGhpcyB3aXRoIG15IHY0LjktcmMyIGJyYW5jaCwgYnV0IGl0DQo+IGRv
ZXNuJ3QgcmVwcm9kdWNlIHdpdGggdGhlIG9sZCB2NC42IGtlcm5lbC4NCg0KTm90IHN1cmUgaWYg
aXQncyByZWxldmFudCwgYnV0IGFzIEZZSSBJIGZpeGVkIGEgc2ltaWxhciBpc3N1ZSBiZWZvcmUu
DQoNCmNvbW1pdCA1OWJmNGZiOWQzODY2MDFjYmFhNzBhOWIwMDE1OWFiYjg0NmRlZGFhDQpkYXg6
IFNwbGl0IHBtZCBtYXAgd2hlbiBmYWxsYmFjayBvbiBDT1cNCg0KLVRvc2hpCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
