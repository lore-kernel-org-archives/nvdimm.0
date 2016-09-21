From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: fix kdump,
 cleanup aborted E820_PRAM max_pfn manipulation
Date: Wed, 21 Sep 2016 16:22:31 -0400
Message-ID: <x49fuotngu0.fsf@segfault.boston.devel.redhat.com>
References: <147448744538.34910.11287693517367139607.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <147448744538.34910.11287693517367139607.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 (Dan Williams's message of "Wed, 21 Sep 2016 12:50:45 -0700")
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
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> In commit ec776ef6bbe1 "x86/mm: Add support for the non-standard
> protected e820 type" Christoph references the original patch I wrote
> implementing pmem support.  The intent of the 'max_pfn' changes in that
> commit were to enable persistent memory ranges to be covered by the
> struct page memmap by default.  However, that approach was abandoned
> when Christoph ported the patches [1], and that functionality has since
> been replaced by devm_memremap_pages().
>
> In the meantime, this max_pfn manipulation is confusing kdump [2] that
> assumes that everything covered by the max_pfn is "System RAM".  This
> results in kdump hanging or crashing.

That was my assumption, I'm not certain that the kdump code is assuming
the pmem region is usable as RAM.  The end result is a hung kdump
kernel.

> [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-March/000348.html
> [2]: https://bugzilla.redhat.com/show_bug.cgi?id=1351098
>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Zhang Yi <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Zhang Yi <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I actually did the testing.  You can leave that line as is, though, as
I'm sure Yi will also test it.  :)

> Fixes: ec776ef6bbe1 ("x86/mm: Add support for the non-standard protected e820 type")
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks, Dan!

-Jeff
