Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE4F421A07A82
 for <linux-nvdimm@lists.01.org>; Tue,  3 Sep 2019 15:40:27 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: daxctl fails to reconfigure to system-ram when DAX modules
 built-in?
Date: Tue, 3 Sep 2019 22:39:14 +0000
Message-ID: <f8b9b5c6830559d00f7d30ed9947602c8471885a.camel@intel.com>
References: <7b6e4dcd-6373-24e2-65f2-d08b2de461fb@inria.fr>
In-Reply-To: <7b6e4dcd-6373-24e2-65f2-d08b2de461fb@inria.fr>
Content-Language: en-US
Content-ID: <C74AA55E23A75C4EAD717F1EC6EF8674@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Brice.Goglin@inria.fr" <Brice.Goglin@inria.fr>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2019-09-03 at 23:20 +0200, Brice Goglin wrote:
> Hello
> 
> It looks like daxctl fails to reconfigure to system-ram when
> DAX modules are built-in the kernel:
> 
> $ daxctl reconfigure-device --mode=system-ram dax1.0 -v
> libdaxctl: daxctl_insert_kmod_for_mode: dax1.0: a modalias lookup list
> was not created
> error reconfiguring devices: No such device or address
> reconfigured 0 devices
> 
> It looks like things were failing in kmod_module_new_from_lookup()

Hi Brice,

Thanks for the report - Dave Hansen also hit this recently, and I'll
take a look at kmod builtin detection. I've created a github issue for
this:

https://github.com/pmem/ndctl/issues/108

	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
