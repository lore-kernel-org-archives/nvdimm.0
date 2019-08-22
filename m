Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12713202110D0
 for <linux-nvdimm@lists.01.org>; Thu, 22 Aug 2019 12:11:39 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/2] drivers/dax/kmem: give a warning if
 CONFIG_DEV_DAX_PMEM_COMPAT is enabled
Date: Thu, 22 Aug 2019 19:10:35 +0000
Message-ID: <91b07911eb6d307c4cb652da6ec53bad661ec066.camel@intel.com>
References: <20190816111844.87442-1-justin.he@arm.com>
 <20190816111844.87442-3-justin.he@arm.com>
 <x49tva9ni68.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49tva9ni68.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <FE4E6340A0DCFB4990BDFDF7F44BCDE4@intel.com>
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
To: "justin.he@arm.com" <justin.he@arm.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2019-08-22 at 14:55 -0400, Jeff Moyer wrote:
> 
> When using daxctl to online memory, you already get the following
> message:
> 
> libdaxctl: daxctl_dev_disable: dax0.0: error: device model is dax-class
> 
> That's still not very helpful.  It would be better if the message
> suggested a fix (like using migrate-device-model).  Vishal?

Yes, it is on my list to improve this. Currently the man page shows the
above error message, and talks about migrate-device-model, but I
received more feedback to add another bread crumb in the printed message
pointing to migrate-device-model.  I'll send a patch for it soon.

Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
