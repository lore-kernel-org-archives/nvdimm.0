From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: fix cache mode of dax pmd mappings
Date: Tue, 6 Sep 2016 13:17:56 -0700
Message-ID: <20160906131756.6b6c6315b7dfba3a9d5f233a@linux-foundation.org>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318058165.30325.16762406881120129093.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <147318058165.30325.16762406881120129093.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Nilesh Choudhury <nilesh.choudhury-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kai Zhang <kai.ka.zhang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, 06 Sep 2016 09:49:41 -0700 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> track_pfn_insert() is marking dax mappings as uncacheable.
> 
> It is used to keep mappings attributes consistent across a remapped range.
> However, since dax regions are never registered via track_pfn_remap(), the
> caching mode lookup for dax pfns always returns _PAGE_CACHE_MODE_UC.  We do not
> use track_pfn_insert() in the dax-pte path, and we always want to use the
> pgprot of the vma itself, so drop this call.
> 
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Nilesh Choudhury <nilesh.choudhury-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Kai Zhang <kai.ka.zhang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changelog fails to explain the user-visible effects of the patch.  The
stable maintainer(s) will look at this and wonder "ytf was I sent
this".

After fixing that, 

Acked-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
