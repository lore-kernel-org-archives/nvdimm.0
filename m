Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B28F21D046BF
 for <linux-nvdimm@lists.01.org>; Mon, 18 Sep 2017 06:59:12 -0700 (PDT)
Received: from G9W8455.americas.hpqcorp.net (g9w8455.houston.hp.com
 [16.216.161.94])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3425.houston.hpe.com (Postfix) with ESMTPS id BBA36B5
 for <linux-nvdimm@lists.01.org>; Mon, 18 Sep 2017 14:02:14 +0000 (UTC)
From: "Saldivar, Maurice A." <maurice.a.saldivar@hpe.com>
Subject: Re: ndctl-58 causing kernel panic w/ latest kernel
Date: Mon, 18 Sep 2017 14:02:12 +0000
Message-ID: <1505742903.3864.2.camel@hpe.com>
References: <1505511004.5511.52.camel@hpe.com>
 <CAPcyv4hMdFrbu0qfCHJGe4OS7E22evj5tPPYY1pE-uQ-Q9vo_g@mail.gmail.com>
In-Reply-To: <CAPcyv4hMdFrbu0qfCHJGe4OS7E22evj5tPPYY1pE-uQ-Q9vo_g@mail.gmail.com>
Content-Language: en-US
Content-ID: <5B9F0C862A3C2349B1FF43B5B89D9E52@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE3OjE2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgU2VwIDE1LCAyMDE3IGF0IDI6NDEgUE0sIFNhbGRpdmFyLCBNYXVyaWNlIEEuDQo+
IDxtYXVyaWNlLmEuc2FsZGl2YXJAaHBlLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gVGVzdGluZyBu
ZGN0bC01OCBvbiBvdXIgTlZESU1NLU5zIHdpdGggdGhlIGxhdGVzdCBrZXJuZWwgKDQuMTMuMikN
Cj4gPiBjYXVzZXMgYSBwYW5pYyB3aGVuIGNvbmZpZ3VyaW5nIGEgcG1lbSBkZXZpY2UgZnJvbSBy
YXcgdG8gc2VjdG9yDQo+ID4gbW9kZS4NCj4gPiANCj4gPiBuZGN0bCBjcmVhdGUtbmFtZXNwYWNl
IC1mIC1lIG5hbWVzcGFjZTAuMCAtbSBzZWN0b3INCj4gPiANCj4gPiBJIHdhcyBub3QgYWJsZSB0
byByZXByb2R1Y2UgdGhpcyBpc3N1ZSB1c2luZyBuZGN0bC01Ny4gQmVsb3cgaXMgdGhlDQo+ID4g
c3RhY2sgdHJhY2UgZnJvbSBjb25maWd1cmluZyBhIHBtZW0gZGV2aWNlIGZyb20gcmF3IHRvIHNl
Y3RvciBtb2RlLg0KPiA+IA0KPiA+IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBw
b2ludGVyIGRlcmVmZXJlbmNlIGF0DQo+ID4gMDAwMDAwMDAwMDAwMDAyOA0KPiA+IElQOiBob2xk
ZXJfY2xhc3Nfc3RvcmUrMHgyNTMvMHgyYjAgW2xpYm52ZGltbV0NCj4gQ2FuIHlvdSB0cmFuc2xh
dGUgdGhpcyB0byBhIGxpbmUgbnVtYmVyPyBUcnkgdGhlIGZvbGxvd2luZywgYW5kIHNlbmQNCj4g
dGhlIG91dHB1dDoNCj4gDQo+ICQgZ2RiIGRyaXZlcnMvbnZkaW1tL2xpYm52ZGltbS5rbw0KPiAo
Z2RiKSBsaSAqKGhvbGRlcl9jbGFzc19zdG9yZSsweDI1MykNCg0KDQpZdXAsIEkgcmFuIHRoZSBj
b21tYW5kIGFuZCBnb3QgdGhlIGZvbGxvd2luZyBvdXRwdXQ6DQrCoA0KUmVhZGluZyBzeW1ib2xz
IGZyb20NCi91c3IvbGliL21vZHVsZXMvNC4xMy4yL2tlcm5lbC9kcml2ZXJzL252ZGltbS9saWJu
dmRpbW0ua28uLi5kb25lLg0KKGdkYikgbGkgKihob2xkZXJfY2xhc3Nfc3RvcmUrMHgyNTMpDQow
eDc3NzMgaXMgaW4gaG9sZGVyX2NsYXNzX3N0b3JlIChkcml2ZXJzL252ZGltbS9uYW1lc3BhY2Vf
ZGV2cy5jOjE0MjApLg0KMTQxNQkJZm9yIChpID0gMDsgaSA8IG5kX3JlZ2lvbi0+bmRyX21hcHBp
bmdzOyBpKyspIHsNCjE0MTYJCQlzdHJ1Y3QgbmRfbWFwcGluZyAqbmRfbWFwcGluZyA9ICZuZF9y
ZWdpb24tDQo+bWFwcGluZ1tpXTsNCjE0MTcJCQlzdHJ1Y3QgbnZkaW1tX2RydmRhdGEgKm5kZCA9
DQp0b19uZGQobmRfbWFwcGluZyk7DQoxNDE4CQkJc3RydWN0IG5kX25hbWVzcGFjZV9pbmRleCAq
bnNpbmRleDsNCjE0MTkJDQoxNDIwCQkJbnNpbmRleCA9IHRvX25hbWVzcGFjZV9pbmRleChuZGQs
IG5kZC0NCj5uc19jdXJyZW50KTsNCjE0MjEJCQlpZiAobnNpbmRleCA9PSBOVUxMKQ0KMTQyMgkJ
CQlsb29wX2JpdG1hc2sgfD0gMTsNCjE0MjMJCQllbHNlIHsNCjE0MjQJCQkJLyogY2hlY2sgd2hl
dGhlciBleGlzdGluZyBsYWJlbHMNCmFyZSB2MS4xIG9yIHYxLjIgKi8NCihnZGIpwqANCg0KU2lu
Y2VyZWx5LA0KTWF1cmljZSDCoApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
