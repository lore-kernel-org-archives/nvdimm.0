Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 825252194D3B3
 for <linux-nvdimm@lists.01.org>; Wed,  2 Jan 2019 16:43:50 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: ndctl ver 63: Basic newbie query: Unable to destroy namespaces
Date: Thu, 3 Jan 2019 00:43:48 +0000
Message-ID: <00fdfd0efbcc97819dd3e50b86a64ce522fabdf2.camel@intel.com>
References: <321255384.2477830.1545776663603.ref@mail.yahoo.com>
 <321255384.2477830.1545776663603@mail.yahoo.com>
In-Reply-To: <321255384.2477830.1545776663603@mail.yahoo.com>
Content-Language: en-US
Content-ID: <21504AA88020B446AC69CEEAB28D9A02@intel.com>
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
To: "kamalkakri2017@yahoo.com" <kamalkakri2017@yahoo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-12-25 at 22:24 +0000, Kamal Kakri wrote:
> h/w: HP ProLiant Gen10 box with 4 nvdimms (16gb each)
> 
> # uname -aLinux fox22hv.lab.netapp.com 4.19.0-1.el7.elrepo.x86_64 #1
> SMP Mon Oct 22 10:40:32 EDT 2018 x86_64 x86_64 x86_64 GNU/Linux
> 
> # ndctl --version
> 63+
> 
> Im not sure if I have label-less namespace or not. My intention was
> to play around with ndctl, destroy default 16gb namespaces and create
> some of my own. This may be due to user error or config error but I
> am not able to get past this. I have dug through every bit of info
> available online and have exhausted my options, hence this email.
> 
> I have not been able to destroy the default 16gb namespace. I get
> this error:

The semantics of destroy-namespace have certainly been cause of
confusion in the past - but my understanding is that HP nvdimms are
indeed label-less, and the namespaces on them can't be destroyed.

You should however be able to reconfigure them to use a different mode
using the create-namespace --reconfigure option.

> # ndctl destroy-namespace namespace0.0destroyed 0 namespaces
> # ndctl destroy-namespace -f namespace0.0 -v
> libndctl: __sysfs_device_parse: base: /sys/class/nd dev: ndctl
> libndctl: __sysfs_device_parse: ndctl0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0 dev: region
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region2: processed
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region0: processed
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region3: processed
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region1: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region1 dev:
> namespace1.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace1.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region3 dev:
> namespace3.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace3.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0 dev:
> namespace0.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace0.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0 dev:
> pfn0.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_read_attr: failed to read
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/pfn0.
> 0/resource: No such device or address
> libndctl: __sysfs_read_attr: failed to read
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/pfn0.
> 0/size: No such device or address
> libndctl: __sysfs_device_parse: pfn0.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0 dev:
> dax0.
> libndctl: to_module: alias: nd:t7 module: dax_pmem
> libndctl: __sysfs_read_attr: failed to read
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/dax0.
> 0/resource: No such device or address
> libndctl: __sysfs_read_attr: failed to read
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/dax0.
> 0/size: No such device or address
> libndctl: __sysfs_device_parse: dax0.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0 dev:
> btt0.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: parse_lbasize_supported: btt0.0: 512 520 528 4096 4104 4160
> 4224
> libndctl: __sysfs_read_attr: failed to read
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/btt0.
> 0/size: No such device or address
> libndctl: __sysfs_device_parse: btt0.0: processed
> libndctl: write_attr: failed to write  to
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0/names
> pace0.0/holder_class: No such device or address
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region2 dev:
> namespace2.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace2.0: processed
> destroyed 0 namespaces
> 
> 
> 
> Then I tried to disable the region and see s little different error
> msg:# ndctl disable-region region0
> disabled 1 region
> 
> # ndctl destroy-namespace namespace0.0 -v
> libndctl: __sysfs_device_parse: base: /sys/class/nd dev: ndctl
> libndctl: __sysfs_device_parse: ndctl0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0 dev: region
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region2: processed
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region0: processed
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region3: processed
> libndctl: to_module: failed to find module for alias: nd:t2 0 list:
> empty
> libndctl: __sysfs_device_parse: region1: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region1 dev:
> namespace1.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace1.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region3 dev:
> namespace3.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace3.0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region0 dev:
> namespace0.
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/region2 dev:
> namespace2.
> libndctl: to_module: alias: nd:t4 module: nd_pmem
> libndctl: __sysfs_device_parse: namespace2.0: processed
> error destroying namespaces: No such device or address
> destroyed 0 namespaces
> 
> Trying to read the labels is also not working:# ndctl read-labels
> nmem1 -v
> libndctl: __sysfs_device_parse: base: /sys/class/nd dev: ndctl
> libndctl: __sysfs_device_parse: ndctl0: processed
> libndctl: __sysfs_device_parse: base:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0 dev: nmem
> libndctl: to_module: failed to find module for alias: nd:t1 0 list:
> empty
> libndctl: parse_dimm_flags: nmem2:
> libndctl: __sysfs_read_attr: failed to open
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/nmem2/nfit/di
> rty_shutdown: No such file or directory
> libndctl: parse_nfit_mem_flags: nmem2: smart_notify
> libndctl: __sysfs_device_parse: nmem2: processed
> libndctl: to_module: failed to find module for alias: nd:t1 0 list:
> empty
> libndctl: parse_dimm_flags: nmem0:
> libndctl: __sysfs_read_attr: failed to open
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/nmem0/nfit/di
> rty_shutdown: No such file or directory
> libndctl: parse_nfit_mem_flags: nmem0: smart_notify
> libndctl: __sysfs_device_parse: nmem0: processed
> libndctl: to_module: failed to find module for alias: nd:t1 0 list:
> empty
> libndctl: parse_dimm_flags: nmem3:
> libndctl: __sysfs_read_attr: failed to open
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/nmem3/nfit/di
> rty_shutdown: No such file or directory
> libndctl: parse_nfit_mem_flags: nmem3: smart_notify
> libndctl: __sysfs_device_parse: nmem3: processed
> libndctl: to_module: failed to find module for alias: nd:t1 0 list:
> empty
> libndctl: parse_dimm_flags: nmem1:
> libndctl: __sysfs_read_attr: failed to open
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/nmem1/nfit/di
> rty_shutdown: No such file or directory
> libndctl: parse_nfit_mem_flags: nmem1: smart_notify
> libndctl: __sysfs_device_parse: nmem1: processed
> libndctl: ndctl_dimm_cmd_new_cfg_size: unsupported cmd
> read 0 nmem
> 
> 
> Here are my kernel options:CONFIG_LIBNVDIMM=y
> CONFIG_BLK_DEV_PMEM=m
> CONFIG_ND_BLK=m
> CONFIG_ND_CLAIM=y
> CONFIG_ND_BTT=m
> CONFIG_BTT=y
> CONFIG_ND_PFN=m
> CONFIG_NVDIMM_PFN=y
> CONFIG_NVDIMM_DAX=y
> CONFIG_DAX_DRIVER=y
> CONFIG_DAX=y
> CONFIG_DEV_DAX=m
> CONFIG_DEV_DAX_PMEM=m
> CONFIG_NVMEM=y
> 
> 
> Would appreciate if someone can help.
> Thanks,KK
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
