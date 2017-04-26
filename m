Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53DF921951C86
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 00:44:19 -0700 (PDT)
Date: Wed, 26 Apr 2017 09:44:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
Message-ID: <20170426074416.GA7936@lst.de>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493144468-22493-2-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCBBcHIgMjUsIDIwMTcgYXQgMTI6MjA6NDhQTSAtMDYwMCwgTG9nYW4gR3VudGhvcnBl
IHdyb3RlOgo+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBmdW5jdGlvbnMgd2hpY2gga21hcCB0aGUg
cGFnZXMgaW5zaWRlIGFuIHNnbC4KPiBUaGVzZSBmdW5jdGlvbnMgcmVwbGFjZSBhIGNvbW1vbiBw
YXR0ZXJuIG9mIGttYXAoc2dfcGFnZShzZykpIHRoYXQgaXMKPiB1c2VkIGluIG1vcmUgdGhhbiA1
MCBwbGFjZXMgd2l0aGluIHRoZSBrZXJuZWwuCj4gCj4gVGhlIG1vdGl2YXRpb24gZm9yIHRoaXMg
d29yayBpcyB0byBldmVudHVhbGx5IHNhZmVseSBzdXBwb3J0IHNnbHMgdGhhdAo+IGNvbnRhaW4g
aW8gbWVtb3J5LiBJbiBvcmRlciBmb3IgdGhhdCB0byB3b3JrLCBhbnkgYWNjZXNzIHRvIHRoZSBj
b250ZW50cwo+IG9mIGFuIGlvbWVtIFNHTCB3aWxsIG5lZWQgdG8gYmUgZG9uZSB3aXRoIGlvbWVt
Y3B5IG9yIGhpdCBzb21lIHdhcm5pbmcuCj4gKFRoZSBleGFjdCBkZXRhaWxzIG9mIGhvdyB0aGlz
IHdpbGwgd29yayBoYXZlIHlldCB0byBiZSB3b3JrZWQgb3V0LikKCkkgdGhpbmsgd2UnbGwgYXQg
bGVhc3QgbmVlZCBhIGRyYWZ0IG9mIHRob3NlIHRvIG1ha2Ugc2Vuc2Ugb2YgdGhlc2UKcGF0Y2hl
cy4gIE90aGVyd2lzZSB0aGV5IGp1c3QgbG9vayB2ZXJ5IGNsdW1zeS4KCj4gKyAqICAgVXNlIHRo
aXMgZnVuY3Rpb24gdG8gbWFwIGEgcGFnZSBpbiB0aGUgc2NhdHRlcmxpc3QgYXQgdGhlIHNwZWNp
ZmllZAo+ICsgKiAgIG9mZnNldC4gc2ctPm9mZnNldCBpcyBhbHJlYWR5IGFkZGVkIGZvciB5b3Uu
IE5vdGU6IHRoZSBzZW1hbnRpY3Mgb2YKPiArICogICB0aGlzIGZ1bmN0aW9uIGFyZSB0aGF0IGl0
IG1heSBmYWlsLiBUaHVzLCBpdHMgb3V0cHV0IHNob3VsZCBiZSBjaGVja2VkCj4gKyAqICAgd2l0
aCBJU19FUlIgYW5kIFBUUl9FUlIuIE90aGVyd2lzZSwgYSBwb2ludGVyIHRvIHRoZSBzcGVjaWZp
ZWQgb2Zmc2V0Cj4gKyAqICAgaW4gdGhlIG1hcHBlZCBwYWdlIGlzIHJldHVybmVkLgo+ICsgKgo+
ICsgKiAgIEZsYWdzIGNhbiBiZSBhbnkgb2Y6Cj4gKyAqCSogU0dfS01BUAkJLSBVc2Uga21hcCB0
byBjcmVhdGUgdGhlIG1hcHBpbmcKPiArICoJKiBTR19LTUFQX0FUT01JQwktIFVzZSBrbWFwX2F0
b21pYyB0byBtYXAgdGhlIHBhZ2UgYXRvbW1pY2FsbHkuCj4gKyAqCQkJCSAgVGh1cywgdGhlIHJ1
bGVzIG9mIHRoYXQgZnVuY3Rpb24gYXBwbHk6IHRoZQo+ICsgKgkJCQkgIGNwdSBtYXkgbm90IHNs
ZWVwIHVudGlsIGl0IGlzIHVubWFwZWQuCj4gKyAqCSogU0dfTUFQX01VU1RfTk9UX0ZBSUwJLSBJ
bmRpY2F0ZSB0aGF0IHNnX21hcCBtdXN0IG5vdCBmYWlsLgo+ICsgKgkJCQkgIElmIGl0IGRvZXMs
IGl0IHdpbGwgaXNzdWUgYSBCVUdfT04gaW5zdGVhZC4KPiArICoJCQkJICBUaGlzIGlzIGludGVu
ZGVkIGZvciBsZWdhY3kgY29kZSBvbmx5LCBpdAo+ICsgKgkJCQkgIGlzIG5vdCB0byBiZSB1c2Vk
IGluIG5ldyBjb2RlLgoKSSdtIHNvcnJ5IGJ1dCB0aGlzIEFQSSBpcyBqdXN0IGEgdHJhaW53cmVj
ay4gIFJpZ2h0IG5vdyB3ZSBoYXZlIHRoZQpuaWNlIGxpdHRsZSBrbWFwX2F0b21pYyBBUEksIHdo
aWNoIG5ldmVyIGZhaWxzIGFuZCBoYXMgYSB2ZXJ5IG5pY2UKY2FsbGluZyBjb252ZW50aW9uIHdo
ZXJlIHdlIGp1c3QgcGFzcyBiYWNrIHRoZSByZXR1cm4gYWRkcmVzcywgYnV0IGRvZXMKbm90IHN1
cHBvcnQgc2xlZXBpbmcgaW5zaWRlIHRoZSBjcml0aWNhbCBzZWN0aW9uLgoKQW5kIGttYXAsIHdo
0ZZjaCBtYXkgZmFpbCBhbmQgcmVxdWlyZXMgdGhlIG9yaWdpbmFsIHBhZ2UgdG8gYmUgcGFzc2Vk
CmJhY2suICBBbnl0aGluZyB0aGF0IG1peGVzIHRoZXNlIHR3byBjb25jZXB0cyB1cCBpcyBzaW1w
bHkgYSBub24tc3RhcnRlci4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
