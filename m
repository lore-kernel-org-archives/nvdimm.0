Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D99422097FAA6
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 14:48:44 -0700 (PDT)
Date: Fri, 20 Jul 2018 15:48:39 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv3 1/2] libnvdimm: Use max contiguous area for namespace
 size
Message-ID: <20180720214838.GB4864@localhost.localdomain>
References: <20180712154709.16444-1-keith.busch@intel.com>
 <1532119565.10343.15.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1532119565.10343.15.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 20, 2018 at 01:46:06PM -0700, Verma, Vishal L wrote:
> $ cat /sys/bus/nd/devices/region1/max_available_extent
> 17045651456
> 
> $ ndctl list -BNR --region=region1
> [
>   {
>     "provider":"ACPI.NFIT",
>     "dev":"ndbus1",
>     "regions":[
>       {
>         "dev":"region1",
>         "size":17045651456,
>         "available_size":0,
>         "type":"pmem",
>         "numa_node":0,
>         "persistence_domain":"unknown",
>         "namespaces":[
>           {
>             "dev":"namespace1.0",
>             "mode":"raw",
>             "size":17045651456,
>             "sector_size":512,
>             "blockdev":"pmem1",
>             "numa_node":0
>           }
> 	...
> 

As we saw, getting the "available_size" directly from the the region's
sysfs entry also returned  the same as max extent:

 $ cat /sys/bus/nd/devices/region1/available_size
 17045651456

The reason ndctl shows available_size as '0' is because the nstype is
neither of type PMEM nor BLK.

So I think max_available_extent is doing the right thing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
