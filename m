Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BE3C202E60EF
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 09:25:55 -0700 (PDT)
Date: Fri, 20 Oct 2017 18:29:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
Message-ID: <20171020162933.GA26320@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBPY3QgMjAsIDIwMTcgYXQgMDg6MjM6MDJBTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+IFllcywgaG93ZXZlciBpdCBzZWVtcyB0aGVzZSBkcml2ZXJzIC8gcGxhdGZvcm1zIGhh
dmUgYmVlbiBsaXZpbmcgd2l0aAo+IHRoZSBsYWNrIG9mIHN0cnVjdCBwYWdlIGZvciBhIGxvbmcg
dGltZS4gU28gdGhleSBlaXRoZXIgZG9uJ3QgdXNlIERBWCwKPiBvciB0aGV5IGhhdmUgYSBjb25z
dHJhaW5lZCB1c2UgY2FzZSB0aGF0IG5ldmVyIHRyaWdnZXJzCj4gZ2V0X3VzZXJfcGFnZXMoKS4g
SWYgaXQgaXMgdGhlIGxhdHRlciB0aGVuIHRoZXkgY291bGQgaW50cm9kdWNlIGEgbmV3Cj4gY29u
ZmlndXJhdGlvbiBvcHRpb24gdGhhdCBieXBhc3NlcyB0aGUgcGZuX3RfZGV2bWFwKCkgY2hlY2sg
aW4KPiBiZGV2X2RheF9zdXBwb3J0ZWQoKSBhbmQgZml4IHVwIHRoZSBnZXRfdXNlcl9wYWdlcygp
IHBhdGhzIHRvIGZhaWwuCj4gU28sIEknZCBsaWtlIHRvIHVuZGVyc3RhbmQgaG93IHRoZXNlIGRy
aXZlcnMgaGF2ZSBiZWVuIHVzaW5nIERBWAo+IHN1cHBvcnQgd2l0aG91dCBzdHJ1Y3QgcGFnZSB0
byBzZWUgaWYgd2UgbmVlZCBhIHdvcmthcm91bmQgb3Igd2UgY2FuCj4gZ28gYWhlYWQgZGVsZXRl
IHRoaXMgc3VwcG9ydC4gSWYgdGhlIHVzYWdlIGlzIGxpbWl0ZWQgdG8KPiBleGVjdXRlLWluLXBs
YWNlIHBlcmhhcHMgd2UgY2FuIGRvIGEgY29uc3RyYWluZWQgLT5kaXJlY3RfYWNjZXNzKCkgZm9y
Cj4ganVzdCB0aGF0IGNhc2UuCgpGb3IgYXhvbnJhbSBJIGRvdWJ0IGFueW9uZSBpcyB1c2luZyBp
dCBhbnkgbW9yZSAtIGl0IHdhcyBhIHZlcnkgZm9yCnRoZSBJQk0gQ2VsbCBibGFkZXMsIHdoaWNo
IHdlcmUgcHJvZHVjZdGVIGluIGEgcmF0aGVyIGxpbWl0ZWQgbnVtYmVyLgpBbmQgQ2VsbCBiYXNp
Y2FsbHkgc2VlbXMgdG8gYmUgZGVhZCBhcyBmYXIgYXMgSSBjYW4gdGVsbC4KCkZvciBTLzM5MCBN
YXJ0aW4gbWlnaHQgYmUgYWJsZSB0byBoZWxwIG91dCB3aGF0IHRoZSBzdGF0dXMgb2YgeHByYW0K
aW4gZ2VuZXJhbCBhbmQgREFYIHN1cHBvcnQgaW4gcGFydGljdWxhciBpcy4KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
