Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tartarus.angband.pl (tartarus.angband.pl
 [IPv6:2001:41d0:602:dbe::8])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00745211F26AE
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 02:57:00 -0700 (PDT)
Date: Thu, 4 Apr 2019 11:56:49 +0200
From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH v4 5/5] xfs: disable map_sync for async flush
Message-ID: <20190404095649.GB8738@angband.pl>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-6-pagupta@redhat.com>
 <20190403220912.GB26298@dastard>
 <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: cohuck@redhat.com, jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, Dave Chinner <david@fromorbit.com>, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBBcHIgMDQsIDIwMTkgYXQgMDI6MTI6MzBBTSAtMDQwMCwgUGFua2FqIEd1cHRhIHdy
b3RlOgo+ID4gQWxsIHRoaXMgYWQgaG9jIElTX0RBWCBjb25kaXRpb25hbCBsb2dpYyBpcyBnZXR0
aW5nIHByZXR0eSBuYXN0eS4KPiA+IAo+ID4geGZzX2ZpbGVfbW1hcCgKPiA+IC4uLi4KPiA+IHsK
PiA+IAlzdHJ1Y3QgaW5vZGUJKmlub2RlID0gZmlsZV9pbm9kZShmaWxwKTsKPiA+IAo+ID4gCWlm
ICh2bWEtPnZtX2ZsYWdzICYgVk1fU1lOQykgewo+ID4gCQlpZiAoIUlTX0RBWChpbm9kZSkpCj4g
PiAJCQlyZXR1cm4gLUVPUE5PVFNVUFA7Cj4gPiAJCWlmICghZGF4X3N5bmNocm9ub3VzKHhmc19m
aW5kX2RheGRldl9mb3JfaW5vZGUoaW5vZGUpKQo+ID4gCQkJcmV0dXJuIC1FT1BOT1RTVVBQOwo+
ID4gCX0KPiA+IAo+ID4gCWZpbGVfYWNjZXNzZWQoZmlscCk7Cj4gPiAJdm1hLT52bV9vcHMgPSAm
eGZzX2ZpbGVfdm1fb3BzOwo+ID4gCWlmIChJU19EQVgoaW5vZGUpKQo+ID4gCQl2bWEtPnZtX2Zs
YWdzIHw9IFZNX0hVR0VQQUdFOwo+ID4gCXJldHVybiAwOwo+ID4gfQo+IAo+IFN1cmUsIHRoaXMg
aXMgYmV0dGVyLgoKPiA+IEV2ZW4gYmV0dGVyLCBmYWN0b3Igb3V0IGFsbCB0aGUgIk1BUF9TWU5D
IHN1cHBvcnRlZCIgY2hlY2tzIGludG8gYQo+ID4gaGVscGVyIHNvIHRoYXQgdGhlIGZpbGVzeXN0
ZW0gY29kZSBqdXN0IGRvZXNuJ3QgaGF2ZSB0byBjYXJlIGFib3V0Cj4gPiB0aGUgZGV0YWlscyBv
ZiBjaGVja2luZyBmb3IgREFYK01BUF9TWU5DIHN1cHBvcnQuLi4uCj4gCj4gby5rLiBXaWxsIGFk
ZCBvbmUgY29tbW9uIGhlbHBlciBmdW5jdGlvbiBmb3IgYm90aCBleHQ0ICYgeGZzIGZpbGVzeXN0
ZW1zLgoKTm90ZSB0aGlzIHBlbmRpbmcgcGF0Y2ggZm9yIEdvbGR3eW4gUm9kcmlndWVzJyBwYXRj
aHNldCBmb3IgYnRyZnM6CgpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1idHJmcy8yMDE5
MDMyODEwMjQxOC41NDY2LTEta2lsb2J5dGVAYW5nYmFuZC5wbC8KCldlIG1pZ2h0IHdhbnQgdG8g
Y29vcmRpbmF0ZS4KCgpNZW93IQotLSAK4qKA4qO04qC+4qC74qK24qOm4qCACuKjvuKggeKioOKg
kuKggOKjv+KhgSBEaWQgeWEga25vdyB0aGF0IHR5cGluZyAidGVzdCAtajgiIGluc3RlYWQgb2Yg
ImN0ZXN0IC1qOCIK4qK/4qGE4qCY4qC34qCa4qCL4qCAIHdpbGwgbWFrZSB5b3VyIHRlc3RzdWl0
ZSBwYXNzIG11Y2ggZmFzdGVyLCBhbmQgZml4IGJ1Z3M/CuKgiOKgs+KjhOKggOKggOKggOKggApf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
