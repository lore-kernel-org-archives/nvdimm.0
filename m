Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 16 Nov 2016 01:57:11 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 17/21] mm: Change return values of finish_mkwrite_fault()
Message-ID: <20161115225711.GQ23021@node>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-18-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478233517-3571-18-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 04, 2016 at 05:25:13AM +0100, Jan Kara wrote:
> Currently finish_mkwrite_fault() returns 0 when PTE got changed before
> we acquired PTE lock and VM_FAULT_WRITE when we succeeded in modifying
> the PTE. This is somewhat confusing since 0 generally means success, it
> is also inconsistent with finish_fault() which returns 0 on success.
> Change finish_mkwrite_fault() to return 0 on success and VM_FAULT_NOPAGE
> when PTE changed. Practically, there should be no behavioral difference
> since we bail out from the fault the same way regardless whether we
> return 0, VM_FAULT_NOPAGE, or VM_FAULT_WRITE. Also note that
> VM_FAULT_WRITE has no effect for shared mappings since the only two
> places that check it - KSM and GUP - care about private mappings only.
> Generally the meaning of VM_FAULT_WRITE for shared mappings is not well
> defined and we should probably clean that up.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Sounds right.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>


-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
