Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x231.google.com (mail-ot0-x231.google.com
 [IPv6:2607:f8b0:4003:c0f::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A6C38170F
 for <linux-nvdimm@lists.01.org>; Mon,  6 Feb 2017 08:24:50 -0800 (PST)
Received: by mail-ot0-x231.google.com with SMTP id 65so65701282otq.2
 for <linux-nvdimm@lists.01.org>; Mon, 06 Feb 2017 08:24:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170206143648.GA461@infradead.org>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 6 Feb 2017 08:24:48 -0800
Message-ID: <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 6, 2017 at 6:36 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Feb 03, 2017 at 02:31:22PM -0700, Dave Jiang wrote:
>> Since the introduction of FAULT_FLAG_SIZE to the vm_fault flag, it has
>> been somewhat painful with getting the flags set and removed at the
>> correct locations. More than one kernel oops was introduced due to
>> difficulties of getting the placement correctly. Removing the flag
>> values and introducing an input parameter to huge_fault that indicates
>> the size of the page entry. This makes the code easier to trace and
>> should avoid the issues we see with the fault flags where removal of the
>> flag was necessary in the fallback paths.
>
> Why is this not in struct vm_fault?

Because this is easier to read and harder to get wrong. Same arguments
as getting rid of struct blk_dax_ctl.

> Also can be use this opportunity
> to fold ->huge_fault into ->fault?

Hmm, yes, just need a scheme to not attempt huge_faults on pte-only handlers.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
