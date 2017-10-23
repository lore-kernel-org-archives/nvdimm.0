Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3240202E5CC4
 for <linux-nvdimm@lists.01.org>; Sun, 22 Oct 2017 22:15:03 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id
 v9N5EV8A015993
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 01:18:45 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2ds7xdc72w-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 01:18:45 -0400
Received: from localhost
 by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <schwidefsky@de.ibm.com>;
 Mon, 23 Oct 2017 06:18:43 +0100
Date: Mon, 23 Oct 2017 07:18:35 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
In-Reply-To: <20171020162933.GA26320@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
 <20171020162933.GA26320@lst.de>
MIME-Version: 1.0
Message-Id: <20171023071835.67ee5210@mschwideX1>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMCBPY3QgMjAxNyAxODoyOTozMyArMDIwMApDaHJpc3RvcGggSGVsbHdpZyA8aGNo
QGxzdC5kZT4gd3JvdGU6Cgo+IE9uIEZyaSwgT2N0IDIwLCAyMDE3IGF0IDA4OjIzOjAyQU0gLTA3
MDAsIERhbiBXaWxsaWFtcyB3cm90ZToKPiA+IFllcywgaG93ZXZlciBpdCBzZWVtcyB0aGVzZSBk
cml2ZXJzIC8gcGxhdGZvcm1zIGhhdmUgYmVlbiBsaXZpbmcgd2l0aAo+ID4gdGhlIGxhY2sgb2Yg
c3RydWN0IHBhZ2UgZm9yIGEgbG9uZyB0aW1lLiBTbyB0aGV5IGVpdGhlciBkb24ndCB1c2UgREFY
LAo+ID4gb3IgdGhleSBoYXZlIGEgY29uc3RyYWluZWQgdXNlIGNhc2UgdGhhdCBuZXZlciB0cmln
Z2Vycwo+ID4gZ2V0X3VzZXJfcGFnZXMoKS4gSWYgaXQgaXMgdGhlIGxhdHRlciB0aGVuIHRoZXkg
Y291bGQgaW50cm9kdWNlIGEgbmV3Cj4gPiBjb25maWd1cmF0aW9uIG9wdGlvbiB0aGF0IGJ5cGFz
c2VzIHRoZSBwZm5fdF9kZXZtYXAoKSBjaGVjayBpbgo+ID4gYmRldl9kYXhfc3VwcG9ydGVkKCkg
YW5kIGZpeCB1cCB0aGUgZ2V0X3VzZXJfcGFnZXMoKSBwYXRocyB0byBmYWlsLgo+ID4gU28sIEkn
ZCBsaWtlIHRvIHVuZGVyc3RhbmQgaG93IHRoZXNlIGRyaXZlcnMgaGF2ZSBiZWVuIHVzaW5nIERB
WAo+ID4gc3VwcG9ydCB3aXRob3V0IHN0cnVjdCBwYWdlIHRvIHNlZSBpZiB3ZSBuZWVkIGEgd29y
a2Fyb3VuZCBvciB3ZSBjYW4KPiA+IGdvIGFoZWFkIGRlbGV0ZSB0aGlzIHN1cHBvcnQuIElmIHRo
ZSB1c2FnZSBpcyBsaW1pdGVkIHRvCj4gPiBleGVjdXRlLWluLXBsYWNlIHBlcmhhcHMgd2UgY2Fu
IGRvIGEgY29uc3RyYWluZWQgLT5kaXJlY3RfYWNjZXNzKCkgZm9yCj4gPiBqdXN0IHRoYXQgY2Fz
ZS4gIAo+IAo+IEZvciBheG9ucmFtIEkgZG91YnQgYW55b25lIGlzIHVzaW5nIGl0IGFueSBtb3Jl
IC0gaXQgd2FzIGEgdmVyeSBmb3IKPiB0aGUgSUJNIENlbGwgYmxhZGVzLCB3aGljaCB3ZXJlIHBy
b2R1Y2XRlSBpbiBhIHJhdGhlciBsaW1pdGVkIG51bWJlci4KPiBBbmQgQ2VsbCBiYXNpY2FsbHkg
c2VlbXMgdG8gYmUgZGVhZCBhcyBmYXIgYXMgSSBjYW4gdGVsbC4KPiAKPiBGb3IgUy8zOTAgTWFy
dGluIG1pZ2h0IGJlIGFibGUgdG8gaGVscCBvdXQgd2hhdCB0aGUgc3RhdHVzIG9mIHhwcmFtCj4g
aW4gZ2VuZXJhbCBhbmQgREFYIHN1cHBvcnQgaW4gcGFydGljdWxhciBpcy4KClRoZSBnb2VzIGJh
Y2sgdG8gdGhlIHRpbWUgd2hlcmUgREFYIHdhcyBjYWxsZWQgWElQLiBUaGUgaW5pdGlhbCBkZXNp
Z24KcG9pbnQgaGFzIGJlZW4gKm5vdCogdG8gaGF2ZSBzdHJ1Y3QgcGFnZXMgZm9yIGEgbGFyZ2Ug
cmVhZC1vbmx5IG1lbW9yeQphcmVhLiBUaGVyZSBpcyBhIGJsb2NrIGRldmljZSBkcml2ZXIgZm9y
IHovVk0gdGhhdCBtYXBzIGEgRENTUyBzZWdtZW50CnNvbWV3aGVyZSBpbiBtZW1vcmUgKG5vIHN0
cnVjdCBwYWdlISkgd2l0aCBlLmcuIHRoZSBjb21wbGV0ZSAvdXNyCmZpbGVzeXN0ZW0uIFRoZSB4
cHJhbSBkcml2ZXIgaXMgYSBkaWZmZXJlbnQgYmVhc3QgYW5kIGhhcyBub3RoaW5nIHRvCmRvIHdp
dGggWElQL0RBWC4KCk5vdywgaWYgYW55IHRoZXJlIGFyZSB2ZXJ5IGZldyB1c2VycyBvZiB0aGUg
ZGNzc2JsayBkcml2ZXIgb3V0IHRoZXJlLgpUaGUgaWRlYSB0byBzYXZlIGEgZmV3IG1lZ2FieXRl
IGZvciAvdXNyIG5ldmVyIHJlYWxseSB0b29rIG9mLgoKV2UgaGF2ZSB0byBsb29rIGF0IG91ciBn
ZXRfdXNlcl9wYWdlcygpIGltcGxlbWVudGF0aW9uIHRvIHNlZSBob3cgaGFyZAppdCB3b3VsZCBi
ZSB0byBtYWtlIGl0IGZhaWwgaWYgdGhlIHRhcmdldCBhZGRyZXNzIGlzIGZvciBhbiBhcmVhIHdp
dGhvdXQKc3RydWN0IHBhZ2VzLgoKLS0gCmJsdWUgc2tpZXMsCiAgIE1hcnRpbi4KCiJSZWFsaXR5
IGNvbnRpbnVlcyB0byBydWluIG15IGxpZmUuIiAtIENhbHZpbi4KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QK
TGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LW52ZGltbQo=
