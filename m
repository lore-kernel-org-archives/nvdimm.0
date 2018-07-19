Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 831A821B02845
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 12:44:48 -0700 (PDT)
Date: Thu, 19 Jul 2018 12:44:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 4/4] kexec_file: Load kernel at top of system RAM if
 required
Message-Id: <20180719124444.c893712cca2e6f2649d1bc0d@linux-foundation.org>
In-Reply-To: <20180719151753.GB7147@localhost.localdomain>
References: <20180718024944.577-1-bhe@redhat.com>
 <20180718024944.577-5-bhe@redhat.com>
 <20180718153326.b795e9ea7835432a56cd7011@linux-foundation.org>
 <20180719151753.GB7147@localhost.localdomain>
Mime-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Baoquan He <bhe@redhat.com>
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, tglx@linutronix.de, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, andy.shevchenko@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, devel@linuxdriverproject.org, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 19 Jul 2018 23:17:53 +0800 Baoquan He <bhe@redhat.com> wrote:

> Hi Andrew,
> 
> On 07/18/18 at 03:33pm, Andrew Morton wrote:
> > On Wed, 18 Jul 2018 10:49:44 +0800 Baoquan He <bhe@redhat.com> wrote:
> > 
> > > For kexec_file loading, if kexec_buf.top_down is 'true', the memory which
> > > is used to load kernel/initrd/purgatory is supposed to be allocated from
> > > top to down. This is what we have been doing all along in the old kexec
> > > loading interface and the kexec loading is still default setting in some
> > > distributions. However, the current kexec_file loading interface doesn't
> > > do like this. The function arch_kexec_walk_mem() it calls ignores checking
> > > kexec_buf.top_down, but calls walk_system_ram_res() directly to go through
> > > all resources of System RAM from bottom to up, to try to find memory region
> > > which can contain the specific kexec buffer, then call locate_mem_hole_callback()
> > > to allocate memory in that found memory region from top to down. This brings
> > > confusion especially when KASLR is widely supported , users have to make clear
> > > why kexec/kdump kernel loading position is different between these two
> > > interfaces in order to exclude unnecessary noises. Hence these two interfaces
> > > need be unified on behaviour.
> > 
> > As far as I can tell, the above is the whole reason for the patchset,
> > yes?  To avoid confusing users.
> 
> 
> In fact, it's not just trying to avoid confusing users. Kexec loading
> and kexec_file loading are just do the same thing in essence. Just we
> need do kernel image verification on uefi system, have to port kexec
> loading code to kernel. 
> 
> Kexec has been a formal feature in our distro, and customers owning
> those kind of very large machine can make use of this feature to speed
> up the reboot process. On uefi machine, the kexec_file loading will
> search place to put kernel under 4G from top to down. As we know, the
> 1st 4G space is DMA32 ZONE, dma, pci mmcfg, bios etc all try to consume
> it. It may have possibility to not be able to find a usable space for
> kernel/initrd. From the top down of the whole memory space, we don't
> have this worry. 
> 
> And at the first post, I just posted below with AKASHI's
> walk_system_ram_res_rev() version. Later you suggested to use
> list_head to link child sibling of resource, see what the code change
> looks like.
> http://lkml.kernel.org/r/20180322033722.9279-1-bhe@redhat.com
> 
> Then I posted v2
> http://lkml.kernel.org/r/20180408024724.16812-1-bhe@redhat.com
> Rob Herring mentioned that other components which has this tree struct
> have planned to do the same thing, replacing the singly linked list with
> list_head to link resource child sibling. Just quote Rob's words as
> below. I think this could be another reason.
> 
> ~~~~~ From Rob
> The DT struct device_node also has the same tree structure with
> parent, child, sibling pointers and converting to list_head had been
> on the todo list for a while. ACPI also has some tree walking
> functions (drivers/acpi/acpica/pstree.c). Perhaps there should be a
> common tree struct and helpers defined either on top of list_head or a
> ~~~~~
> new struct if that saves some size.

Please let's get all this into the changelogs?

> > 
> > Is that sufficient?  Can we instead simplify their lives by providing
> > better documentation or informative printks or better Kconfig text,
> > etc?
> > 
> > And who *are* the people who are performing this configuration?  Random
> > system administrators?  Linux distro engineers?  If the latter then
> > they presumably aren't easily confused!
> 
> Kexec was invented for kernel developer to speed up their kernel
> rebooting. Now high end sever admin, kernel developer and QE are also
> keen to use it to reboot large box for faster feature testing, bug
> debugging. Kernel dev could know this well, about kernel loading
> position, admin or QE might not be aware of it very well. 
> 
> > 
> > In other words, I'm trying to understand how much benefit this patchset
> > will provide to our users as a whole.
> 
> Understood. The list_head replacing patch truly involes too many code
> changes, it's risky. I am willing to try any idea from reviewers, won't
> persuit they have to be accepted finally. If don't have a try, we don't
> know what it looks like, and what impact it may have. I am fine to take
> AKASHI's simple version of walk_system_ram_res_rev() to lower risk, even
> though it could be a little bit low efficient.

The larger patch produces a better result.  We can handle it ;)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
