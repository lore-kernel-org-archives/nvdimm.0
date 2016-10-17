Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam03on071f.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe4a::71f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3019A1A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 10:45:06 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2] DAX: enable iostat for read/write
Date: Mon, 17 Oct 2016 17:45:04 +0000
Message-ID: <1476726205.20881.72.camel@hpe.com>
References: <1476724738-19133-1-git-send-email-toshi.kani@hpe.com>
 <20161017172957.GC25175@linux.intel.com>
In-Reply-To: <20161017172957.GC25175@linux.intel.com>
Content-Language: en-US
Content-ID: <7AA5AB08D4FFCF4D8118B3DF6ACF59C3@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTEwLTE3IGF0IDExOjI5IC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIE1vbiwgT2N0IDE3LCAyMDE2IGF0IDExOjE4OjU4QU0gLTA2MDAsIFRvc2hpIEthbmkgd3Jv
dGU6DQo+ID4gDQo+ID4gREFYIElPIHBhdGggZG9lcyBub3Qgc3VwcG9ydCBpb3N0YXQsIGJ1dCBp
dHMgbWV0YWRhdGEgSU8gcGF0aCBkb2VzLg0KPiA+IFRoZXJlZm9yZSwgaW9zdGF0IHNob3dzIG1l
dGFkYXRhIElPIHN0YXRpc3RpY3Mgb25seSwgd2hpY2ggaGFzIGJlZW4NCj4gPiBjb25mdXNpbmcg
dG8gdXNlcnMuDQo+ID4gDQo+ID4gQWRkIGlvc3RhdCBzdXBwb3J0IHRvIHRoZSBEQVggcmVhZC93
cml0ZSBwYXRoLg0KPiA+IA0KPiA+IE5vdGUsIGlvc3RhdCBzdGlsbCBkb2VzIG5vdCBzdXBwb3J0
IHRoZSBEQVggbW1hcCBwYXRoIGFzIGl0IGFsbG93cw0KPiA+IHVzZXIgYXBwbGljYXRpb25zIHRv
IGFjY2VzcyBkaXJlY3RseS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBUb3NoaSBLYW5pIDx0
b3NoaS5rYW5pQGhwZS5jb20+DQo+ID4gQ2M6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91
bmRhdGlvbi5vcmc+DQo+ID4gQ2M6IEFsZXhhbmRlciBWaXJvIDx2aXJvQHplbml2LmxpbnV4Lm9y
Zy51az4NCj4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+
ID4gQ2M6IFJvc3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVsLmNvbT4NCj4gPiAt
LS0NCj4gPiB2MjoNCj4gPiAtIFNldCBhIG1pbmltdW0gb2Ygb25lIHNlY3RvciAoRGFuIFdpbGxp
YW1zKQ0KPiANCj4gV2hhdCBhYm91dCBEYXZlJ3MgZmVlZGJhY2sgdGhhdCB0aGlzIGNvZGUganVz
dCByZWltcGxlbWVudHPCoA0KPiBnZW5lcmljX3N0YXJ0X2lvX2FjY3QoKSBhbmQgZ2VuZXJpY19l
bmRfaW9fYWNjdCgpPw0KDQpNeSBiYWQuIFRoZXJlIHdhcyBzb21lIGlzc3VlIGluIG15IGVtYWls
IGJveCBhbmQgSSBqdXN0IHJlYWxpemVkIGl0Lg0KUGxlYXNlIGRpc3JlZ2FyZCB0aGlzIHZlcnNp
b24uLi7CoA0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
