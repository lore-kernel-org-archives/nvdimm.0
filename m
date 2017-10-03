Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAD4921EC8CEF
 for <linux-nvdimm@lists.01.org>; Tue,  3 Oct 2017 10:26:04 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id n82so15516987oib.8
 for <linux-nvdimm@lists.01.org>; Tue, 03 Oct 2017 10:29:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171003080901.GD11879@quack2.suse.cz>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150664807800.36094.3685385297224300424.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171003080901.GD11879@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Oct 2017 10:29:24 -0700
Message-ID: <CAPcyv4hOwKRMJ15GnPt7Qdtx2NiJQd-e8ooFc6SSQ=hoA58oUw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] dax: stop using VM_MIXEDMAP for dax
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
Cc: Michal Hocko <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 3, 2017 at 1:09 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 28-09-17 18:21:18, Dan Williams wrote:
>> VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
>> the memory page it is dealing with is not typical memory from the linear
>> map. The get_user_pages_fast() path, since it does not resolve the vma,
>> is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
>> use that as a VM_MIXEDMAP replacement in some locations. In the cases
>> where there is no pte to consult we fallback to using vma_is_dax() to
>> detect the VM_MIXEDMAP special case.
>
> Well, I somewhat dislike the vma_is_dax() checks sprinkled around. That
> seems rather errorprone (easy to forget about it when adding new check
> somewhere). Can we possibly also create a helper vma_is_special() (or some
> other name) which would do ((vma->vm_flags & VM_SPECIAL) || vma_is_dax(vma)
> || is_vm_hugetlb_page(vma)) and then use it in all those places?

Yes, I can take a look at that... I shied away from it initially since
it does not appear that "vma_is_special()" paths are symmetric in
terms of all the conditions they check, but perhaps I can start small
with the ones that are common. I'll break that conversion out into a
lead-in cleanup patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
