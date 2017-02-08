From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 1/2] ext4: fix DAX write locking
Date: Wed, 8 Feb 2017 14:38:32 -0500
Message-ID: <20170208193832.zydlsh64ieage2js@thunk.org>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-2-git-send-email-hch@lst.de>
 <20170111090136.GE16116@quack2.suse.cz>
 <20170208171410.GA27359@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208171410.GA27359-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gV2VkLCBGZWIgMDgsIDIwMTcgYXQgMDk6MTQ6MTBBTSAtMDgwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gV2VkLCBKYW4gMTEsIDIwMTcgYXQgMTA6MDE6MzZBTSArMDEwMCwgSmFu
IEthcmEgd3JvdGU6Cj4gPiBPbiBUdWUgMTAtMDEtMTcgMTY6NDg6MDcsIENocmlzdG9waCBIZWxs
d2lnIHdyb3RlOgo+ID4gPiBVbmxpa2UgT19ESVJFQ1QgREFYIGlzIG5vdCBhbiBvcHRpb25hbCBv
cHQtaW4gZmVhdHVyZSBzZWxlY3RlZCBieSB0aGUKPiA+ID4gYXBwbGljYXRpb24sIHNvIHdlJ2xs
IGhhdmUgdG8gcHJvdmlkZSB0aGUgdHJhZGl0aW9uYWwgc3luY2hyb27RlnphdGlvbgo+ID4gPiBv
ZiBvdmVybGFwcGluZyB3cml0ZXMgYXMgd2UgZG8gZm9yIGJ1ZmZlcmVkIHdyaXRlcy4KPiA+ID4g
Cj4gPiA+IFRoaXMgd2FzIGJyb2tlbiBoaXN0b3JpY2FsbHkgZm9yIERBWCwgYnV0IGdvdCBmaXhl
ZCBmb3IgZXh0MiBhbmQgWEZTCj4gPiA+IGFzIHBhcnQgb2YgdGhlIGlvbWFwIGNvbnZlcnNpb24u
ICBGaXggdXAgZXh0NCBhcyB3ZWxsLgo+ID4gPiAKPiA+ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0
b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gPiAKPiA+IE1ha2VzIHNlbnNlLiBZb3UgY2FuIGFk
ZDoKPiA+IAo+ID4gUmV2aWV3ZWQtYnk6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+Cj4gPiAKPiA+
IFRlZCwgY2FuIHlvdSBwbGVhc2UgcGljayBpdCB1cD8gVGhhbmtzIQo+IAo+IERpZCB0aGlzIGdl
dCBwaWNrZWQgdXA/CgpTb3JyeSwgSSBtaXNzZWQgSmFuJ3MgcmVxdWVzdCB0byBwaWNrIGl0IHVw
LiAgSSBoYWQgYXNzdW1lZCBpdCB3b3VsZApiZSBnb2luZyBpbiB2aWEgdGhlIGRheCB0cmVlLiAg
SSdsbCB0YWtlIGEgbG9vayBhdCBpdCBub3cgZm9yIHRoZSBleHQ0CnRyZWUuCgoJCQkJCS0gVGVk
CgkJCQkJCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxp
bnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczov
L2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
