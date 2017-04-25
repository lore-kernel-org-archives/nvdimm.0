From: "Stephen  Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Tue, 25 Apr 2017 21:23:30 +0000
Message-ID: <B5A68214-E3A6-45F6-9820-758C5C84688A@raithlin.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
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
 <1493101803.3171.246.camel@oracle.com>
 <0cc95df5-b9dd-6493-15fe-771d535c1020@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <0cc95df5-b9dd-6493-15fe-771d535c1020-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <2DE64262AC700A45B4EEDB3B78B07FB4-JkAt9bkEularoOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Pj4gWWVzLCB0aGF0J3Mgd2h5IEkgdXNlZCAnc2lnbmlmaWNhbnQnLiBPbmUgZ29vZCB0aGluZyBp
cyB0aGF0IGdpdmVuIHJlc291cmNlcyANCj4+IGl0IGNhbiBlYXNpbHkgYmUgZG9uZSBpbiBwYXJh
bGxlbCB3aXRoIG90aGVyIGRldmVsb3BtZW50LCBhbmQgd2lsbCBnaXZlIGFkZGl0aW9uYWwNCj4+
IGluc2lnaHQgb2Ygc29tZSBmb3JtLg0KPg0KPll1cCwgd2VsbCBpZiBzb21lb25lIHdhbnRzIHRv
IHN0YXJ0IHdvcmtpbmcgb24gYW4gZW11bGF0ZWQgUkRNQSBkZXZpY2UNCj50aGF0IGFjdHVhbGx5
IHNpbXVsYXRlcyBwcm9wZXIgRE1BIHRyYW5zZmVycyB0aGF0IHdvdWxkIGJlIGdyZWF0IQ0KDQpH
aXZlIHRoYXQgZWFjaCBSRE1BIHZlbmRvcuKAmXMgZGV2aWNlcyBleHBvc2UgYSBkaWZmZXJlbnQg
TU1JTyBJIGRvbuKAmXQgZXhwZWN0IHRoaXMgdG8gaGFwcGVuIGFueXRpbWUgc29vbi4NCg0KPiBZ
ZXMsIHRoZSBudm1lIGRldmljZSBpbiBxZW11IGhhcyBhIENNQiBidWZmZXIgd2hpY2ggaXMgYSBn
b29kIGNob2ljZSB0bw0KPiB0ZXN0IHdpdGggYnV0IHdlIGRvbid0IGhhdmUgY29kZSB0byB1c2Ug
aXQgZm9yIHAycCB0cmFuc2ZlcnMgaW4gdGhlDQo+a2VybmVsIHNvIGl0IGlzIGEgYml0IGF3a3dh
cmQuDQoNCk5vdGUgdGhlIENNQiBjb2RlIGlzIG5vdCBpbiB1cHN0cmVhbSBRRU1VLCBpdOKAmXMg
aW4gS2VpdGjigJlzIGZvcmsgWzFdLiBJIHdpbGwgc2VlIGlmIEkgY2FuIHB1c2ggdGhpcyB1cHN0
cmVhbS4NCg0KU3RlcGhlbg0KDQpbMV0gZ2l0Oi8vZ2l0LmluZnJhZGVhZC5vcmcvdXNlcnMva2J1
c2NoL3FlbXUtbnZtZS5naXQNCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0
cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRp
bW0K
