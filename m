Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 4A66E1A1E2E
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 10:35:08 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4 0/6] Add alignment check for DAX mount
Date: Fri, 20 May 2016 17:34:59 +0000
Message-ID: <1463765696.3005.2.camel@intel.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <f265e4ce-9271-1d83-35bc-794f2e2129df@sandeen.net>
 <1463755257.32042.15.camel@hpe.com>
In-Reply-To: <1463755257.32042.15.camel@hpe.com>
Content-Language: en-US
Content-ID: <72CEEF3F0DD5A74F901B6D9DBD9FC7D1@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "toshi.kani@hpe.com" <toshi.kani@hpe.com>, "jack@suse.cz" <jack@suse.cz>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "micah.parrish@hpe.com" <micah.parrish@hpe.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTA1LTIwIGF0IDE0OjUwICswMDAwLCBLYW5pLCBUb3NoaW1pdHN1IHdyb3Rl
Og0KPiBPbiBUaHUsIDIwMTYtMDUtMTkgYXQgMTg6MzcgLTA1MDAsIEVyaWMgU2FuZGVlbiB3cm90
ZToNCj4gPiANCj4gPiBPbiA1LzEwLzE2IDExOjIzIEFNLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiA+
ID4gDQo+ID4gPiANCj4gPiA+IFdoZW4gYSBwYXJ0aXRpb24gaXMgbm90IGFsaWduZWQgYnkgNEtC
LCBtb3VudCAtbyBkYXggc3VjY2VlZHMsDQo+ID4gU29ycnkgZm9yIGJlaW5nIGxhdGUsIGJ1dCAt
DQo+ID4gDQo+ID4gU2hvdWxkbid0IHRoaXMgYW5kIGFsbCBzdWJzZXF1ZW50IHBhdGNoIGNvbW1p
dHMgcmVmZXIgdG8NCj4gPiBQQUdFX1NJWkUsIHJhdGhlciB0aGFuICI0a0I/Ig0KPiBSaWdodCwg
dGhlIHBhdGNoIGNvbW1pdHMgc2hvdWxkIHJlZmVyIHRvIFBBR0VfU0laRSB0byBtYXRjaCB3aXRo
IHRoZQ0KPiBjb2RlDQo+IGNoYW5nZXMuwqDCoEkgYW0gYWZyYWlkIGl0IG1heSBiZSBhIGJpdCB0
b28gbGF0ZSB0byB1cGRhdGUsIHRob3VnaC4uLg0KPiANCj4gVmlzaGFsLCBkbyB5b3UgdGhpbmsg
eW91IGNhbiB0d2VhayB0aGUgbG9ncywgIjRLQiIgdG8gIlBBR0VfU0laRSI/DQo+IA0KPiBUaGFu
a3MsDQo+IC1Ub3NoaQ0KDQpIaSBUb3NoaSwNCg0KSXMgaXQganVzdCBjb21taXQgbWVzc2FnZSBj
aGFuZ2VzPyBJZiBzbyBJJ20gbm90IHN1cmUgaXQgaXMgd29ydGh3aGlsZQ0KdG8gcmViYXNlIGV2
ZXJ5dGhpbmcgZm9yIHRoYXQgLSBpLmUuIG15IGRheCBlcnJvciBoYW5kbGluZyBzZXJpZXMgYW5k
DQpSb3NzJyBkYXgtbG9ja2luZyBicmFuY2ggd291bGQgYm90aCBoYXZlIHRvIGJlIHJlYmFzZWQu
Lg0KDQpJZiB0aGVyZSBhcmUgYW5kIGZpeGVzIGZvciBjb2RlLCB3ZSBjYW4gZG8gdGhlbSBhcyBh
biBhZGQtb24gcGF0Y2gNCnRob3VnaC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
