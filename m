Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01FF12121AA36
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 10:13:27 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id o39so3732413ota.6
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 10:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Apr 2019 10:13:15 -0700
Message-ID: <CAPcyv4hzRj5yxVJ5-7AZgzzBxEL02xf2xwhDv-U9_osWFm9kiA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Chandan Rajendra <chandan@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 2, 2019 at 4:51 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> With some architectures like ppc64, set_pmd_at() cannot cope with
> a situation where there is already some (different) valid entry present.
>
> Use pmdp_set_access_flags() instead to modify the pfn which is built to
> deal with modifying existing PMD entries.
>
> This is similar to
> commit cae85cb8add3 ("mm/memory.c: fix modifying of page protection by insert_pfn()")
>
> We also do similar update w.r.t insert_pfn_pud eventhough ppc64 don't support
> pud pfn entries now.
>
> Without this patch we also see the below message in kernel log
> "BUG: non-zero pgtables_bytes on freeing mm:"
>
> CC: stable@vger.kernel.org
> Reported-by: Chandan Rajendra <chandan@linux.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
> Changes from v1:
> * Fix the pgtable leak
>
>  mm/huge_memory.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)

This patch is triggering the following bug in v4.19.35.

 kernel BUG at arch/x86/mm/pgtable.c:515!
 invalid opcode: 0000 [#1] SMP NOPTI
 CPU: 51 PID: 43713 Comm: java Tainted: G           OE     4.19.35 #1
 RIP: 0010:pmdp_set_access_flags+0x48/0x50
 [..]
 Call Trace:
  vmf_insert_pfn_pmd+0x198/0x350
  dax_iomap_fault+0xe82/0x1190
  ext4_dax_huge_fault+0x103/0x1f0
  ? __switch_to_asm+0x40/0x70
  __handle_mm_fault+0x3f6/0x1370
  ? __switch_to_asm+0x34/0x70
  ? __switch_to_asm+0x40/0x70
  handle_mm_fault+0xda/0x200
  __do_page_fault+0x249/0x4f0
  do_page_fault+0x32/0x110
  ? page_fault+0x8/0x30
  page_fault+0x1e/0x30

I asked the reporter to try a kernel with commit c6f3c5ee40c1
"mm/huge_memory.c: fix modifying of page protection by
insert_pfn_pmd()" reverted and the failing test passed.

I think unaligned addresses have always been passed to
vmf_insert_pfn_pmd(), but nothing cared until this patch. I *think*
the only change needed is the following, thoughts?

diff --git a/fs/dax.c b/fs/dax.c
index ca0671d55aa6..82aee9a87efa 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1560,7 +1560,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct
vm_fault *vmf, pfn_t *pfnp,
                }

                trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
-               result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
+               result = vmf_insert_pfn_pmd(vma, pmd_addr, vmf->pmd, pfn,
                                            write);
                break;
        case IOMAP_UNWRITTEN:


I'll ask the reporter to try this fix as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
