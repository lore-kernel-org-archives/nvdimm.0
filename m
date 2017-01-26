From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v2 2/3] mm, x86: Add support for PUD-sized transparent
 hugepages
Date: Thu, 26 Jan 2017 15:46:27 -0700
Message-ID: <94209678-bb55-2085-9cc8-f47bdf754ea4@intel.com>
References: <148545012634.17912.13951763606410303827.stgit@djiang5-desk3.ch.intel.com>
 <148545059381.17912.8602162635537598445.stgit@djiang5-desk3.ch.intel.com>
 <20170126143854.9694811975f4c0945aba58b9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170126143854.9694811975f4c0945aba58b9@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave.hansen@linux.intel.com, mawilcox@microsoft.com, linux-nvdimm@ml01.01.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, jack@suse.com, dan.j.williams@intel.com, linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com, kirill.shutemov@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

On 01/26/2017 03:38 PM, Andrew Morton wrote:
> On Thu, 26 Jan 2017 10:09:53 -0700 Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> The current transparent hugepage code only supports PMDs.  This patch
>> adds support for transparent use of PUDs with DAX.  It does not include
>> support for anonymous pages. x86 support code also added.
>>
>> Most of this patch simply parallels the work that was done for huge PMDs.
>> The only major difference is how the new ->pud_entry method in mm_walk
>> works.  The ->pmd_entry method replaces the ->pte_entry method, whereas
>> the ->pud_entry method works along with either ->pmd_entry or ->pte_entry.
>> The pagewalk code takes care of locking the PUD before calling ->pud_walk,
>> so handlers do not need to worry whether the PUD is stable.
> 
> The patch adds a lot of new BUG()s and BG_ON()s.  We'll get in trouble
> if any of those triggers.  Please recheck everything and decide if we
> really really need them.  It's far better to drop a WARN and to back
> out and recover in some fashion.
> 

So I believe all the BUG() and BUG_ON() are replicated the same way that
the existing PMD support functions do with the same behavior. If we want
them to be different then we probably need to examine if the PMD code
(or maybe the PTE ones as well) need to be different also. I'm open to
suggestions from the experts on the cc list though.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
