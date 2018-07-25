Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BF86209831CF
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 23:48:22 -0700 (PDT)
Date: Wed, 25 Jul 2018 14:48:13 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v7 4/4] kexec_file: Load kernel at top of system RAM if
 required
Message-ID: <20180725064813.GI6480@MiWiFi-R3L-srv>
References: <20180718024944.577-1-bhe@redhat.com>
 <20180718024944.577-5-bhe@redhat.com>
 <20180718153326.b795e9ea7835432a56cd7011@linux-foundation.org>
 <20180719151753.GB7147@localhost.localdomain>
 <20180723143443.GD18181@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180723143443.GD18181@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, andy.shevchenko@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

On 07/23/18 at 04:34pm, Michal Hocko wrote:
> On Thu 19-07-18 23:17:53, Baoquan He wrote:
> > Kexec has been a formal feature in our distro, and customers owning
> > those kind of very large machine can make use of this feature to speed
> > up the reboot process. On uefi machine, the kexec_file loading will
> > search place to put kernel under 4G from top to down. As we know, the
> > 1st 4G space is DMA32 ZONE, dma, pci mmcfg, bios etc all try to consume
> > it. It may have possibility to not be able to find a usable space for
> > kernel/initrd. From the top down of the whole memory space, we don't
> > have this worry. 
> 
> I do not have the full context here but let me note that you should be
> careful when doing top-down reservation because you can easily get into
> hotplugable memory and break the hotremove usecase. We even warn when
> this is done. See memblock_find_in_range_node

Kexec read kernel/initrd file into buffer, just search usable positions
for them to do the later copying. You can see below struct kexec_segment, 
for the old kexec_load, kernel/initrd are read into user space buffer,
the @buf stores the user space buffer address, @mem stores the position
where kernel/initrd will be put. In kernel, it calls
kimage_load_normal_segment() to copy user space buffer to intermediate
pages which are allocated with flag GFP_KERNEL. These intermediate pages
are recorded as entries, later when user execute "kexec -e" to trigger
kexec jumping, it will do the final copying from the intermediate pages
to the real destination pages which @mem pointed. Because we can't touch
the existed data in 1st kernel when do kexec kernel loading. With my
understanding, GFP_KERNEL will make those intermediate pages be
allocated inside immovable area, it won't impact hotplugging. But the
@mem we searched in the whole system RAM might be lost along with
hotplug. Hence we need do kexec kernel again when hotplug event is
detected.

#define KEXEC_CONTROL_MEMORY_GFP (GFP_KERNEL | __GFP_NORETRY)


struct kexec_segment {
        /*
         * This pointer can point to user memory if kexec_load() system
         * call is used or will point to kernel memory if
         * kexec_file_load() system call is used.
         *
         * Use ->buf when expecting to deal with user memory and use ->kbuf
         * when expecting to deal with kernel memory.
         */
        union {
                void __user *buf;
                void *kbuf;
        };
        size_t bufsz;                                                                                                                             
        unsigned long mem;
        size_t memsz;
};

Thanks
Baoquan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
