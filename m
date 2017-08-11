Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 982BF21D490FD
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 03:01:13 -0700 (PDT)
Date: Fri, 11 Aug 2017 03:03:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170811100327.GD7064@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
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
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBBdWcgMDcsIDIwMTcgYXQgMDU6MjQ6MDhQTSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdy
b3RlOgo+IERvZXMgc3lzX21tYXAoKSByZWplY3QgdW5rbm93biBmbGFnIHZhbHVlcyB0b2RheT8g
SSdtIGVpdGhlciBub3QKPiBsb29raW5nIGluIHRoZSByaWdodCBwbGFjZSBvciBpdCdzIG1pc3Np
bmcgYW5kIHdlJ2xsIG5lZWQgc29tZQo+IGludGVyZmFjZS9tZWNoYW5pc20gdG8gY2hlY2sgaWYg
TUFQX1NZTkMgaXMgaG9ub3JlZC4KCkl0IGRvZXNuJ3Qgc2VlbSB0byByZWplY3QgdW5rbm93biBm
bGFncy4KClRoZSBsYWNrIG9mIGZsYWdzIGNoZWNraW5nIHN0cmlrZXMgYmFjayBvbmNlIG1vcmUs
IHNpZ2jhuasuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRw
czovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
