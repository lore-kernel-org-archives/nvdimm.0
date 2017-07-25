Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55D6F21C91278
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 15:26:01 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Date: Tue, 25 Jul 2017 22:27:10 +0000
Message-ID: <1501021068.2042.71.camel@hpe.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
In-Reply-To: <20170725222247.GA26391@linux.intel.com>
Content-Language: en-US
Content-ID: <D414E1DE38DE34458CBBF3105CBF74A3@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE3LTA3LTI1IGF0IDE2OjIyIC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVsIDI1LCAyMDE3IGF0IDA5OjM3OjM4UE0gKzAwMDAsIEthbmksIFRvc2hpbWl0
c3Ugd3JvdGU6DQo+ID4gSGksDQo+ID4gDQo+ID4gQ29weWluZyBmaWxlcyB0byB2ZmF0IEZTIG9u
IGFuIE5WRElNTSBkZXZpY2UgaGl0cw0KPiA+IEJVR19PTighUGFnZUxvY2tlZChwYWdlKSkgaW4g
dHJ5X3RvX2ZyZWVfYnVmZmVycygpLsKgwqBJdCBoYXBwZW5zIG9uDQo+ID4gNC4xMy1yYzEsIGFu
ZCBoYXBwZW5zIG9uIG9sZGVyIGtlcm5lbHMgYXMgd2VsbC4NCj4gPiANCj4gPiBBIHNpbXBsZSBy
ZXByb2R1Y2VyIGlzIHNob3duIGJlbG93LsKgwqBJdCBpcyAxMDAlIHJlcHJvZHVjaWJsZSBvbiBt
eQ0KPiA+IHNldHVwICg4R0Igb2YgcmVndWxhciBtZW1vcnkgYW5kIDE2R0Igb2YgTlZESU1NKS7C
oMKgSXQgdXN1YWxseSBoaXRzDQo+ID4gaW4gdGhlIDNyZCBvciA0dGggZmlsZSBjb3B5IGFuZCBk
b2VzIG5vdCByZXBlYXQgd2l0aCB0aGUgd2hpbGUtDQo+ID4gbG9vcC4gIEludGVyZXN0aW5nbHks
IGl0IGhpdHMgb25seSB3aGVuIGFuIE5WRElNTSBkZXZpY2UgaXMgc2V0IGFzDQo+ID4gcmF3IG9y
IG1lbW9yeSBtb2RlLsKgwqBJdCBkb2VzIG5vdCBoaXQgd2l0aCBzZWN0b3IgbW9kZS4NCj4gDQo+
IEludGVyZXN0aW5nLCB0aGFua3MgZm9yIHRoZSByZXBvcnQuLsKgwqBJIHdhcyBhYmxlIHRvIHJl
cHJvZHVjZSB0aGlzIGluDQo+IG15IEtWTSBzZXR1cCB3aXRoIGEgdmlydHVhbGl6ZWQgTlZESU1N
IHVzaW5nIHY0LjEyLsKgwqBJIGFsc28gdHJpZWQNCj4gcmVwcm9kdWNpbmcgaXQgd2l0aCBCUkQs
IGFuZCB3YXNuJ3QgYWJsZS4NCj4gDQo+IEknbGwgdGFrZSBhIGxvb2suDQoNCkdyZWF0ISEgVGhh
bmtzIFJvc3MhDQotVG9zaGkNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
