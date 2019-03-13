Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC099211DBE79
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 08:46:23 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k11so1806197oic.7
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 08:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190309120721.21416-1-aneesh.kumar@linux.ibm.com>
 <8736nrnzxm.fsf@linux.ibm.com> <20190313095834.GF32521@quack2.suse.cz>
In-Reply-To: <20190313095834.GF32521@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Mar 2019 08:46:10 -0700
Message-ID: <CAPcyv4irZP2F1acuco7UVbvTARzn5SXvCAWstFYtP7ygLRSXTg@mail.gmail.com>
Subject: Re: [PATCH v2] fs/dax: deposit pagetable even when installing zero
 page
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 13, 2019 at 2:58 AM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 13-03-19 10:17:17, Aneesh Kumar K.V wrote:
> >
> > Hi Dan/Andrew/Jan,
> >
> > "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> >
> > > Architectures like ppc64 use the deposited page table to store hardware
> > > page table slot information. Make sure we deposit a page table when
> > > using zero page at the pmd level for hash.
> > >
> > > Without this we hit
> > >
> > > Unable to handle kernel paging request for data at address 0x00000000
> > > Faulting instruction address: 0xc000000000082a74
> > > Oops: Kernel access of bad area, sig: 11 [#1]
> > > ....
> > >
> > > NIP [c000000000082a74] __hash_page_thp+0x224/0x5b0
> > > LR [c0000000000829a4] __hash_page_thp+0x154/0x5b0
> > > Call Trace:
> > >  hash_page_mm+0x43c/0x740
> > >  do_hash_page+0x2c/0x3c
> > >  copy_from_iter_flushcache+0xa4/0x4a0
> > >  pmem_copy_from_iter+0x2c/0x50 [nd_pmem]
> > >  dax_copy_from_iter+0x40/0x70
> > >  dax_iomap_actor+0x134/0x360
> > >  iomap_apply+0xfc/0x1b0
> > >  dax_iomap_rw+0xac/0x130
> > >  ext4_file_write_iter+0x254/0x460 [ext4]
> > >  __vfs_write+0x120/0x1e0
> > >  vfs_write+0xd8/0x220
> > >  SyS_write+0x6c/0x110
> > >  system_call+0x3c/0x130
> > >
> > > Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> >
> > Any suggestion on which tree this patch should got to? Also since this
> > fix a kernel crash, we may want to get this to 5.1?
>
> I think this should go through Dan's tree...

I'll merge this and let it soak in -next for a week and then submit for 5.1-rc2.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
