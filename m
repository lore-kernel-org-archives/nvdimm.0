Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78DD01A1F7E
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 07:34:14 -0700 (PDT)
Message-ID: <1462976710.27137.140.camel@hpe.com>
Subject: Re: [PATCH v4 6/6] block: Update blkdev_dax_capable() for consistency
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 11 May 2016 08:25:10 -0600
In-Reply-To: <20160511080537.GA14744@quack2.suse.cz>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
 <20160511080537.GA14744@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, tytso@mit.edu, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE2LTA1LTExIGF0IDEwOjA1ICswMjAwLCBKYW4gS2FyYSB3cm90ZToKPiBPbiBU
dWUgMTAtMDUtMTYgMTA6MjM6NTcsIFRvc2hpIEthbmkgd3JvdGU6Cj4gPiAKPiA+IGJsa2Rldl9k
YXhfY2FwYWJsZSgpIGlzIHNpbWlsYXIgdG8gYmRldl9kYXhfc3VwcG9ydGVkKCksIGJ1dCBuZWVk
cwo+ID4gdG8gcmVtYWluIGFzIGEgc2VwYXJhdGUgaW50ZXJmYWNlIGZvciBjaGVja2luZyBkYXgg
Y2FwYWJpbGl0eSBvZgo+ID4gYSByYXcgYmxvY2sgZGV2aWNlLgo+ID4gCj4gPiBSZW5hbWUgYW5k
IHJlbG9jYXRlIGJsa2Rldl9kYXhfY2FwYWJsZSgpIHRvIGtlZXAgdGhlbSBtYWludGFpbmVkCj4g
PiBjb25zaXN0ZW50bHksIGFuZCBjYWxsIGJkZXZfZGlyZWN0X2FjY2VzcygpIGZvciB0aGUgZGF4
IGNhcGFiaWxpdHkKPiA+IGNoZWNrLgo+IC4uLgo+ID4gCj4gPiArYm9vbCBiZGV2X2RheF9jYXBh
YmxlKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYpCj4gPiArewo+ID4gKwlzdHJ1Y3QgZ2VuZGlz
ayAqZGlzayA9IGJkZXYtPmJkX2Rpc2s7Cj4gPiArCXN0cnVjdCBibGtfZGF4X2N0bCBkYXggPSB7
Cj4gPiArCQkuc2l6ZSA9IFBBR0VfU0laRSwKPiA+ICsJfTsKPiA+ICsKPiA+ICsJaWYgKCFJU19F
TkFCTEVEKENPTkZJR19GU19EQVgpKQo+ID4gKwkJcmV0dXJuIGZhbHNlOwo+Cj4gRnJhbmtseSwg
SSBwcmVmZXIgdGhlICNpZmRlZiBDT05GSUdfRlNfREFYIGFuZCBqdXN0IGNvbXBpbGUgdGhlIGNv
ZGUgb3V0Cj4gd2hlbiBEQVggaXMgbm90IGVuYWJsZWQgKGxpa2UgaXQgd2FzIHdpdGggYmxrZGV2
X2RheF9jYXBhYmxlKCkpLiBUaGF0IHdheQo+IHdlIGRvbid0IGdyb3cgdGhlIGtlcm5lbCBmb3Ig
cGVvcGxlIHdobyBkb24ndCBjYXJlIGFib3V0IERBWC4KCldoZW4gQ09ORklHX0ZTX0RBWCBpcyBu
b3Qgc2V0LCB0aGUgcmVzdCBvZiB0aGUgY29kZSBpcyBvcHRpbWl6ZWQgb3V0LiDCoFNvLApJIHRo
aW5rIHRoZSBjb2RlIHNpemUgaXMgdGhlIHNhbWUuCgooZ2RiKSBkaXNhcyBiZGV2X2RheF9jYXBh
YmxlCkR1bXAgb2YgYXNzZW1ibGVyIGNvZGUgZm9yIGZ1bmN0aW9uIGJkZXZfZGF4X2NhcGFibGU6
CsKgwqDCoDB4ZmZmZmZmZmY4MTI2MGQyMCA8KzA+OsKgwqDCoMKgwqBjYWxsccKgwqAweGZmZmZm
ZmZmODE4MTNjMzAgPF9fZmVudHJ5X18+CsKgwqDCoDB4ZmZmZmZmZmY4MTI2MGQyNSA8KzU+OsKg
wqDCoMKgwqBwdXNowqDCoMKgJXJicArCoMKgwqAweGZmZmZmZmZmODEyNjBkMjYgPCs2PjrCoMKg
wqDCoMKgeG9ywqDCoMKgwqAlZWF4LCVlYXgKwqDCoMKgMHhmZmZmZmZmZjgxMjYwZDI4IDwrOD46
wqDCoMKgwqDCoG1vdsKgwqDCoMKgJXJzcCwlcmJwCsKgwqDCoDB4ZmZmZmZmZmY4MTI2MGQyYiA8
KzExPjrCoMKgwqDCoHBvcMKgwqDCoMKgJXJicArCoMKgwqAweGZmZmZmZmZmODEyNjBkMmMgPCsx
Mj46wqDCoMKgwqByZXRxwqDCoMKgCkVuZCBvZiBhc3NlbWJsZXIgZHVtcC4KClRoYW5rcywKLVRv
c2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
