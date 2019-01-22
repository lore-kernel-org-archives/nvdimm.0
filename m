Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAECE211B7F6F
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 19:14:08 -0800 (PST)
Date: Tue, 22 Jan 2019 11:13:38 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH] libnvdimm: Clarify nd_pfn_init() flow
Message-ID: <20190122031338.GA3983@richard>
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190121075102.GA3758@richard> <20190122002915.GA5984@richard>
 <CAPcyv4gANCKeEE5xgC9W99XdiR+rNyN5TEzho18039S2+7TaPA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gANCKeEE5xgC9W99XdiR+rNyN5TEzho18039S2+7TaPA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 04:45:46PM -0800, Dan Williams wrote:
>On Mon, Jan 21, 2019 at 4:30 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>>
>>
>> May I ask a question about the purpose to create these three device here?
>>
>> I see nd_pfn_create() doesn't allocate pfn_sb here, and the probe on these
>> devices failed. Confused why we need these three devices.
>
>These allow for the namespace creation flow. Namespace creation with
>the pfn personality, for example, goes like this:
>
>1/ Find available region capacity
>
>2/ Allocate capacity to a namespace
>
>3/ Assign that namespace to a free pfn instance
>echo namespace0.0 > /sys/bus/nd/devices/pfn0.0/namespace
>

Here we use __nd_attach_ndns() connect pfn0.0 with namespace0.0

>4/ Start the pfn0.0 device
>echo pfn0.0 > /sys/bus/nd/drivers/nd_pmem/bind
>

Here we trigger nd_pmem_probe() and call pmem_attach_disk() for device pfn0.0,
because this is a pfn device.

>5/ At this point nd_pfn_validate() returns -ENODEV, so the driver
>writes the configuration to the device to be autodetected next time.
>

Then it go through pmem_attach_disk()->nvdimm_setup_pfn()->nd_pfn_init().

The return value -ENODEV leads nd_pfn_init() to configuration write.

Everything looks good here, but I am lost at "Autodetected next time". Because
the driver will continue to finish its work and attach pfn0.0.

Do we need another autodetect? Or you mean after driver detach or reboot? So
nd_pfn_validate() will not return -ENODEV, as it has already configured well.

>This explicit force binding operation is how the driver determines the
>difference between the namespace creation case and the namespace
>auto-probing case at the next driver load.


-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
