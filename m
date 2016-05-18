Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85A1F1A1FB6
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 07:10:31 -0700 (PDT)
Message-ID: <1463580074.1575.7.camel@hpe.com>
Subject: Re: [PATCH] remove unused blkdev_dax_capable() function
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 18 May 2016 08:01:14 -0600
In-Reply-To: <3280835.MNk2ItMooy@wuerfel>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
 <3280835.MNk2ItMooy@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, jack@suse.cz, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE2LTA1LTE4IGF0IDA5OjU0ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOgo+
IFRoZSBjaGFuZ2UgZnJvbSBibGtkZXZfZGF4X2NhcGFibGUoKSB0byBiZGV2X2RheF9jYXBhYmxl
KCkgcmVtb3ZlZCB0aGUKPiBvbmx5IHVzZXIgb2YgdGhlIGZvcm1lciwgc28gd2Ugbm93IGdldCBh
IGJ1aWxkIHdhcm5pbmc6Cj4gCj4gZnMvYmxvY2tfZGV2LmM6MTI0NDoxMzogZXJyb3I6ICdibGtk
ZXZfZGF4X2NhcGFibGUnIGRlZmluZWQgYnV0IG5vdCB1c2VkCj4gWy1XZXJyb3I9dW51c2VkLWZ1
bmN0aW9uXQo+IMKgc3RhdGljIGJvb2wgYmxrZGV2X2RheF9jYXBhYmxlKHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXYpCj4gCj4gVGhpcyByZW1vdmVzIHRoZSBub3ctdW51c2VkIGZ1bmN0aW9uLgo+
IAo+IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+Cj4gRml4ZXM6
IGE4MDc4YjFmYzYxNiAoImJsb2NrOiBVcGRhdGUgYmxrZGV2X2RheF9jYXBhYmxlKCkgZm9yCj4g
Y29uc2lzdGVuY3kiKQrCoDoKPiBJdCdzIG5vdCBlbnRpcmVseSBmcm9tIHRoZSBwYXRjaCBkZXNj
cmlwdGlvbiB3aGF0IHRoZSBpbnRlbnRpb24gd2FzIGhlcmUKPiBpbiBrZWVwaW5nIHR3byBzbGln
aHRseSBkaWZmZXJlbnQgaW1wbGVtZW50YXRpb25zIG9mIHRoZSBzYW1lIGZ1bmN0aW9uCj4gaW4g
b25lIGZpbGUsIG15IGJlc3QgZ3Vlc3MgaXMgdGhhdCBpdCB3YXMgbm90IGludGVudGlvbmFsIGFu
ZCB3ZSBzaG91bGQKPiBqdXN0IHJlbW92ZSB0aGlzLgoKVGhhbmtzIGZvciB0aGUgYnVpbGQgZml4
LiDCoExvb2tzIGxpa2UgdGhlcmUgd2FzIGEgY29uZmxpY3QKYmV0d2VlbsKgODA0NGFhZTZmMzc0
IGFuZMKgYTgwNzhiMWZjNjE2ZCwgd2hpY2ggcmVzdWx0ZWQgdGhpcyBidWlsZCBlcnJvci4KQm90
aCBwYXRjaGVzIG1vdmVkIGJsa2Rldl9kYXhfY2FwYWJsZSgpIGZyb23CoGJsb2NrL2lvY3RsLmMK
dG/CoGZzL2Jsb2NrX2Rldi5jLgoKQWNrZWQtYnk6IFRvc2hpIEthbmkgPHRvc2hpLmthbmlAaHBl
LmNvbT4KClRoYW5rcywKLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGlt
bQo=
