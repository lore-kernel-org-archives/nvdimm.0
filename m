Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 21/22] mm: remove the HMM config option
Date: Thu, 13 Jun 2019 20:01:55 +0000
Message-ID: <20190613200150.GB22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-22-hch@lst.de>
In-Reply-To: <20190613094326.24093-22-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4F4AB6FDDD24014F95455A97A0E953B7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 11:43:24AM +0200, Christoph Hellwig wrote:
> All the mm/hmm.c code is better keyed off HMM_MIRROR.  Also let nouveau
> depend on it instead of the mix of a dummy dependency symbol plus the
> actually selected one.  Drop various odd dependencies, as the code is
> pretty portable.

I don't really know, but I thought this needed the arch restriction
for the same reason get_user_pages has various unique arch specific
implementations (it does seem to have some open coded GUP like thing)?

I was hoping we could do this after your common gup series? But sooner
is better too.

Jason
