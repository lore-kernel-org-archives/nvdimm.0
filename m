From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] device-dax: sub-division support
Date: Mon, 12 Dec 2016 12:15:02 -0500
Message-ID: <x497f75hxwp.fsf@segfault.boston.devel.redhat.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <148143770485.10950.13227732273892953675.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 (Dan Williams's message of "Sat, 10 Dec 2016 22:28:25 -0800")
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
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi, Dan,

Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

>>From [PATCH 6/8] dax: sub-division support:
>
> Device-DAX is a mechanism to establish mappings of performance / feature
> differentiated memory with strict fault behavior guarantees.  With
> sub-division support a platform owner can provision sub-allocations of a
> dax-region into separate devices. The provisioning mechanism follows the
> same scheme as the libnvdimm sub-system in that a 'seed' device is
> created at initialization time that can be resized from zero to become
> enabled.
>
> Unlike the nvdimm sub-system there is no on media labelling scheme
> associated with this partitioning. Provisioning decisions are ephemeral
> / not automatically restored after reboot. While the initial use case of
> device-dax is persistent memory other uses case may be volatile, so the
> device-dax core is unable to assume the underlying memory is pmem.  The
> task of recalling a partitioning scheme or permissions on the device(s)
> is left to userspace.

Can you explain this reasoning in a bit more detail, please?  If you
have specific use cases in mind, that would be helpful.

> For persistent allocations, naming, and permissions automatically
> recalled by the kernel, use filesystem-DAX. For a userspace helper

I'd agree with that guidance if it wasn't for the fact that device dax
was born out of the need to be able to flush dirty data in a safe manner
from userspace.  At best, we're giving mixed guidance to application
developers.

-Jeff

> library and utility for manipulating device-dax instances see libdaxctl
> and the daxctl utility here: https://github.com/pmem/ndctl
>
> ---
>
> Dan Williams (8):
>       dax: add region-available-size attribute
>       dax: add region 'id', 'size', and 'align' attributes
>       dax: register seed device
>       dax: use multi-order radix for resource lookup
>       dax: refactor locking out of size calculation routines
>       dax: sub-division support
>       dax: add / remove dax devices after provisioning
>       dax: add debug for region available_size
>
>
>  drivers/dax/Kconfig |    1 
>  drivers/dax/dax.c   |  747 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 698 insertions(+), 50 deletions(-)
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
