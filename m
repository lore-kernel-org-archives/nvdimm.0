Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E9AE1A1E57
 for <linux-nvdimm@lists.01.org>; Tue, 25 Oct 2016 09:24:17 -0700 (PDT)
Date: Tue, 25 Oct 2016 10:24:16 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] nvdimm: make CONFIG_NVDIMM_DAX 'bool'
Message-ID: <20161025162416.GA16761@linux.intel.com>
References: <20161025155246.4174413-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161025155246.4174413-1-arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 25, 2016 at 05:52:04PM +0200, Arnd Bergmann wrote:
> tatus: O
> Content-Length: 2346
> Lines: 60
> 
> A bugfix just tried to address a randconfig build problem and introduced
> a variant of the same problem: with CONFIG_LIBNVDIMM=y and
> CONFIG_NVDIMM_DAX=m, the nvdimm module now fails to link:
> 
> drivers/nvdimm/built-in.o: In function `to_nd_device_type':
> bus.c:(.text+0x1b5d): undefined reference to `is_nd_dax'
> drivers/nvdimm/built-in.o: In function `nd_region_notify_driver_action.constprop.2':
> region_devs.c:(.text+0x6b6c): undefined reference to `is_nd_dax'
> region_devs.c:(.text+0x6b8c): undefined reference to `to_nd_dax'
> drivers/nvdimm/built-in.o: In function `nd_region_probe':
> region.c:(.text+0x70f3): undefined reference to `nd_dax_create'
> drivers/nvdimm/built-in.o: In function `mode_show':
> namespace_devs.c:(.text+0xa196): undefined reference to `is_nd_dax'
> drivers/nvdimm/built-in.o: In function `nvdimm_namespace_common_probe':
> (.text+0xa55f): undefined reference to `is_nd_dax'
> drivers/nvdimm/built-in.o: In function `nvdimm_namespace_common_probe':
> (.text+0xa56e): undefined reference to `to_nd_dax'
> 
> This reverts the earlier fix, making NVDIMM_DAX a 'bool' option again
> as it should be (it gets linked into the libnvdimm module). To fix
> the original problem, I'm adding a dependency on LIBNVDIMM to
> DEV_DAX_PMEM, which ensures we can't have that one built-in if the
> rest is a module.
> 
> Fixes: 4e65e9381c7a ("/dev/dax: fix Kconfig dependency build breakage")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
