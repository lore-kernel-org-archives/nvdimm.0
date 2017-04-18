From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 18 Apr 2017 16:29:12 -0400 (EDT)
Message-ID: <1565047873.28680036.1492547352121.JavaMail.zimbra@redhat.com>
References: <CAPcyv4it56J8Voo6kV0bBcO3nHsOHYLENpAtONJZTGceDDwNPg@mail.gmail.com>
 <1492381396.25766.43.camel@kernel.crashing.org>
 <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

PiBPbiBUdWUsIEFwciAxOCwgMjAxNyBhdCAxMjozNSBQTSwgTG9nYW4gR3VudGhvcnBlIDxsb2dh
bmdAZGVsdGF0ZWUuY29tPgo+IHdyb3RlOgo+ID4KPiA+Cj4gPiBPbiAxOC8wNC8xNyAwMTowMSBQ
TSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOgo+ID4+IFVsdGltYXRlbHkgZXZlcnkgZG1hX29wcyB3
aWxsIG5lZWQgc3BlY2lhbCBjb2RlIHRvIHN1cHBvcnQgUDJQIHdpdGgKPiA+PiB0aGUgc3BlY2lh
bCBoYXJkd2FyZSB0aGF0IG9wcyBpcyBjb250cm9sbGluZywgc28gaXQgbWFrZXMgc29tZSBzZW5z
ZQo+ID4+IHRvIHN0YXJ0IGJ5IHB1c2hpbmcgdGhlIGNoZWNrIGRvd24gdGhlcmUgaW4gdGhlIGZp
cnN0IHBsYWNlLiBUaGlzCj4gPj4gYWR2aWNlIGlzIHBhcnRpYWxseSBtb3RpdmF0ZWQgYnkgaG93
IGRtYV9tYXBfc2cgaXMganVzdCBhIHNtYWxsCj4gPj4gd3JhcHBlciBhcm91bmQgdGhlIGZ1bmN0
aW9uIHBvaW50ZXIgY2FsbC4uLgo+ID4KPiA+IFllcywgSSBub3RpY2VkIHRoaXMgcHJvYmxlbSB0
b28gYW5kIHRoYXQgbWFrZXMgc2Vuc2UuIEl0IGp1c3QgbWVhbnMKPiA+IGV2ZXJ5IGRtYV9vcHMg
d2lsbCBwcm9iYWJseSBuZWVkIHRvIGJlIG1vZGlmaWVkIHRvIGVpdGhlciBzdXBwb3J0IHAycAo+
ID4gcGFnZXMgb3IgZmFpbCBvbiB0aGVtLiBUaG91Z2gsIHRoZSBvbmx5IHJlYWwgZGlmZmljdWx0
eSB0aGVyZSBpcyB0aGF0IGl0Cj4gPiB3aWxsIGJlIGEgbG90IG9mIHdvcmsuCj4gCj4gSSBkb24n
dCB0aGluayB5b3UgbmVlZCB0byBnbyB0b3VjaCBhbGwgZG1hX29wcywgSSB0aGluayB5b3UgY2Fu
IGp1c3QKPiBhcnJhbmdlIGZvciBkZXZpY2VzIHRoYXQgYXJlIGdvaW5nIHRvIGRvIGRtYSB0byBn
ZXQgcmVkaXJlY3RlZCB0byBhCj4gcDJwIGF3YXJlIHByb3ZpZGVyIG9mIG9wZXJhdGlvbnMgdGhh
dCBvdmVycmlkZXMgdGhlIHN5c3RlbSBkZWZhdWx0Cj4gZG1hX29wcy4gSS5lLiBqdXN0IHRvdWNo
IGdldF9kbWFfb3BzKCkuCgpUaGlzIHdvdWxkIG5vdCB3b3JrIHdlbGwgZm9yIGV2ZXJ5b25lLCBm
b3IgaW5zdGFuY2Ugb24gR1BVIHdlIHVzdWFseQpoYXZlIGJ1ZmZlciBvYmplY3Qgd2l0aCBhIG1p
eCBvZiBkZXZpY2UgbWVtb3J5IGFuZCByZWd1bGFyIHN5c3RlbQptZW1vcnkgYnV0IGNhbGwgZG1h
IHNnIG1hcCBvbmNlIGZvciB0aGUgbGlzdC4KCkNoZWVycywKSsOpcsO0bWUKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
