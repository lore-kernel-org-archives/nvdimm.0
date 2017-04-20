From: "Stephen  Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Thu, 20 Apr 2017 23:07:06 +0000
Message-ID: <D090F830-2753-4479-A291-CEE37DC0A853@raithlin.com>
References: <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
 <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com>
 <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
 <CAPcyv4iJ9H8Ykwnjqa2R_D1qG6PsSQmi=QxYH-rKLF_ihrsWyw@mail.gmail.com>
 <20170419173225.GA11255@redhat.com>
 <CAPcyv4gxBgVsbSez7_dZYkZojUWU0X0txs7FxiJ+Z3xsMt6TqQ@mail.gmail.com>
 <D79A59A8-DC7E-413F-ABB8-05F373A9DFD4@raithlin.com>
 <CAPcyv4i+a_14E58SjFHncyq2O2-zf_PB=aT7k0a-Jc0XsfPapQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4i+a_14E58SjFHncyq2O2-zf_PB=aT7k0a-Jc0XsfPapQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <190261666B639441A95CAFDD7BF19528-JkAt9bkEularoOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Pj4gWWVzLCB0aGlzIG1ha2VzIHNlbnNlIEkgdGhpbmsgd2UgcmVhbGx5IGp1c3Qgd2FudCB0byBk
aXN0aW5ndWlzaCBob3N0DQo+PiBtZW1vcnkgb3Igbm90IGluIHRlcm1zIG9mIHRoZSBkZXZfcGFn
ZW1hcCB0eXBlLg0KPg0KPj4gSSB3b3VsZCBsaWtlIHRvIHNlZSBtdXR1YWxseSBleGNsdXNpdmUg
ZmxhZ3MgZm9yIGhvc3QgbWVtb3J5IChvciBub3QpIGFuZCBwZXJzaXN0ZW5jZSAob3Igbm90KS4N
Cj4+DQo+DQo+IFdoeSBwZXJzaXN0ZW5jZT8gSXQgaGFzIHplcm8gbWVhbmluZyB0byB0aGUgbW0u
DQoNCkkgbGlrZSB0aGUgaWRlYSBvZiBoYXZpbmcgcHJvcGVydGllcyBvZiB0aGUgbWVtb3J5IGlu
IG9uZSBwbGFjZS4gV2hpbGUgbW0gbWlnaHQgbm90IHVzZSBwZXJzaXN0ZW5jZSB0b2RheSBpdCBt
YXkgbWFrZSB1c2UgY2VydGFpbiB0aGluZ3MgdGhhdCBwZXJzaXN0ZW5jZSBpbXBsaWVzIChsaWtl
IGZpbml0ZSBlbmR1cmFuY2UgYW5kL29yIGhpZ2hlciB3cml0ZSBsYXRlbmN5KSBpbiB0aGUgZnV0
dXJlLiBBbHNvIHRoZSBwZXJzaXN0ZW5jZSBvZiB0aGUgbWVtb3J5IG11c3QgaGF2ZSBpc3N1ZXMg
Zm9yIG1tIHNlY3VyaXR5PyBBZ2FpbiBub3QgYWRkcmVzc2VkIHRvZGF5IGJ1dCB1c2VmdWwgaW4g
dGhlIGZ1dHVyZS4NCg0KSW4gYWRkaXRpb24gSSBhbSBub3Qgc3VyZSB3aGVyZSBlbHNlIHdvdWxk
IGJlIGFuIGFwcHJvcHJpYXRlIHBsYWNlIHRvIHB1dCBzb21ldGhpbmcgbGlrZSBhIHBlcnNpc3Rl
bmNlIHByb3BlcnR5IGZsYWcuIEkga25vdyB0aGUgTlZESU1NIHNlY3Rpb24gb2YgdGhlIGtlcm5l
bCB1c2VzIHRoaW5ncyBsaWtlIE5GSVQgdG8gZGVzY3JpYmUgcHJvcGVydGllcyBvZiB0aGUgbWVt
b3J5IGJ1dCB3ZSBkb27igJl0IHlldCAodG8gbXkga25vd2xlZGdlKSBoYXZlIHNvbWV0aGluZyBz
aW1pbGFyIGZvciBJTyBtZW1vcnkuDQoNClN0ZXBoZW4NCg0KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
