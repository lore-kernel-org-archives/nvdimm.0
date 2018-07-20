Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 735202096F34B
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 16:17:09 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCHv3 1/2] libnvdimm: Use max contiguous area for namespace
 size
Date: Fri, 20 Jul 2018 23:17:04 +0000
Message-ID: <1532128622.10343.28.camel@intel.com>
References: <20180712154709.16444-1-keith.busch@intel.com>
 <1532119565.10343.15.camel@intel.com>
 <20180720214838.GB4864@localhost.localdomain>
In-Reply-To: <20180720214838.GB4864@localhost.localdomain>
Content-Language: en-US
Content-ID: <6111878D459B934E9CA31AC472BA44D8@intel.com>
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
To: "Busch, Keith" <keith.busch@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-07-20 at 15:48 -0600, Keith Busch wrote:
> On Fri, Jul 20, 2018 at 01:46:06PM -0700, Verma, Vishal L wrote:
> > $ cat /sys/bus/nd/devices/region1/max_available_extent
> > 17045651456
> > 
> > $ ndctl list -BNR --region=region1
> > [
> >   {
> >     "provider":"ACPI.NFIT",
> >     "dev":"ndbus1",
> >     "regions":[
> >       {
> >         "dev":"region1",
> >         "size":17045651456,
> >         "available_size":0,
> >         "type":"pmem",
> >         "numa_node":0,
> >         "persistence_domain":"unknown",
> >         "namespaces":[
> >           {
> >             "dev":"namespace1.0",
> >             "mode":"raw",
> >             "size":17045651456,
> >             "sector_size":512,
> >             "blockdev":"pmem1",
> >             "numa_node":0
> >           }
> > 	...
> > 
> 
> As we saw, getting the "available_size" directly from the the
> region's
> sysfs entry also returned  the same as max extent:
> 
>  $ cat /sys/bus/nd/devices/region1/available_size
>  17045651456
> 
> The reason ndctl shows available_size as '0' is because the nstype is
> neither of type PMEM nor BLK.
> 
> So I think max_available_extent is doing the right thing.

Yep, I agree. I did however see another potential breakage (the blk-
exhaust unit test fails due to this)

	ndctl create-namespace --bus=nfit_test.0

creates a namespace on say region 3. That makes available_size for
region3 zero (as reported by ndctl-list as well as directly from
sysfs), but max_available_extent still shows the full size available.

   $ sudo ndctl create-namespace --bus=nfit_test.0 
   {
     "dev":"namespace3.0",
     "mode":"fsdax",
     "map":"dev",
     "size":"28.50 MiB (29.89 MB)",
     "uuid":"592071ed-0928-4be8-96fb-4be944e4c6f4",
     "raw_uuid":"c4ac44fa-d3bd-43ea-9a1a-3a083d9fed1d",
     "sector_size":512,
     "blockdev":"pmem3"
   }

   $ cat /sys/bus/nd/devices/region3/max_available_extent
   33554432

   $ cat /sys/bus/nd/devices/region3/available_size
   0

And then a subsequent

	ndctl create-namespace --bus=nfit_test.0

sees the max_available extent on region 3 (with the corresponding ndctl
patches for this applied), tries to create a namespace again there, and
 obviously fails.

As a side note, I think it may be useful to include in the related
ndctl patch, a json entry for the max_available_extent for region
listings.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
