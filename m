From: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] kvm: Use huge pages for DAX-backed files
Date: Tue, 13 Nov 2018 11:21:48 -0500
Message-ID: <20181113112148.6205fc56@gnomeregan.cam.corp.google.com>
References: <20181109203921.178363-1-brho@google.com>
 <20181109203921.178363-3-brho@google.com>
 <861c4adb-e2f0-2caf-8f6e-9f09ecb0b624@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <861c4adb-e2f0-2caf-8f6e-9f09ecb0b624-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yu.c.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 2018-11-12 at 20:31 Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Looks good.  What's the plan for removing PageReserved from DAX pages?

I hear that's going on in this thread:

https://lore.kernel.org/lkml/154145268025.30046.11742652345962594283.stgit-+uVpp3jiz/RcxmDmkzA3yGt3HXsI98Cx0E9HWUfgJXw@public.gmane.org/

Though it looks like it's speeding up page initialization, and not
explicitly making the PageReserved change, yet.

Alternatively, I could change kvm_is_reserved_pfn() to single out
zone_device pages if we don't want to wait or if there is a concern
that it won't happen.

On a related note, there are two places in KVM where we check
PageReserved outside of kvm_is_reserved_pfn().

For reference:

bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
{
        if (pfn_valid(pfn))
                return PageReserved(pfn_to_page(pfn));

        return true;
}

One caller of PageReserved():

void kvm_set_pfn_dirty(kvm_pfn_t pfn)
{
        if (!kvm_is_reserved_pfn(pfn)) {
                struct page *page = pfn_to_page(pfn);

                if (!PageReserved(page))
                        SetPageDirty(page);
        }
}

In that one, the PageReserved() check looks redundant, since if the
page was PageReserved, then it would have been kvm_is_reserved.

The other is:

static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
{
        if (pfn_valid(pfn))
                return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
                        /*
                         * Some reserved pages, such as those from NVDIMM
                         * DAX devices, are not for MMIO, and can be mapped
                         * with cached memory type for better performance.
                         * However, the above check misconceives those pages
                         * as MMIO, and results in KVM mapping them with UC
                         * memory type, which would hurt the performance.
                         * Therefore, we check the host memory type in addition
                         * and only treat UC/UC-/WC pages as MMIO.
                         */
                        (!pat_enabled() || pat_pfn_immune_to_uc_mtrr(pfn));

        return true;
}

Where the PAT stuff was motivated by DAX.  The PageReserved check here
looks like a broken-out version of kvm_is_reserved_pfn(), so that we can
make some extra checks around it.

Anyway, I can get rid of those two PageReserved checks and/or have
kvm_is_reserved_pfn() just check DAX pages, if everyone is OK with that.

Thanks,

Barret
