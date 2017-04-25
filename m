From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 25 Apr 2017 08:30:03 +0200
Message-ID: <1493101803.3171.246.camel@oracle.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1491974532.7236.43.camel@kernel.crashing.org>
 <5ac22496-56ec-025d-f153-140001d2a7f9@deltatee.com>
 <1492034124.7236.77.camel@kernel.crashing.org>
 <81888a1e-eb0d-cbbc-dc66-0a09c32e4ea2@deltatee.com>
 <20170413232631.GB24910@bhelgaas-glaptop.roam.corp.google.com>
 <20170414041656.GA30694@obsidianresearch.com>
 <1492169849.25766.3.camel@kernel.crashing.org>
 <630c1c63-ff17-1116-e069-2b8f93e50fa2@deltatee.com>
 <20170414190452.GA15679@bhelgaas-glaptop.roam.corp.google.com>
 <1492207643.25766.18.camel@kernel.crashing.org>
 <bff1e503-95a9-e19f-bfd9-0ff962c63a81@deltatee.com>
 <CAPcyv4jUeKzKDARp6Z35kdPLKnP-M6aF8X5KpOx55CLyjnj4dA@mail.gmail.com>
 <1492311719.25766.37.camel@kernel.crashing.org>
 <CAPcyv4iqnz1B00Q3xG-nGrLXdOyB7ditxmwZyotksLFgUqr+jA@mail.gmail.com>
 <5e43818e-8c6b-8be8-23ff-b798633d2a73@deltatee.com>
 <1492381907.25766.49.camel@kernel.crashing.org>
 <1493019397.3171.118.camel@oracle.com>
 <9b6c0830-a728-c7ca-e6c6-2135f3f760ed@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <9b6c0830-a728-c7ca-e6c6-2135f3f760ed-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gTW9uLCAyMDE3LTA0LTI0IGF0IDEwOjE0IC0wNjAwLCBMb2dhbiBHdW50aG9ycGUgd3JvdGU6
Cj4gCj4gT24gMjQvMDQvMTcgMDE6MzYgQU0sIEtudXQgT21hbmcgd3JvdGU6Cj4gPiBNeSBmaXJz
dCByZWZsZXggd2hlbiByZWFkaW5nIHRoaXMgdGhyZWFkIHdhcyB0byB0aGluayB0aGF0IHRoaXMg
d2hvbGUgZG9tYWluCj4gPiBsZW5kcyBpdCBzZWxmIGV4Y2VsbGVudGx5IHRvIHRlc3Rpbmcgdmlh
IFFlbXUuIENvdWxkIGl0IGJlIHRoYXQgZG9pbmcgdGhpcyBpbsKgCj4gPiB0aGUgb3Bwb3NpdGUg
ZGlyZWN0aW9uIG1pZ2h0IGJlIGEgc2FmZXIgYXBwcm9hY2ggaW4gdGhlIGxvbmcgcnVuIGV2ZW4g
dGhvdWdowqAKPiA+IChzaWduaWZpY2FudCkgbW9yZSB3b3JrIHVwLWZyb250Pwo+IAo+IFRoYXQn
cyBhbiBpbnRlcmVzdGluZyBpZGVhLiBXZSBkaWQgZG8gc29tZSB2ZXJ5IGxpbWl0ZWQgdGVzdGlu
ZyBvbiBxZW11Cj4gd2l0aCBvbmUgaXRlcmF0aW9uIG9mIG91ciB3b3JrLiBIb3dldmVyLCBpdCdz
IGRpZmZpY3VsdCBiZWNhdXNlIHRoZXJlIGlzCj4gbm8gc3VwcG9ydCBmb3IgYW55IFJETUEgZGV2
aWNlcyB3aGljaCBhcmUgYSBwYXJ0IG9mIG91ciBwcmltYXJ5IHVzZQo+IGNhc2UuIAoKWWVzLCB0
aGF0J3Mgd2h5IEkgdXNlZCAnc2lnbmlmaWNhbnQnLiBPbmUgZ29vZCB0aGluZyBpcyB0aGF0IGdp
dmVuIHJlc291cmNlc8KgCml0IGNhbiBlYXNpbHkgYmUgZG9uZSBpbiBwYXJhbGxlbCB3aXRoIG90
aGVyIGRldmVsb3BtZW50LCBhbmQgd2lsbCBnaXZlIGFkZGl0aW9uYWwKaW5zaWdodCBvZiBzb21l
IGZvcm0uCgo+IEkgYWxzbyBpbWFnaW5lIGl0IHdvdWxkIGJlIHF1aXRlIGRpZmZpY3VsdCB0byBk
ZXZlbG9wIHRob3NlIG1vZGVscwo+IGdpdmVuIHRoZSBhcnJheSBvZiBoYXJkd2FyZSB0aGF0IG5l
ZWRzIHRvIGJlIHN1cHBvcnRlZCBhbmQgdGhlIGRlZXAKPiBmdW5jdGlvbmFsIGtub3dsZWRnZSBy
ZXF1aXJlZCB0byBmaWd1cmUgb3V0IGFwcHJvcHJpYXRlIHJlc3RyaWN0aW9ucy4KCkZyb20gbXkg
bmFpdmUgcGVyc3BlY3RpdmUgaXQgc2VlbXMgaXQgbmVlZCBub3QgZXZlbiBiZSBhIGZ1bGwgbW9k
ZWwgdG8gZ2V0IHNvbWUgYmVuZWZpdHMsCmp1c3QgbG93IGxldmVsIGZ1bmN0aW9uYWxpdHkgdGVz
dHMgd2l0aCBzb21lIGluc3RhbmNlcyBvZiBhCmRldmljZSB0aGF0IG9mZmVycyBzb21lIE1NSU8g
c3BhY2UgJ3BsYXlncm91bmQnLgoKT3IgbWF5YmUgeW91IGNhbiBsZXZlcmFnZSBzb21lIG9mIHRo
ZSBhbHJlYWR5IGltcGxlbWVudGVkIGVtdWxhdGVkIGRldmljZXMgaW4gUWVtdT8KCktudXQKCj4g
Cj4gTG9nYW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
