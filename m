Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
Message-ID: <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
Date: Sat, 9 Feb 2019 12:00:05 +0100
MIME-Version: 1.0
In-Reply-To: <20190124231448.E102D18E@viggo.jf.intel.com>
Content-Type: multipart/alternative;
 boundary="------------B1FBBAC4595CC6A4AB516193"
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, ying.huang@intel.com, linux-mm@kvack.org, jglisse@redhat.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

This is a multi-part message in MIME format.
--------------B1FBBAC4595CC6A4AB516193
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Le 25/01/2019 à 00:14, Dave Hansen a écrit :
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> This is intended for use with NVDIMMs that are physically persistent
> (physically like flash) so that they can be used as a cost-effective
> RAM replacement.  Intel Optane DC persistent memory is one
> implementation of this kind of NVDIMM.
>
> Currently, a persistent memory region is "owned" by a device driver,
> either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
> allow applications to explicitly use persistent memory, generally
> by being modified to use special, new libraries. (DIMM-based
> persistent memory hardware/software is described in great detail
> here: Documentation/nvdimm/nvdimm.txt).
>
> However, this limits persistent memory use to applications which
> *have* been modified.  To make it more broadly usable, this driver
> "hotplugs" memory into the kernel, to be managed and used just like
> normal RAM would be.
>
> To make this work, management software must remove the device from
> being controlled by the "Device DAX" infrastructure:
>
> 	echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/remove_id
> 	echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/unbind


Hello Dave

I am trying to use these patches (on top on Dan's nvdimm-pending branch
with Keith's HMAT patches). Writing to remove_id just hangs. echo never
returns, it uses 100% CPU and I can't kill it.

[ 5468.744898] bash            R  running task        0 21419  21416 0x00000080
[ 5468.744899] Call Trace:
[ 5468.744902]  ? vsnprintf+0x372/0x4e0
[ 5468.744904]  ? klist_next+0x79/0xe0
[ 5468.744905]  ? sprintf+0x56/0x80
[ 5468.744907]  ? bus_for_each_dev+0x8a/0xc0
[ 5468.744911]  ? do_id_store+0xe8/0x1e0
[ 5468.744914]  ? _cond_resched+0x15/0x30
[ 5468.744915]  ? __kmalloc+0x17f/0x200
[ 5468.744918]  ? kernfs_fop_write+0x83/0x190
[ 5468.744918]  ? __vfs_write+0x36/0x1b0
[ 5468.744919]  ? selinux_file_permission+0xe1/0x130
[ 5468.744921]  ? security_file_permission+0x36/0x100
[ 5468.744922]  ? vfs_write+0xad/0x1b0
[ 5468.744922]  ? ksys_write+0x52/0xc0
[ 5468.744924]  ? do_syscall_64+0x5b/0x180
[ 5468.744927]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

CONFIG_NVDIMM_DAX=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y

  {
    "dev":"namespace0.0",
    "mode":"devdax",
    "map":"dev",
    "size":1598128390144,
    "uuid":"7046a749-477f-4690-9b3c-a640a1aa44f1",
    "chardev":"dax0.0"
  }


I've used your patches on fake hardware (memmap=xx!yy) with an older
nvdimm-pending branch (without Keith's patches). It worked fine. This
time I am running on real Intel hardware. Any idea where to look ?

Thanks

Brice



--------------B1FBBAC4595CC6A4AB516193
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">Le 25/01/2019 à 00:14, Dave Hansen a
      écrit :<br>
    </div>
    <blockquote type="cite"
      cite="mid:20190124231448.E102D18E@viggo.jf.intel.com">
      <pre class="moz-quote-pre" wrap="">
From: Dave Hansen <a class="moz-txt-link-rfc2396E" href="mailto:dave.hansen@linux.intel.com">&lt;dave.hansen@linux.intel.com&gt;</a>

This is intended for use with NVDIMMs that are physically persistent
(physically like flash) so that they can be used as a cost-effective
RAM replacement.  Intel Optane DC persistent memory is one
implementation of this kind of NVDIMM.

Currently, a persistent memory region is "owned" by a device driver,
either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
allow applications to explicitly use persistent memory, generally
by being modified to use special, new libraries. (DIMM-based
persistent memory hardware/software is described in great detail
here: Documentation/nvdimm/nvdimm.txt).

However, this limits persistent memory use to applications which
*have* been modified.  To make it more broadly usable, this driver
"hotplugs" memory into the kernel, to be managed and used just like
normal RAM would be.

To make this work, management software must remove the device from
being controlled by the "Device DAX" infrastructure:

	echo -n dax0.0 &gt; /sys/bus/dax/drivers/device_dax/remove_id
	echo -n dax0.0 &gt; /sys/bus/dax/drivers/device_dax/unbind
</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Hello Dave</p>
    <p>I am trying to use these patches (on top on Dan's nvdimm-pending
      branch with Keith's HMAT patches). Writing to remove_id just
      hangs. echo never returns, it uses 100% CPU and I can't kill it.</p>
    <pre>[ 5468.744898] bash            R  running task        0 21419  21416 0x00000080
[ 5468.744899] Call Trace:
[ 5468.744902]  ? vsnprintf+0x372/0x4e0
[ 5468.744904]  ? klist_next+0x79/0xe0
[ 5468.744905]  ? sprintf+0x56/0x80
[ 5468.744907]  ? bus_for_each_dev+0x8a/0xc0
[ 5468.744911]  ? do_id_store+0xe8/0x1e0
[ 5468.744914]  ? _cond_resched+0x15/0x30
[ 5468.744915]  ? __kmalloc+0x17f/0x200
[ 5468.744918]  ? kernfs_fop_write+0x83/0x190
[ 5468.744918]  ? __vfs_write+0x36/0x1b0
[ 5468.744919]  ? selinux_file_permission+0xe1/0x130
[ 5468.744921]  ? security_file_permission+0x36/0x100
[ 5468.744922]  ? vfs_write+0xad/0x1b0
[ 5468.744922]  ? ksys_write+0x52/0xc0
[ 5468.744924]  ? do_syscall_64+0x5b/0x180
[ 5468.744927]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

CONFIG_NVDIMM_DAX=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y

  {
    "dev":"namespace0.0",
    "mode":"devdax",
    "map":"dev",
    "size":1598128390144,
    "uuid":"7046a749-477f-4690-9b3c-a640a1aa44f1",
    "chardev":"dax0.0"
  }


</pre>
    <p>I've used your patches on fake hardware (memmap=xx!yy) with an
      older nvdimm-pending branch (without Keith's patches). It worked
      fine. This time I am running on real Intel hardware. Any idea
      where to look ?</p>
    <p>Thanks</p>
    <p>Brice</p>
    <p><br>
    </p>
  </body>
</html>

--------------B1FBBAC4595CC6A4AB516193--
