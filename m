Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE57121A02F31
 for <linux-nvdimm@lists.01.org>; Mon, 22 May 2017 11:59:29 -0700 (PDT)
Message-ID: <1495479565.6967.72.camel@linux.intel.com>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 22 May 2017 21:59:25 +0300
In-Reply-To: <20170518085629.GA6149@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-24-hch@lst.de>
 <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
 <20170518085629.GA6149@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, Hugh Dickins <hughd@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA1LTE4IGF0IDEwOjU2ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBUaHUsIE1heSAxOCwgMjAxNyBhdCAxMDo1NzoyNEFNICswMzAwLCBBbWlyIEdvbGRz
dGVpbiB3cm90ZToKPiA+IEkgcmV2aWV3ZWQgdGhlIGVudGlyZSBzZXJpZXMuIFlvdSBtYXkgYWRk
Cj4gPiBSZXZpZXdlZC1ieTogQW1pciBHb2xkc3RlaW4gPGFtaXI3M2lsQGdtYWlsLmNvbT4KPiA+
IAo+ID4gdG8gYW55IG9mIHRoZSBwYXRjaGVzIGFzIHlvdSBzZWUgZml0Lgo+IAo+IFRoYW5rcywg
ZG9uZSEKClNpbWlsYXIgZnJvbSBteSBzaWRlLCBGV0lXOgpSZXZpZXdlZC1ieTogQW5keSBTaGV2
Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+Cgo+IAo+ID4gTm93IGxl
dCdzIHRhbGsgYWJvdXQgaG93IHRoaXMgaXMgZ29pbmcgdG8gYmUgbWVyZ2VkLgo+ID4gRG8geW91
IGludGVuZCB0byBzZW5kIExpbnVzIGEgcHVsbCByZXF1ZXN0Pwo+IAo+IFllcywgdGhhdCBtaWdo
dCBiZSB0aGUgYmVzdCBpZGVhLsKgwqBJJ20gYWxzbyBjb250ZW1wbGF0aW5nIGxpc3RpbmcKPiBt
ZSBwbHVzIGFueW9uZSB2b2x1bnRlZXJpbmcgKHlvdT8sIEFuZHkpIGFzIG1haW50YWluZXMgZm9y
IHRoZSB1dWlkCj4gY29kZS4KCkkgd291bGQgYWdyZWUgdG8gYmUgYSBkZXNpZ25hdGVkIHJldmll
d2VyIGZvciBub3cgKHRvbyBtYW55IHN0dWZmIHRvCmZvbGxvdyBhcyBhIChjby0pbWFpbnRhaW5l
cikuCgo+ID4gVGhlIHJlYXNvbiBJIGFtIGFza2luZyBpcyBiZWNhdXNlIHRoaXMgbGFzdCByZW1v
dmFsIHBhdGNoIHNob3VsZAo+ID4gcHJvYmFibHkKPiA+IGJlIGFwcGxpZWQgbmVhciB0aGUgZW5k
IG9mIHRoZSBtZXJnZSB3aW5kb3cgKD8pLgo+ID4gQmVjYXVzZSBtYWludGFpbmVycyBjYW5ub3Qg
YXBwbHkgcGF0Y2hlcyB3aXRoIGNvZGUgdGhhdCB1c2VzIHRoZSBuZXcKPiA+IHV1aWRfdCB0byBs
aW51eC1uZXh0IGJyYW5jaGVzIGFuZCB3ZSBkb24ndCB3YW50IGxpbnV4LW5leHQgYnVpbGQgdG8K
PiA+IGZhaWwKPiA+IHdpdGggbmV3IGNvZGUgdGhhdCB1c2VzIHV1aWRfYmUuLi4KPiAKPiBZZWFo
LCB3ZSBjYW4gcHJvYmFibHkgZGVmZXIgdGhhdCBvbmUgZm9yIG5vdy4KCkkgd291bGQgYWxzbyBs
aWtlIHRvIGFwcGVuZCBzb21lIG9mIHBhdGNoZXMgZnJvbSBteSBzaWRlLCB0aG91Z2ggdGhleQph
cmUgV0lQLgoKLS0gCkFuZHkgU2hldmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50
ZWwuY29tPgpJbnRlbCBGaW5sYW5kIE95Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
