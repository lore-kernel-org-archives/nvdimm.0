From: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
Date: Tue, 6 Nov 2018 11:22:43 -0500
Message-ID: <20181106112243.6fabdb0f@brho.roam.corp.google.com>
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
 <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A@mail.gmail.com>
 <20181030154524.181b8236@gnomeregan.cam.corp.google.com>
 <71d52e0f-ec40-d423-4dd4-e3aeb3730166@redhat.com>
 <20181102163254.04be68b5@gnomeregan.cam.corp.google.com>
 <876d5a71-8dda-4728-5329-4e169777ba4a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <876d5a71-8dda-4728-5329-4e169777ba4a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Zhang, Yu C" <yu.c.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On 2018-11-06 at 11:19 Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > void kvm_set_pfn_dirty(kvm_pfn_t pfn)
> > {
> >         if (!kvm_is_reserved_pfn(pfn)) {
> >                 struct page *page = pfn_to_page(pfn);
> > 
> >                 if (!PageReserved(page))
> >                         SetPageDirty(page);
> >         }
> > }
> > 
> > I think we want to SetPageDirty for DAX, so making PageReserved be true
> > for DAX seems like the way to go, or we'll need more KVM-specific
> > changes.  Apologies is this was discussed in the previous thread on this
> > topic and is redundant.  
> 
> Isn't it the opposite?  We want SetPageDirty, so PageReserved must _not_
> be true.

You're right on that, I had it backwards.  The other DAX work is making
it so that DAX pages are not reserved, so the only extra '!' was in my
head.  

Thanks,

Barret
