Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B48E2034C0B7
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 15:26:18 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id j126so22442178oib.8
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 15:29:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171020162933.GA26320@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
 <20171020162933.GA26320@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Oct 2017 15:29:57 -0700
Message-ID: <CAPcyv4jP0ws7dcBrXafS7ON+0_J1BTp_LCB6XB3od4d6db071A@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBPY3QgMjAsIDIwMTcgYXQgOToyOSBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+IE9uIEZyaSwgT2N0IDIwLCAyMDE3IGF0IDA4OjIzOjAyQU0gLTA3MDAs
IERhbiBXaWxsaWFtcyB3cm90ZToKPj4gWWVzLCBob3dldmVyIGl0IHNlZW1zIHRoZXNlIGRyaXZl
cnMgLyBwbGF0Zm9ybXMgaGF2ZSBiZWVuIGxpdmluZyB3aXRoCj4+IHRoZSBsYWNrIG9mIHN0cnVj
dCBwYWdlIGZvciBhIGxvbmcgdGltZS4gU28gdGhleSBlaXRoZXIgZG9uJ3QgdXNlIERBWCwKPj4g
b3IgdGhleSBoYXZlIGEgY29uc3RyYWluZWQgdXNlIGNhc2UgdGhhdCBuZXZlciB0cmlnZ2Vycwo+
PiBnZXRfdXNlcl9wYWdlcygpLiBJZiBpdCBpcyB0aGUgbGF0dGVyIHRoZW4gdGhleSBjb3VsZCBp
bnRyb2R1Y2UgYSBuZXcKPj4gY29uZmlndXJhdGlvbiBvcHRpb24gdGhhdCBieXBhc3NlcyB0aGUg
cGZuX3RfZGV2bWFwKCkgY2hlY2sgaW4KPj4gYmRldl9kYXhfc3VwcG9ydGVkKCkgYW5kIGZpeCB1
cCB0aGUgZ2V0X3VzZXJfcGFnZXMoKSBwYXRocyB0byBmYWlsLgo+PiBTbywgSSdkIGxpa2UgdG8g
dW5kZXJzdGFuZCBob3cgdGhlc2UgZHJpdmVycyBoYXZlIGJlZW4gdXNpbmcgREFYCj4+IHN1cHBv
cnQgd2l0aG91dCBzdHJ1Y3QgcGFnZSB0byBzZWUgaWYgd2UgbmVlZCBhIHdvcmthcm91bmQgb3Ig
d2UgY2FuCj4+IGdvIGFoZWFkIGRlbGV0ZSB0aGlzIHN1cHBvcnQuIElmIHRoZSB1c2FnZSBpcyBs
aW1pdGVkIHRvCj4+IGV4ZWN1dGUtaW4tcGxhY2UgcGVyaGFwcyB3ZSBjYW4gZG8gYSBjb25zdHJh
aW5lZCAtPmRpcmVjdF9hY2Nlc3MoKSBmb3IKPj4ganVzdCB0aGF0IGNhc2UuCj4KPiBGb3IgYXhv
bnJhbSBJIGRvdWJ0IGFueW9uZSBpcyB1c2luZyBpdCBhbnkgbW9yZSAtIGl0IHdhcyBhIHZlcnkg
Zm9yCj4gdGhlIElCTSBDZWxsIGJsYWRlcywgd2hpY2ggd2VyZSBwcm9kdWNl0ZUgaW4gYSByYXRo
ZXIgbGltaXRlZCBudW1iZXIuCj4gQW5kIENlbGwgYmFzaWNhbGx5IHNlZW1zIHRvIGJlIGRlYWQg
YXMgZmFyIGFzIEkgY2FuIHRlbGwuCj4KPiBGb3IgUy8zOTAgTWFydGluIG1pZ2h0IGJlIGFibGUg
dG8gaGVscCBvdXQgd2hhdCB0aGUgc3RhdHVzIG9mIHhwcmFtCj4gaW4gZ2VuZXJhbCBhbmQgREFY
IHN1cHBvcnQgaW4gcGFydGljdWxhciBpcy4KCk9rLCBJJ2QgYWxzbyBsaWtlIHRvIGtpbGwgREFY
IHN1cHBvcnQgaW4gdGhlIGJyZCBkcml2ZXIuIEl0J3MgYSBzb3VyY2UKb2YgY29tcGxleGl0eSBh
bmQgbWFpbnRlbmFuY2UgYnVyZGVuIGZvciB6ZXJvIGJlbmVmaXQuIEl0J3MgdGhlIG9ubHkKLT5k
aXJlY3RfYWNjZXNzKCkgaW1wbGVtZW50YXRpb24gdGhhdCBzbGVlcHMgYW5kIGl0J3MgdGhlIG9u
bHkKaW1wbGVtZW50YXRpb24gd2hlcmUgdGhlcmUgaXMgYSBub24tbGluZWFyIHJlbGF0aW9uc2hp
cCBiZXR3ZWVuCnNlY3RvcnMgYW5kIHBmbnMuIEhhdmluZyBhIDE6MSBzZWN0b3IgdG8gcGZuIHJl
bGF0aW9uc2hpcCB3aWxsIGhlbHAKd2l0aCB0aGUgZG1hLWV4dGVudC1idXN5IG1hbmFnZW1lbnQg
c2luY2Ugd2UgZG9uJ3QgbmVlZCB0byBrZWVwCmNhbGxpbmcgaW50byB0aGUgZHJpdmVyIHRvIG1h
cCBwZm5zIGJhY2sgdG8gc2VjdG9ycyBvbmNlIHdlIGtub3cgdGhlCnBmblswXSBzZWN0b3JbMF0g
cmVsYXRpb25zaGlwLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcK
aHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
