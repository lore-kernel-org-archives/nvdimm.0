Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FAA5211F932B
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 03:52:18 -0700 (PDT)
Date: Thu, 4 Apr 2019 06:52:16 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <511760533.17430856.1554375136102.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190404095649.GB8738@angband.pl>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-6-pagupta@redhat.com> <20190403220912.GB26298@dastard>
 <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
 <20190404095649.GB8738@angband.pl>
Subject: Re: [PATCH v4 5/5] xfs: disable map_sync for async flush
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
To: Adam Borowski <kilobyte@angband.pl>
Cc: cohuck@redhat.com, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, Dave Chinner <david@fromorbit.com>, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Cj4gCj4gT24gVGh1LCBBcHIgMDQsIDIwMTkgYXQgMDI6MTI6MzBBTSAtMDQwMCwgUGFua2FqIEd1
cHRhIHdyb3RlOgo+ID4gPiBBbGwgdGhpcyBhZCBob2MgSVNfREFYIGNvbmRpdGlvbmFsIGxvZ2lj
IGlzIGdldHRpbmcgcHJldHR5IG5hc3R5Lgo+ID4gPiAKPiA+ID4geGZzX2ZpbGVfbW1hcCgKPiA+
ID4gLi4uLgo+ID4gPiB7Cj4gPiA+IAlzdHJ1Y3QgaW5vZGUJKmlub2RlID0gZmlsZV9pbm9kZShm
aWxwKTsKPiA+ID4gCj4gPiA+IAlpZiAodm1hLT52bV9mbGFncyAmIFZNX1NZTkMpIHsKPiA+ID4g
CQlpZiAoIUlTX0RBWChpbm9kZSkpCj4gPiA+IAkJCXJldHVybiAtRU9QTk9UU1VQUDsKPiA+ID4g
CQlpZiAoIWRheF9zeW5jaHJvbm91cyh4ZnNfZmluZF9kYXhkZXZfZm9yX2lub2RlKGlub2RlKSkK
PiA+ID4gCQkJcmV0dXJuIC1FT1BOT1RTVVBQOwo+ID4gPiAJfQo+ID4gPiAKPiA+ID4gCWZpbGVf
YWNjZXNzZWQoZmlscCk7Cj4gPiA+IAl2bWEtPnZtX29wcyA9ICZ4ZnNfZmlsZV92bV9vcHM7Cj4g
PiA+IAlpZiAoSVNfREFYKGlub2RlKSkKPiA+ID4gCQl2bWEtPnZtX2ZsYWdzIHw9IFZNX0hVR0VQ
QUdFOwo+ID4gPiAJcmV0dXJuIDA7Cj4gPiA+IH0KPiA+IAo+ID4gU3VyZSwgdGhpcyBpcyBiZXR0
ZXIuCj4gCj4gPiA+IEV2ZW4gYmV0dGVyLCBmYWN0b3Igb3V0IGFsbCB0aGUgIk1BUF9TWU5DIHN1
cHBvcnRlZCIgY2hlY2tzIGludG8gYQo+ID4gPiBoZWxwZXIgc28gdGhhdCB0aGUgZmlsZXN5c3Rl
bSBjb2RlIGp1c3QgZG9lc24ndCBoYXZlIHRvIGNhcmUgYWJvdXQKPiA+ID4gdGhlIGRldGFpbHMg
b2YgY2hlY2tpbmcgZm9yIERBWCtNQVBfU1lOQyBzdXBwb3J0Li4uLgo+ID4gCj4gPiBvLmsuIFdp
bGwgYWRkIG9uZSBjb21tb24gaGVscGVyIGZ1bmN0aW9uIGZvciBib3RoIGV4dDQgJiB4ZnMgZmls
ZXN5c3RlbXMuCj4gCj4gTm90ZSB0aGlzIHBlbmRpbmcgcGF0Y2ggZm9yIEdvbGR3eW4gUm9kcmln
dWVzJyBwYXRjaHNldCBmb3IgYnRyZnM6Cj4gCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtYnRyZnMvMjAxOTAzMjgxMDI0MTguNTQ2Ni0xLWtpbG9ieXRlQGFuZ2JhbmQucGwvCj4gCj4g
V2UgbWlnaHQgd2FudCB0byBjb29yZGluYXRlLgoKU3VyZS4gR29vZCB0byBrbm93LgoKVGhhbmtz
IGZvciB0aGUgcG9pbnRlci4gV2lsbCBoYXZlIGEgbG9vay4KCkJlc3QgcmVnYXJkcywKUGFua2Fq
IAoKPiAKPiAKPiBNZW93IQo+IC0tCj4g4qKA4qO04qC+4qC74qK24qOm4qCACj4g4qO+4qCB4qKg
4qCS4qCA4qO/4qGBIERpZCB5YSBrbm93IHRoYXQgdHlwaW5nICJ0ZXN0IC1qOCIgaW5zdGVhZCBv
ZiAiY3Rlc3QgLWo4Igo+IOKiv+KhhOKgmOKgt+KgmuKgi+KggCB3aWxsIG1ha2UgeW91ciB0ZXN0
c3VpdGUgcGFzcyBtdWNoIGZhc3RlciwgYW5kIGZpeCBidWdzPwo+IOKgiOKgs+KjhOKggOKggOKg
gOKggAo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
