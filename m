Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0630A2097F55F
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 15:33:28 -0700 (PDT)
Date: Wed, 18 Jul 2018 15:33:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 4/4] kexec_file: Load kernel at top of system RAM if
 required
Message-Id: <20180718153326.b795e9ea7835432a56cd7011@linux-foundation.org>
In-Reply-To: <20180718024944.577-5-bhe@redhat.com>
References: <20180718024944.577-1-bhe@redhat.com>
 <20180718024944.577-5-bhe@redhat.com>
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

On Wed, 18 Jul 2018 10:49:44 +0800 Baoquan He <bhe@redhat.com> wrote:

> For kexec_file loading, if kexec_buf.top_down is 'true', the memory which
> is used to load kernel/initrd/purgatory is supposed to be allocated from
> top to down. This is what we have been doing all along in the old kexec
> loading interface and the kexec loading is still default setting in some
> distributions. However, the current kexec_file loading interface doesn't
> do like this. The function arch_kexec_walk_mem() it calls ignores checking
> kexec_buf.top_down, but calls walk_system_ram_res() directly to go through
> all resources of System RAM from bottom to up, to try to find memory region
> which can contain the specific kexec buffer, then call locate_mem_hole_callback()
> to allocate memory in that found memory region from top to down. This brings
> confusion especially when KASLR is widely supported , users have to make clear
> why kexec/kdump kernel loading position is different between these two
> interfaces in order to exclude unnecessary noises. Hence these two interfaces
> need be unified on behaviour.

As far as I can tell, the above is the whole reason for the patchset,
yes?  To avoid confusing users.

Is that sufficient?  Can we instead simplify their lives by providing
better documentation or informative printks or better Kconfig text,
etc?

And who *are* the people who are performing this configuration?  Random
system administrators?  Linux distro engineers?  If the latter then
they presumably aren't easily confused!

In other words, I'm trying to understand how much benefit this patchset
will provide to our users as a whole.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
