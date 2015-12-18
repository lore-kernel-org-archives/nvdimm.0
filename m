Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1450464730.10450.14.camel@hpe.com>
Subject: Re: [PATCH] BTT: Change nd_btt_arena_is_valid() to verify UUID
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 18 Dec 2015 11:52:10 -0700
In-Reply-To: <CAPcyv4iBk+DwHRBu=zAzSYrqD3Ni_cdK2630FuREtAhtDk5rdw@mail.gmail.com>
References: <1450393200-6802-1-git-send-email-toshi.kani@hpe.com>
	 <1450427687.11503.14.camel@kernel.org>	<1450451737.20148.121.camel@hpe.com>
	 <CAPcyv4iBk+DwHRBu=zAzSYrqD3Ni_cdK2630FuREtAhtDk5rdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-12-18 at 09:54 -0800, Dan Williams wrote:
> On Fri, Dec 18, 2015 at 7:15 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Fri, 2015-12-18 at 01:34 -0700, Vishal Verma wrote:
> > > Also, I wonder if this problem is solved by using libndctl to manage
> > > BTTs.
> > 
> > I have not tested with libndctl yet, but I think our bind/unbind 
> > scripts do the same procedures.
> 
> We loop through all combinations of sector size in our unit test.  If
> you want to change the sector size the expectation is that the
> namespace is destroyed and fully re-created, especially due to the
> fact that changing sector size invalidates all data on the namespace.
> 
> See: https://github.com/pmem/ndctl/blob/master/lib/test-libndctl.c

The parent_uuid is not set on our NVDIMM-N systems.  I do not see 'uuid'
file under sysfs 'namespaceX.X' per namespace_visible(), either.  This
concept of creating/destroying a namespace is a bit foreign to us since
we've never needed to do.  Can you elaborate how it's supposed to work for
NVDIMM-N?

Thanks,
-Toshi
