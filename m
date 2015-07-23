Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1437674941.3214.325.camel@hp.com>
Subject: Re: [PATCH] x86/panic/reboot: Flush processor caches during
 panic/reboot
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 23 Jul 2015 12:09:01 -0600
In-Reply-To: <CAPcyv4j76ToWdgjEb+r35Mq_ucPEqnD8izQef82M1NkxbEXHQw@mail.gmail.com>
References: <1437672810-9641-1-git-send-email-toshi.kani@hp.com>
	 <CAPcyv4j76ToWdgjEb+r35Mq_ucPEqnD8izQef82M1NkxbEXHQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-07-23 at 10:40 -0700, Dan Williams wrote:
> On Thu, Jul 23, 2015 at 10:33 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > During power failure, Asynchronous DRAM Refresh (ADR) flushes
> > the write buffer in memory controllers into NVDIMM, but does not
> > flush processor caches.  While the kernel and application code
> > need to take care of processor cache flush, they may not be able
> > to do so during panic or reboot.
> > 
> > Add processor cache flush (wbinvd) to the stop-CPUs interfaces,
> > native_stop_other_cpus() and nmi_shootdown_cpus(), which are
> > called during panic and reboot as follows.  These wbinvd()s are
> > called on each CPU after its irq/APIC is disabled.
> > 
> >   - panic()
> >     + smp_send_stop()
> >        o native_stop_other_cpus()
> >           o stop_this_cpu()
> > 
> >   - native_machine_restart()
> >   - native_machine_halt()
> >   - native_machine_power_off()
> >      + native_machine_shutdown()
> >         + stop_other_cpus()
> >            o native_stop_other_cpus()
> >               o stop_this_cpu()
> > 
> >   - native_machine_crash_shutdown()
> >      + kdump_nmi_shootdown_cpus()
> >         o nmi_shootdown_cpus()
> >            o crash_nmi_callback()
> > 
> > Note, the cpu offline path, mwait_play_dead(), already calls
> > wbinvd().
> > 
> 
> If the application is already prepared for surprise power loss what
> additional benefit is there to flushing caches on panic?  In other
> words, if the application needs this for correctness then it is broken
> with respect to surprise power loss, otherwise these flushes are not
> necessary.

I agree that well-written applications should withstand with their own
journaling mechanisms whey they access NVDIMM directly.  But not all
applications are well-written or perfect on this regard.  msync does not
flush processor caches at this point, either.  So, we want to save all
updates to NVDIMM as much as possible to minimize inconsistency.

Thanks,
-Toshi
