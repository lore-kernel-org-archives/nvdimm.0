Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B747C21A09130
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 01:17:59 -0700 (PDT)
Date: Tue, 30 Oct 2018 09:17:57 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
Message-ID: <20181030081757.GX32673@dhcp22.suse.cz>
References: <20181029141210.GJ32673@dhcp22.suse.cz>
 <84f09883c16608ddd2ba88103f43ec6a1c649e97.camel@linux.intel.com>
 <20181029163528.GL32673@dhcp22.suse.cz>
 <18dfc5a0db11650ff31433311da32c95e19944d9.camel@linux.intel.com>
 <20181029172415.GM32673@dhcp22.suse.cz>
 <8e7a4311a240b241822945c0bb4095c9ffe5a14d.camel@linux.intel.com>
 <20181029181827.GO32673@dhcp22.suse.cz>
 <3281f3044fa231bbc1b02d5c5efca3502a0d05a8.camel@linux.intel.com>
 <20181030062915.GT32673@dhcp22.suse.cz>
 <CAPcyv4itSde5oiW2j5uK8PCqdpXkHKz=kS8NBk2Ge+Ldb=yLUg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4itSde5oiW2j5uK8PCqdpXkHKz=kS8NBk2Ge+Ldb=yLUg@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, osalvador@techadventures.net, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 29-10-18 23:55:12, Dan Williams wrote:
> On Mon, Oct 29, 2018 at 11:29 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 29-10-18 12:59:11, Alexander Duyck wrote:
> > > On Mon, 2018-10-29 at 19:18 +0100, Michal Hocko wrote:
> [..]
> > > The patches Andrew pushed addressed the immediate issue so that now
> > > systems with nvdimm/DAX memory can at least initialize quick enough
> > > that systemd doesn't refuse to mount the root file system due to a
> > > timeout.
> >
> > This is about the first time you actually mention that. I have re-read
> > the cover letter and all changelogs of patches in this serious. Unless I
> > have missed something there is nothing about real users hitting issues
> > out there. nvdimm is still considered a toy because there is no real HW
> > users can play with.
> 
> Yes, you have missed something, because that's incorrect. There's been
> public articles about these parts sampling since May.
> 
>     https://www.anandtech.com/show/12828/intel-launches-optane-dimms-up-to-512gb-apache-pass-is-here

indeed!

> That testing identified this initialization performance problem and
> thankfully got it addressed in time for the current merge window.

And I still cannot see a word about that in changelogs.

-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
