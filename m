Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAB9B21A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:41:56 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 1/2] libnvdimm: fix clear length of nvdimm_forget_poison()
Date: Fri, 28 Apr 2017 22:41:53 +0000
Message-ID: <1493419278.30303.8.camel@hpe.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
 <CAPcyv4i+U62GMyK=xNXB9ZjzS-028q4Qch=kxa9_pkwXrFJdsA@mail.gmail.com>
 <1493418523.30303.6.camel@hpe.com>
 <CAPcyv4jyH=kyBy7-NW77NdssqUKpE2=uf3VfOjk7A5zeUgMAMA@mail.gmail.com>
In-Reply-To: <CAPcyv4jyH=kyBy7-NW77NdssqUKpE2=uf3VfOjk7A5zeUgMAMA@mail.gmail.com>
Content-Language: en-US
Content-ID: <C4CC909238E0974994BB4F1A147780ED@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA0LTI4IGF0IDE1OjM5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgQXByIDI4LCAyMDE3IGF0IDM6MjkgUE0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbQ0KPiA+IHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAxNy0wNC0yOCBhdCAxNDo0
OCAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBBcHIgMjcsIDIwMTcg
YXQgMzo1NyBQTSwgVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPg0KIDoNCj4gPiA+ID4g
DQo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoG52ZGltbV9mb3JnZXRfcG9pc29uKG52ZGltbV9idXMs
IHBoeXMsIGxlbik7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChjbGVhcl9lcnIuY2xlYXJl
ZCA+IDApDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBudmRpbW1fZm9y
Z2V0X3BvaXNvbihudmRpbW1fYnVzLCBwaHlzLA0KPiA+ID4gPiBjbGVhcl9lcnIuY2xlYXJlZCk7
DQo+ID4gPiA+ICsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBjbGVhcl9lcnIuY2xl
YXJlZDsNCj4gPiA+IA0KPiA+ID4gTG9va3MsIGdvb2Qgd2UgbmVlZCB0byBtYXJrIHRoaXMgZm9y
IC1zdGFibGUgc2luY2UgdGhlIGJ1ZyBpcw0KPiA+ID4gYWxzbyBwcmVzZW50IGluIGN1cnJlbnQg
bWFpbmxpbmUuDQo+ID4gPiANCj4gPiA+IEZpeGVzOiBlMDQ2MTE0YWY1ZmMgKCJsaWJudmRpbW06
IGNsZWFyIHRoZSBpbnRlcm5hbCBwb2lzb25fbGlzdA0KPiA+ID4gd2hlbiBjbGVhcmluZyBiYWRi
bG9ja3MiKQ0KPiA+IA0KPiA+IFNoYWxsIEkgc2VuZCBhIHBhdGNoIGJhc2VkIG9uIHRoZSBjdXJy
ZW50IG1haW5saW5lIHdpdGggY2MgdG8NCj4gPiAtc3RhYmxlPyAgVGhlIGZ1bmMgbmFtZSBpcyBu
dmRpbW1fY2xlYXJfZnJvbV9wb2lzb25fbGlzdCgpIGluIHRoZQ0KPiA+IG1haW5saW5lLg0KPiAN
Cj4gSSB0aGlua3MgaXQncyB0b28gbGF0ZSB0byBnZXQgYSBmaXggaW50byA0LjExLCBlc3BlY2lh
bGx5IHdoZW4gdGhpcw0KPiB3ZW50IGluIGJyb2tlbiBhbmQgbm90IGEgcmVncmVzc2lvbi4gSSds
bCBqdXN0IHRhZyB0aGlzIGZvciAtc3RhYmxlDQo+IGFuZCBoYW5kbGUgdGhlIGJhY2twb3J0IG1h
bnVhbGx5Lg0KDQpTb3VuZHMgZ3JlYXQuIFRoYW5rcyBEYW4hDQotVG9zaGkNCg0KDQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
