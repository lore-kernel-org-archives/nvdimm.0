Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D4198210C0F4E
 for <linux-nvdimm@lists.01.org>; Thu, 26 Jul 2018 08:10:32 -0700 (PDT)
Date: Thu, 26 Jul 2018 23:10:25 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v7 4/4] kexec_file: Load kernel at top of system RAM if
 required
Message-ID: <20180726151025.GN6480@MiWiFi-R3L-srv>
References: <20180718153326.b795e9ea7835432a56cd7011@linux-foundation.org>
 <20180719151753.GB7147@localhost.localdomain>
 <20180723143443.GD18181@dhcp22.suse.cz>
 <20180725064813.GI6480@MiWiFi-R3L-srv>
 <20180726125957.GH28386@dhcp22.suse.cz>
 <20180726130904.GL6480@MiWiFi-R3L-srv>
 <20180726131242.GI28386@dhcp22.suse.cz>
 <20180726131420.GJ28386@dhcp22.suse.cz>
 <20180726133705.GM6480@MiWiFi-R3L-srv>
 <20180726140152.GM28386@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180726140152.GM28386@dhcp22.suse.cz>
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

On 07/26/18 at 04:01pm, Michal Hocko wrote:
> On Thu 26-07-18 21:37:05, Baoquan He wrote:
> > On 07/26/18 at 03:14pm, Michal Hocko wrote:
> > > On Thu 26-07-18 15:12:42, Michal Hocko wrote:
> > > > On Thu 26-07-18 21:09:04, Baoquan He wrote:
> > > > > On 07/26/18 at 02:59pm, Michal Hocko wrote:
> > > > > > On Wed 25-07-18 14:48:13, Baoquan He wrote:
> > > > > > > On 07/23/18 at 04:34pm, Michal Hocko wrote:
> > > > > > > > On Thu 19-07-18 23:17:53, Baoquan He wrote:
> > > > > > > > > Kexec has been a formal feature in our distro, and customers owning
> > > > > > > > > those kind of very large machine can make use of this feature to speed
> > > > > > > > > up the reboot process. On uefi machine, the kexec_file loading will
> > > > > > > > > search place to put kernel under 4G from top to down. As we know, the
> > > > > > > > > 1st 4G space is DMA32 ZONE, dma, pci mmcfg, bios etc all try to consume
> > > > > > > > > it. It may have possibility to not be able to find a usable space for
> > > > > > > > > kernel/initrd. From the top down of the whole memory space, we don't
> > > > > > > > > have this worry. 
> > > > > > > > 
> > > > > > > > I do not have the full context here but let me note that you should be
> > > > > > > > careful when doing top-down reservation because you can easily get into
> > > > > > > > hotplugable memory and break the hotremove usecase. We even warn when
> > > > > > > > this is done. See memblock_find_in_range_node
> > > > > > > 
> > > > > > > Kexec read kernel/initrd file into buffer, just search usable positions
> > > > > > > for them to do the later copying. You can see below struct kexec_segment, 
> > > > > > > for the old kexec_load, kernel/initrd are read into user space buffer,
> > > > > > > the @buf stores the user space buffer address, @mem stores the position
> > > > > > > where kernel/initrd will be put. In kernel, it calls
> > > > > > > kimage_load_normal_segment() to copy user space buffer to intermediate
> > > > > > > pages which are allocated with flag GFP_KERNEL. These intermediate pages
> > > > > > > are recorded as entries, later when user execute "kexec -e" to trigger
> > > > > > > kexec jumping, it will do the final copying from the intermediate pages
> > > > > > > to the real destination pages which @mem pointed. Because we can't touch
> > > > > > > the existed data in 1st kernel when do kexec kernel loading. With my
> > > > > > > understanding, GFP_KERNEL will make those intermediate pages be
> > > > > > > allocated inside immovable area, it won't impact hotplugging. But the
> > > > > > > @mem we searched in the whole system RAM might be lost along with
> > > > > > > hotplug. Hence we need do kexec kernel again when hotplug event is
> > > > > > > detected.
> > > > > > 
> > > > > > I am not sure I am following. If @mem is placed at movable node then the
> > > > > > memory hotremove simply won't work, because we are seeing reserved pages
> > > > > > and do not know what to do about them. They are not migrateable.
> > > > > > Allocating intermediate pages from other nodes doesn't really help.
> > > > > 
> > > > > OK, I forgot the 2nd kernel which kexec jump into. It won't impact hotremove
> > > > > in 1st kernel, it does impact the kernel which kexec jump into if kernel
> > > > > is at top of system RAM and the top RAM is in movable node.
> > > > 
> > > > It will affect the 1st kernel (which does the memblock allocation
> > > > top-down) as well. For reasons mentioned above.
> > > 
> > > And btw. in the ideal world, we would restrict the memblock allocation
> > > top-down from the non-movable nodes. But I do not think we have that
> > > information ready at the time when the reservation is done.
> > 
> > Oh, you could mix kexec loading up with kdump kernel loading. For kdump
> > kernel, we need reserve memory region during bootup with memblock
> > allocator. For kexec loading, we just operate after system up, and do
> > not need to reserve any memmory region. About memory used to load them,
> > it's quite different way.
> 
> I didn't know about that. I thought both use the same underlying
> reservation mechanism. My bad and sorry for the noise.

Not at all. It's truly confusing. I often need take time to recall those
details. 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
