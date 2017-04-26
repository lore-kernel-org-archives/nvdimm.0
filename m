Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11BD921951CB6
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 13:24:58 -0700 (PDT)
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4736d44e-bbcf-5d59-a1a9-317d0f4da847@deltatee.com>
Date: Wed, 26 Apr 2017 12:11:33 -0600
MIME-Version: 1.0
In-Reply-To: <20170426074416.GA7936@lst.de>
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
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
To: Christoph Hellwig <hch@lst.de>
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyNi8wNC8xNyAwMTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gSSB0aGlu
ayB3ZSdsbCBhdCBsZWFzdCBuZWVkIGEgZHJhZnQgb2YgdGhvc2UgdG8gbWFrZSBzZW5zZSBvZiB0
aGVzZQo+IHBhdGNoZXMuICBPdGhlcndpc2UgdGhleSBqdXN0IGxvb2sgdmVyeSBjbHVtc3kuCgpP
aywgSSdsbCB3b3JrIHVwIGEgZHJhZnQgcHJvcG9zYWwgYW5kIHNlbmQgaXQgaW4gYSBjb3VwbGUg
ZGF5cy4gQnV0CndpdGhvdXQgYSBsb3Qgb2YgY2xlYW51cCBzdWNoIGFzIHRoaXMgc2VyaWVzIGl0
J3Mgbm90IGdvaW5nIHRvIGV2ZW4gYmUKYWJsZSB0byBjb21waWxlLgoKPiBJJ20gc29ycnkgYnV0
IHRoaXMgQVBJIGlzIGp1c3QgYSB0cmFpbndyZWNrLiAgUmlnaHQgbm93IHdlIGhhdmUgdGhlCj4g
bmljZSBsaXR0bGUga21hcF9hdG9taWMgQVBJLCB3aGljaCBuZXZlciBmYWlscyBhbmQgaGFzIGEg
dmVyeSBuaWNlCj4gY2FsbGluZyBjb252ZW50aW9uIHdoZXJlIHdlIGp1c3QgcGFzcyBiYWNrIHRo
ZSByZXR1cm4gYWRkcmVzcywgYnV0IGRvZXMKPiBub3Qgc3VwcG9ydCBzbGVlcGluZyBpbnNpZGUg
dGhlIGNyaXRpY2FsIHNlY3Rpb24uCj4gCj4gQW5kIGttYXAsIHdo0ZZjaCBtYXkgZmFpbCBhbmQg
cmVxdWlyZXMgdGhlIG9yaWdpbmFsIHBhZ2UgdG8gYmUgcGFzc2VkCj4gYmFjay4gIEFueXRoaW5n
IHRoYXQgbWl4ZXMgdGhlc2UgdHdvIGNvbmNlcHRzIHVwIGlzIHNpbXBseSBhIG5vbi1zdGFydGVy
LgoKT2ssIHdlbGwgZm9yIHN0YXJ0ZXJzIEkgdGhpbmsgeW91IGFyZSBtaXN0YWtlbiBhYm91dCBr
bWFwIGJlaW5nIGFibGUgdG8KZmFpbC4gSSdtIGhhdmluZyBhIGhhcmQgdGltZSBmaW5kaW5nIG1h
bnkgdXNlcnMgb2YgdGhhdCBmdW5jdGlvbiB0aGF0CmJvdGhlciB0byBjaGVjayBmb3IgYW4gZXJy
b3Igd2hlbiBjYWxsaW5nIGl0LiBUaGUgbWFpbiBkaWZmaWN1bHR5IHdlCmhhdmUgbm93IGlzIHRo
YXQgbmVpdGhlciBvZiB0aG9zZSBmdW5jdGlvbnMgYXJlIGV4cGVjdGVkIHRvIGZhaWwgYW5kIHdl
Cm5lZWQgdGhlbSB0byBiZSBhYmxlIHRvIGluIGNhc2VzIHdoZXJlIHRoZSBwYWdlIGRvZXNuJ3Qg
bWFwIHRvIHN5c3RlbQpSQU0uIFRoaXMgcGF0Y2ggc2VyaWVzIGlzIHRyeWluZyB0byBhZGRyZXNz
IGl0IGZvciB1c2VycyBvZiBzY2F0dGVybGlzdC4KSSdtIGNlcnRhaW5seSBvcGVuIHRvIG90aGVy
IHN1Z2dlc3Rpb25zLgoKSSBhbHNvIGhhdmUgdG8gZGlzYWdyZWUgdGhhdCBrbWFwIGFuZCBrbWFw
X2F0b21pYyBhcmUgYWxsIHRoYXQgIm5pY2UiLgpFeGNlcHQgZm9yIHRoZSBzbGVlcGluZyByZXN0
cmljdGlvbiBhbmQgcGVyZm9ybWFuY2UsIHRoZXkgZWZmZWN0aXZlbHkgZG8KdGhlIHNhbWUgdGhp
bmcuIEFuZCBpdCB3YXMgbmVjZXNzYXJ5IHRvIHdyaXRlIGEgbWFjcm8gd3JhcHBlciBhcm91bmQK
a3VubWFwX2F0b21pYyB0byBlbnN1cmUgdGhhdCB1c2VycyBvZiB0aGF0IGZ1bmN0aW9uIGRvbid0
IHNjcmV3IGl0IHVwLgooU2VlIDU5Nzc4MWYzZTUuKSBJJ2Qgc2F5IHRoZSBrbWFwL2ttYXBfYXRv
bWljIGZ1bmN0aW9ucyBhcmUgdGhlCnRyYWlud3JlY2sgYW5kIEknbSB0cnlpbmcgdG8gZG8gbXkg
YmVzdCB0byBjbGVhbnVwIGEgZmV3IGNhc2VzLgoKVGhlcmUgYXJlIGEgZmFpciBudW1iZXIgb2Yg
Y2FzZXMgaW4gdGhlIGtlcm5lbCB0aGF0IGRvIHNvbWV0aGluZyBsaWtlOgoKaWYgKHNvbWV0aGlu
ZykKICAgIHggPSBrbWFwKHBhZ2UpOwplbHNlCiAgICB4ID0ga21hcF9hdG9taWMocGFnZSk7Ci4u
LgppZiAoc29tZXRoaW5nKQogICAga3VubWFwKHBhZ2UpCmVsc2UKICAgIGt1bm1hcF9hdG9taWMo
eCkKCldoaWNoIGp1c3Qgc2VlbXMgY3VtYmVyc29tZSB0byBtZS4KCkluIGFueSBjYXNlLCBpZiB5
b3UgY2FuIGFjY2VwdCBhbiBzZ19rbWFwIGFuZCBzZ19rbWFwX2F0b21pYyBhcGkganVzdApzYXkg
c28gYW5kIEknbGwgbWFrZSB0aGUgY2hhbmdlLiBCdXQgSSdsbCBzdGlsbCBuZWVkIGEgZmxhZ3Mg
dmFyaWFibGUKZm9yIFNHX01BUF9NVVNUX05PVF9GQUlMIHRvIHN1cHBvcnQgbGVnYWN5IGNhc2Vz
IHRoYXQgaGF2ZSBubyBmYWlsIHBhdGgKYW5kIGJvdGggb2YgdGhvc2UgZnVuY3Rpb25zIHdpbGwg
bmVlZCB0byBiZSBwcmV0dHkgbmVhcmx5IHJlcGxpY2FzIG9mCmVhY2ggb3RoZXIuCgpMb2dhbgoK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
