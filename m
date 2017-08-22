Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2934421E49BA7
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 10:24:48 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id f11so192590117oic.0
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 10:27:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170821215703.GA24473@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170821215703.GA24473@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Aug 2017 10:27:19 -0700
Message-ID: <CAPcyv4jpM_4fY+f+0i6ysnQ=0i2W9eq1pUCO0axYTHKbOtaufg@mail.gmail.com>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andy Lutomirski <luto@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 21, 2017 at 2:57 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
>> Pretty crude for now...
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>
> One other thing that should probably be wired up before this is all said and
> done is the VmFlag string in /proc/<pid>/smaps.  Right now when we set this
> flag it ends up as ??:
>
> 7f44e6cbd000-7f44e6dbd000 rw-s 00000000 103:00 12              /root/dax/data
> Size:               1024 kB
> Rss:                   0 kB
> Pss:                   0 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:         0 kB
> Referenced:            0 kB
> Anonymous:             0 kB
> LazyFree:              0 kB
> AnonHugePages:         0 kB
> ShmemPmdMapped:        0 kB
> Shared_Hugetlb:        0 kB
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Locked:                0 kB
> VmFlags: rd wr sh mr mw me ms ?? mm hg
>
> The quick one-liner at the end of this patch changes that to:
>
> 7fe30e87f000-7fe30e97f000 rw-s 00000000 103:00 12               /root/dax/data
> Size:               1024 kB
> Rss:                   0 kB
> Pss:                   0 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:         0 kB
> Referenced:            0 kB
> Anonymous:             0 kB
> LazyFree:              0 kB
> AnonHugePages:         0 kB
> ShmemPmdMapped:        0 kB
> Shared_Hugetlb:        0 kB
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Locked:                0 kB
> VmFlags: rd wr sh mr mw me ms sf mm hg
>
> I think that of software can rely on this flag for userspace flushing without
> worrying about any new TOCTOU races because there isn't a way to unset the
> VM_SYNC flag once it is set - it should be valid as long as the mmap() remains
> open and the mmap'd address is valid.
>
> --- 8< ---
>  fs/proc/task_mmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index b836fd6..a2a82ed 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -650,6 +650,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>                 [ilog2(VM_ACCOUNT)]     = "ac",
>                 [ilog2(VM_NORESERVE)]   = "nr",
>                 [ilog2(VM_HUGETLB)]     = "ht",
> +               [ilog2(VM_SYNC)]        = "sf",
>                 [ilog2(VM_ARCH_1)]      = "ar",
>                 [ilog2(VM_DONTDUMP)]    = "dd",
>  #ifdef CONFIG_MEM_SOFT_DIRTY

So, I'm not sure I agree with this. I'm explicitly *not* advertising
MAP_DIRECT in ->vm_flags in my patches because we've seen applications
try to use smaps as an API rather than a debug tool. The toctou race
is fundamentally unsolvable unless you trust the agent that setup the
mapping will not tear it down while you've observed the sync flag.
Otherwise, if you do trust that the mapping will not be torn down then
userspace can already just trust itself and not rely on the kernel to
communicate the flag state.

I'm not against adding it, but the reasoning should be for debug and
not an api guarantee that applications will rely on, and unfortunately
I think we've seen that applications will rely on smaps no matter how
we document it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
