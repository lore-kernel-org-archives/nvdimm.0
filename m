Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F9992118D948
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 14:48:59 -0800 (PST)
Message-ID: <b92d7ea58dafefc30128dacebc6de6fb9c7fa8e8.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v6 3/9] device core: Consolidate locking and
 unlocking of parent and device
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Thu, 08 Nov 2018 14:48:59 -0800
In-Reply-To: <791408d3-bf97-0f54-adc5-9b06540015c6@oracle.com>
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041590.12967.4367086895437513524.stgit@ahduyck-desk1.jf.intel.com>
 <791408d3-bf97-0f54-adc5-9b06540015c6@oracle.com>
Mime-Version: 1.0
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
To: jane.chu@oracle.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, bvanassche@acm.org, linux-nvdimm@lists.01.org, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-11-08 at 14:43 -0800, jane.chu@oracle.com wrote:
> Hi, Alex,
> 
> 
> On 11/08/2018 10:06 AM, Alexander Duyck wrote:
> > +/*
> > + * __device_driver_lock - release locks needed to manipulate dev->drv
> 
> You meant to say __device_driver_unlock, right?

Yes, you are correct.

> > + * @dev: Device we will update driver info for
> > + * @parent: Parent device. Needed if the bus requires parent lock
> > + *
> > + * This function will release the required locks for manipulating dev->drv.
> > + * Normally this will just be the the @dev lock, but when called for a
> > + * USB interface, @parent lock will be released as well.
> > + */
> > +static void __device_driver_unlock(struct device *dev, struct device *parent)
> > +{
> > +	device_unlock(dev);
> > +	if (parent && dev->bus->need_parent_lock)
> > +		device_unlock(parent);
> > +}
> 
> -jane

Thanks.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
