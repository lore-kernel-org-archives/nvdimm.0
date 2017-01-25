From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v7] x86: fix kaslr and memmap collision
Date: Wed, 25 Jan 2017 11:47:47 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1701251147350.3728@nanos>
References: <148417664156.131935.2248592164852799738.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <148417664156.131935.2248592164852799738.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, 11 Jan 2017, Dave Jiang wrote:

> CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
> However it does not take into account the memmap= parameter passed in from
> the kernel cmdline. This results in the kernel sometimes being put in
> the middle of memmap. Teaching kaslr to not insert the kernel in
> memmap defined regions. We will support up to 4 memmap regions. Any
> additional regions will cause kaslr to disable. The mem_avoid set has
> been augmented to add up to 4 unusable regions of memmaps provided by the
> user to exclude those regions from the set of valid address range to insert
> the uncompressed kernel image. The nn@ss ranges will be skipped by the
> mem_avoid set since it indicates memory useable.
> 
> Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Acked-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
