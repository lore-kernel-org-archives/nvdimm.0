Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 900872034D8C8
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 15:14:10 -0700 (PDT)
Date: Tue, 20 Mar 2018 16:20:39 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4] ndctl: Add support for get bus and region persistence
 domain
Message-ID: <20180320222039.GA7863@linux.intel.com>
References: <152158332323.54131.4095700460006442823.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152158332323.54131.4095700460006442823.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 20, 2018 at 03:02:59PM -0700, Dave Jiang wrote:
> Adding helper functions to iterate through sysfs region persistence domain
> attribute. The region will display the domain with the most persistence for the
> region.  The bus will display the domain attribute with the least persistence
> amongst all the regions. ndctl_bus_get_persistence_domain() and
> ndctl_region_get_persistence_domain are exported. ndctl list will also display
> the region persistence domain as well.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> v4:
> - change enum ndctl_persistence to enum ndctl_persistence_domain

I think you missed Dan's second comment in that mail about spacing out the
enum ndctl_persistence_domain members.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
