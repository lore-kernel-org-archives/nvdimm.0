Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on072b.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::72b])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BEA21A1E2B
 for <linux-nvdimm@lists.01.org>; Wed, 24 Aug 2016 07:40:11 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
Date: Wed, 24 Aug 2016 14:40:07 +0000
Message-ID: <1472049570.1532.10.camel@hpe.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
 <CAPcyv4gJtTj8chX_eTNhs1PJ=D3X7USuDXwFSWSEZt1cUAXpUw@mail.gmail.com>
 <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
 <CAPcyv4g1ULSDXzp5ufpXzp5JB3z1TN_za=_AqUC8E6f2FNsycw@mail.gmail.com>
 <DF4PR84MB0010039BC15DFF7538D46A6682EA0@DF4PR84MB0010.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4hZEU3bnpiSCr3KFxF+MiGDGzB5NdopWkFB5CWazD1pkw@mail.gmail.com>
In-Reply-To: <CAPcyv4hZEU3bnpiSCr3KFxF+MiGDGzB5NdopWkFB5CWazD1pkw@mail.gmail.com>
Content-Language: en-US
Content-ID: <0F2EE656D522D64CB12B35C04D1633E6@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "Mulumudi, Abhilash Kumar  <m.abhilash-kumar@hpe.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brian.starkey@arm.com" <brian.starkey@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA4LTIzIGF0IDIxOjQ4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXVnIDIzLCAyMDE2IGF0IDk6MjggUE0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbQ0KPiA+IA0KPiA+IEJUVywgd2h5IGRvZXMgZGV2bV9tZW1yZW1hcF9wYWdl
cygpIHB1dCBhIHdob2xlIHJhbmdlIHRvDQo+ID4gcGdtYXBfcmFkaXggYXMgZGV2aWNlIG1lbW9y
eSwgYnV0IG9ubHkgaW5pdGlhbGl6ZSBwYWdlLT5wZ21hcCBmb3INCj4gPiBpdHMgZGF0YSByYW5n
ZT/CoMKgSXMgdGhlcmUgcGFydGljdWxhciByZWFzb24gZm9yIHRoaXMgaW5jb25zaXN0ZW5jeT8N
Cj4NCj4gVGhlIHJhZGl4IHRyZWUgaXMgaW5kZXhlZCBieSBzZWN0aW9uIG51bWJlciwgYnV0IHdl
IGRvbid0IGFsd2F5cw0KPiBpbml0aWFsaXplIGEgZnVsbCBzZWN0aW9uLsKgwqBUaGUgY2FzZXMg
d2hlbiB3ZSBkb24ndCB1c2UgYSBmdWxsDQo+IHNlY3Rpb24gaXMgd2hlbiBpdCBvdmVybGFwcyBk
ZXZpY2UgbWV0YWRhdGEsIG9yIGlmIGEgcGxhdGZvcm0NCj4gbXVsdGlwbGV4ZXMgdGhlIGRldmlj
ZSBtZW1vcnkgcmFuZ2Ugd2l0aCBhbm90aGVyIHJlc291cmNlIHdpdGhpbiB0aGUNCj4gc2FtZSBz
ZWN0aW9uLg0KDQpJIHNlZSwgYnV0IEkgc3RpbGwgZmVlbCBvZGQgYWJvdXQgbWFraW5nwqBnZXRf
ZGV2X3BhZ2VtYXAoKSB0byB3b3JrIGZvcg0KbWV0YWRhdGEsIGJ1dMKgZ2V0X3BhZ2UoKSAtPsKg
Z2V0X3pvbmVfZGV2aWNlX3BhZ2UoKSB0byBjcmFzaCBsaWtlIHRoaXMuDQrCoGZvbGxvd19kZXZt
YXBfcG1kKCkgYXNzdW1lcyBnZXRfcGFnZSgpIHRvIHdvcmsgd2hlbiBnZXRfZGV2X3BhZ2VtYXAo
KQ0KcmV0dXJucyBhIHZhbGlkIHBnbWFwLi4uDQoNClRoYW5rcywNCi1Ub3NoaQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
