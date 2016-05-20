Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bon0728.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc10::1:728])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 334AF1A1E16
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 07:50:14 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 0/6] Add alignment check for DAX mount
Date: Fri, 20 May 2016 14:50:05 +0000
Message-ID: <1463755257.32042.15.camel@hpe.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <f265e4ce-9271-1d83-35bc-794f2e2129df@sandeen.net>
In-Reply-To: <f265e4ce-9271-1d83-35bc-794f2e2129df@sandeen.net>
Content-Language: en-US
Content-ID: <773678FCC3FAD347868F4644E1224647@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.cz" <jack@suse.cz>, "david@fromorbit.com" <david@fromorbit.com>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "axboe@fb.com" <axboe@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Parrish, Micah \\ linux-block@vger.kernel.org (HP Servers Linux R&D)\" <micah.parrish@hpe.com>,)" <linux-block@vger.kernel.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTA1LTE5IGF0IDE4OjM3IC0wNTAwLCBFcmljIFNhbmRlZW4gd3JvdGU6DQo+
IE9uIDUvMTAvMTYgMTE6MjMgQU0sIFRvc2hpIEthbmkgd3JvdGU6DQo+ID4gDQo+ID4gV2hlbiBh
IHBhcnRpdGlvbiBpcyBub3QgYWxpZ25lZCBieSA0S0IsIG1vdW50IC1vIGRheCBzdWNjZWVkcywN
Cj4NCj4gU29ycnkgZm9yIGJlaW5nIGxhdGUsIGJ1dCAtDQo+IA0KPiBTaG91bGRuJ3QgdGhpcyBh
bmQgYWxsIHN1YnNlcXVlbnQgcGF0Y2ggY29tbWl0cyByZWZlciB0bw0KPiBQQUdFX1NJWkUsIHJh
dGhlciB0aGFuICI0a0I/Ig0KDQpSaWdodCwgdGhlIHBhdGNoIGNvbW1pdHMgc2hvdWxkIHJlZmVy
IHRvIFBBR0VfU0laRSB0byBtYXRjaCB3aXRoIHRoZSBjb2RlDQpjaGFuZ2VzLiDCoEkgYW0gYWZy
YWlkIGl0IG1heSBiZSBhIGJpdCB0b28gbGF0ZSB0byB1cGRhdGUsIHRob3VnaC4uLg0KDQpWaXNo
YWwsIGRvIHlvdSB0aGluayB5b3UgY2FuIHR3ZWFrIHRoZSBsb2dzLCAiNEtCIiB0byAiUEFHRV9T
SVpFIj8NCg0KVGhhbmtzLA0KLVRvc2hpDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBs
aXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1u
dmRpbW0K
