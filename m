Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 83AD01A1E75
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 11:40:02 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 4/5] dax: for truncate/hole-punch, do zeroing through
 the driver if possible
Date: Wed, 11 May 2016 18:39:59 +0000
Message-ID: <1462991986.29294.29.camel@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
 <1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <5E1FB0B45FA4AB4A819E9443201F1C82@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA1LTEwIGF0IDEyOjQ5IC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
wqANCi4uLg0KDQo+IEBAIC0xMjQwLDExICsxMjU0LDE2IEBAIGludCBkYXhfemVyb19wYWdlX3Jh
bmdlKHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+IGxvZmZfdCBmcm9tLCB1bnNpZ25lZCBsZW5ndGgs
DQo+IMKgCQkJLnNpemUgPSBQQUdFX1NJWkUsDQo+IMKgCQl9Ow0KPiDCoA0KPiAtCQlpZiAoZGF4
X21hcF9hdG9taWMoYmRldiwgJmRheCkgPCAwKQ0KPiAtCQkJcmV0dXJuIFBUUl9FUlIoZGF4LmFk
ZHIpOw0KPiAtCQljbGVhcl9wbWVtKGRheC5hZGRyICsgb2Zmc2V0LCBsZW5ndGgpOw0KPiAtCQl3
bWJfcG1lbSgpOw0KPiAtCQlkYXhfdW5tYXBfYXRvbWljKGJkZXYsICZkYXgpOw0KPiArCQlpZiAo
ZGF4X3JhbmdlX2lzX2FsaWduZWQoYmRldiwgJmRheCwgb2Zmc2V0LCBsZW5ndGgpKQ0KPiArCQkJ
cmV0dXJuIGJsa2Rldl9pc3N1ZV96ZXJvb3V0KGJkZXYsIGRheC5zZWN0b3IsDQo+ICsJCQkJCWxl
bmd0aCA+PiA5LCBHRlBfTk9GUywgdHJ1ZSk7DQoNCkZvdW5kIGFub3RoZXIgYnVnIGhlcmUgd2hp
bGUgdGVzdGluZy4gVGhlIHplcm9vdXQgbmVlZHMgdG8gYmUgZG9uZSBmb3INCnNlY3RvciArIChv
ZmZzZXQgPj4gOSkuIFRoZSBhYm92ZSBqdXN0IHplcm9lZCBvdXQgdGhlIGZpcnN0IHNlY3RvciBv
Zg0KdGhlIHBhZ2UgaXJyZXNwZWN0aXZlIG9mIG9mZnNldCwgd2hpY2ggaXMgd3JvbmcuCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
