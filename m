Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B92A820E6
 for <linux-nvdimm@lists.01.org>; Wed,  8 Feb 2017 09:14:15 -0800 (PST)
Date: Wed, 8 Feb 2017 09:14:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] ext4: fix DAX write locking
Message-ID: <20170208171410.GA27359@infradead.org>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-2-git-send-email-hch@lst.de>
 <20170111090136.GE16116@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170111090136.GE16116@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBKYW4gMTEsIDIwMTcgYXQgMTA6MDE6MzZBTSArMDEwMCwgSmFuIEthcmEgd3JvdGU6
Cj4gT24gVHVlIDEwLTAxLTE3IDE2OjQ4OjA3LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+
IFVubGlrZSBPX0RJUkVDVCBEQVggaXMgbm90IGFuIG9wdGlvbmFsIG9wdC1pbiBmZWF0dXJlIHNl
bGVjdGVkIGJ5IHRoZQo+ID4gYXBwbGljYXRpb24sIHNvIHdlJ2xsIGhhdmUgdG8gcHJvdmlkZSB0
aGUgdHJhZGl0aW9uYWwgc3luY2hyb27RlnphdGlvbgo+ID4gb2Ygb3ZlcmxhcHBpbmcgd3JpdGVz
IGFzIHdlIGRvIGZvciBidWZmZXJlZCB3cml0ZXMuCj4gPiAKPiA+IFRoaXMgd2FzIGJyb2tlbiBo
aXN0b3JpY2FsbHkgZm9yIERBWCwgYnV0IGdvdCBmaXhlZCBmb3IgZXh0MiBhbmQgWEZTCj4gPiBh
cyBwYXJ0IG9mIHRoZSBpb21hcCBjb252ZXJzaW9uLiAgRml4IHVwIGV4dDQgYXMgd2VsbC4KPiA+
IAo+ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gCj4g
TWFrZXMgc2Vuc2UuIFlvdSBjYW4gYWRkOgo+IAo+IFJldmlld2VkLWJ5OiBKYW4gS2FyYSA8amFj
a0BzdXNlLmN6Pgo+IAo+IFRlZCwgY2FuIHlvdSBwbGVhc2UgcGljayBpdCB1cD8gVGhhbmtzIQoK
RGlkIHRoaXMgZ2V0IHBpY2tlZCB1cD8KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
