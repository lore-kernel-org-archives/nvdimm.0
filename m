Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A49B1202E60E7
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 03:40:55 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id
 v9NAiRwo006716
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 06:44:38 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2dsc8eqfcp-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 06:44:37 -0400
Received: from localhost
 by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <schwidefsky@de.ibm.com>;
 Mon, 23 Oct 2017 11:44:34 +0100
Date: Mon, 23 Oct 2017 12:44:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
In-Reply-To: <CAPcyv4hqiV6oHMgFik3MBTw5SJ6hcq4RzngPn2Xtp9kAv1E+Ow@mail.gmail.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
 <20171020162933.GA26320@lst.de>
 <20171023071835.67ee5210@mschwideX1>
 <CAPcyv4hqiV6oHMgFik3MBTw5SJ6hcq4RzngPn2Xtp9kAv1E+Ow@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <20171023124427.10d15ee3@mschwideX1>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMyBPY3QgMjAxNyAwMTo1NToyMCAtMDcwMApEYW4gV2lsbGlhbXMgPGRhbi5qLndp
bGxpYW1zQGludGVsLmNvbT4gd3JvdGU6Cgo+IE9uIFN1biwgT2N0IDIyLCAyMDE3IGF0IDEwOjE4
IFBNLCBNYXJ0aW4gU2Nod2lkZWZza3kKPiA8c2Nod2lkZWZza3lAZGUuaWJtLmNvbT4gd3JvdGU6
Cj4gPiBPbiBGcmksIDIwIE9jdCAyMDE3IDE4OjI5OjMzICswMjAwCj4gPiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4gd3JvdGU6Cj4gPiAgCj4gPj4gT24gRnJpLCBPY3QgMjAsIDIwMTcg
YXQgMDg6MjM6MDJBTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOiAgCj4gPj4gPiBZZXMsIGhv
d2V2ZXIgaXQgc2VlbXMgdGhlc2UgZHJpdmVycyAvIHBsYXRmb3JtcyBoYXZlIGJlZW4gbGl2aW5n
IHdpdGgKPiA+PiA+IHRoZSBsYWNrIG9mIHN0cnVjdCBwYWdlIGZvciBhIGxvbmcgdGltZS4gU28g
dGhleSBlaXRoZXIgZG9uJ3QgdXNlIERBWCwKPiA+PiA+IG9yIHRoZXkgaGF2ZSBhIGNvbnN0cmFp
bmVkIHVzZSBjYXNlIHRoYXQgbmV2ZXIgdHJpZ2dlcnMKPiA+PiA+IGdldF91c2VyX3BhZ2VzKCku
IElmIGl0IGlzIHRoZSBsYXR0ZXIgdGhlbiB0aGV5IGNvdWxkIGludHJvZHVjZSBhIG5ldwo+ID4+
ID4gY29uZmlndXJhdGlvbiBvcHRpb24gdGhhdCBieXBhc3NlcyB0aGUgcGZuX3RfZGV2bWFwKCkg
Y2hlY2sgaW4KPiA+PiA+IGJkZXZfZGF4X3N1cHBvcnRlZCgpIGFuZCBmaXggdXAgdGhlIGdldF91
c2VyX3BhZ2VzKCkgcGF0aHMgdG8gZmFpbC4KPiA+PiA+IFNvLCBJJ2QgbGlrZSB0byB1bmRlcnN0
YW5kIGhvdyB0aGVzZSBkcml2ZXJzIGhhdmUgYmVlbiB1c2luZyBEQVgKPiA+PiA+IHN1cHBvcnQg
d2l0aG91dCBzdHJ1Y3QgcGFnZSB0byBzZWUgaWYgd2UgbmVlZCBhIHdvcmthcm91bmQgb3Igd2Ug
Y2FuCj4gPj4gPiBnbyBhaGVhZCBkZWxldGUgdGhpcyBzdXBwb3J0LiBJZiB0aGUgdXNhZ2UgaXMg
bGltaXRlZCB0bwo+ID4+ID4gZXhlY3V0ZS1pbi1wbGFjZSBwZXJoYXBzIHdlIGNhbiBkbyBhIGNv
bnN0cmFpbmVkIC0+ZGlyZWN0X2FjY2VzcygpIGZvcgo+ID4+ID4ganVzdCB0aGF0IGNhc2UuICAK
PiA+Pgo+ID4+IEZvciBheG9ucmFtIEkgZG91YnQgYW55b25lIGlzIHVzaW5nIGl0IGFueSBtb3Jl
IC0gaXQgd2FzIGEgdmVyeSBmb3IKPiA+PiB0aGUgSUJNIENlbGwgYmxhZGVzLCB3aGljaCB3ZXJl
IHByb2R1Y2XRlSBpbiBhIHJhdGhlciBsaW1pdGVkIG51bWJlci4KPiA+PiBBbmQgQ2VsbCBiYXNp
Y2FsbHkgc2VlbXMgdG8gYmUgZGVhZCBhcyBmYXIgYXMgSSBjYW4gdGVsbC4KPiA+Pgo+ID4+IEZv
ciBTLzM5MCBNYXJ0aW4gbWlnaHQgYmUgYWJsZSB0byBoZWxwIG91dCB3aGF0IHRoZSBzdGF0dXMg
b2YgeHByYW0KPiA+PiBpbiBnZW5lcmFsIGFuZCBEQVggc3VwcG9ydCBpbiBwYXJ0aWN1bGFyIGlz
LiAgCj4gPgo+ID4gVGhlIGdvZXMgYmFjayB0byB0aGUgdGltZSB3aGVyZSBEQVggd2FzIGNhbGxl
ZCBYSVAuIFRoZSBpbml0aWFsIGRlc2lnbgo+ID4gcG9pbnQgaGFzIGJlZW4gKm5vdCogdG8gaGF2
ZSBzdHJ1Y3QgcGFnZXMgZm9yIGEgbGFyZ2UgcmVhZC1vbmx5IG1lbW9yeQo+ID4gYXJlYS4gVGhl
cmUgaXMgYSBibG9jayBkZXZpY2UgZHJpdmVyIGZvciB6L1ZNIHRoYXQgbWFwcyBhIERDU1Mgc2Vn
bWVudAo+ID4gc29tZXdoZXJlIGluIG1lbW9yZSAobm8gc3RydWN0IHBhZ2UhKSB3aXRoIGUuZy4g
dGhlIGNvbXBsZXRlIC91c3IKPiA+IGZpbGVzeXN0ZW0uIFRoZSB4cHJhbSBkcml2ZXIgaXMgYSBk
aWZmZXJlbnQgYmVhc3QgYW5kIGhhcyBub3RoaW5nIHRvCj4gPiBkbyB3aXRoIFhJUC9EQVguCj4g
Pgo+ID4gTm93LCBpZiBhbnkgdGhlcmUgYXJlIHZlcnkgZmV3IHVzZXJzIG9mIHRoZSBkY3NzYmxr
IGRyaXZlciBvdXQgdGhlcmUuCj4gPiBUaGUgaWRlYSB0byBzYXZlIGEgZmV3IG1lZ2FieXRlIGZv
ciAvdXNyIG5ldmVyIHJlYWxseSB0b29rIG9mLgo+ID4KPiA+IFdlIGhhdmUgdG8gbG9vayBhdCBv
dXIgZ2V0X3VzZXJfcGFnZXMoKSBpbXBsZW1lbnRhdGlvbiB0byBzZWUgaG93IGhhcmQKPiA+IGl0
IHdvdWxkIGJlIHRvIG1ha2UgaXQgZmFpbCBpZiB0aGUgdGFyZ2V0IGFkZHJlc3MgaXMgZm9yIGFu
IGFyZWEgd2l0aG91dAo+ID4gc3RydWN0IHBhZ2VzLiAgCj4gCj4gRm9yIHJlYWQtb25seSBtZW1v
cnkgSSB0aGluayB3ZSBjYW4gZW5hYmxlIGEgc3Vic2V0IG9mIERBWCwgYW5kCj4gZXhwbGljaXRs
eSB0dXJuIG9mZiB0aGUgcGF0aHMgdGhhdCByZXF1aXJlIGdldF91c2VyX3BhZ2VzKCkuIEhvd2V2
ZXIsCj4gSSB3b25kZXIgaWYgYW55b25lIGhhcyB0ZXN0ZWQgREFYIHdpdGggZGNzc2JsayBiZWNh
dXNlIGZvcmsoKSByZXF1aXJlcwo+IGdldF91c2VyX3BhZ2VzKCk/CiAKSSBkaWQgbm90IHRlc3Qg
aXQgcmVjZW50bHksIHNvbWVvbmUgZWxzZSBtaWdodCBoYXZlLiBHZXJhbGQ/CgpMb29raW5nIGF0
IHRoZSBjb2RlIEkgc2VlIHRoaXMgaW4gdGhlIHMzOTAgdmVyc2lvbiBvZiBndXBfcHRlX3Jhbmdl
OgoKICAgICAgICBtYXNrID0gKHdyaXRlID8gX1BBR0VfUFJPVEVDVCA6IDApIHwgX1BBR0VfSU5W
QUxJRCB8IF9QQUdFX1NQRUNJQUw7CgkuLi4KICAgICAgICAgICAgICAgIGlmICgocHRlX3ZhbChw
dGUpICYgbWFzaykgIT0gMCkKICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7CgkuLi4K
ClRoZSBYSVAgY29kZSB1c2VkIHRoZSBwdGVfbWtzcGVjaWFsIG1lY2hhbmljcyB0byBtYWtlIGl0
IHdvcmsuIEFzIGZhciBhcwpJIGNhbiBzZWUgdGhlIHBmbl90X2Rldm1hcCByZXR1cm5zIHRydWUg
Zm9yIHRoZSBEQVggbWFwcGlucywgeWVzPwpUaGVuIEkgd291bGQgc2F5IHRoYXQgZGNzc2JsayBh
bmQgREFYIGN1cnJlbnRseSBkbyBub3Qgd29yayB0b2dldGhlci4KCi0tIApibHVlIHNraWVzLAog
ICBNYXJ0aW4uCgoiUmVhbGl0eSBjb250aW51ZXMgdG8gcnVpbiBteSBsaWZlLiIgLSBDYWx2aW4u
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
