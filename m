From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Fri, 14 Apr 2017 21:37:29 +1000
Message-ID: <1492169849.25766.3.camel@kernel.crashing.org>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1491974532.7236.43.camel@kernel.crashing.org>
 <5ac22496-56ec-025d-f153-140001d2a7f9@deltatee.com>
 <1492034124.7236.77.camel@kernel.crashing.org>
 <81888a1e-eb0d-cbbc-dc66-0a09c32e4ea2@deltatee.com>
 <20170413232631.GB24910@bhelgaas-glaptop.roam.corp.google.com>
 <20170414041656.GA30694@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170414041656.GA30694-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCAyMDE3LTA0LTEzIGF0IDIyOjE2IC0wNjAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
Cj4gPiBBbnkgY2FsbGVyIG9mIHBjaV9hZGRfcmVzb3VyY2Vfb2Zmc2V0KCkgdXNlcyBDUFUgYWRk
cmVzc2VzIGRpZmZlcmVudCBmcm9tCj4gPiB0aGUgUENJIGJ1cyBhZGRyZXNzZXMgKHVubGVzcyB0
aGUgb2Zmc2V0IGlzIHplcm8sIG9mIGNvdXJzZSkuwqAgQWxsIEFDUEkKPiA+IHBsYXRmb3JtcyBh
bHNvIHN1cHBvcnQgdGhpcyB0cmFuc2xhdGlvbiAoc2VlICJ0cmFuc2xhdGlvbl9vZmZzZXQiKSwg
dGhvdWdoCj4gPiBpbiBtb3N0IHg4NiBzeXN0ZW1zIHRoZSBvZmZzZXQgaXMgemVyby7CoCBJJ20g
YXdhcmUgb2Ygb25lIHg4NiBzeXN0ZW0gdGhhdAo+ID4gd2FzIHRlc3RlZCB3aXRoIGEgbm9uLXpl
cm8gb2Zmc2V0IGJ1dCBJIGRvbid0IHRoaW5rIGl0IHdhcyBzaGlwcGVkIHRoYXQKPiA+IHdheS4K
PiAKPiBJJ2Qgc3VnZ2VzdCBqdXN0IGRldGVjdGluZyBpZiB0aGVyZSBpcyBhbnkgdHJhbnNsYXRp
b24gaW4gYnVzCj4gYWRkcmVzc2VzIGFueXdoZXJlIGFuZCBqdXN0IGhhcmQgZGlzYWJsaW5nIFAy
UCBvbiBzdWNoIHN5c3RlbXMuCgpJIG9iamVjdCB0byBkZXNpZ25pbmcgYSBzdWJzeXN0ZW0gdGhh
dCBieSBkZXNpZ24gY2Fubm90IHdvcmsgb24gd2hvbGUKY2F0ZWdvcmllcyBvZiBhcmNoaXRlY3R1
cmVzIG91dCB0aGVyZS4KCj4gT24gbW9kZXJuIGhhcmR3YXJlIHdpdGggNjQgYml0IEJBUnMgdGhl
cmUgaXMgdmVyeSBsaXR0bGUgcmVhc29uIHRvCj4gaGF2ZSB0cmFuc2xhdGlvbiwgc28gSSB0aGlu
ayB0aGlzIGlzIGEgbGVnYWN5IGZlYXR1cmUuCgpObyBpdCdzIG5vdC4KCkNoZWVycywKQmVuLgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
