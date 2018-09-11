Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta23.messagelabs.com (mail1.bemta23.messagelabs.com
 [67.219.246.213])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 134B621A07A80
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 01:50:02 -0700 (PDT)
From: Ocean HY1 He <hehy1@lenovo.com>
Subject: RE: [External]  Re: [PATCH 0/3] libnvdimm: reset seeds for next
 namespace creation
Date: Tue, 11 Sep 2018 08:49:47 +0000
Message-ID: <HK0PR03MB3170D70900D45B97AAA52E2D89040@HK0PR03MB3170.apcprd03.prod.outlook.com>
References: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
 <CAPcyv4hvtL6eu7=c+7GRqpy6TG2w0-mLZi8smdeTjHX3xxnpZw@mail.gmail.com>
In-Reply-To: <CAPcyv4hvtL6eu7=c+7GRqpy6TG2w0-mLZi8smdeTjHX3xxnpZw@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Ocean He <oceanhehy@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "zwisler@kernel.org" <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams <dan.j.williams@intel.com>
> Sent: Tuesday, September 11, 2018 8:51 AM
> To: Ocean He <oceanhehy@gmail.com>
> Cc: zwisler@kernel.org; Vishal L Verma <vishal.l.verma@intel.com>; Dave Jiang
> <dave.jiang@intel.com>; linux-nvdimm <linux-nvdimm@lists.01.org>; Linux
> Kernel Mailing List <linux-kernel@vger.kernel.org>; Ocean HY1 He
> <hehy1@lenovo.com>
> Subject: [External] Re: [PATCH 0/3] libnvdimm: reset seeds for next
> namespace creation
> 
> On Sun, Sep 9, 2018 at 11:21 PM, Ocean He <oceanhehy@gmail.com> wrote:
> > From: Ocean He <hehy1@lenovo.com>
> >
> > When pmem namespaces created are smaller than section size twice, the
> > second creation would fail and meanwhile there is a kernel call trace
> > which comes from commit 15d36fecd0bdc7510b70 ("mm: disallow mappings
> that
> > conflict for devm_memremap_pages()").
> >         ------------[ cut here ]------------
> >         nd_pmem pfn1.1: Conflicting mapping in same section
> >         WARNING: CPU: 84 PID: 51974 at kernel/memremap.c:194
> devm_memremap_pages+0x4a0/0x4e0
> >         CPU: 84 PID: 51974 Comm: ndctl Kdump: loaded Tainted: G W E 4.19.0-
> rc2-23-default+ #27
> >         RIP: 0010:devm_memremap_pages+0x4a0/0x4e0
> >         Call Trace:
> >          pmem_attach_disk+0x3ab/0x581 [nd_pmem]
> >          nvdimm_bus_probe+0x69/0x150 [libnvdimm]
> >          really_probe+0x262/0x3d0
> >          driver_probe_device+0x60/0x120
> >          bind_store+0x102/0x190
> >          kernfs_fop_write+0x105/0x180
> >          __vfs_write+0x36/0x1a0
> >          ? common_file_perm+0x47/0x130
> >          ? security_file_permission+0x2c/0xb0
> >          vfs_write+0xad/0x1a0
> >          ksys_write+0x52/0xc0
> >          do_syscall_64+0x5b/0x180
> >          entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > Here is an example (section size is 128MB) based on kernel 4.19-rc2.
> >         # ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
> >         {
> >           "dev":"namespace1.0",
> >           "mode":"fsdax",
> >           "map":"dev",
> >           "size":"96.00 MiB (100.66 MB)",
> >           "uuid":"ef9a0556-a610-40b5-8c71-43991765a2cc",
> >           "raw_uuid":"177b22e2-b7e8-482f-a063-2b8de876d979",
> >           "sector_size":512,
> >           "blockdev":"pmem1",
> >           "numa_node":1
> >         }
> >         # ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
> >         libndctl: ndctl_pfn_enable: pfn1.1: failed to enable
> >           Error: namespace1.1: failed to enable
> >         failed to create namespace: No such device or address
> >
> > When above second creation failure occurs, the expectation is to destroy
> > namespace1.0 to create a new namespace which size is aligned with section
> > size. However, both namespace seed and pfn seed have been consumed,
> the
> > new namespace creation still fails.
> >         # ndctl destroy-namespace namespace1.0 -f
> >         destroyed 1 namespace
> >         # ndctl create-namespace -r region1 -s 128m -t pmem -m fsdax
> >         failed to create namespace: Device or resource busy
> >
> > To ensure pfn_seed/dax_seed and namespace_seed are always ready for
> next
> > namespace creation, this patch set enables seed detach and reset. Back to
> > the example, the new namespace creation never fails if this patch set
> > applied.
> >         # ndctl destroy-namespace namespace1.0 -f
> >         destroyed 1 namespace
> >         # ndctl create-namespace -r region1 -s 128m -t pmem -m fsdax
> >         {
> >           "dev":"namespace1.0",
> >           "mode":"fsdax",
> >           "map":"dev",
> >           "size":"124.00 MiB (130.02 MB)",
> >           "uuid":"0d0e7506-d108-4a88-824a-edef26fd0399",
> >           "raw_uuid":"efeb9647-12f5-44cd-8a52-2f3a0d14589a",
> >           "sector_size":512,
> >           "blockdev":"pmem1",
> >           "numa_node":1
> >         }
> >         # ndctl create-namespace -r region1 -s 128m -t pmem -m fsdax
> >         {
> >           "dev":"namespace1.1",
> >           "mode":"fsdax",
> >           "map":"dev",
> >           "size":130023424,
> >           "uuid":"689828dc-8779-434d-8e93-0406d4e1e536",
> >           "raw_uuid":"d86e1025-c224-48b6-b2a7-6ccef152d5fd",
> >           "sector_size":512,
> >           "blockdev":"pmem1.1",
> >           "numa_node":1
> >         }
> >
> > The mode devdax (-m devdax) has the same issue, this patch set could
> > cover it.
> 
> This is good analysis, but I believe this is better fixed / handled in
> ndctl directly. This is just one of a few reasons that namespace
> creation can fail, and it should be ndctl's job to recover from failed
> creation. The kernel only provides the mechanism the policy of what to
> do with errors and interrupted namespace creation is up to userspace.
> 
Well, thanks for your review. I just send out the patch of ndctl for this
issue, please help to review again. Many thanks!
https://lists.01.org/pipermail/linux-nvdimm/2018-September/017778.html

Ocean.
> Also, in the future, the plan is to allow namespaces smaller than a
> section size which will fix this particular failing condition
> properly.
I am interesting that what minimal size is allowed for namespace creation.
I need this to guide the NVDIMM enablement on Lenovo ThinkSystem Servers.

I see function nvdimm_namespace_common_probe return error if size is less
than ND_MIN_NAMESPACE_SIZE(equals to PAGE_SIZE).
	size = nvdimm_namespace_capacity(ndns);
	if (size < ND_MIN_NAMESPACE_SIZE) {
		dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
				&size, ND_MIN_NAMESPACE_SIZE);
		return ERR_PTR(-ENODEV);
	}

I also see function nd_namespace_store return error if size is less than SZ_16M.
	if (__nvdimm_namespace_capacity(ndns) < SZ_16M) {
		dev_dbg(dev, "%s too small to host\n", name);
		len = -ENXIO;
		goto out_attach;
	}

Ocean.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
