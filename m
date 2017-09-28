Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8365321EC8CFE
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 17:06:23 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id r20so19192236oie.0
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 17:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150655619012.700.15161500295945223238.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150655617774.700.5326522538400299973.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150655619012.700.15161500295945223238.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Sep 2017 17:09:36 -0700
Message-ID: <CAPcyv4gy=_QA9Ko-wz=GwvmXa2Q8t_5QZv6WM3siCoROM92hXQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] dax: stop using VM_MIXEDMAP for dax
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 27, 2017 at 4:49 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Now that we always have pages for DAX we can stop setting VM_MIXEDMAP.
> This does require some small fixups for the pte insert routines that dax
> utilizes.
>

This changelog can be improved with this from the cover letter:

VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
the memory page it is dealing with is not typical memory from the linear
map. The get_user_pages_fast() path, since it does not resolve the vma,
is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
use that as a VM_MIXEDMAP replacement in some locations. In the cases
where there is no pte to consult we fallback to using vma_is_dax() to
detect the VM_MIXEDMAP special case.

...I'll fold this in for v2.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
