Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1259C21A16E5F
 for <linux-nvdimm@lists.01.org>; Tue, 23 May 2017 06:11:44 -0700 (PDT)
Message-ID: <1495545099.6967.81.camel@linux.intel.com>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 23 May 2017 16:11:39 +0300
In-Reply-To: <20170523084956.GB20121@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-11-hch@lst.de>
 <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE3LTA1LTIzIGF0IDEwOjQ5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBNb24sIE1heSAyMiwgMjAxNyBhdCAwOTo0OToxN1BNICswMzAwLCBBbmR5IFNoZXZj
aGVua28gd3JvdGU6Cj4gPiA+IMKgCXN0cnVjdCBhZnNfY2FsbCAqY2FsbCA9IGNvbnRhaW5lcl9v
Zih3b3JrLCBzdHJ1Y3QKPiA+ID4gYWZzX2NhbGwsCj4gPiA+IHdvcmspOwo+ID4gPiAtCXN0cnVj
dCB1dWlkX3YxICpyID0gY2FsbC0+cmVxdWVzdDsKPiA+ID4gKwl1dWlkX3QgKnIgPSBjYWxsLT5y
ZXF1ZXN0Owo+ID4gPiDCoAo+ID4gPiDCoAlzdHJ1Y3Qgewo+ID4gPiDCoAkJX19iZTMyCW1hdGNo
Owo+ID4gPiAKPiA+IAo+ID4gSnVzdCB0byBkb3VibGUgY2hlY2sgdGhhdCB0aGlzIGRvZXNuJ3Qg
Y3JlYXRlIGEgdW5pb24gYWxpYXNpbmcuCj4gCj4gV2hhdCBkbyB5b3UgbWVhbiB3aXRoIHRoYXQ/
CgpTaW5jZSB3ZSBpbnRyb2R1Y2VkIGEgdW5pb24gaXQncyBwb3NzaWJsZSB0aGF0IHdlIG1pZ2h0
IGFjY2VzcyB0aGUKbWVtYmVyIHdoaWNoIHdhc24ndCBsYXN0IG1vZGlmaWVkIG9uZS4gU28sIG15
IGNvbW1lbnQgaXMgdG8gZ2l2ZSBhbgphdHRlbnRpb24gb24gc3VjaCBwb3NzaWJpbGl0eSBhbmQg
YXZvaWQgaWYgdGhlcmUgaXMgYW4gYWxpYXNpbmcKaGFwcGVuZWQuCgotLSAKQW5keSBTaGV2Y2hl
bmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+CkludGVsIEZpbmxhbmQgT3kK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
