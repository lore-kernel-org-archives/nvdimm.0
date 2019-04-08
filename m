Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190309120721.21416-1-aneesh.kumar@linux.ibm.com>
 <8736nrnzxm.fsf@linux.ibm.com> <20190313095834.GF32521@quack2.suse.cz>
 <CAPcyv4irZP2F1acuco7UVbvTARzn5SXvCAWstFYtP7ygLRSXTg@mail.gmail.com> <87r2acn8eq.fsf@linux.ibm.com>
In-Reply-To: <87r2acn8eq.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Apr 2019 08:54:31 -0700
Message-ID: <CAPcyv4hJ=fhXNYXwtUKwSY=dZo540bLX+d12j3HQswkNWFugRg@mail.gmail.com>
Subject: Re: [PATCH v2] fs/dax: deposit pagetable even when installing zero page
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 8, 2019 at 2:39 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
>
>  Hi Dan,
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Wed, Mar 13, 2019 at 2:58 AM Jan Kara <jack@suse.cz> wrote:
> >>
> >> On Wed 13-03-19 10:17:17, Aneesh Kumar K.V wrote:
> >> >
> >> > Hi Dan/Andrew/Jan,
> >> >
> >> > "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> >> >
> >> > > Architectures like ppc64 use the deposited page table to store hardware
> >> > > page table slot information. Make sure we deposit a page table when
> >> > > using zero page at the pmd level for hash.
> >> > >
> >> > > Without this we hit
> >> > >
> >> > > Unable to handle kernel paging request for data at address 0x00000000
> >> > > Faulting instruction address: 0xc000000000082a74
> >> > > Oops: Kernel access of bad area, sig: 11 [#1]
> >> > > ....
> >> > >
> >> > > NIP [c000000000082a74] __hash_page_thp+0x224/0x5b0
> >> > > LR [c0000000000829a4] __hash_page_thp+0x154/0x5b0
> >> > > Call Trace:
> >> > >  hash_page_mm+0x43c/0x740
> >> > >  do_hash_page+0x2c/0x3c
> >> > >  copy_from_iter_flushcache+0xa4/0x4a0
> >> > >  pmem_copy_from_iter+0x2c/0x50 [nd_pmem]
> >> > >  dax_copy_from_iter+0x40/0x70
> >> > >  dax_iomap_actor+0x134/0x360
> >> > >  iomap_apply+0xfc/0x1b0
> >> > >  dax_iomap_rw+0xac/0x130
> >> > >  ext4_file_write_iter+0x254/0x460 [ext4]
> >> > >  __vfs_write+0x120/0x1e0
> >> > >  vfs_write+0xd8/0x220
> >> > >  SyS_write+0x6c/0x110
> >> > >  system_call+0x3c/0x130
> >> > >
> >> > > Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
> >> > > Reviewed-by: Jan Kara <jack@suse.cz>
> >> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> >> >
> >> > Any suggestion on which tree this patch should got to? Also since this
> >> > fix a kernel crash, we may want to get this to 5.1?
> >>
> >> I think this should go through Dan's tree...
> >
> > I'll merge this and let it soak in -next for a week and then submit for 5.1-rc2.
>
> Any update on this? Did you get to merge this?

Thanks for the reminder. Will send this week along with some other
libnvdimm related fixes.
