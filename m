Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD515210F75C8
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 10:05:11 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id l22-v6so12458971oib.4
 for <linux-nvdimm@lists.01.org>; Fri, 08 Jun 2018 10:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152847720311.55924.16999195879201817653.stgit@djiang5-desk3.ch.intel.com>
References: <152847720311.55924.16999195879201817653.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 8 Jun 2018 10:05:10 -0700
Message-ID: <CAPcyv4h+OTXvfLiG8cpS7nO5wkUTkZBsyq9iq6FB_FG4wi4naA@mail.gmail.com>
Subject: Re: [PATCH] dax: remove VM_MIXEDMAP for fsdax and device dax
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 8, 2018 at 10:00 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> This patch is reworked from an earlier patch that Dan has posted:
> https://patchwork.kernel.org/patch/10131727/
>
> VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
> the memory page it is dealing with is not typical memory from the linear
> map. The get_user_pages_fast() path, since it does not resolve the vma,
> is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
> use that as a VM_MIXEDMAP replacement in some locations. In the cases
> where there is no pte to consult we fallback to using vma_is_dax() to
> detect the VM_MIXEDMAP special case.
>
> Now that we have explicit driver pfn_t-flag opt-in/opt-out for
> get_user_pages() support for DAX we can stop setting VM_MIXEDMAP.  This
> also means we no longer need to worry about safely manipulating vm_flags
> in a future where we support dynamically changing the dax mode of a
> file.
>
> DAX should also now be supported with madvise_behavior(), vma_merge(),
> and copy_page_range().
>
> This patch has been tested against ndctl unit test. It has also been
> tested against xfstests commit: 625515d using fake pmem created by memmap
> and no additional issues have been observed.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
