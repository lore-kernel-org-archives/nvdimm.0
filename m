Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F0A4224488AE
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 11:11:06 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id x12so13111253oie.13
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 11:17:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180312141721.GB4214@redhat.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066492680.40260.6843692416565308005.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180312141721.GB4214@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Mar 2018 11:17:25 -0700
Message-ID: <CAPcyv4jdOdvUZHS43Q18h3yTNzmiVJceEcVN5XSKstTkQHfDFQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/11] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
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
To: Jerome Glisse <jglisse@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBNYXIgMTIsIDIwMTggYXQgNzoxNyBBTSwgSmVyb21lIEdsaXNzZSA8amdsaXNzZUBy
ZWRoYXQuY29tPiB3cm90ZToKPiBPbiBGcmksIE1hciAwOSwgMjAxOCBhdCAxMDo1NToyNlBNIC0w
ODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4+IFRoZSBITU0gc3ViLXN5c3RlbSBleHRlbmRlZCBk
ZXZfcGFnZW1hcCB0byBhcnJhbmdlIGEgY2FsbGJhY2sgd2hlbiBhCj4+IGRldl9wYWdlbWFwIG1h
bmFnZWQgcGFnZSBpcyBmcmVlZC4gU2luY2UgYSBkZXZfcGFnZW1hcCBwYWdlIGlzIGZyZWUgLwo+
PiBpZGxlIHdoZW4gaXRzIHJlZmVyZW5jZSBjb3VudCBpcyAxIGl0IHJlcXVpcmVzIGFuIGFkZGl0
aW9uYWwgYnJhbmNoIHRvCj4+IGNoZWNrIHRoZSBwYWdlLXR5cGUgYXQgcHV0X3BhZ2UoKSB0aW1l
LiBHaXZlbiBwdXRfcGFnZSgpIGlzIGEgaG90LXBhdGgKPj4gd2UgZG8gbm90IHdhbnQgdG8gaW5j
dXIgdGhhdCBjaGVjayBpZiBITU0gaXMgbm90IGluIHVzZSwgc28gYSBzdGF0aWMKPj4gYnJhbmNo
IGlzIHVzZWQgdG8gYXZvaWQgdGhhdCBvdmVyaGVhZCB3aGVuIG5vdCBuZWNlc3NhcnkuCj4+Cj4+
IE5vdywgdGhlIEZTX0RBWCBpbXBsZW1lbnRhdGlvbiB3YW50cyB0byByZXVzZSB0aGlzIG1lY2hh
bmlzbSBmb3IKPj4gcmVjZWl2aW5nIGRldl9wYWdlbWFwIC0+cGFnZV9mcmVlKCkgY2FsbGJhY2tz
LiBSZXdvcmsgdGhlIEhNTS1zcGVjaWZpYwo+PiBzdGF0aWMta2V5IGludG8gYSBnZW5lcmljIG1l
Y2hhbmlzbSB0aGF0IGVpdGhlciBITU0gb3IgRlNfREFYIGNvZGUgcGF0aHMKPj4gY2FuIGVuYWJs
ZS4KPgo+IFdoeSBFWFBPUlRfU1lNQk9MX0dQTCBhbmQgbm90IEVYUE9SVF9TWU1CT0wgbGlrZSBp
dCB3YXMgcHJpb3IgdG8gdGhpcwo+IHBhdGNoID8gTm90IGkgY2FyZSB0aGF0IG11Y2ggYWJvdXQg
dGhhdCwganVzdCB3b25kZXJpbmcuIE1heWJlIGtlZXAgaXQKPiBFWFBPUlRfU1lNQk9MKCkgPwoK
SE1NIGhhcyBzaWduaWZpY2FudCBpbnRlZ3JhdGlvbnMgYW5kIHVzZWZ1bCBoYWNrcyB3aXRoaW4g
dGhlIG1tCnN1Yi1zeXN0ZW0sIEkgdGhpbmsgd2Ugc2hvdWxkIGdvIGZ1cnRoZXIgdGhhbiBqdXN0
IHRoZXNlIHN5bWJvbHMgYW5kCmFsc28gaW5jbHVkZSBkZXZtX21lbXJlbWFwX3BhZ2VzKCkgYXMg
RVhQT1JUX1NZTUJPTF9HUEwuIEl0IHdhcyBzaW1wbHkKYW4gb3ZlcnNpZ2h0IHRoYXQgdGhlc2Ug
d2VyZSBFWFBPUlRfU1lNQk9MIHByZXZpb3VzbHkuCgo+IEluIGFueSBjYXNlCj4gUmV2aWV3ZWQt
Ynk6ICJKw6lyw7RtZSBHbGlzc2UiIDxqZ2xpc3NlQHJlZGhhdC5jb20+CgpUaGFua3MhCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
