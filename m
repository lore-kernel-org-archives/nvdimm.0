Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08F6821FC747A
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 16:11:44 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id v132so12552841oie.1
 for <linux-nvdimm@lists.01.org>; Fri, 06 Oct 2017 16:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507331434.29211.439.camel@infradead.org>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1507329939.29211.434.camel@infradead.org>
 <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
 <1507331434.29211.439.camel@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Oct 2017 16:15:08 -0700
Message-ID: <CAPcyv4j0gbXtyviEA00ktav_-VwZUpd1+BgBNfzBqFA9XOqXBw@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
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
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBPY3QgNiwgMjAxNyBhdCA0OjEwIFBNLCBEYXZpZCBXb29kaG91c2UgPGR3bXcyQGlu
ZnJhZGVhZC5vcmc+IHdyb3RlOgo+IE9uIEZyaSwgMjAxNy0xMC0wNiBhdCAxNTo1MiAtMDcwMCwg
RGFuIFdpbGxpYW1zIHdyb3RlOgo+PiBPbiBGcmksIE9jdCA2LCAyMDE3IGF0IDM6NDUgUE0sIERh
dmlkIFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz4gd3JvdGU6Cj4+ID4KPj4gPiBPbiBG
cmksIDIwMTctMTAtMDYgYXQgMTU6MzUgLTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToKPj4gPiA+
Cj4+ID4gPiBBZGQgYSBoZWxwZXIgdG8gZGV0ZXJtaW5lIGlmIHRoZSBkbWEgbWFwcGluZ3Mgc2V0
IHVwIGZvciBhIGdpdmVuIGRldmljZQo+PiA+ID4gYXJlIGJhY2tlZCBieSBhbiBpb21tdS4gSW4g
cGFydGljdWxhciwgdGhpcyBsZXRzIGNvZGUgcGF0aHMga25vdyB0aGF0IGEKPj4gPiA+IGRtYV91
bm1hcCBvcGVyYXRpb24gd2lsbCByZXZva2UgYWNjZXNzIHRvIG1lbW9yeSBpZiB0aGUgZGV2aWNl
IGNhbiBub3QKPj4gPiA+IG90aGVyd2lzZSBiZSBxdWllc2NlZC4gVGhlIG5lZWQgZm9yIHRoaXMg
a25vd2xlZGdlIGlzIGRyaXZlbiBieSBhIG5lZWQKPj4gPiA+IHRvIG1ha2UgUkRNQSB0cmFuc2Zl
cnMgdG8gREFYIG1hcHBpbmdzIHNhZmUuIElmIHRoZSBEQVggZmlsZSdzIGJsb2NrIG1hcAo+PiA+
ID4gY2hhbmdlcyB3ZSBuZWVkIHRvIGJlIHRvIHJlbGlhYmx5IHN0b3AgYWNjZXNzZXMgdG8gYmxv
Y2tzIHRoYXQgaGF2ZSBiZWVuCj4+ID4gPiBmcmVlZCBvciByZS1hc3NpZ25lZCB0byBhIG5ldyBm
aWxlLgo+PiA+ICJhIGRtYV91bm1hcCBvcGVyYXRpb24gcmV2b2tlIGFjY2VzcyB0byBtZW1vcnki
Li4uIGJ1dCBpdCdzIE9LIHRoYXQgdGhlCj4+ID4gbmV4dCAqbWFwKiB3aWxsIGdpdmUgdGhlIHNh
bWUgRE1BIGFkZHJlc3MgdG8gc29tZW9uZSBlbHNlLCByaWdodD8KPj4KPj4gSSdtIGFzc3VtaW5n
IHRoZSBuZXh0IG1hcCB3aWxsIGJlIHRvIG90aGVyIHBoeXNpY2FsIGFkZHJlc3NlcyBhbmQgYQo+
PiBkaWZmZXJlbnQgcmVxdWVzdGVyIGRldmljZSBzaW5jZSB0aGUgbWVtb3J5IGlzIHN0aWxsIHJl
Z2lzdGVyZWQKPj4gZXhjbHVzaXZlbHkuCj4KPiBJIG1lYW50IHRoZSBuZXh0IG1hcCBmb3IgdGhp
cyBkZXZpY2UvZ3JvdXAuCj4KPiBJdCBtYXkgd2VsbCB1c2UgdGhlIHNhbWUgdmlydHVhbCBETUEg
YWRkcmVzcyBhcyB0aGUgb25lIHlvdSBqdXN0Cj4gdW5tYXBwZWQsIHlldCBhY3R1YWxseSBtYXAg
dG8gYSBkaWZmZXJlbnQgcGh5c2ljYWwgYWRkcmVzcy4gU28gaWYgdGhlCj4gRE1BIHN0aWxsIG9j
Y3VycyB0byB0aGUgIm9sZCIgYWRkcmVzcywgdGhhdCBpc24ndCByZXZva2VkIGF0IGFsbCDigJQg
aXQncwo+IGp1c3QgZ29pbmcgdG8gdGhlIHdyb25nIHBoeXNpY2FsIGxvY2F0aW9uLgo+Cj4gQW5k
IGlmIHlvdSBhcmUgc3VyZSB0aGF0IHRoZSBETUEgd2lsbCBuZXZlciBoYXBwZW4sIHdoeSBkbyB5
b3UgbmVlZCB0bwo+IHJldm9rZSB0aGUgbWFwcGluZyBpbiB0aGUgZmlyc3QgcGxhY2U/CgpSaWdo
dCwgY3Jvc3NlZCBtYWlscy4gVGhlIHNlbWFudGljIEkgd2FudCBpcyB0aGF0IHRoZSBJT1ZBIGlz
CmludmFsaWRhdGVkIC8gc3RhcnRzIHRocm93aW5nIGVycm9ycyB0byB0aGUgZGV2aWNlIGJlY2F1
c2UgdGhlIGFkZHJlc3MKaXQgdGhvdWdodCBpdCB3YXMgdGFsa2luZyB0byBoYXMgYmVlbiByZW1h
cHBlZCBpbiB0aGUgZmlsZS4gT25jZQp1c2Vyc3BhY2Ugd2FrZXMgdXAgYW5kIHJlc3BvbmRzIHRv
IHRoaXMgaW52YWxpZGF0aW9uIGV2ZW50IGl0IGNhbiBkbwp0aGUgYWN0dWFsIHVubWFwIHRvIG1h
a2UgdGhlIElPVkEgcmV1c2FibGUgYWdhaW4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4
LW52ZGltbQo=
