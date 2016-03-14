Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F3C31A1F63
 for <linux-nvdimm@lists.01.org>; Sun, 13 Mar 2016 20:15:52 -0700 (PDT)
Message-ID: <1457925331.4102.1.camel@kernel.org>
Subject: Re: [RFC v6 2/8] nvdimm: Add wrapper for IOCTL pass thru
From: Vishal Verma <vishal@kernel.org>
Date: Sun, 13 Mar 2016 21:15:31 -0600
In-Reply-To: <CAPcyv4itG0tyBLW7G1babYVd8UDyTG2Vg8xbwddz6n0z02LYdw@mail.gmail.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
 <833a627a8cff27a72f946fa9432cacf2a855e485.1457730736.git.jerry.hoemann@hpe.com>
 <CAPcyv4gBg5g2Zj6xE0RC0k68t+x8KY9zaJprRC4UYP3HAX3oew@mail.gmail.com>
 <20160311232941.GA139754@tevye.fc.hp.com>
 <CADDOmiKotO4d81STbf1dL033HRqmiWYQ_HHHDGeU_jyYSJMdWA@mail.gmail.com>
 <CAPcyv4itG0tyBLW7G1babYVd8UDyTG2Vg8xbwddz6n0z02LYdw@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCAyMDE2LTAzLTEyIGF0IDA5OjUwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gU2F0LCBNYXIgMTIsIDIwMTYgYXQgNzo0OSBBTSwgVmlzaGFsIFZlcm1hIDx2aXNoYWxAa2Vy
bmVsLm9yZz4KPiB3cm90ZToKPiA+IAo+ID4gT24gRnJpLCBNYXIgMTEsIDIwMTYgYXQgNDoyOSBQ
TSwgSmVycnkgSG9lbWFubiA8amVycnkuaG9lbWFubkBocGUuYwo+ID4gb20+IHdyb3RlOgo+ID4g
PiAKPiA+ID4gPiAKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBBbHNvIGxldCdzIGRyb3Ag
dGhlIG5jcF8KPiA+ID4gPiBwcmVmaXgsCj4gPiA+ID4gaXQncyBub24taWRpb21hdGljIHdpdGgg
dGhlIHJlc3Qgb2YgdGhlIGRlZmluaXRpb25zIGluIHRoaXMKPiA+ID4gPiBmaWxlLgo+ID4gPiAK
PiA+ID4gSSBsaWtlIGZpZWxkIG5hbWVzIHdpdGggcHJlZml4ZXMgdGhhdCByZWZlciBiYWNrIHRv
IHRoZSBzdHJ1Y3R1cmUKPiA+ID4gdGhleSdyZQo+ID4gPiBkZWZpbmVkIGluLsKgwqBJdCBtYWtl
cyByZWFkaW5nIGNvZGUgZWFzaWVyLsKgwqAoZS5nLiBob3cgbWFueSB0aW1lcwo+ID4gPiBpcwo+
ID4gPiAic2l6ZSIgZGVmaW5lZCBpbiBhIHN0cnVjdD8pCj4gPiA+IAo+ID4gPiB3b3VsZCB5b3Ug
YmUgb2theSB3aXRoIGEgcHJlZml4ICJuZF8iP8KgwqBpdCBkb2Vzbid0IHF1aXRlIHRpZSBhcwo+
ID4gPiBjbG9zZWx5Cj4gPiA+IHRvIHRoZSBzdHJ1Y3QsIGJ1dCBpdCBzaG91bGQgbWFrZSB0aGVt
IHVuaXF1ZSB3L2luIHRoZSBrZXJuZWwuCj4gPiBJc24ndCB0aGlzIGxlYW5pbmcgdG93YXJkcyB0
aGUgIkh1bmdhcmlhbiBub3RhdGlvbiIsIGFuZCBpc24ndCB0aGF0Cj4gPiBkaXNjb3VyYWdlZCBp
biB0aGUga2VybmVsIGNvZGluZyBzdHlsZS4uCj4gPiAKPiA+IEZyb20gRG9jdW1lbnRhdGlvbi9D
b2RpbmdTdHlsZQo+ID4gCj4gPiBFbmNvZGluZyB0aGUgdHlwZSBvZiBhIGZ1bmN0aW9uIGludG8g
dGhlIG5hbWUgKHNvLWNhbGxlZCBIdW5nYXJpYW4KPiA+IG5vdGF0aW9uKSBpcyBicmFpbiBkYW1h
Z2VkIC0gdGhlIGNvbXBpbGVyIGtub3dzIHRoZSB0eXBlcyBhbnl3YXkKPiA+IGFuZCBjYW4KPiA+
IGNoZWNrIHRob3NlLCBhbmQgaXQgb25seSBjb25mdXNlcyB0aGUgcHJvZ3JhbW1lci4KPiBJIHdv
dWxkbid0IGdvIHRoYXQgZmFyLi4uIGxvb2sgYXQgInN0cnVjdCBiaW8iLCAic3RydWN0IGZpbGUi
LCBvcgo+ICJzdHJ1Y3QgbmRfcmVnaW9uIiB0aGF0IGhhdmUgYSBjb21tb24gcHJlZml4IGZvciAo
c29tZSkgbWVtYmVyCj4gZmllbGRzLgo+IFRoYXQncyBub3QgSHVuZ2FyaWFuIG5vdGF0aW9uLCB0
aGF0J3MgbWFraW5nIHRoZSBjb2RlIGVhc2llciB0byBncmVwLgoKQWggeWVzIC0gYWdyZWVkLgoK
PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IExpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKPiBMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCj4gaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
