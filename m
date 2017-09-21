Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88F7521E1B775
 for <linux-nvdimm@lists.01.org>; Thu, 21 Sep 2017 14:48:56 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 0/3] acpi nfit: make emulation of translate SPA on
 nfit_test
Date: Thu, 21 Sep 2017 21:52:02 +0000
Message-ID: <1506030599.23025.26.camel@intel.com>
References: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <58633FA4B101E24980B0E73A6FD19F91@intel.com>
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
To: "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA4LTE4IGF0IDEzOjQ2ICswOTAwLCBZYXN1bm9yaSBHb3RvIHdyb3RlOg0K
PiBUaGlzIHBhdGNoIHNldCBpcyB0byBlbXVsYXRlIHRyYW5zbGF0ZSBTUEEgZmVhdHVyZSBieSBu
Zml0X3Rlc3Qua28uDQo+IA0KPiBDZXJ0YWlubHkgdGhlIG5maXQgYWNwaSBkcml2ZXIgc3VwcG9y
dHMgdHJhbnNsYXRlIFNQQSBpbnRlcmZhY2XCoA0KPiB2aWEgTkRfQ01EX0NBTEwuIEJ1dCBuZml0
X3Rlc3QgZG9lcyBub3Qgc3VwcG9ydCBpdCB5ZXQuDQo+IA0KPiBUbyB0ZXN0IHRyYW5zbGF0ZSBT
UEEgd2l0aCBuZml0X3Rlc3QsIHRoaXMgcGF0Y2ggc2V0IGlzIG5lZWRlZC4NCj4gDQo+IC0tLQ0K
PiBDaGFuZ2UgbG9nIHNpbmNlIHYxIFsxXToNCj4gwqAtIFNlcGFyYXRlIHBhdGNoIHNldCBvZiBr
ZW5lbCBmcm9tIG5kY3RsIHBhdGNoIHNldC4NCj4gwqAtIENoYW5nZSBpbnRlcmZhY2UgdmlhIE5E
X0NNRF9DQUxMLg0KDQpPdGhlciB0aGFuIHRoZSBmZXcgY2hlY2twYXRjaCB0eXBlIGlzc3Vlcywg
dGhlIHNlcmllcyBsb29rcyBnb29kIHRvIG1lLg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8
dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KDQo+IA0KPiANCj4gWzFdIGh0dHBzOi8vd3d3Lm1h
aWwtYXJjaGl2ZS5jb20vbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZy9tc2cwNTI4Ny5odA0KPiBt
bA0KPiANCj4gLS0tLQ0KPiANCj4gVGhhbmtzLA0KPiAtLS0NCj4gWWFzdW5vcmkgR290bw0KPiAN
Cj4gDQo+IA0KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xw0KPiBMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0DQo+IExpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcNCj4gaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
