Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 25 Jun 2019 09:23:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/22] mm: export alloc_pages_vma
Message-ID: <20190625072317.GC30350@lst.de>
References: <20190613094326.24093-1-hch@lst.de> <20190613094326.24093-6-hch@lst.de> <20190620191733.GH12083@dhcp22.suse.cz> <CAPcyv4h9+Ha4FVrvDAe-YAr1wBOjc4yi7CAzVuASv=JCxPcFaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h9+Ha4FVrvDAe-YAr1wBOjc4yi7CAzVuASv=JCxPcFaw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@lst.de>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, Linux MM <linux-mm@kvack.org>, nouveau@lists.freedesktop.org, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 24, 2019 at 11:24:48AM -0700, Dan Williams wrote:
> I asked for this simply because it was not exported historically. In
> general I want to establish explicit export-type criteria so the
> community can spend less time debating when to use EXPORT_SYMBOL_GPL
> [1].
> 
> The thought in this instance is that it is not historically exported
> to modules and it is safer from a maintenance perspective to start
> with GPL-only for new symbols in case we don't want to maintain that
> interface long-term for out-of-tree modules.
> 
> Yes, we always reserve the right to remove / change interfaces
> regardless of the export type, but history has shown that external
> pressure to keep an interface stable (contrary to
> Documentation/process/stable-api-nonsense.rst) tends to be less for
> GPL-only exports.

Fully agreed.  In the end the decision is with the MM maintainers,
though, although I'd prefer to keep it as in this series.
