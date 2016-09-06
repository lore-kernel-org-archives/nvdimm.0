From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: fix cache mode of dax pmd mappings
Date: Tue, 6 Sep 2016 14:52:03 -0700
Message-ID: <CAPcyv4hjdPWxdY+UTKVstiLZ7r4oOCa+h+Hd+kzS+wJZidzCjA@mail.gmail.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318058165.30325.16762406881120129093.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160906131756.6b6c6315b7dfba3a9d5f233a@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160906131756.6b6c6315b7dfba3a9d5f233a-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Nilesh Choudhury <nilesh.choudhury-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kai Zhang <kai.ka.zhang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Sep 6, 2016 at 1:17 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, 06 Sep 2016 09:49:41 -0700 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>> track_pfn_insert() is marking dax mappings as uncacheable.
>>
>> It is used to keep mappings attributes consistent across a remapped range.
>> However, since dax regions are never registered via track_pfn_remap(), the
>> caching mode lookup for dax pfns always returns _PAGE_CACHE_MODE_UC.  We do not
>> use track_pfn_insert() in the dax-pte path, and we always want to use the
>> pgprot of the vma itself, so drop this call.
>>
>> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>> Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Cc: Nilesh Choudhury <nilesh.choudhury-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Kai Zhang <kai.ka.zhang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Changelog fails to explain the user-visible effects of the patch.  The
> stable maintainer(s) will look at this and wonder "ytf was I sent
> this".

True, I'll change it to this:

track_pfn_insert() is marking dax mappings as uncacheable rendering
them impractical for application usage.  DAX-pte mappings are cached
and the goal of establishing DAX-pmd mappings is to attain more
performance, not dramatically less (3 orders of magnitude).

Deleting the call to track_pfn_insert() in vmf_insert_pfn_pmd() lets
the default pgprot (write-back cache enabled) from the vma be used for
the mapping which yields the expected performance improvement over
DAX-pte mappings.

track_pfn_insert() is meant to keep the cache mode for a given range
synchronized across different users of remap_pfn_range() and
vm_insert_pfn_prot().  DAX uses neither of those mapping methods, and
the pmem driver is already marking its memory ranges as write-back
cache enabled.  So, removing the call to track_pfn_insert() leaves the
kernel no worse off than the current situation where a user could map
the range via /dev/mem with an incompatible cache mode compared to the
driver.

> After fixing that,
>
> Acked-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Thanks Andrew!
