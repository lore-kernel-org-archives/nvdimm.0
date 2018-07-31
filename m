Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BE2D21B02845
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 12:36:43 -0700 (PDT)
Date: Tue, 31 Jul 2018 13:36:42 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: Help trying to use /dev/pmem for dax debugging?
Message-ID: <20180731193642.GA3473@linux.intel.com>
References: <20180730235312.GA5089@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180730235312.GA5089@thunk.org>
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 30, 2018 at 07:53:12PM -0400, Theodore Y. Ts'o wrote:
> In newer kernels, it looks like you can't use /dev/pmem0 for DAX
> unless it's marked as being DAX capable.  This appears to require
> CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
> configured, I get the following BUG:
> 
> [    0.000000] Linux version 4.18.0-rc4-xfstests-00031-g7c2d77aa7d80 (tytso@cwcc) (gcc version 7.3.0 (Debian 7.3.0-27)) #460 SMP Mon Jul 30 19:38:44 EDT 2018
> [    0.000000] Command line: systemd.show_status=auto systemd.log_level=crit root=/dev/vda console=ttyS0,115200 cmd=maint fstesttz=America/New_York fstesttyp=ext4 fstestapi=1.4 memmap=4G!9G memmap=9G!14G

Hey Ted,

You're using the memmap kernel command line parameter to reserve normal
memory to be treated as normal memory, but you've also got kernel address
randomization turned on in your kernel config:

CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_MEMORY=y

You need to turn these off for the memmap kernel command line parameter, else
the memory we're using could overlap with addresses used for other things.

Once that is off you probably want to double check that the addresses you're
reserving are marked as 'usable' in the e820 table.  Gory details here, sorry
for the huge link:

https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_parameter_for_pmem_on_your_system

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
