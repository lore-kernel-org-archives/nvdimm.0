From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH v2] fs/dax: deposit pagetable even when installing zero
 page
Date: Mon, 08 Apr 2019 15:08:53 +0530
Message-ID: <87r2acn8eq.fsf@linux.ibm.com>
References: <20190309120721.21416-1-aneesh.kumar@linux.ibm.com>
 <8736nrnzxm.fsf@linux.ibm.com> <20190313095834.GF32521@quack2.suse.cz>
 <CAPcyv4irZP2F1acuco7UVbvTARzn5SXvCAWstFYtP7ygLRSXTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4irZP2F1acuco7UVbvTARzn5SXvCAWstFYtP7ygLRSXTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linuxppc-dev <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


 Hi Dan,

Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> On Wed, Mar 13, 2019 at 2:58 AM Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
>>
>> On Wed 13-03-19 10:17:17, Aneesh Kumar K.V wrote:
>> >
>> > Hi Dan/Andrew/Jan,
>> >
>> > "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> writes:
>> >
>> > > Architectures like ppc64 use the deposited page table to store hardware
>> > > page table slot information. Make sure we deposit a page table when
>> > > using zero page at the pmd level for hash.
>> > >
>> > > Without this we hit
>> > >
>> > > Unable to handle kernel paging request for data at address 0x00000000
>> > > Faulting instruction address: 0xc000000000082a74
>> > > Oops: Kernel access of bad area, sig: 11 [#1]
>> > > ....
>> > >
>> > > NIP [c000000000082a74] __hash_page_thp+0x224/0x5b0
>> > > LR [c0000000000829a4] __hash_page_thp+0x154/0x5b0
>> > > Call Trace:
>> > >  hash_page_mm+0x43c/0x740
>> > >  do_hash_page+0x2c/0x3c
>> > >  copy_from_iter_flushcache+0xa4/0x4a0
>> > >  pmem_copy_from_iter+0x2c/0x50 [nd_pmem]
>> > >  dax_copy_from_iter+0x40/0x70
>> > >  dax_iomap_actor+0x134/0x360
>> > >  iomap_apply+0xfc/0x1b0
>> > >  dax_iomap_rw+0xac/0x130
>> > >  ext4_file_write_iter+0x254/0x460 [ext4]
>> > >  __vfs_write+0x120/0x1e0
>> > >  vfs_write+0xd8/0x220
>> > >  SyS_write+0x6c/0x110
>> > >  system_call+0x3c/0x130
>> > >
>> > > Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
>> > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
>> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
>> >
>> > Any suggestion on which tree this patch should got to? Also since this
>> > fix a kernel crash, we may want to get this to 5.1?
>>
>> I think this should go through Dan's tree...
>
> I'll merge this and let it soak in -next for a week and then submit for 5.1-rc2.

Any update on this? Did you get to merge this?

-aneesh
